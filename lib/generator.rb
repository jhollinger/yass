require 'fileutils'

class Generator
  attr_reader :src_dir, :dest_dir

  def initialize(src_dir, dest_dir)
    @src_dir = src_dir
    @dest_dir = dest_dir
  end

  def generate!
    dest_dirs = sources.map(&:dirname).uniq
    dest_dirs.each { |dir| FileUtils.mkdir_p dir }
    sources.each { |src| src.write dest_dir }
  end

  private

  def sources
    return @sourcs if @sources

    dynamic = Dir[src_dir.join("**", "*.{erb,md}")]
    static = Dir[src_dir.join("**", "*.*")] - dynamic

    @sources = dynamic.map { |path| Source::Dynamic.new(path, src_dir) } +
      static.map { |path| Source::Static.new(path, src_dir) }
  end
end
