require_relative 'lib/yass/version'

Gem::Specification.new do |spec|
  spec.name = "yass"
  spec.version = Yass::VERSION
  spec.licenses = ["MIT"]
  spec.description = "An astonishingly un-opinionated static site generator"
  spec.summary = "Yet Another Static Site (generator)"
  spec.authors = ["Jordan Hollinger"]
  spec.email = "jordan.hollinger@gmail.com"
  spec.homepage = "https://jhollinger.github.io/yass/"
  spec.metadata = {
    "homepage_uri" => "https://jhollinger.github.io/yass/",
    "source_code_uri" => "https://github.com/jhollinger/yass/",
  }

  spec.require_paths = ["lib"]
  spec.executables << 'yass'
  spec.files = ["README.md", "LICENSE", *Dir["lib/**/*"], *Dir["docs-src/**/*"]]

  spec.required_ruby_version = ">= 3.0.0"
  spec.add_runtime_dependency 'filewatcher', ['~> 2.0']
  spec.add_runtime_dependency 'kramdown', ['~> 2.0']
  spec.add_runtime_dependency 'liquid', ['~> 5.0']
end
