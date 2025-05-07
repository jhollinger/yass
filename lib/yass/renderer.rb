module Yass
  class Renderer
    attr_reader :config, :page

    def initialize(config, source)
      @config = config
      @page = Page.new(source)
    end

    def render(template) = template.result(binding { yield })

    def template(name) = render config.template_cache.fetch(name)

    def raw(str) = HtmlSafeString.new(str)

    def pages = files "**/*.{html,md}*"

    def files(glob = "**/*.*")
      paths = Dir[config.src_dir.join(glob)]
      paths.map { |path| Source.new(config, Pathname.new(path)) }
    end

    def relative_path_to(file)
      in_root = page.path.dirname.to_s == "."
      updirs = in_root ? [] : page.path.dirname.to_s.split("/").map { ".." }
      path = Pathname.new([*updirs, file].join("/"))
      path.basename.to_s == "index.html" && !config.local ? path.dirname : path
    end
  end
end
