module Yass
  class Page
    attr_reader :config, :source

    def initialize(config, source)
      @config = config
      @source = source
    end

    def title = source.title

    def relative_path_to(file)
      in_root = source.relative_path.dirname.to_s == "."
      updirs = in_root ? [] : source.relative_path.dirname.to_s.split("/").map { ".." }
      path = Pathname.new([*updirs, file].join("/"))
      path.basename.to_s == "index.html" && !config.local ? path.dirname : path
    end

    def render(template) = template.result(binding { yield })

    def template(name) = render config.template_cache.fetch(name)

    def url = source.url

    def path = source.relative_path

    def raw(str) = HtmlSafeString.new(str)

    def pages = files "**/*.{html,md}*"

    def files(glob = "**/*.*")
      paths = Dir[config.src_dir.join(glob)]
      paths.map { |path| Source.new(config, Pathname.new(path)) }
    end
  end
end
