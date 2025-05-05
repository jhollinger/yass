module YASS
  Config = Struct.new(:root, :src, :dest, :templates, :local, :stdin, :stdout, :stderr, keyword_init: true) do
    def src_dir = root.join(src)
    def dest_dir = root.join(dest)
    def template_dir = root.join(templates)
  end
end
