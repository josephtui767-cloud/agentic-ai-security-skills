.PHONY: help validate lint index frameworks injection all clean check-ruby

RUBY ?= ruby
SHELL := /bin/bash

help:
	@echo "Agentic AI Security Skills — common tasks"
	@echo
	@echo "  make validate      Run every validator (frontmatter, index, frameworks, injection scan)"
	@echo "  make lint          Validate SKILL.md frontmatter"
	@echo "  make index         Validate index.yaml consistency"
	@echo "  make frameworks    Validate framework registry"
	@echo "  make injection     Run prompt-injection / malware / secret scan"
	@echo "  make staleness     Report frameworks older than 365 days"
	@echo "  make clean         Remove temporary files"

check-ruby:
	@command -v $(RUBY) >/dev/null 2>&1 || { echo "Ruby not installed. Install Ruby 3.0+ first."; exit 1; }

lint: check-ruby
	$(RUBY) scripts/validate_skill_schema.rb

index: check-ruby
	$(RUBY) scripts/validate_index.rb

frameworks: check-ruby
	$(RUBY) scripts/validate_framework_registry.rb

staleness: check-ruby
	$(RUBY) scripts/validate_framework_registry.rb --stale --max-age-days 365

injection:
	bash scripts/injection_scan.sh

validate: lint index frameworks injection
	@echo
	@echo "All validators passed."

all: validate

clean:
	@find . -name "*.swp" -o -name "*.tmp" -o -name ".DS_Store" -delete 2>/dev/null || true
	@echo "Clean."
