module Yass
  Config = Struct.new(:root, :src, :dest, :templates, :local, :stdin, :stdout, :stderr, :debug, keyword_init: true) do
    def src_dir = root.join(src)
    def dest_dir = root.join(dest)
    def template_dir = root.join(templates)

    def template_cache
      @template_cache ||= Dir[template_dir.join("**/*.*")].each_with_object({}) do |path, acc|
        path = Pathname.new(path)
        key = path.relative_path_from(template_dir).to_s
        case path.extname
        when ".liquid"
          acc[key.sub(/\.liquid$/, "")] = LiquidTemplate.compile path.read
        when ".erb"
          acc[key.sub(/\.erb$/, "")] = ErbTemplate.compile path.read
        end
      end.freeze
    end
  end
end
