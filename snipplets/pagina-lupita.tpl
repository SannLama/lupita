{# /*============================================================================
  #Paginas "Medios de pago" y "Como comprar" (2026-09-15)
  page.tpl lo usa cuando la pagina se llama asi. La clienta crea las dos
  paginas en "Mi Tiendanube > Paginas" y las linkea desde el menu del pie.

  - pagos: el bloque de snipplets/medios-de-pago.tpl en grande, con los
    mismos textos del panel que el home, la ficha y el carrito.
  - comprar: hasta cinco pasos numerados desde "Personalizar diseño > Cómo
    comprar"; los vacios no salen.

  Lo que se escriba en el contenido de la pagina va debajo.
==============================================================================*/#}

{% set lu_pasos = [
    [settings.lupita_comprar_1_titulo, settings.lupita_comprar_1_texto],
    [settings.lupita_comprar_2_titulo, settings.lupita_comprar_2_texto],
    [settings.lupita_comprar_3_titulo, settings.lupita_comprar_3_texto],
    [settings.lupita_comprar_4_titulo, settings.lupita_comprar_4_texto],
    [settings.lupita_comprar_5_titulo, settings.lupita_comprar_5_texto]
] %}

<section class="lu-pagina lu-pagina-{{ lu_tipo }}" data-store="page-{{ lu_tipo }}">
    <div class="container">
        <h1 class="lu-pagina-titulo">{{ page.name }}</h1>
    </div>

    {% if lu_tipo == 'pagos' %}
        {% include 'snipplets/medios-de-pago.tpl' with {tamano: 'grande'} %}
    {% else %}
        <div class="container">
            <ol class="lu-pasos list-unstyled">
                {% for lu_paso in lu_pasos if lu_paso[0] %}
                    <li class="lu-paso">
                        <span class="lu-paso-numero">{{ loop.index }}</span>
                        <div class="lu-paso-cuerpo">
                            <h2 class="lu-paso-titulo">{{ lu_paso[0] }}</h2>
                            {% if lu_paso[1] %}
                                <p class="lu-paso-texto">{{ lu_paso[1] }}</p>
                            {% endif %}
                        </div>
                    </li>
                {% endfor %}
            </ol>
        </div>
    {% endif %}

    {% if page.content %}
        <div class="container">
            <div class="user-content lu-pagina-extra">{{ page.content }}</div>
        </div>
    {% endif %}
</section>
