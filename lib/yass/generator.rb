require 'fileutils'

module Yass
  class Generator
    attr_reader :site

    def initialize(site) = @site = site

    def generate!
      dest_dirs.each { |dir| FileUtils.mkdir_p dir }
      site.sources.each do |source|
        outfile = site.dest_dir.join(source.src_path)
        if source.dynamic?
          outfile, content = generate(source, outfile)
          outfile.write content
        else
          FileUtils.cp(source.path, outfile)
        end
      end
      clean if site.clean
    end

    private

    def generate(source, outfile, content = source.content)
      case outfile.extname
      when ".md"
        content = Kramdown::Document.new(content, input: "GFM").to_html
        return generate(source, outfile.sub(/\.md$/, ".html"), content)
      when ".liquid"
        template = LiquidTemplate.compile(site, source.src_path, content)
        content = template.render(source)
        return generate(source, outfile.sub(/\.liquid$/, ""), content)
      else
        return outfile, content if source.layout.nil?

        page = source.layout.render(source) { content }
        return outfile.dirname.join(source.dest_path.basename), page
      end
    end

    def clean
      expected_files = site.sources.map { |s| site.dest_dir.join(s.dest_path).to_s }
      actual_files = Dir[site.dest_dir.join("**/*")].reject { |p| Dir.exist? p }
      (actual_files - expected_files).each { |f| FileUtils.rm f }
    end

    def dest_dirs = site.sources.map { |s| s.outfile.dirname.to_s }.uniq
  end
end
