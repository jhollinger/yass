### 0.8.1 (?)

* Bugfix to files with empty front matter

### 0.8.0 (2025-05-13)

* Use Github-Flavored Markdown
* Add `where_not` filter
* `strip_index` should leave any anchors or queries after index.html
* Add `published` field (if false, file is excluded from build)

### 0.7.0 (2025-05-13)

* Jekyll-like front matter support
* Ditch filename-based layouts, use default.ext and front matter
* Add `page.layout`
* Bugfix to `page.title`

### 0.6.1 (2025-05-12)

* Use the docs site in `yass init`
* Bugfixes to path handling during build

### 0.6.0 (2025-05-10)

* Added `where_match` Liquid filter

### 0.5.1 (2025-05-10)

* Added `--dest` option to specify a different build dir

### 0.5.0 (2025-05-10)

* Removed `relative_to` filter, added `relative`.
* Removed `page.url`
* Added `strip_index` filter, renamed `--local` option to `--no-strip-index`
* Misc bugfixes

### 0.4.0 (2025-05-09)

* Added `render_content`

### 0.3.0 (2025-05-09)

* Default layouts

### 0.2.1 (2025-05-08)

* Don't list directories with watched changes

### 0.2.0 (2025-05-08)

* Added `--clean` option

### 0.1.0 (2025-05-08)

* Added `match` filter
* Added `watch` command

### 0.0.1 (2025-05-08)

* Initial release
