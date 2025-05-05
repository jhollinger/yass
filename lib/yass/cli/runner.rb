require 'fileutils'

module YASS
  module CLI
    module Runner
      def self.build(config)
        YASS::Generator.new(config).generate!
        return 0
      rescue => e
        config.stderr.puts "#{e.class.name}: #{e.message}"
        return 1
      end

      def self.init(config)
        config.stdout.puts "Creating #{config.src_dir}"
        FileUtils.mkdir_p config.src_dir

        config.stdout.puts "Creating #{config.template_dir}"
        FileUtils.mkdir_p config.template_dir.join("layouts")
        return 0
      rescue => e
        config.stderr.puts "#{e.class.name}: #{e.message}"
        return 1
      end
    end
  end
end
