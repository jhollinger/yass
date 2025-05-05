require 'fileutils'

module YASS
  class Generator
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def generate!
      dest_dirs = sources.map { |s| config.dest_dir.join(s.rel_path).dirname }.uniq
      dest_dirs.each { |dir| FileUtils.mkdir_p dir }
      sources.each { |src| src.write config.dest_dir }
    end

    private

    def sources
      return @sources if @sources

      dynamic = Dir[config.src_dir.join("**", "*.{erb,md}")]
      static = Dir[config.src_dir.join("**", "*.*")] - dynamic

      @sources = dynamic.map { |path| Sources::Dynamic.new(config, path) } +
        static.map { |path| Sources::Static.new(config, path) }
    end
  end
end
