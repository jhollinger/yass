module Yass
  class Page
    attr_reader :config, :title, :url, :path

    def initialize(config, source)
      @config = config
      @title = source.title
      @url = source.url
      @path = source.relative_path
    end

    def relative_path_to(file)
      in_root = path.dirname.to_s == "."
      updirs = in_root ? [] : path.dirname.to_s.split("/").map { ".." }
      path = Pathname.new([*updirs, file].join("/"))
      path.basename.to_s == "index.html" && !config.local ? path.dirname : path
    end

    def render(template) = template.result(binding { yield })

    def template(name) = render config.template_cache.fetch(name)

    def raw(str) = HtmlSafeString.new(str)

    def pages = files "**/*.{html,md}*"

    def files(glob = "**/*.*")
      paths = Dir[config.src_dir.join(glob)]
      paths.map { |path| Source.new(config, Pathname.new(path)) }
    end
  end
end
