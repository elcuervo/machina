.PHONY: test

test:
	ruby -Ilib:spec spec/*_spec.rb
