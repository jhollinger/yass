require 'optparse'

module Yass
  module CLI
    module Helpers
      def self.get_cmd(argv)
        argv[0].to_s.to_sym
      end

      def self.get_args!(argv, max: nil)
        args = argv[1..]
        if max && args.size > max
          $stderr.puts "Expected no more than #{max} args, found #{args.size}"
          exit 1
        end
        args
      end

      def self.get_opts!
        config = default_config
        parser = option_parser config
        parser.parse!
        config
      end

      def self.help!
        config = default_config
        parser = option_parser config
        config.stdout.puts parser.help
        exit 1
      end

      def self.option_parser(config)
        OptionParser.new { |opts|
          opts.banner = %(
Yet Another Static Site (generator) v#{VERSION}

yass <command> [options] [path/to/dir]

  Build the site:
      yass build
      yass build path/to/dir

  Auto-build when files change:
      yass watch
      yass watch path/to/dir

  Create a new site:
      yass init <path/to/dir>

  Options:
          ).strip
          opts.on("--clean", "Remove unknown files from dist/ when bulding") { config.clean = true }
          opts.on("--no-strip-index", "Disable the strip_index Liquid filter") { config.strip_index = false }
          opts.on("--debug", "Print stack traces") { config.debug = true }
          opts.on("-h", "--help", "Prints this help") { config.stdout.puts opts; exit }
        }
      end

      def self.default_config
        Config.new({
          root: Pathname.new(Dir.pwd),
          src: "site",
          layouts: "layouts",
          templates: "templates",
          dest: "dist",
          clean: false,
          strip_index: true,
          stdin: $stdin,
          stdout: $stdout,
          stderr: $stderr,
          debug: false,
        })
      end
    end
  end
end
