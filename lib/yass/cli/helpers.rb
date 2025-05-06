require 'optparse'

module YASS
  module CLI
    module Helpers
      def self.get_cmd(argv = ARGV)
        argv[0].to_s.to_sym
      end

      def self.get_args!(argv = ARGV, min: nil, max: nil, num: nil)
        args, error = get_args(argv, min: min, max: max, num: num)
        if error
          $stderr.puts error
          exit 1
        end
        args
      end

      def self.get_args(argv = ARGV, min: nil, max: nil, num: nil)
        args = argv[1..]
        if num
          if num != args.size
            return nil, "Expected #{num} args, found #{args.size}"
          end
        elsif min and max
          if args.size < min or args.size > max
            return nil, "Expected #{min}-#{max} args, found #{args.size}"
          end
        elsif min
          if args.size < min
            return nil, "Expected at least #{min} args, found #{args.size}"
          end
        elsif max
          if args.size > max
            return nil, "Expected no more than #{max} args, found #{args.size}"
          end
        end
        return args, nil
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
Yet Another Static Site (generator)

  Build the site:
      yass build

  Create a new site:
      yass init <path/to/dir>

  Options:
          ).strip
          opts.on("--local", "Build in local mode (with links to /index.html's)") { |l| config.local = true }
          opts.on("--debug", "Print stack traces") { |l| config.debug = true }
          opts.on("-h", "--help", "Prints this help") { config.stdout.puts opts; exit }
        }
      end

      def self.default_config
        Config.new({
          root: Pathname.new(Dir.pwd),
          src: "site",
          dest: "dist",
          templates: "templates",
          local: false,
          stdin: $stdin,
          stdout: $stdout,
          stderr: $stderr,
          debug: false,
        })
      end
    end
  end
end
