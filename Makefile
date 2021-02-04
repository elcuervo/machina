.PHONY: *

default: test

build:
	rm *.gem
	gem build machina.gemspec

publish: build
	gem push *.gem

test:
	ruby -Ilib:spec spec/*_spec.rb
