{# /*============================================================================
  #Page header
==============================================================================*/

#Properties

#Title

#Breadcrumbs 

#}

<section class="page-header mt-3" {% if template != 'product' %}data-store="page-title"{% endif %}>
    {% if template != 'product' %}
    <div class="container">
        <div class="row">
    {% endif %}
            <div class="{% if template != 'product' %}col text-center{% endif %} {% if template == 'product' %}text-center text-md-left{% endif %} {% if template == 'category' %}col-lg-6 offset-lg-3{% endif %}">
                {% include 'snipplets/breadcrumbs.tpl' %}
                <h1 {% if template == 'product' %}class="js-product-name" data-store="product-name-{{ product.id }}"{% endif %}{% if template == 'blog-post' %} data-motion="split-lines"{% endif %} >{% block page_header_text %}{% endblock %}</h1>
                {# Descripcion de categoria sacada (Santiago, 2026-09-23,
                   con foto del celular real): en las categorias que trae el
                   sistema externo, la descripcion repite el mismo nombre en
                   gris chico debajo del titulo grande -- sobra, no suma
                   informacion. #}
            </div>
    {% if template != 'product' %}
        </div>
    </div>
    {% endif %}
</section>
