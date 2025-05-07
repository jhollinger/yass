require 'fileutils'

module Yass
  class Generator
    attr_reader :config
    Liquid::Environment.default.error_mode = :strict

    def initialize(config)
      @config = config
    end

    def generate!
      dest_dirs.each { |dir| FileUtils.mkdir_p dir }
      sources.each do |source|
        outfile = config.dest_dir.join(source.relative_path)
        if source.dynamic?
          outfile, content = generate(source, outfile)
          outfile.write content
        else
          FileUtils.cp(source.path, outfile)
        end
      end
    end

    private

    def generate(source, outfile, content = source.path.read)
      case outfile.extname
      when ".md"
        content = Kramdown::Document.new(content).to_html
        return generate(source, outfile.sub(/\.md$/, ".html"), content)
      when ".liquid"
        template = LiquidTemplate.compile(content)
        content = template.render(config, Page.new(source))
        return generate(source, outfile.sub(/\.liquid$/, ""), content)
      when ".erb"
        template = ErbTemplate.compile(content)
        content = template.render(config, Page.new(source))
        return generate(source, outfile.sub(/\.erb$/, ""), content)
      else
        return outfile, content if source.layout.nil?

        content = HtmlSafeString.new(content)
        page = source.layout.render(config, Page.new(source)) { content }
        return outfile.dirname.join(source.rendered_filename), page
      end
    end

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
