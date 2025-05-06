module Yass
  Config = Struct.new(:root, :src, :dest, :templates, :local, :stdin, :stdout, :stderr, :debug, keyword_init: true) do
    def src_dir = root.join(src)
    def dest_dir = root.join(dest)
    def template_dir = root.join(templates)

    def template_cache
      @template_cache ||= Dir[template_dir.join("**/*.erb")].each_with_object({}) do |path, acc|
        template = Pathname.new(path)
        key = template.relative_path_from(template_dir).to_s
        acc[key] = ErbTemplate.compile template.read
      end.freeze
    end
  end
end
