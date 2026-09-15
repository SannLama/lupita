{# /*============================================================================
  #Galeria de campanas (2026-09-15)
  Las piezas graficas de Sea of Dreams / City Moves traen el titulo impreso,
  asi que no sirven de fondo con texto encima (se probaron en el carrusel y
  Santiago prefirio las fotos de antes). Van aca, debajo de los videos de las
  mismas campanas: tres en fila desde 768, apiladas en celular, enteras
  (sin object-fit: cover, cada una con su proporcion).

  Se incluye desde home-section-switch.tpl a continuacion de la Capsula.
  Imagenes y rotulo desde "Personalizar diseño > Capsula".
==============================================================================*/#}

{% set lu_campanas = ['campana-1.jpg', 'campana-2.jpg', 'campana-3.jpg'] %}
{% set lu_hay_campanas = ('campana-1.jpg' | has_custom_image) or ('campana-2.jpg' | has_custom_image) or ('campana-3.jpg' | has_custom_image) %}

{% if settings.lupita_campanas_show and lu_hay_campanas %}
    <section class="lu-campanas" data-store="home-campanas">
        {% if settings.lupita_campanas_titulo %}
            <div class="container">
                <span class="lu-rotulo lu-micro lu-campanas-rotulo">{{ settings.lupita_campanas_titulo }}</span>
            </div>
        {% endif %}
        <div class="lu-campanas-grilla">
            {% for pieza in lu_campanas if pieza | has_custom_image %}
                <figure class="lu-campana">
                    <img src="{{ pieza | static_url | settings_image_url('xlarge') }}" alt="{{ 'Campaña de' | translate }} {{ store.name }}" loading="lazy">
                </figure>
            {% endfor %}
        </div>
    </section>
{% endif %}
