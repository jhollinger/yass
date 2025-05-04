require 'bundler/setup'

ROOT = Pathname.new(File.expand_path("..", __FILE__))
SRC_DIR = ROOT.join("src")
DEST_DIR = ROOT.join("dist")

desc "Generate site (with links to index.html's)"
task :generate => :environment do
  Generator.new(SRC_DIR, DEST_DIR).generate!
end

namespace :generate do
  desc "Generate site in local mode ('path/index.html' instead of 'path/')"
  task :local => :environment do
    Page.index_in_urls = true
    Generator.new(SRC_DIR, DEST_DIR).generate!
  end
end

task :environment do
  Bundler.require(:default)
  Zeitwerk::Loader.new.tap do |loader|
    loader.push_dir ROOT.join("lib")
    loader.setup
  end
end
