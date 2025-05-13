# yass

Yet Another Static Site (generator)

Yass is an incredibly un-opinionated static site generator. [Learn more!](https://jhollinger.github.io/yass/)

## Getting started

Starting from a blank page isn't fun, so `yass init` spits out the source to [jhollinger.github.io/yass/](https://jhollinger.github.io/yass/) to help get you started.

```bash
$ gem install yass
$ yass init blog
Creating blog/layouts/default.html.liquid
Creating blog/layouts/splash.html.liquid
Creating blog/site/assets/highlight.min.js
Creating blog/site/assets/highlightjs-atom-one-dark.min.css
Creating blog/site/assets/main.css.liquid
Creating blog/site/helpers/index.md.liquid
Creating blog/site/index.md.liquid
Creating blog/site/layouts-templates/index.md.liquid
Creating blog/templates/asset_tags.liquid
Creating blog/templates/nav.liquid
$ cd blog
```

## Building

The built site will be placed into `dist`.

```bash
yass build
```

NOTE If you're building for webserverless, local viewing, and using the `strip_index` filter anywhere, use the `--no-strip-index` option.

```bash
yass build --no-strip-index
```

Use the `watch` command to continually build your site as files change.

```bash
yass watch # also supports --no-strip-index
```

## License

MIT License. See LICENSE for details.

## Copyright

Copyright (c) 2025 Jordan Hollinger.
