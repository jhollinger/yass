module Yass
  module LiquidFilters
    def relative_to(url, to)
      url, to = Pathname.new(url), Pathname.new(to)
      in_root = to.dirname.to_s == "."
      updirs = in_root ? [] : to.dirname.to_s.split("/").map { ".." }
      Pathname.new([*updirs, url].join("/")).to_s
    end

    def match(str, regex) = Regexp.new(regex).match? str
  end
end
