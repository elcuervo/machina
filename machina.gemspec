# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name              = "machina"
  s.version           = "0.0.1"
  s.summary           = "Simple state machine"
  s.description       = "Really really simple state machine"
  s.authors           = ["elcuervo"]
  s.licenses          = %w[MIT HUGWARE]
  s.email             = ["elcuervo@elcuervo.net"]
  s.homepage          = "http://github.com/elcuervo/machina"
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files test`.split("\n")
end
