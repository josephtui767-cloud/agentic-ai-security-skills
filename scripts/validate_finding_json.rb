#!/usr/bin/env ruby
# frozen_string_literal: true
#
# validate_finding_json.rb
#
# Validates one or more finding JSON documents against
# schemas/finding.schema.json. Use this when a skill emits a sample finding
# that you want to check in CI or locally.
#
# Usage:
#   ruby scripts/validate_finding_json.rb path/to/finding.json [...]
#
# Exit 0 on pass, 1 on any failure.

require "json"

ROOT = File.expand_path("..", __dir__)
SCHEMA_PATH = File.join(ROOT, "schemas", "finding.schema.json")

abort "Usage: ruby #{$PROGRAM_NAME} <finding.json> [...]" if ARGV.empty?

schema = JSON.parse(File.read(SCHEMA_PATH))

# Minimal validator that reuses the same walker pattern as validate_skill_schema.rb.
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

def resolve_ref(ref, root)
  # Only supports in-document $ref like "#/$defs/finding"
  parts = ref.sub(/^#\//, "").split("/")
  parts.inject(root) { |acc, key| acc.is_a?(Hash) ? acc[key] : nil }
end

def validate(path, value, schema, root, errors)
  if schema["$ref"]
    return validate(path, value, resolve_ref(schema["$ref"], root), root, errors)
  end

  if (type = schema["type"])
    expected = Array(type)
    unless expected.include?(type_name(value))
      errors << "#{path} must be #{expected.join(' or ')}, got #{type_name(value)}"
      return
    end
  end

  case value
  when String
    if (min = schema["minLength"]) && value.length < min
      errors << "#{path} must be at least #{min} characters"
    end
    if (pattern = schema["pattern"])
      errors << "#{path} must match /#{pattern}/" unless Regexp.new(pattern).match?(value)
    end
    if (fmt = schema["format"])
      case fmt
      when "date-time"
        errors << "#{path} must be an ISO 8601 date-time" unless value =~ /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?(Z|[+-]\d{2}:?\d{2})\z/
      when "uri"
        errors << "#{path} must be a URI" unless value.start_with?("http://", "https://")
      end
    end
  when Array
    if (min = schema["minItems"]) && value.length < min
      errors << "#{path} must have at least #{min} item(s)"
    end
    if (item_schema = schema["items"])
      value.each_with_index { |item, i| validate("#{path}[#{i}]", item, item_schema, root, errors) }
    end
  when Hash
    required = schema["required"] || []
    required.each { |k| errors << "#{path}.#{k} is required" unless value.key?(k) }

    properties = schema["properties"] || {}
    value.each do |key, v|
      if (prop_schema = properties[key])
        validate("#{path}.#{key}", v, prop_schema, root, errors)
      elsif schema["additionalProperties"] == false
        errors << "#{path} contains disallowed property '#{key}'"
      end
    end
  end

  if (enum = schema["enum"]) && !enum.include?(value)
    errors << "#{path} must be one of #{enum.inspect}"
  end
end

failed = 0
ARGV.each do |path|
  errors = []
  begin
    data = JSON.parse(File.read(path))
    validate("$", data, schema, schema, errors)
  rescue => e
    errors << "#{e.class}: #{e.message}"
  end

  if errors.empty?
    puts "  OK  #{path}"
  else
    failed += 1
    puts "FAIL  #{path}"
    errors.each { |e| puts "      - #{e}" }
  end
end

puts
puts "Validated #{ARGV.length} file(s), #{failed} failed."
exit(failed.zero? ? 0 : 1)
