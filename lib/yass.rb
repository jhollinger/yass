require 'pathname'
require 'kramdown'

module Yass
  autoload :CLI, 'yass/cli'
  autoload :Config, 'yass/config'
  autoload :ErbTemplate, 'yass/erb_template'
  autoload :Generator, 'yass/generator'
  autoload :HtmlSafeString, 'yass/html_safe_string'
  autoload :Page, 'yass/page'
  autoload :Renderer, 'yass/renderer'
  autoload :Source, 'yass/source'
  autoload :VERSION, 'yass/version'
end
