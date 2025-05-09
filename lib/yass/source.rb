module Yass
  class Source
    EXT_CONVERSIONS = {"md" => "html"}.freeze
    attr_reader :config, :path, :layout, :relative_path, :dest_path

    def initialize(config, path)
      @config = config
      @path = path
      @relative_path = path.relative_path_from config.src_dir
      dest_filename, @layout= parse_name
      @dest_path = relative_path.dirname.join(dest_filename)
    end

    def url = index? && !config.local ? dest_path.dirname : dest_path

    def title
      fname = dest_path.basename.sub(/\..+$/, "").to_s
      fname = relative_path.dirname.basename.to_s if fname == "index"
      fname = "Home" if fname == "."
      fname.sub(/[_-]+/, " ").split(/ +/).map(&:capitalize).join(" ")
    end

    def dynamic? = !!(/\.(liquid|md)(\..+)?$/ =~ path.basename.to_s || layout)

    def index? = dest_path.basename.to_s == "index.html"

    private

    def parse_name
      name, exts = path.basename.to_s.split(".", 2)
      return name, nil if exts.nil?

      exts = exts.split(".").map { |x| EXT_CONVERSIONS[x] || x } - %w[liquid]
      return "#{name}.#{exts.join "."}", nil if exts.size < 2

      layout = config.layout_cache["#{exts[-2..].join(".")}"]
      exts.delete_at(-2) if layout

      return "#{name}.#{exts.join "."}", layout
    end
  end
end
