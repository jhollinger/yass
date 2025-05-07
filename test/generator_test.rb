require 'test_helper'

class GeneratorTest < Minitest::Test
  include TestHelpers

  def test_generate
    with_config do |config|
      create_files config
      Yass::Generator.new(config).generate!

      dir = config.dest_dir
      assert_equal styles, dir.join("assets", "styles.css").read
      assert_equal "body { color: #222; }", dir.join("assets", "styles2.css").read

      # test layout with relative paths
      assert_match(/<link rel="stylesheet" href="assets\/styles\.css">/, dir.join("index.html").read)
      assert_match(/<link rel="stylesheet" href="assets\/styles\.css">/, dir.join("foo.html").read)
      assert_match(/<link rel="stylesheet" href="\.\.\/assets\/styles\.css">/, dir.join("posts", "post3.html").read)

      assert_match(/<p>HOME<\/p>/, dir.join("index.html").read)
      assert_match(/<h2>Foo<\/h2>/, dir.join("foo.html").read)
      assert_equal "<h2>Bar</h2>", dir.join("bar.html").read
      assert_equal "<h2 id=\"post-1\">Post 1</h2>", dir.join("posts", "post1.html").read.chomp
      assert_equal "<h3 id=\"post-2\">Post 2</h3>", dir.join("posts", "post2.html").read.chomp
      assert_match(/<h3 id="post-3">Post 3<\/h3>/, dir.join("posts", "post3.html").read)
    end
  end

  private

  def create_files(config)
    FileUtils.mkdir_p config.src_dir.join("posts")
    FileUtils.mkdir_p config.src_dir.join("assets")
    File.write(config.template_dir.join("layouts", "page.html.erb"), page_layout)
    File.write(config.src_dir.join("assets", "styles.css"), styles)
    File.write(config.src_dir.join("assets", "styles2.css.erb"), styles2)
    File.write(config.src_dir.join("index.page.html.erb"), index)
    File.write(config.src_dir.join("foo.page.html"), foo)
    File.write(config.src_dir.join("bar.html"), bar)
    File.write(config.src_dir.join("posts", "post1.md"), post1)
    File.write(config.src_dir.join("posts", "post2.md.erb"), post2)
    File.write(config.src_dir.join("posts", "post3.page.md.erb"), post3)
  end

  def styles = "body { background-color: #b0b0b0; }"

  def styles2 = "body { color: <%= '#222' %>; }"

  def index = "<p><%= page.title.upcase %></p>"

  def foo = "<h2>Foo</h2>"

  def bar = "<h2>Bar</h2>"

  def post1 = "## Post 1"

  def post2 = "### Post <%= 1 + 1 %>"

  def post3 = "### Post <%= 2 + 1 %>"

  def page_layout
    %(<!DOCTYPE html>
<html lang="en">
  <head>
    <title><%= page.title %></title>
    <% files("**/*.css*").each do |f| %>
      <link rel="stylesheet" href="<%= relative_path_to f.url %>">
    <% end %>
  </head>
  <body>
<%= yield %>
  </body>
</html>)
  end
end
