{# /*============================================================================
  #Sobre nosotros (2026-09-15)
  Pagina propia: page.tpl lo usa cuando la pagina se llama "Sobre nosotros"
  (handle sobre-nosotros). La clienta la crea en "Mi Tiendanube > Paginas" y
  la suma a los menus. Textos y tres fotos de las tiendas desde
  "Personalizar diseño > Sobre nosotros". Sin fotos cargadas, el texto queda
  solo y centrado: no se muestran fotos de relleno.
==============================================================================*/#}

{% set lu_fotos_sobre = ['sobre-nosotros-1.jpg', 'sobre-nosotros-2.jpg', 'sobre-nosotros-3.jpg'] %}
{% set lu_hay_fotos_sobre = ('sobre-nosotros-1.jpg' | has_custom_image) or ('sobre-nosotros-2.jpg' | has_custom_image) or ('sobre-nosotros-3.jpg' | has_custom_image) %}

<section class="lu-sobre" data-store="page-about">
    <div class="container">
        <div class="lu-sobre-grilla {% if not lu_hay_fotos_sobre %}lu-sobre-solo-texto{% endif %}">
            <div class="lu-sobre-texto">
                <h1 class="lu-sobre-titulo">{{ settings.lupita_about_title ? settings.lupita_about_title : page.name }}</h1>
                {% if settings.lupita_about_text %}
                    <p class="lu-sobre-parrafo">{{ settings.lupita_about_text }}</p>
                {% endif %}
                {% if settings.lupita_about_advice %}
                    <p class="lu-sobre-asesoramiento">{{ settings.lupita_about_advice }}</p>
                {% endif %}
                {% if settings.lupita_about_closing %}
                    <p class="lu-sobre-cierre">{{ settings.lupita_about_closing }}</p>
                {% endif %}
                {% include 'snipplets/tiendas-link.tpl' with {tiendas_clase: 'lu-tiendas-sobre'} %}
            </div>

            {% if lu_hay_fotos_sobre %}
                <div class="lu-sobre-fotos">
                    {% for foto in lu_fotos_sobre if foto | has_custom_image %}
                        <figure class="lu-sobre-foto">
                            <img src="{{ foto | static_url | settings_image_url('large') }}" alt="{{ 'Tienda de' | translate }} {{ store.name }}" loading="lazy">
                        </figure>
                    {% endfor %}
                </div>
            {% endif %}
        </div>
    </div>
</section>
