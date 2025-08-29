---
title: Home
layout: home
nav_order: 1
---

# Ice-Sheet and Sea-level System Model (ISSM) Documentation
[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

----

Welcome to the documentation page for the Ice-Sheet and Sea-level System Model (ISSM). Included here are instructions for installation and use of ISSM, development status and forecast, as well as information about how ISSM used and the team behind it.

Please feel free to let us know how this documentation could be improved. We also welcome contributions to the source code via fork and pull request.

----

## Build Status
![Ubuntu - Basic](https://github.com/ISSMteam/ISSM/actions/workflows/ubuntu-basic.yml/badge.svg)
[![Ubuntu Python](https://github.com/ISSMteam/ISSM/actions/workflows/ubuntu-python.yml/badge.svg)](https://github.com/ISSMteam/ISSM/actions/workflows/ubuntu-python.yml)
[![Ubuntu CodiPack](https://github.com/ISSMteam/ISSM/actions/workflows/ubuntu-codipack.yml/badge.svg)](https://github.com/ISSMteam/ISSM/actions/workflows/ubuntu-codipack.yml)

There are more build configurations and regression test suites on <a href="https://ross.ics.uci.edu/jenkins/view/All/" target="_blank">ISSM's Jenkins server</a>.

----

## Contact
- ISSM source code GitHub repository
  - <a href="https://github.com/ISSMteam/ISSM/discussions" target="_blank">Discussions</a>
  - <a href="https://github.com/ISSMteam/ISSM/issues" target="_blank">Issues</a>
- <a href="https://issm.ess.uci.edu/forum/d/242-issm-development-slack-workspace" target="_blank">ISSM Slack Workspace</a>

----

## About ISSM
- <a href="about-issm/contributors">Contributors</a>
- <a href="about-issm/contributors">Collaborations</a>
- <a href="about-issm/publications">Publications</a>
- <a href="about-issm/development-status">Development Status</a>
- <a href="about-issm/news">News</a>

{% comment %}Only output if we have featured posts{% endcomment %}
{% assign have_featured_posts = false %}
{% for post in site.posts %}
	{% if post.featured %}
		{% assign have_featured_posts = true %}
		{% break %}
	{% endif %}
{% endfor %}
{% if have_featured_posts %}
### Featured News
<ul class="post-index home-page-post-index">
	{% for post in site.posts %}
		{% if post.featured %}
			<li>
				<a href="{{ post.url }}"><img src="{{ post.image }}" /></a>
				<div>
					<a href="{{ post.url }}"><span class="text-beta">{{ post.title }}</span></a>
					<p class="post-excerpt">{{ post.excerpt }}</p>
				</div>
			</li>
		{% endif %}
	{% endfor %}
</ul>
{% endif %}

----

## Installation and Usage Documentation
- <a href="installation">Installation</a>
- <a href="getting-started">Getting Started</a>
- <a href="using-issm">Using ISSM</a>
- <a href="supplements">Supplements</a>
- <a href="troubleshooting">Troubleshooting</a>

----

## Projects
- <a href="projects/gofm">Gulf of Mexico</a>

----

## Acknowledgements
This site uses <a href="https://just-the-docs.com/" target="_blank">Just the Docs</a>, a documentation theme for Jekyll.
