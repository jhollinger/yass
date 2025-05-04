require 'bundler/setup'

ROOT = Pathname.new(File.expand_path("..", __FILE__))
LIB_DIR = ROOT.join("lib")
SRC_DIR = ROOT.join("src")
DEST_DIR = ROOT.join("dest")

desc "Generate site"
task :generate => :environment do
  Generator.new(SRC_DIR, DEST_DIR).generate!
end

task :environment do
  Bundler.require(:default)
  Zeitwerk::Loader.new.tap do |loader|
    loader.push_dir LIB_DIR
    loader.setup
  end
end
