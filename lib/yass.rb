require 'pathname'
require 'kramdown'

module YASS
  autoload :CLI, 'yass/cli'
  autoload :ErbTemplate, 'yass/erb_template'
  autoload :File, 'yass/file'
  autoload :Generator, 'yass/generator'
  autoload :HtmlSafeString, 'yass/html_safe_string'
  autoload :Page, 'yass/page'
  autoload :Sources, 'yass/sources'
  autoload :VERSION, 'yass/version'
end
