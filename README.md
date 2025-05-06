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

Your site lives under `site`. Static files will be copied as-is, and `md` and `erb` files will be processed.

### Layouts

Layouts may be defined in `templates/layouts/`. Files find layouts based on their name. A file named `foo.page.html` would use a `page.html.erb` layout, and the resulting file would be named `foo.html`. (Note that `md` files  match `html` layouts.)

### Templates

Arbitrary ERB templates may be placed under `templates/` and rendered in `.erb` files with `<%= template "my-template.html.erb" %>`.

## Building

The built site will be placed into `dist`.

```bash
yass build
```

Use the `--local` option if you need links to work without a webserver.
