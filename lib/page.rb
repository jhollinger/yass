class Page
  attr_reader :path, :options

  def initialize(path, options = {})
    @path = path
    @options = options
  end

  def render(template)
    template.result(binding { yield })
  end

  def title
    fname = path.basename.sub(/\..+$/, "")
    fname = path.dirname.basename if fname.to_s == "index"
    fname = "" if fname.to_s == "."
    fname = fname.to_s.sub(/[_-]+/, " ")
    fname.split(/ +/).map(&:capitalize).join(" ")
  end

  def url
    url = path.sub(/\.html.+$/, ".html")
    ENV["HIDE_INDEX"] == "0" ? url : url.sub(/index\.html$/, "")
  end

  private

  def path_to(target_path)
    in_root = path.dirname.to_s == "."
    updirs = in_root ? [] : path.dirname.to_s.split("/").map { ".." }
    [*updirs, target_path].join("/")
  end

  def pages
    Dir[SRC_DIR.join("**", "*.html*")]
      .map { |path| Pathname.new(path).relative_path_from(SRC_DIR) }
      .map { |path| Page.new(Pathname.new(path_to path)) }
  end

  def bind = binding { yield }

  def raw(str) = HtmlSafeString.new(str)
end
