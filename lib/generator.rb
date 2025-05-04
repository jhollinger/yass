require 'fileutils'

class Generator
  attr_reader :src_dir, :dest_dir

  def initialize(src_dir, dest_dir)
    @src_dir = src_dir
    @dest_dir = dest_dir
  end

  def generate!
    dest_dirs = sources.map { |s| dest_dir.join(s.rel_path).dirname }.uniq
    dest_dirs.each { |dir| FileUtils.mkdir_p dir }
    sources.each { |src| src.write dest_dir }
  end

  private

  def sources
    return @sources if @sources

    dynamic = Dir[src_dir.join("**", "*.{erb,md}")]
    static = Dir[src_dir.join("**", "*.*")] - dynamic

    @sources = dynamic.map { |path| Sources::Dynamic.new(path, src_dir) } +
      static.map { |path| Sources::Static.new(path, src_dir) }
  end
end
