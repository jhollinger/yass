require 'erb'

class Template
  attr_reader :src_root, :src_path

  def initialize(src_root, src_path)
    @src_root = src_root
    @src_path = src_path
  end

  def render
  end
end
