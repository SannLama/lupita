{# /*============================================================================
  #Vidriera virtual (Santiago, 2026-09-27)
  Explica que la web es una vidriera y que la venta online llega pronto. Va
  al principio de todo lo que habla de venta online o de formas de pago:
  seccion de medios de pago del home, paginas Medios de pago, Como comprar,
  Preguntas frecuentes y Envios, el aviso del carrito y la ficha de producto.

  lu_vv_tamano: 'grande' (bloque con titulo, texto y links) o 'compacto'
  (un renglon, para la ficha de producto). Textos desde "Personalizar
  diseno > Vidriera virtual"; vacios, usan los de aca.
==============================================================================*/#}

{% if not settings.lupita_vidriera_ocultar %}
    {% set lu_vv_tamano = lu_vv_tamano | default('grande') %}
    {% set lu_vv_rotulo = settings.lupita_vidriera_rotulo ?: 'Próximamente venta online' %}
    {% set lu_vv_titulo = settings.lupita_vidriera_titulo ?: '¿Qué es una vidriera virtual?' %}
    {% set lu_vv_texto = settings.lupita_vidriera_texto ?: 'Es nuestra tienda abierta en la web: recorré las prendas, mirá precios y talles y guardalas en la wishlist. Próximamente venta online; mientras tanto, la compra la terminás en cualquiera de nuestras tres tiendas o escribiéndonos por WhatsApp.' %}

    {% if lu_vv_tamano == 'compacto' %}
        <p class="lu-vidriera lu-vidriera-compacto" data-store="lupita-vidriera">
            <strong class="lu-vidriera-nombre">{{ 'Vidriera virtual' | translate }}</strong>
            <span class="lu-vidriera-rotulo">{{ lu_vv_rotulo }}</span>
        </p>
    {% else %}
        <section class="lu-vidriera lu-vidriera-grande" data-store="lupita-vidriera" aria-labelledby="lu-vidriera-titulo-{{ lu_vv_id | default('1') }}">
            <div class="container">
                <div class="lu-vidriera-caja">
                    <span class="lu-vidriera-rotulo">{{ lu_vv_rotulo }}</span>
                    <h2 class="lu-vidriera-titulo" id="lu-vidriera-titulo-{{ lu_vv_id | default('1') }}">{{ lu_vv_titulo }}</h2>
                    <p class="lu-vidriera-texto">{{ lu_vv_texto }}</p>
                    <p class="lu-vidriera-links">
                        <a class="lu-vidriera-link" href="{{ store.url }}/locales/">{{ 'Conocé nuestras tiendas' | translate }}</a>
                        {% if store.whatsapp %}
                            <a class="lu-vidriera-link" href="{{ store.whatsapp }}" target="_blank" rel="noopener">{{ 'Escribinos por WhatsApp' | translate }}</a>
                        {% endif %}
                    </p>
                </div>
            </div>
        </section>
    {% endif %}
{% endif %}
