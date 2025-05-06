require 'fileutils'

module Yass
  module CLI
    module Runner
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
        FileUtils.mkdir_p config.template_dir.join("layouts")
        return 0
      rescue => e
        raise e if config.debug
        config.stderr.puts "#{e.class.name}: #{e.message}"
        return 1
      end
    end
  end
end
