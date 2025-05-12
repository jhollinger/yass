module Yass
  Config = Struct.new(:cwd, :src, :dest, :layouts, :templates, :clean, :strip_index, :stdin, :stdout, :stderr, :debug, keyword_init: true) do
    def src_dir = @src_dir ||= get_dir(src)
    def dest_dir = @dest_dir ||= get_dir(dest)
    def template_dir = @template_dir ||= get_dir(templates)
    def layout_dir = @layout_dir ||= get_dir(layouts)

    def clear_cache!
      @sources = nil
      @layout_cache = nil
    end

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
        env.register_tag 'render_content', LiquidTags::RenderContent
      end
    end

    private

    def get_dir(dir) = CLI::Helpers.find_path(dir, cwd: cwd)
  end
end
