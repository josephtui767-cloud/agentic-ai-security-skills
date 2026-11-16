#!/usr/bin/env ruby
# frozen_string_literal: true
#
# validate_index.rb
#
# Validates that index.yaml matches the on-disk skill and role inventory:
# - meta.skill_count matches actual skills
# - meta.role_count matches actual roles
# - Every skill in skills/*/*/SKILL.md is in index.yaml
# - Every index.yaml entry points at a real SKILL.md
# - Every role in roles/*/SKILL.md is in index.yaml
# - Every role bundle references only skills that exist
# - index.yaml metadata (tags, role, phase, frameworks) matches SKILL.md frontmatter
#
# Usage:
#   ruby scripts/validate_index.rb
#
# Exit 0 on pass, 1 on any failure.

require "yaml"
require "set"
require "date"

ROOT = File.expand_path("..", __dir__)
INDEX_PATH = File.join(ROOT, "index.yaml")
SKILL_GLOB = File.join(ROOT, "skills", "*", "*", "SKILL.md")
ROLE_GLOB = File.join(ROOT, "roles", "*", "SKILL.md")

def rel(path)
  path.delete_prefix("#{ROOT}#{File::SEPARATOR}")
end

def load_index
  YAML.safe_load(File.read(INDEX_PATH), permitted_classes: [Date], aliases: false)
rescue Errno::ENOENT
  abort "index.yaml not found: #{INDEX_PATH}"
rescue Psych::SyntaxError => e
  abort "Invalid YAML in index.yaml: #{e.message}"
end

def load_frontmatter(path)
  text = File.read(path)
  m = text.match(/\A---\s*\n(.*?)\n---\s*(?:\n|\z)/m)
  return nil unless m
  YAML.safe_load(m[1], permitted_classes: [], aliases: false) || {}
rescue Psych::SyntaxError
  nil
end

def skill_id_from_path(path)
  File.basename(File.dirname(path))
end

errors = []

index = load_index
abort "index.yaml missing 'meta'" unless index.is_a?(Hash) && index["meta"].is_a?(Hash)

skills_on_disk = Dir.glob(SKILL_GLOB).sort
roles_on_disk = Dir.glob(ROLE_GLOB).sort

skill_ids_on_disk = skills_on_disk.map { |p| skill_id_from_path(p) }.sort
role_ids_on_disk = roles_on_disk.map { |p| skill_id_from_path(p) }.sort

index_skills = Array(index["skills"])
index_roles  = Array(index["roles"])

skill_ids_in_index = index_skills.map { |s| s["id"] }.compact.sort
role_ids_in_index  = index_roles.map { |r| r["id"] }.compact.sort

# 1. Counts match meta
meta_skill_count = index.dig("meta", "skill_count")
meta_role_count = index.dig("meta", "role_count")
if meta_skill_count && meta_skill_count != skill_ids_on_disk.length
  errors << "meta.skill_count = #{meta_skill_count} but found #{skill_ids_on_disk.length} skills on disk"
end
if meta_role_count && meta_role_count != role_ids_on_disk.length
  errors << "meta.role_count = #{meta_role_count} but found #{role_ids_on_disk.length} roles on disk"
end

# 2. Each on-disk skill is in index
missing_from_index = skill_ids_on_disk - skill_ids_in_index
missing_from_index.each { |id| errors << "Skill '#{id}' exists on disk but not in index.yaml" }

# 3. Each index entry points at a real SKILL.md
extra_in_index = skill_ids_in_index - skill_ids_on_disk
extra_in_index.each { |id| errors << "Skill '#{id}' in index.yaml but not on disk" }

# 4. Each index entry's file: path resolves
index_skills.each do |entry|
  file = entry["file"]
  next unless file
  full = File.join(ROOT, file)
  unless File.exist?(full)
    errors << "index.yaml skill '#{entry['id']}' file: #{file} does not exist"
  end
end

# 5. Roles present
missing_roles = role_ids_on_disk - role_ids_in_index
missing_roles.each { |id| errors << "Role '#{id}' exists on disk but not in index.yaml" }

extra_roles = role_ids_in_index - role_ids_on_disk
extra_roles.each { |id| errors << "Role '#{id}' in index.yaml but not on disk" }

# 6. Role bundles reference only existing skills
index_roles.each do |role|
  Array(role["skills"]).each do |skill_id|
    unless skill_ids_on_disk.include?(skill_id)
      errors << "Role '#{role['id']}' references skill '#{skill_id}' which does not exist"
    end
  end
end

# 7. Index metadata matches SKILL.md frontmatter
skills_on_disk.each do |path|
  id = skill_id_from_path(path)
  entry = index_skills.find { |s| s["id"] == id }
  next unless entry
  fm = load_frontmatter(path)
  next unless fm

  # index.yaml is a discovery catalog; it holds the primary metadata but
  # SKILL.md may carry additional tags. For array fields we require the
  # index to be a *subset* of the file. For scalar fields we require equality.
  %w[tags role phase frameworks].each do |field|
    index_value = entry[field]
    file_value = fm[field]
    next if index_value.nil? || file_value.nil?

    missing = Array(index_value) - Array(file_value)
    unless missing.empty?
      errors << "Skill '#{id}' #{field} in index.yaml contains values not in SKILL.md: #{missing.inspect}"
    end
  end

  %w[difficulty time_estimate].each do |field|
    index_value = entry[field]
    file_value = fm[field]
    next if index_value.nil? || file_value.nil?

    if index_value != file_value
      errors << "Skill '#{id}' #{field} differs: index=#{index_value.inspect} file=#{file_value.inspect}"
    end
  end
end

# Report
puts "Index check"
puts "  skills on disk: #{skill_ids_on_disk.length}"
puts "  skills in index: #{skill_ids_in_index.length}"
puts "  roles on disk:  #{role_ids_on_disk.length}"
puts "  roles in index: #{role_ids_in_index.length}"
puts

if errors.empty?
  puts "PASS"
  exit 0
else
  errors.each { |e| puts "FAIL  #{e}" }
  puts
  puts "#{errors.length} error(s)."
  exit 1
end
