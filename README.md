# yass

Yet Another Static Site (generator)

Yass is an incredibly unopinioanted static site generator. Here's how it works:

* You write everything by hand under `site/`.
* Everything under `site/` is copied to `dist/`.
* [Markdown](https://commonmark.org/) (`.md`) and [Liquid](https://shopify.github.io/liquid/) (`.liquid`) files are processed.
* Liquid layouts and templates can be placed into `layouts/` and `templates/`.
* Helpers are available in addition to Liquid's standard functionality.
* Syntax highlighting via [Highlight.js](https://highlightjs.org/).
* Want to preview your site? Build it and open `dist/index.html` in your browser.

## Getting started

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

## License & copywrite

MIT License. See LICENSE for details.

Copyright (c) 2025 Jordan Hollinger.
