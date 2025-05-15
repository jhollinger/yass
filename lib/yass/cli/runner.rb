require 'fileutils'

module Yass
  module CLI
    module Runner
      INIT_DIR = Pathname.new(File.expand_path(File.join("..", "..", "..", "..", "docs-src"), __FILE__))

      def self.build(config, argv:) config.cwd = Helpers.get_working_dir! argv
        site = Site.new(config.dup.freeze)
        Generator.new(site).generate!
        return 0
      rescue => e
        raise e if config.debug
        config.stderr.puts "#{e.class.name}: #{e.message}"
        return 1
      end

      def self.init(config, argv:)
        config.cwd = Helpers.get_working_dir! argv
        site = Site.new(config.dup.freeze)

        Dir[INIT_DIR.join("**/*.*")].each do |path|
          dest = site.cwd.join Pathname.new(path).relative_path_from(INIT_DIR)
          site.stdout.puts "Creating #{dest}"
          FileUtils.mkdir_p dest.dirname unless dest.dirname.exist?
          FileUtils.cp(path, dest) unless dest.exist?
        end
        return 0
      rescue => e
        raise e if config.debug
        config.stderr.puts "#{e.class.name}: #{e.message}"
        return 1
      end

      def self.watch(config, argv:)
        config.cwd = Helpers.get_working_dir! argv
        site = Site.new(config.dup.freeze)

        site.stdout.puts "Watching for changes..."
        watcher = Filewatcher.new([site.src_dir, site.layout_dir, site.template_dir].map(&:to_s))
        yield watcher if block_given?

        Yass::CLI::Runner.build(config, argv: argv)
        watcher.watch do |changes|
          files = changes.map { |f, _| Pathname.new(f).relative_path_from(site.cwd).to_s }.reject { |f| Dir.exist? f }
          # TODO use \r?
          site.stdout.puts "Building #{files.join ", "}"
          site.clear_cache!
          Yass::CLI::Runner.build(config, argv: argv)
        end
        return 0
      end
    end
  end
end
