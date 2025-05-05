require 'fileutils'

module YASS
  module Sources
    class Static < Base
      def write(outdir) = FileUtils.cp(fs_path, outfile(outdir))

      def outfile(outdir) = outdir.join(rel_path)
    end
  end
end
