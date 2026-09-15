<div class="container">
    {% embed "snipplets/page-header.tpl" with { breadcrumbs: true } %}
        {% block page_header_text %}{{ "Blog" | translate }}{% endblock page_header_text %}
    {% endembed %}

    {# Lista editorial: una fila por nota. Las clases lu-* son las que controla
       el theme; el HTML de adentro lo arma la plataforma (component). Sin lazy
       en las fotos: la vista previa del cursor necesita el src real. #}
    <section class="blog-page lu-blog" data-motion="hover-preview">
        {% for post in blog.posts %}
            {{ component(
                'blog/blog-post-item', {
                    image_lazy: false,
                    post_item_classes: {
                        item: 'lu-post',
                        image_container: 'lu-post-imagen',
                        image: 'lu-post-img',
                        title: 'lu-post-titulo',
                        summary: 'lu-post-resumen',
                        read_more: 'lu-post-leer',
                    },
                })
            }}
        {% endfor %}
    </section>
    {% include 'snipplets/grid/pagination.tpl' with {'pages': blog.pages} %}
</div>
