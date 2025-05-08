# yass

Yet Another Static Site (generator)

Yass is an incredibly un-opinionated static site generator. Here's how it works:

* Write everything by hand under `site/`.
* Everything under `site/` is copied to `dist/`.
* [Markdown](https://commonmark.org/) (`.md`) and [Liquid](https://shopify.github.io/liquid/) (`.liquid`) files are processed.
* Liquid layouts and templates can be placed into `layouts/` and `templates/`.
* Helpers are available in addition to Liquid's standard functionality.
* Syntax highlighting via [Highlight.js](https://highlightjs.org/).
* Want to preview your site? Build it and open `dist/index.html` in your browser.

## Getting started

Starting from an empty page isn't fun, so `yass init` will create a skeleton site for you.

```bash
$ gem install yass
$ yass init blog
Creating blog/layouts/default.html.liquid
Creating blog/site/assets/highlight-default.css
Creating blog/site/assets/highlight.min.js
Creating blog/site/index.default.html.liquid
Creating blog/templates/css_links.liquid
Creating blog/templates/js_scripts.liquid
$ cd blog
```

## Building

The built site will be placed into `dist`.

```bash
yass build
```

If you're building for local viewing, use the `--local` option. It ensures any generated URLs ending in `/` have `.index.html` appended.

```bash
yass build --local
```

## Layouts

Layouts live in `layouts/` and will be applied to files with matching names.

*templates/page.html.liquid*

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>{{ page.title }}</title>
  </head>
  <body>{{ content }}</body>
</html>
```

This template will be applied to files with names like `foo.page.html` and `foo.page.html.liquid`. The `.page` part of the name will be removed from the final file.

Since Markdown files (`foo.page.md`, `foo.page.md.liquid`) are converted to `.html` files, they'll also use `.html` templates.

## Templates

Templates live in `templates/` and can be used in any `.liquid` files.

*templates/hi.liquid*

```html
<p>Hi, my name is {{ name }}</p>
```

Render the above template with `{% render "hi", name: "Pleck" %}`.

NOTE: Liquid is pretty strict about template filenames. They must match `^[a-zA-Z0-9_]\.liquid$`.

## Liquid variables

### page

An object representing the current page. Properties:

* `title` A titleized version of the filename (e.g. *My File* from *my-file.html*)
* `url` URL path to the file (note that *index.html* stripped unless the `--local` option is used)
* `path` Same as `url` except *index.html* is never stripped
* `dirname` Directory file is in (e.g. *foo/bar* from *foo/bar/zorp.html*)
* `filename` Name of file (e.g. *zorp.html* from *foo/bar/zorp.html*)
* `extname` File extension (e.g. *.html* from *foo/bar/zorp.html*)
* `src_path` Path with the original filename (e.g. *foo/index.md.liquid*)

### files

Any array of all files that will be written `dist/`. Same properties as `page`.

## Liquid filters

### relative_to

Modifies a path to be relative to another path. Useful in layouts and template that need to refer to another file.

```html
<script src="{{ "assets/main.js" | relative_to: page.path }}"</script>
```

### match

Returns true if the string matches the regex.

```liquid
{% assign is_asset = page.path | match: "\.(css|js|jpe?g)$"
```

## Liquid tags

### highlight

Converts the given code into something useable by [Highlight.js](https://highlightjs.org/).

```liquid
{% highlight ruby %}
puts "Yass!"
{% endhighlight %}
```

Hightlight.js CSS and JS files (common languages) are generated and included by default with `yass init`. [Download](https://highlightjs.org/download) your own versions if you want different languages or themes.

## Legal

MIT License. See LICENSE for details.

Copyright (c) 2025 Jordan Hollinger.
