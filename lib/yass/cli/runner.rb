require 'fileutils'

module Yass
  module CLI
    module Runner
      INIT_DIR = Pathname.new(File.expand_path(File.join("..", "..", "..", "template"), __FILE__))

      def self.build(config, argv:)
        args = Helpers.get_args!(argv, max: 1)
        config.root = Pathname.new(args[0] || Dir.pwd)
        Generator.new(config).generate!
        return 0
      rescue => e
        raise e if config.debug
        config.stderr.puts "#{e.class.name}: #{e.message}"
        return 1
      end

      def self.init(config, argv:)
        args = Helpers.get_args!(argv, max: 1)
        config.root = Pathname.new(args[0] || Dir.pwd)

        config.stdout.puts "Creating #{config.src_dir}"
        FileUtils.mkdir_p config.src_dir

        config.stdout.puts "Creating #{config.template_dir}"
        FileUtils.mkdir_p config.template_dir

        config.stdout.puts "Creating #{config.layout_dir}"
        FileUtils.mkdir_p config.layout_dir

        Dir[INIT_DIR.join("**/*.*")].each do |path|
          dest = config.root.join Pathname.new(path).relative_path_from(INIT_DIR)
          FileUtils.cp(path, dest) unless dest.exist?
        end

        return 0
      rescue => e
        raise e if config.debug
        config.stderr.puts "#{e.class.name}: #{e.message}"
        return 1
      end
    end
  end
end
