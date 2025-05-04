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
        return generate(outfile.sub(/\.erb$/, ""), template.render)
      when ".html"
        #content = PAGE_LAYOUT.render { content }
        return outfile, content
      else
        return outfile, content
      end
    end
  end
end
