module Sources
  class Dynamic < Base
    PAGE_LAYOUT = ErbTemplate.compile ROOT.join("layouts", "page.html.erb").read

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
        content = Page.new(rel_path).render(template)
        return generate(outfile.sub(/\.erb$/, ""), content)
      when ".html"
        content = HtmlSafeString.new(content)
        html = Page.new(rel_path).render(PAGE_LAYOUT) { content }
        return outfile, html
      else
        return outfile, content
      end
    end
  end
end
