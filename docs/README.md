# ISSM Documentation
Repository for generating online and PDF documentation for ISSM and storing publications based on ISSM.

The [generated documentation] is a [Jekyll] site that uses a customized version of the [Just the Docs] theme and is built and published on [GitHub Pages].

## Making Changes to the Documentation
If you have write access to this repository, you can make and commit changes from a copy of the repository or make changes to pages directly through the GitHub interface. Alternatively, all users may fork this repository and submit pull requests with proposed changes.

It can take up to 10 minutes for changes to your site to publish after you push the changes to GitHub.

### Previewing Changes Locally
Assuming [Jekyll] and [Bundler] are installed on your computer:

1.  Change your working directory to the root directory of your site.

2.  Run `bundle install`.

3.  Run `bundle exec jekyll serve` to build your site and preview it at `localhost:4000`.

    The built site is stored in the directory `_site`.

[generated documentation]: https://issmteam.github.io/ISSM-Documentation/
[Jekyll]: https://jekyllrb.com
[Just the Docs]: https://just-the-docs.github.io/just-the-docs/
[GitHub Pages]: https://docs.github.com/en/pages
[Bundler]: https://bundler.io

## Structure
Each page in the [generated documentation]{front end of the documentation} has a corresponding Markdown file (`.md`) in the appropriate subdirectory of `docs/`. For example,
````
https://issmteam.github.io/ISSM-Documentation/getting-started/model-class
````
corresponds to,
````
docs/getting-started/model-class/index.md
````
A subdirectory may contain the default file (`index.md`) as well as additional sibling files. In these cases, the `index` file is just that: an index of the other files in the subdirectory (e.g. `docs/troubleshooting/index.md`).

### Publications
The 'Publications' page and its corresponding content files and their structure in the repo work differently. The important thing to know is that if you want to add a new publication to the front end page, you can do so by adding a DOI to the appropriate file in `docs/publications/doi`, which are named according to the year that the corresponding articles were published. On commit, the entire 'Publications' page will be regenerated.

For more info, see `docs/publications/README`.
