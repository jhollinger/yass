module Yass
  class Renderer
    attr_reader :source

    def initialize(source) = @source = source

    def render(outfile = source.site.dest_dir.join(source.src_path), content = source.content, layout: true)
      case outfile.extname
      when ".md"
        content = Kramdown::Document.new(content, input: "GFM").to_html
        return render(outfile.sub(/\.md$/, ".html"), content, layout: layout)
      when ".liquid"
        template = LiquidTemplate.compile(source.site, source.src_path, content)
        content = template.render(source)
        return render(outfile.sub(/\.liquid$/, ""), content, layout: layout)
      else
        return outfile, content if source.layout.nil? || !layout

        page = source.layout.render(source) { content }
        return outfile.dirname.join(source.dest_path.basename), page
      end
    end
  end
end
