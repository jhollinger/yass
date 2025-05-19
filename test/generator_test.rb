require 'test_helper'

class GeneratorTest < Minitest::Test
  include TestHelpers

  def test_generate
    with_site do |site|
      create_files site
      Yass::Generator.new(site).generate!

      dir = site.dest_dir
      assert_equal styles, dir.join("assets", "styles.css").read
      assert_equal "body { color: #222; }", dir.join("assets", "styles2.css").read

      # test layout with relative paths
      assert_match(/<link rel="stylesheet" href="assets\/styles\.css">/, dir.join("index.html").read)
      assert_match(/<link rel="stylesheet" href="assets\/styles\.css">/, dir.join("foo.html").read)
      assert_match(/<link rel="stylesheet" href="\.\.\/assets\/styles\.css">/, dir.join("posts", "post3.html").read)

      assert_match(/<p>Home<\/p>/, dir.join("index.html").read)
      assert_match(/<h2>Foo<\/h2>/, dir.join("foo.html").read)
      assert_match(/<p>Template received: Zorp!<\/p>/, dir.join("zorp.html").read)
      assert_equal "<h2>Bar</h2>", dir.join("bar.html").read
      assert_equal "<h2 id=\"post-1\">Post 1</h2>", dir.join("posts", "post1.html").read.chomp
      assert_equal "<h3 id=\"post-2\">Post 2</h3>", dir.join("posts", "post2.html").read.chomp
      assert_match(/<h3 id="post-3">Post 3<\/h3>/, dir.join("posts", "post3.html").read)
      refute dir.join("posts", "post4.html").exist?
    end
  end

  def test_generate_with_drafts
    with_config do |config|
      config.include_drafts = true
      site = Yass::Site.new(config)
      create_files site
      Yass::Generator.new(site).generate!

      assert site.dest_dir.join("posts", "post4.html").exist?
    end
  end

  def test_clean
    with_config do |config|
      config.clean = true
      site = Yass::Site.new(config)
      FileUtils.mkdir_p site.dest_dir.join("old")
      File.write(site.dest_dir.join("old", "old-foo.html"), "")
      File.write(site.dest_dir.join("old-bar.png"), "")

      create_files site
      Yass::Generator.new(site).generate!

      expected_files = %w[assets/styles.css assets/styles2.css index.html foo.html zorp.html bar.html posts/post1.html posts/post2.html posts/post3.html]
      actual_files = Dir[site.dest_dir.join("**/*")]
        .reject { |p| Dir.exist? p }
        .map { |p| Pathname.new(p).relative_path_from(site.dest_dir).to_s }
      assert_equal expected_files.sort, actual_files.sort
    end
  end

  private

  def create_files(site)
    FileUtils.mkdir_p site.src_dir.join("posts")
    FileUtils.mkdir_p site.src_dir.join("assets")
    File.write(site.layout_dir.join("page.html.liquid"), page_layout)
    File.write(site.template_dir.join("foo.liquid"), foo_template)
    File.write(site.src_dir.join("assets", "styles.css"), styles)
    File.write(site.src_dir.join("assets", "styles2.css.liquid"), styles2)
    File.write(site.src_dir.join("index.html.liquid"), index)
    File.write(site.src_dir.join("foo.html"), foo)
    File.write(site.src_dir.join("zorp.html.liquid"), zorp)
    File.write(site.src_dir.join("bar.html"), bar)
    File.write(site.src_dir.join("posts", "post1.md"), post1)
    File.write(site.src_dir.join("posts", "post2.md.liquid"), post2)
    File.write(site.src_dir.join("posts", "post3.md.liquid"), post3)
    File.write(site.src_dir.join("posts", "post4.md.liquid"), post4)
  end

  def styles = "body { background-color: #b0b0b0; }"

  def styles2 = "body { color: {{ '#222' }}; }"

  def index = "---\nlayout: page\n---\n<p>{{ page.title }}</p>"

  def foo = "---\nlayout: page\n---\n<h2>Foo</h2>"

  def zorp = '<p>{% render "foo", message: "Zorp!" %}</p>'

  def bar = "<h2>Bar</h2>"

  def post1 = "## Post 1"

  def post2 = "### Post {{ 2 }}"

  def post3 = "---\nlayout: page\n---\n### Post {{ 3 }}"

  def post4 = "---\npublished: false\n---### WIP"

  def foo_template = "Template received: {{ message }}"

  def page_layout
    %(<!DOCTYPE html>
<html lang="en">
  <head>
    <title>{{ page.title }}</title>
    {% assign css_files = site.files | where: "extname", ".css" %}
    {% for file in css_files %}
      <link rel="stylesheet" href="{{ file.path | relative }}">
    {% endfor %}
  </head>
  <body>
{{ content }}
  </body>
</html>)
  end
end
