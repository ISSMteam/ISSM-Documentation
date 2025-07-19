---
title: News
layout: default
parent: About ISSM
nav_order: 5
---

# News
<ul class="post-index news-page-post-index">
	{% for post in site.posts %}
		<li>
			<a href="{{ post.url }}"><img src="{{ post.image }}" /></a>
			<div>
				<a href="{{ post.url }}"><span class="text-beta">{{ post.title }}</span></a>
				<p class="post-excerpt">{{ post.excerpt }}</p>
			</div>
		</li>
	{% endfor %}
</ul>
