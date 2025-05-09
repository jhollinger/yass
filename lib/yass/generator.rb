require 'fileutils'

module Yass
  class Generator
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def generate!
      dest_dirs.each { |dir| FileUtils.mkdir_p dir }
      config.sources.each do |source|
        outfile = config.dest_dir.join(source.relative_path)
        if source.dynamic?
          outfile, content = generate(source, outfile)
          outfile.write content
        else
          FileUtils.cp(source.path, outfile)
        end
      end
      clean if config.clean
    end

    private

    def generate(source, outfile, content = source.path.read)
      case outfile.extname
      when ".md"
        content = Kramdown::Document.new(content).to_html
        return generate(source, outfile.sub(/\.md$/, ".html"), content)
      when ".liquid"
        template = LiquidTemplate.compile(config, source.relative_path, content)
        content = template.render(source)
        return generate(source, outfile.sub(/\.liquid$/, ""), content)
      else
        return outfile, content if source.layout.nil?

        page = source.layout.render(source) { content }
        return outfile.dirname.join(source.dest_path.basename), page
      end
    end

    def clean
      expected_files = config.sources.map { |s| config.dest_dir.join(s.dest_path).to_s }
      actual_files = Dir[config.dest_dir.join("**/*")].reject { |p| Dir.exist? p }
      (actual_files - expected_files).each { |f| FileUtils.rm f }
    end

    def dest_dirs
      config.sources.map { |s| config.dest_dir.join(s.relative_path).dirname }.uniq
    end
  end
end
