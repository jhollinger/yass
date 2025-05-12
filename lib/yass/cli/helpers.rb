require 'optparse'

module Yass
  module CLI
    module Helpers
      def self.get_cmd(argv) = argv[0].to_s.to_sym

      def self.get_working_dir!(argv)
        dir = Pathname.new(argv[1] || Dir.pwd)
        dir.relative? ? Pathname.new(File.join(Dir.pwd, dir)) : dir
      end

      def self.find_path(path, cwd:)
        path = Pathname.new(path)
        path.relative? ? Pathname.new(cwd).join(path) : path
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

yass <command> [path/to/dir] [options]

  Build the site:
      yass build [path/to/dir] [options]

  Auto-build when files change:
      yass watch [path/to/dir] [options]

  Create a new site:
      yass init [path/to/dir]

  Options:
          ).strip
          opts.on("--clean", "Remove unknown files from dist/ when bulding") { config.clean = true }
          opts.on("--dest=DIR", "Build to a different directory") { |dir| config.dest = find_path(dir, cwd: Dir.pwd) }
          opts.on("--no-strip-index", "Disable the strip_index Liquid filter") { config.strip_index = false }
          opts.on("--debug", "Print stack traces") { config.debug = true }
          opts.on("-h", "--help", "Prints this help") { config.stdout.puts opts; exit }
        }
      end

      def self.default_config
        Config.new({
          cwd: Pathname.new(Dir.pwd),
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
