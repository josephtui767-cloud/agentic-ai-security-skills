#!/usr/bin/env ruby
# frozen_string_literal: true
#
# validate_skill_schema.rb
#
# Validates SKILL.md frontmatter in skills/*/*/SKILL.md and roles/*/SKILL.md
# against schemas/skill.schema.json.
#
# Usage:
#   ruby scripts/validate_skill_schema.rb                   # validate every skill
#   ruby scripts/validate_skill_schema.rb path/to/SKILL.md  # validate one file
#
# Exit 0 on pass, 1 on any failure.

require "json"
require "yaml"

ROOT = File.expand_path("..", __dir__)
SCHEMA_PATH = File.join(ROOT, "schemas", "skill.schema.json")
DEFAULT_GLOBS = [
  File.join(ROOT, "skills", "*", "*", "SKILL.md"),
  File.join(ROOT, "roles", "*", "SKILL.md")
].freeze

def load_schema
  JSON.parse(File.read(SCHEMA_PATH))
rescue Errno::ENOENT
  abort "Schema not found: #{SCHEMA_PATH}"
rescue JSON::ParserError => e
  abort "Invalid JSON in schema #{SCHEMA_PATH}: #{e.message}"
end

def skill_files(argv)
  files = argv.empty? ? DEFAULT_GLOBS.flat_map { |g| Dir.glob(g) } : argv
  files.map { |p| File.expand_path(p, Dir.pwd) }.sort.uniq
end

def rel(path)
  path.delete_prefix("#{ROOT}#{File::SEPARATOR}")
end

def frontmatter_for(path)
  text = File.read(path)
  m = text.match(/\A---\s*\n(.*?)\n---\s*(?:\n|\z)/m)
  raise "missing YAML frontmatter delimited by ---" unless m

  YAML.safe_load(m[1], permitted_classes: [], aliases: false) || {}
rescue Psych::SyntaxError => e
  raise "invalid YAML frontmatter: #{e.message}"
end

def directory_name(path)
  File.basename(File.dirname(path))
end

def type_name(value)
  case value
  when String then "string"
  when Array then "array"
  when Hash then "object"
  when TrueClass, FalseClass then "boolean"
  when Integer then "integer"
  when Float then "number"
  when NilClass then "null"
  else value.class.name
  end
end

def validate_value(path, value, schema, errors)
  if (type = schema["type"])
    expected = Array(type)
    unless expected.include?(type_name(value))
      errors << "#{path} must be #{expected.join(' or ')}, got #{type_name(value)}"
      return
    end
  end

  if (one_of = schema["oneOf"])
    matches = one_of.count do |sub|
      sub_errors = []
      validate_value(path, value, sub, sub_errors)
      sub_errors.empty?
    end
    unless matches == 1
      errors << "#{path} must match exactly one of #{one_of.length} schemas (matched #{matches})"
    end
  end

  case value
  when String
    validate_string(path, value, schema, errors)
  when Array
    validate_array(path, value, schema, errors)
  when Hash
    validate_object(path, value, schema, errors)
  end

  if (enum = schema["enum"]) && !enum.include?(value)
    errors << "#{path} must be one of #{enum.inspect}"
  end
end

def validate_string(path, value, schema, errors)
  if (min = schema["minLength"]) && value.length < min
    errors << "#{path} must be at least #{min} characters (got #{value.length})"
  end
  if (pattern = schema["pattern"])
    errors << "#{path} must match /#{pattern}/" unless Regexp.new(pattern).match?(value)
  end
end

def validate_array(path, value, schema, errors)
  if (min = schema["minItems"]) && value.length < min
    errors << "#{path} must contain at least #{min} item(s)"
  end
  if (item_schema = schema["items"])
    value.each_with_index do |item, i|
      validate_value("#{path}[#{i}]", item, item_schema, errors)
    end
  end
end

def validate_object(path, value, schema, errors)
  required = schema["required"] || []
  required.each do |key|
    errors << "#{path}.#{key} is required" unless value.key?(key)
  end

  properties = schema["properties"] || {}
  value.each do |key, v|
    if (prop_schema = properties[key])
      validate_value("#{path}.#{key}", v, prop_schema, errors)
    elsif schema["additionalProperties"] == false
      errors << "#{path} contains disallowed property '#{key}'"
    end
  end
end

def validate_file(path, schema)
  errors = []
  data = frontmatter_for(path)
  validate_value("frontmatter", data, schema, errors)

  # Repo-level invariants beyond schema
  expected_name = directory_name(path)
  if data["name"] && data["name"] != expected_name
    errors << "frontmatter.name '#{data['name']}' must match directory name '#{expected_name}'"
  end

  errors
rescue => e
  ["#{e.class}: #{e.message}"]
end

schema = load_schema
files = skill_files(ARGV)

abort "No SKILL.md files found" if files.empty?

failed = 0
files.each do |path|
  errors = validate_file(path, schema)
  if errors.empty?
    puts "  OK  #{rel(path)}"
  else
    failed += 1
    puts "FAIL  #{rel(path)}"
    errors.each { |e| puts "      - #{e}" }
  end
end

puts
puts "Validated #{files.length} skill file(s), #{failed} failed."
exit(failed.zero? ? 0 : 1)
