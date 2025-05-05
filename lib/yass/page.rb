module YASS
  class Page < File
    def render(template) = template.result(binding { yield })

    def layout = templates["layouts/default#{final_path.extname}.erb"]

    def raw(str) = HtmlSafeString.new(str)

    def files(glob = "**/*.*")
      Dir[config.src_dir.join(glob)]
        .map { |path| Pathname.new(path).relative_path_from config.src_dir }
        .map { |path| File.new(config, relative_path_to(path)) }
    end

    def templates
      @templates ||= Dir[config.template_dir.join("**/*.erb")].each_with_object({}) do |path, acc|
        template = Pathname.new(path)
        key = template.relative_path_from(config.template_dir).to_s
        acc[key] = ErbTemplate.compile template.read
      end.freeze
    end
  end
end
