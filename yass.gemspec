require_relative 'lib/yass/version'

Gem::Specification.new do |spec|
  spec.name = "yass"
  spec.version = YASS::VERSION
  spec.licenses = ["MIT"]
  spec.summary = "Yet Another Static Site (generator)"
  spec.description = "A dead-simple static site generator"

  spec.authors = ["Jordan Hollinger"]
  spec.email = "jordan.hollinger@gmail.com"
  spec.homepage = "https://jhollinger.github.io/yass/"

  spec.require_paths = ["lib"]
  spec.executables << 'yass'
  spec.files = [*Dir["lib/**/*"], "README.md"]

  spec.required_ruby_version = ">= 3.0.0"
  spec.add_runtime_dependency 'kramdown', ['~> 2.0']
end
