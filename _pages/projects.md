---
layout: page
title: projects
permalink: /projects/
description: Selected research and engineering projects — my contributions, results, and supporting materials.
nav: true
nav_order: 3
display_categories: [research, engineering, internship]
---

<div class="publications">
  <ol class="bibliography">
    {% for category in page.display_categories %}
      {% assign entries = site.projects | where: "category", category | sort: "importance" %}
      {% for project in entries %}
        <li>
          <div class="row">
            <div class="col col-sm-2 abbr">
              <abbr class="badge rounded w-100">{{ project.category | capitalize }}</abbr>
              {% if project.img %}
                <a href="{{ project.url | relative_url }}" aria-label="{{ project.title | escape }} — project details">
                  <img src="{{ project.img | relative_url }}" alt="{{ project.image_alt | default: project.title | escape }}" class="preview img-fluid z-depth-1 rounded" loading="lazy">
                </a>
              {% endif %}
            </div>
            <div class="col-sm-10">
              <div class="title"><a href="{{ project.url | relative_url }}" style="color: inherit">{{ project.title }}</a></div>
              <div class="author">{{ project.role_short }}</div>
              <div class="periodical"><em>{{ project.period | default: project.status }}</em></div>
              <div class="mt-1">{{ project.summary }}</div>
              <div class="mt-1"><strong>{{ project.card_result }}</strong></div>
              <div class="links">
                <a href="{{ project.url | relative_url }}" class="btn btn-sm z-depth-0" role="button">Details</a>
                {% for link in project.links %}
                  <a href="{{ link.url }}" class="btn btn-sm z-depth-0" role="button" target="_blank" rel="noopener noreferrer">{{ link.label }}</a>
                {% endfor %}
              </div>
            </div>
          </div>
        </li>
      {% endfor %}
    {% endfor %}
  </ol>
</div>
