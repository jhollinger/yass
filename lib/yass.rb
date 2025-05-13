require 'pathname'
require 'filewatcher'
require 'liquid' # MUST be loaded before kramdown-parser-gfm for some reason
require 'kramdown'
require 'kramdown-parser-gfm'

module Yass
  autoload :CLI, 'yass/cli'
  autoload :Config, 'yass/config'
  autoload :Generator, 'yass/generator'
  autoload :LiquidFilters, 'yass/liquid_filters'
  autoload :LiquidTags, 'yass/liquid_tags'
  autoload :LiquidTemplate, 'yass/liquid_template'
  autoload :Source, 'yass/source'
  autoload :VERSION, 'yass/version'
end
