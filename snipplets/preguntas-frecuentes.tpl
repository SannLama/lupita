{# /*============================================================================
  #Preguntas frecuentes (2026-09-15)
  Pagina propia: page.tpl lo usa cuando la pagina se llama "Preguntas
  frecuentes" (handle preguntas-frecuentes) o "FAQ". La clienta la crea en
  "Mi Tiendanube > Paginas" y la suma a los menus. Hasta seis preguntas desde
  "Personalizar diseño > Preguntas frecuentes"; las vacias no salen.

  Desplegables con <details>: abren con teclado y sin JS.

  El boton de arrepentimiento va SOLO al final y chico (pedido de Santiago):
  un link al formulario de cancelacion de Tiendanube, el mismo al que lleva el
  del pie (contact.tpl con order_cancellation_without_id).
==============================================================================*/#}

{# Cada pregunta: [pregunta, respuesta, segundo parrafo, mostrar tiendas]. Con
   la casilla prendida, entre los dos parrafos va la lista de
   snipplets/tiendas-datos.tpl: las direcciones y el horario se cargan en un
   solo lugar y no se desincronizan del pie. #}
{% set lu_faqs = [
    [settings.lupita_faq_1_pregunta, settings.lupita_faq_1_respuesta, settings.lupita_faq_1_respuesta_2, settings.lupita_faq_1_tiendas],
    [settings.lupita_faq_2_pregunta, settings.lupita_faq_2_respuesta, settings.lupita_faq_2_respuesta_2, settings.lupita_faq_2_tiendas],
    [settings.lupita_faq_3_pregunta, settings.lupita_faq_3_respuesta, settings.lupita_faq_3_respuesta_2, settings.lupita_faq_3_tiendas],
    [settings.lupita_faq_4_pregunta, settings.lupita_faq_4_respuesta, settings.lupita_faq_4_respuesta_2, settings.lupita_faq_4_tiendas],
    [settings.lupita_faq_5_pregunta, settings.lupita_faq_5_respuesta, settings.lupita_faq_5_respuesta_2, settings.lupita_faq_5_tiendas],
    [settings.lupita_faq_6_pregunta, settings.lupita_faq_6_respuesta, settings.lupita_faq_6_respuesta_2, settings.lupita_faq_6_tiendas]
] %}

<section class="lu-faq" data-store="page-faq">
    <div class="container">
        <div class="lu-faq-caja">
            <h1 class="lu-faq-titulo">{{ page.name }}</h1>

            <div class="lu-faq-lista">
                {% for lu_faq in lu_faqs %}
                    {% if lu_faq[0] and lu_faq[1] %}
                        <details class="lu-faq-item">
                            <summary class="lu-faq-pregunta">{{ lu_faq[0] }}</summary>
                            <div class="lu-faq-respuesta">
                                <p>{{ lu_faq[1] }}</p>
                                {% if lu_faq[3] %}
                                    <ul class="lu-faq-tiendas list-unstyled">
                                        {% include 'snipplets/tiendas-datos.tpl' with {tiendas_item_clase: 'lu-faq-tienda'} %}
                                    </ul>
                                {% endif %}
                                {% if lu_faq[2] %}
                                    <p>{{ lu_faq[2] }}</p>
                                {% endif %}
                            </div>
                        </details>
                    {% endif %}
                {% endfor %}
            </div>

            {% if page.content %}
                <div class="user-content lu-faq-extra">{{ page.content }}</div>
            {% endif %}

            <p class="lu-faq-arrepentimiento">
                <a href="{{ store.contact_url }}?order_cancellation_without_id=true" class="lu-arrepentimiento-link">{{ 'Botón de arrepentimiento' | translate }}</a>
            </p>
        </div>
    </div>
</section>
