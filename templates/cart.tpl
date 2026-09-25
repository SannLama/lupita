{# Carrito desactivado (Santiago, 2026-09-25): no se vende online por ahora. Si
   alguien llega a /comprar/ (un link viejo o un carrito que ya tenia cosas) ve
   este aviso y no puede avanzar al checkout. Para volver a vender online:
   borrar este bloque y el "if false" que envuelve el carrito original, y el "and false" de
   snipplets/header/header-utilities.tpl. #}
<section class="lu-sin-carrito" data-store="cart-page">
    <div class="container">
        <div class="lu-sin-carrito-caja">
            <h1 class="lu-pagina-titulo">{{ 'Carrito' | translate }}</h1>
            <p class="lu-sin-carrito-titulo">{{ 'Por el momento no se realiza la venta online' | translate }}</p>
            <p class="lu-sin-carrito-texto">{{ 'Guardá tus favoritos con el corazón y vení a probártelos a cualquiera de nuestras tiendas.' | translate }}</p>
            <div class="lu-sin-carrito-acciones">
                <a class="btn btn-primary" href="{{ store.url }}/locales/">{{ 'Conocé nuestras tiendas' | translate }}</a>
                {% if store.whatsapp %}
                    <a class="btn btn-line" href="{{ store.whatsapp }}" target="_blank" rel="noopener">{{ 'Escribinos por WhatsApp' | translate }}</a>
                {% endif %}
            </div>
        </div>
    </div>
</section>

{% if false %}
{% embed "snipplets/page-header.tpl" with {'breadcrumbs': true} %}
    {% block page_header_text %}{{ "Carrito de Compras" | translate }}{% endblock page_header_text %}
{% endembed %}

<div id="shoppingCartPage" class="container" data-minimum="{{ settings.cart_minimum_value }}" data-store="cart-page">
    <form action="{{ store.cart_url }}" method="post" class="cart-body" data-store="cart-form" data-component="cart">
        <div class="cart-body">

            {# Cart alerts #}

            {% if error.add %}
                {{ component('alert', {'type': 'warning', 'message': 'our_components.cart.error_messages.' ~ error.add }) }}
            {% endif %}
            {% for error in error.update %}
                <div class="alert alert-warning">{{ "No podemos ofrecerte {1} unidades de {2}. Solamente tenemos {3} unidades." | translate(error.requested, error.item.name, error.stock) }}</div>
            {% endfor %}
            {% if cart.items %}
                <div class="js-ajax-cart-list cart-row">

                    {# Cart page items #}

                    {% if cart.items %}
                      {% for item in cart.items %}
                        {% include "snipplets/cart-item-ajax.tpl" with {'cart_page': true} %}
                      {% endfor %}
                    {% endif %}
                </div>
            {% else %}

                {#  Empty cart  #}

                {% if not error %}
                    {{ component('alert', {'type': 'info', 'message': ('El carrito de compras está vacío.' | translate) }) }}
                {% endif %}
            {% endif %}
            <div id="error-ajax-stock" style="display: none;">
                <div class="alert alert-warning">
                    {{ "¡Uy! No tenemos más stock de este producto para agregarlo al carrito. Si querés podés" | translate }}<a href="{{ store.products_url }}" class="btn-link ml-1">{{ "ver otros acá" | translate }}</a>
                </div>
            </div>
            <div class="cart-row">
                {% include "snipplets/cart-totals.tpl" with {'cart_page': true} %}
            </div>
        </div>
    </form>
    <div id="store-curr" class="hidden">{{ cart.currency }}</div>
</div>
{% endif %}
