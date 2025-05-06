module YASS
  class Page
    attr_reader :source

    def initialize(source)
      @source = source
    end

    def title = source.title

    def relative_path_to(file)
      in_root = source.relative_path.dirname.to_s == "."
      updirs = in_root ? [] : source.relative_path.dirname.to_s.split("/").map { ".." }
      Pathname.new([*updirs, file].join("/"))
    end

    def render(template) = template.result(binding { yield })

    def template(name) = render source.config.template_cache.fetch(name)

    def url = source.url

    def path = source.relative_path

    def raw(str) = HtmlSafeString.new(str)

    def pages = files "**/*.{html,md}*"

    def files(glob = "**/*.*")
      paths = Dir[source.config.src_dir.join(glob)]
      paths.map { |path| Source.new(source.config, Pathname.new(path)) }
    end
  end
end
