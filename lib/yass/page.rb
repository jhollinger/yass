require 'forwardable'

module Yass
  class Page
    extend Forwardable

    def initialize(source) = @source = source

    def_delegators :@source, :title, :url
    def_delegator :@source, :relative_path, :path
  end
end
