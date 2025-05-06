require 'fileutils'

module YASS
  class Source
    attr_reader :config, :path, :layout, :relative_path, :rendered_filename

    def initialize(config, path)
      @config = config
      @path = path
      @relative_path = path.relative_path_from config.src_dir
      @layout, @rendered_filename = parse_name
    end

    def write
      outfile = config.dest_dir.join(relative_path)
      return FileUtils.cp(path, outfile) unless dynamic?

      outfile, content = generate(outfile, path.read)
      outfile.write content
    end

    def url
      url = relative_path.dirname.join(rendered_filename)
      config.local ? url : url.sub(/\/index\.html$/, "/")
    end

    def title
      fname = rendered_filename.sub(/\..+$/, "")
      fname = relative_path.dirname.basename if fname.to_s == "index"
      fname = "" if fname.to_s == "."
      fname = fname.to_s.sub(/[_-]+/, " ")
      fname.split(/ +/).map(&:capitalize).join(" ")
    end

    private

    def dynamic? = !!(/\.(erb,md)$/ =~ path.basename.to_s || layout)

    def parse_name
      name, exts = path.basename.to_s.split(".", 2)
      exts = exts.split(".").map { |x| x == "md" ? "html" : x } - %w[erb]
      return nil, "#{name}.#{exts.join "."}" if exts.size < 2

      layout = config.template_cache["layouts/#{exts[-2..].join(".")}.erb"]
      exts = exts[0..-3] + [exts[-1]] if layout

      return layout, "#{name}.#{exts.join "."}"
    end

    def generate(outfile, content)
      case outfile.extname
      when ".md"
        content = Kramdown::Document.new(content).to_html
        return generate(outfile.sub(/\.md$/, ".html"), content)
      when ".erb"
        template = ErbTemplate.compile(content)
        content = Page.new(self).render(template)
        return generate(outfile.sub(/\.erb$/, ""), content)
      else
        return outfile, content if layout.nil?

        content = HtmlSafeString.new(content)
        page = Page.new(self).render(layout) { content }
        return outfile.dirname.join(rendered_filename), page
      end
    end
  end
end
