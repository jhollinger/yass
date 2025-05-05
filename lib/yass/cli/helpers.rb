require 'optparse'

module YASS
  module CLI
    module Helpers
      # Returns the command given to yass
      def self.get_cmd(argv = ARGV)
        argv[0].to_s.to_sym
      end

      def self.get_opts!
        config = default_config
        parser = option_parser config
        parser.parse!
        config
      end

      # Print help and exit
      def self.help!
        config = default_config
        parser = option_parser config
        config.stdout.puts parser.help
        exit 1
      end

      def self.option_parser(config)
        OptionParser.new { |opts|
          opts.banner = %(
Yet Another Static Site (generator)

  Build the site:
      yass build

  Options:
          ).strip
          opts.on("-l", "--local", "Build in local mode (with links to /index.html's)") { |l| config.local = true }
          opts.on("-h", "--help", "Prints this help") { config.stdout.puts opts; exit }
        }
      end

      def self.default_config
        root = Pathname.new(Dir.pwd)
        Config.new({
          src: root.join("site"),
          dest: root.join("dist"),
          templates: root.join("templates"),
          local: false,
          stdin: $stdin,
          stdout: $stdout,
          stderr: $stderr,
        })
      end
    end
  end
end
