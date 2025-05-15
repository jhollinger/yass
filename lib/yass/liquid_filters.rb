module Yass
  module LiquidFilters
    def relative(url)
      url = Pathname.new(url)
      to = context.registers[:source].dest_path
      in_root = to.dirname.to_s == "."
      updirs = in_root ? [] : to.dirname.to_s.split("/").map { ".." }
      Pathname.new([*updirs, url].join("/")).to_s
    end

    def strip_index(url)
      path = strip_index? ? url.sub(%r'/?index\.html([\?#][^/]*)?$', '\1') : url
      path == "" ? "." : path
    end

    def match(str, regex) = Regexp.new(regex).match? str

    def where_match(objects, field, regex)
      regex = Regexp.new(regex)
      objects.select { |obj| regex =~ obj[field].to_s }
    end

    def where_not(objects, field, value) = objects.reject { |obj| obj[field] == value }

    private

    def strip_index? = context.registers[:source].site.strip_index
  end
end
