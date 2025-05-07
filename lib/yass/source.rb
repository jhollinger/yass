module Yass
  class Source
    EXT_CONVERSIONS = {"md" => "html"}.freeze
    attr_reader :path, :layout, :relative_path, :rendered_filename

    def initialize(config, path)
      @config = config
      @path = path
      @relative_path = path.relative_path_from config.src_dir
      @layout, @rendered_filename = parse_name(config)
      @local = config.local
    end

    def url
      url = relative_path.dirname.join(rendered_filename)
      index? && !@local ? url.dirname : url
    end

    def title
      fname = rendered_filename.sub(/\..+$/, "").to_s
      fname = relative_path.dirname.basename.to_s if fname == "index"
      fname = "Home" if fname == "."
      fname.sub(/[_-]+/, " ").split(/ +/).map(&:capitalize).join(" ")
    end

    def dynamic? = !!(/\.(erb|liquid|md)(\..*)?$/ =~ path.basename.to_s || layout)

    def index? = rendered_filename == "index.html"

    private

    def parse_name(config)
      name, exts = path.basename.to_s.split(".", 2)
      exts = exts.split(".").map { |x| EXT_CONVERSIONS[x] || x } - %w[erb liquid]
      return nil, "#{name}.#{exts.join "."}" if exts.size < 2

      layout = config.template_cache["layouts/#{exts[-2..].join(".")}"]
      exts.delete_at(-2) if layout

      return layout, "#{name}.#{exts.join "."}"
    end
  end
end
