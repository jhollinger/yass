require 'pathname'
require 'kramdown'
require 'liquid'

module Yass
  autoload :CLI, 'yass/cli'
  autoload :Config, 'yass/config'
  autoload :ErbTemplate, 'yass/erb_template'
  autoload :Generator, 'yass/generator'
  autoload :HtmlSafeString, 'yass/html_safe_string'
  autoload :LiquidTemplate, 'yass/liquid_template'
  autoload :Page, 'yass/page'
  autoload :Source, 'yass/source'
  autoload :VERSION, 'yass/version'
end
