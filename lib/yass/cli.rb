module YASS
  module CLI
    Config = Struct.new(:src, :dest, :templates, :local, :stdin, :stdout, :stderr, keyword_init: true)

    autoload :Helpers, 'yass/cli/helpers'
    autoload :Runner, 'yass/cli/runner'
  end
end
