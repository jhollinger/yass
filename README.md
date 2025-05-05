# yass

Yet Another Static Site (generator)

## Getting started

```bash
$ yass init my-site
Creating my-site/site
Creating my-site/templates
$ cd my-site
```

## Site strucutre

Your site lives under `site` and the structure is entirely up to you. In addition to static files, `.md` and `.erb` files are supported.

### Layouts

Layouts may be defined in `templates/layouts/`. A layout called `default.html.erb` will be applied to any `.html` files.

## Building

The built site will be placed into `dist`.

```bash
yass build
```

Use the `--local` option if you need links to work without a webserver.
