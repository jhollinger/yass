require 'fileutils'

module YASS
  class Generator
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def generate!
      dest_dirs.each { |dir| FileUtils.mkdir_p dir }
      sources.each(&:write)
    end

    private

    def dest_dirs
      sources.map { |s| config.dest_dir.join(s.relative_path).dirname }.uniq
    end

    def sources
      @sources ||= Dir[config.src_dir.join("**", "*")]
        .reject { |path| Dir.exist? path }
        .map { |path| Pathname.new path }
        .map { |path| Source.new(config, path) }
    end
  end
end
