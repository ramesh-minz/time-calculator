# frozen_string_literal: true

require_relative "lib/time_calculator/version"

Gem::Specification.new do |spec|
  spec.name          = "time-calculator"
  spec.version       = TimeCalculator::VERSION
  spec.summary       = "Advanced time calculator (durations + expressions) in Ruby"
  spec.description   = "Parses time literals and unit durations, evaluates expressions with operators and parentheses."
  spec.authors       = ["Your Name"]
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*", "bin/*", "README.md", "LICENSE"]
  spec.executables   = ["timecalc"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
