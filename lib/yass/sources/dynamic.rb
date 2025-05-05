module YASS
  module Sources
    class Dynamic < Base
      def write(outdir)
        outfile, content = generate(outdir.join(rel_path), fs_path.read)
        outfile.write content
      end

      def generate(outfile, content)
        case outfile.extname
        when ".md"
          content = Kramdown::Document.new(content).to_html
          return generate(outfile.sub(/\.md$/, ""), content)
        when ".erb"
          template = ErbTemplate.compile(content)
          content = Page.new(config, rel_path).render(template)
          return generate(outfile.sub(/\.erb$/, ""), content)
        else
          page = Page.new(config, rel_path)
          return outfile, content if page.layout.nil?

          content = HtmlSafeString.new(content)
          page = page.render(page.layout) { content }
          return outfile, page
        end
      end
    end
  end
end
