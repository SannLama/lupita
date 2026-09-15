<div class="container container-narrow">

    {% embed "snipplets/page-header.tpl" with { breadcrumbs: true} %}
        {% block page_header_text %}{{ post.title | translate }}{% endblock page_header_text %}
    {% endembed %}

    {# user-content le da al cuerpo las reglas de texto largo de las paginas
       institucionales; el titulo lo anima page-header.tpl (split-lines) #}
    <div class="blog-post-page lu-nota">
        {{ component(
            'blog/blog-post-content', {
                image_lazy: true,
                image_lazy_js: true,
                post_content_classes: {
                    date: 'lu-nota-fecha',
                    image: 'img-fluid fade-in lu-nota-img',
                    content: 'user-content lu-nota-cuerpo',
                },
            })
        }}
    </div>
</div>
