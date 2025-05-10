# yass

Yet Another Static Site (generator)

Yass is an incredibly un-opinionated static site generator. [Learn more!](https://jhollinger.github.io/yass/)

## Getting started

Starting from an empty page isn't fun, so `yass init` will create a skeleton site for you.

```bash
$ gem install yass
$ yass init blog
Creating blog/layouts/default.html.liquid
Creating blog/site/assets/highlight.min.css
Creating blog/site/assets/highlight.min.js
Creating blog/site/index.html.liquid
Creating blog/templates/asset_tags.liquid
$ cd blog
```

## Building

The built site will be placed into `dist`.

```bash
yass build
```

NOTE If you're building for webserverless, local viewing, and using the `skip_index` filter anywhere, use the `--no-skip-index` option.

```bash
yass build --no-skip-index
```

Use the `watch` command to continually build your site as files change.

```bash
yass watch # also supports --no-skip-index
```

## License

MIT License. See LICENSE for details.

## Copyright

Copyright (c) 2025 Jordan Hollinger.
