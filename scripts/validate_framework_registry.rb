#!/usr/bin/env ruby
# frozen_string_literal: true
#
# validate_framework_registry.rb
#
# Validates data/frameworks.yaml structure and verifies:
# - Every framework ID is unique
# - Every framework has required fields (family, name, version, url, date_reviewed, owner)
# - Every framework ID referenced in a skill's `frameworks:` frontmatter resolves
#   either as a top-level id OR as an alias
# - --stale flag reports frameworks whose date_reviewed is older than --max-age-days
#
# Usage:
#   ruby scripts/validate_framework_registry.rb
#   ruby scripts/validate_framework_registry.rb --stale --max-age-days 365
#
# Exit 0 on pass, 1 on any failure.

require "yaml"
require "date"

ROOT = File.expand_path("..", __dir__)
REGISTRY_PATH = File.join(ROOT, "data", "frameworks.yaml")
SKILL_GLOBS = [
  File.join(ROOT, "skills", "*", "*", "SKILL.md"),
  File.join(ROOT, "roles", "*", "SKILL.md")
].freeze

REQUIRED_FIELDS = %w[id family name version url date_reviewed owner].freeze

def rel(path)
  path.delete_prefix("#{ROOT}#{File::SEPARATOR}")
end

def parse_args(argv)
  options = { stale: false, max_age_days: 365 }
  argv.each_with_index do |arg, i|
    case arg
    when "--stale" then options[:stale] = true
    when "--max-age-days" then options[:max_age_days] = argv[i + 1].to_i
    end
  end
  options
end

def load_registry
  data = YAML.safe_load(File.read(REGISTRY_PATH), permitted_classes: [Date], aliases: false)
  abort "frameworks.yaml must be a hash" unless data.is_a?(Hash)
  abort "frameworks.yaml missing 'references' array" unless data["references"].is_a?(Array)
  data
rescue Errno::ENOENT
  abort "frameworks.yaml not found: #{REGISTRY_PATH}"
rescue Psych::SyntaxError => e
  abort "Invalid YAML in #{REGISTRY_PATH}: #{e.message}"
end

def load_skill_frameworks
  refs = {}
  SKILL_GLOBS.flat_map { |g| Dir.glob(g) }.each do |path|
    text = File.read(path)
    m = text.match(/\A---\s*\n(.*?)\n---\s*(?:\n|\z)/m)
    next unless m
    begin
      fm = YAML.safe_load(m[1], permitted_classes: [], aliases: false) || {}
    rescue Psych::SyntaxError
      next
    end
    Array(fm["frameworks"]).each do |fid|
      refs[fid] ||= []
      refs[fid] << rel(path)
    end
  end
  refs
end

def to_date(value)
  case value
  when Date then value
  when String then Date.parse(value) rescue nil
  end
end

registry = load_registry
options = parse_args(ARGV)

errors = []
warnings = []

# 1. Required fields on every reference
ids = []
aliases = {}

registry["references"].each_with_index do |ref, i|
  path = "references[#{i}]"
  unless ref.is_a?(Hash)
    errors << "#{path} must be a hash"
    next
  end
  REQUIRED_FIELDS.each do |field|
    errors << "#{path}.#{field} is required" unless ref.key?(field) && ref[field]
  end

  id = ref["id"]
  next unless id

  if ids.include?(id)
    errors << "#{path}.id '#{id}' is duplicated"
  else
    ids << id
  end

  Array(ref["aliases"]).each do |alias_id|
    if aliases.key?(alias_id)
      errors << "#{path}.aliases contains '#{alias_id}' already claimed by '#{aliases[alias_id]}'"
    else
      aliases[alias_id] = id
    end
  end

  if ref["url"] && !ref["url"].to_s.start_with?("http://", "https://")
    errors << "#{path}.url must be an http(s) URL"
  end

  if options[:stale]
    date = to_date(ref["date_reviewed"])
    if date.nil?
      warnings << "#{path}.date_reviewed is not a valid date: #{ref['date_reviewed']}"
    else
      age = (Date.today - date).to_i
      if age > options[:max_age_days]
        warnings << "#{id} last reviewed #{age} days ago (>#{options[:max_age_days]} limit)"
      end
    end
  end
end

# 2. Every framework ID referenced by a skill must resolve
skill_refs = load_skill_frameworks
unresolved = {}
skill_refs.each do |fid, files|
  next if ids.include?(fid) || aliases.key?(fid)
  unresolved[fid] = files
end

unless unresolved.empty?
  unresolved.each do |fid, files|
    errors << "Framework '#{fid}' referenced by #{files.length} skill(s) but not in registry or aliases: #{files.first(3).join(', ')}"
  end
end

# 3. Print report
puts "Framework registry: #{ids.length} frameworks, #{aliases.length} aliases"
puts "Skill references:   #{skill_refs.length} distinct framework IDs across #{skill_refs.values.flatten.uniq.length} skill file(s)"

warnings.each { |w| puts "WARN  #{w}" } unless warnings.empty?

if errors.empty?
  puts
  puts "PASS"
  exit 0
else
  puts
  errors.each { |e| puts "FAIL  #{e}" }
  puts
  puts "#{errors.length} error(s)."
  exit 1
end
