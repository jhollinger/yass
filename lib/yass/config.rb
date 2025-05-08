module Yass
  Config = Struct.new(:root, :src, :dest, :layouts, :templates, :local, :stdin, :stdout, :stderr, :debug, keyword_init: true) do
    def src_dir = root.join src
    def dest_dir = root.join dest
    def template_dir = root.join templates
    def layout_dir = root.join layouts

    def layout_cache
      @layout_cache ||= Dir[layout_dir.join("*.liquid")].each_with_object({}) do |path, acc|
        path = Pathname.new(path)
        name = path.basename.to_s
        acc[name.sub(/\.liquid$/, "")] = LiquidTemplate.compile(self, name, path.read)
      end.freeze
    end

    def sources
      @sources ||= Dir[src_dir.join("**", "*")]
        .reject { |path| Dir.exist? path }
        .map { |path| Pathname.new path }
        .map { |path| Source.new(self, path) }
    end

    def liquid_env
      @liquid_env ||= Liquid::Environment.build do |env|
        env.error_mode = :strict
        env.file_system = Liquid::LocalFileSystem.new(template_dir.to_s, "%s.liquid")
        env.register_filter LiquidFilters
        env.register_tag 'highlight', LiquidTags::Highlight
      end
    end
  end
end
