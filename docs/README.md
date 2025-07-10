# ISSM Documentation
Repository for generating online and PDF documentation for ISSM and storing publications based on ISSM.

The [generated documentation](https://issmteam.github.io/ISSM-Documentation/) is a [Jekyll] site that uses a customized version of the [Just the Docs] theme and is built and published on [GitHub Pages].

Blog features on the 'News' page are adapted from the [Mediumish Jekyll Template].

## Making Changes to the Documentation
If you have write access to this repository, you can make and commit changes from a copy of the repository or make changes to pages directly through the GitHub interface. Alternatively, all users may fork this repository and submit pull requests with proposed changes.

It can take up to 10 minutes for changes to your site to publish after you push the changes to GitHub.

### Previewing Changes Locally
Assuming [Jekyll] and [Bundler] are installed on your computer:

1. Change your working directory to `docs/` in the local copy of the repository.

2. Run `bundle install`.

3. Run `bundle exec jekyll serve --watch` to build your site.

4. Preview the site in a web browser at `localhost:4000`.

The built site is stored in and served from `_site/`.

NOTE: The copy of Ruby included with macOS will likely not be of a new enough version. We suggest you install Ruby via Homebrew with,
```
brew install ruby
```
add the following to your `.bash_profile`,
```
export PATH="/opt/homebrew/opt/ruby/bin:${PATH}"
```
then start a new terminal and follow the above steps.

## Structure
Each page in the [front end of the documentation](https://issmteam.github.io/ISSM-Documentation/) has a corresponding Markdown file (`.md`) in the appropriate subdirectory of `docs/`. For example,
````
https://issmteam.github.io/ISSM-Documentation/getting-started/model-class
````
corresponds to,
````
docs/getting-started/model-class/index.md
````
A subdirectory may contain the default file (`index.md`) as well as additional sibling files. In these cases, the `index` file is just that: an index of the other files in the subdirectory (e.g. `docs/troubleshooting/index.md`).

When built, pages are converted from Markdown to HTML and deployed to the `_site/` directory (default).

### Publications
The 'Publications' page and its corresponding content files and their structure in the repo work differently. The important thing to know is that if you want to add a new publication to the front end page, you can do so by adding a DOI to the appropriate file in `docs/publications/doi`, which are named according to the year that the corresponding articles were published. On commit, the entire 'Publications' page will be regenerated.

For more info, see `docs/publications/README`.

### News
The 'News' page and posts rely on [Jekyll's built-in support for blogging]{https://jekyllrb.com/docs/posts/}.

## More In-depth Development
Various components of the default presentation of the site can be overridden by adding custom files to the appropriate directories (which may not yet exist and need to be created).

For example, 
- a custom color scheme has been added to `_sass/color_schemes/issm.scss` (see also: [Just the Docs - Custom Schemes]).
- custom SASS rules have been added to `_sass/custom/custom.scss` (see also: [Just the Docs - Custom Styles]).
- custom layouts have been added to `_layouts/` (see also: [Jekyll - Layouts]). Of note, `default.html` was copied in full from Ruby Gem and modified so that `h1` headings do not have an anchor link attached to them.

Recipes for custom layouts can be derived from the default ones shipped with the Just the Docs Ruby Gem,
1. Find Ruby Gem installation directories by running `gem environment` and inspecting the `GEM PATHS` section.
1. Search each location for the `just-the-docs-*` directory.
1. Inspect the files in the contained `_layouts/` directory.
1. These layouts can be overridden by creating a new file of the same name in the `_layouts/` directory of the ISSM Documentation repository.

<!--- Reference-style Links --->
[Jekyll]: https://jekyllrb.com
[Jekyll - Layouts]: https://jekyllrb.com/docs/layouts
[Just the Docs]: https://just-the-docs.github.io/just-the-docs/
[Just the Docs - Custom Schemes]: https://just-the-docs.com/docs/customization/#custom-schemes
[Just the Docs - Custom Styles]: https://just-the-docs.com/docs/customization/#override-and-completely-custom-styles
[GitHub Pages]: https://docs.github.com/en/pages
[Bundler]: https://bundler.io

