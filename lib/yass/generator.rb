require 'fileutils'

module Yass
  class Generator
    attr_reader :site

    def initialize(site) = @site = site

    def generate!
      dest_dirs.each { |dir| FileUtils.mkdir_p dir }
      site.sources.each do |source|
        outfile = source.outfile
        if source.dynamic?
          outfile.write Renderer.new(source).render
        else
          FileUtils.cp(source.path, outfile)
        end
      end
      clean if site.clean
    end

    private

    def clean
      expected_files = site.sources.map { |s| site.dest_dir.join(s.dest_path).to_s }
      actual_files = Dir[site.dest_dir.join("**/*")].reject { |p| Dir.exist? p }
      (actual_files - expected_files).each { |f| FileUtils.rm f }
    end

    def dest_dirs = site.sources.map { |s| s.outfile.dirname.to_s }.uniq
  end
end
