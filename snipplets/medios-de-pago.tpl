{# /*============================================================================
  #Medios de pago de Lupita
  Un solo bloque para el home (tamano: 'grande'), la ficha y el carrito
  (tamano: 'compacto'). Todos los textos salen de "Personalizar diseño >
  Medios de pago de Lupita": la clienta los cambia en un lugar y se actualizan
  en los tres. American Express va aparte y se apaga con su casilla.
==============================================================================*/#}

{% set lu_tamano = tamano | default('compacto') %}
{% set lu_pagos = [
    [settings.lupita_pago_efectivo_cifra, settings.lupita_pago_efectivo],
    [settings.lupita_pago_tarjetas_cifra, settings.lupita_pago_tarjetas],
    [settings.lupita_pago_transferencia_cifra, settings.lupita_pago_transferencia],
] %}
{% set lu_hay_pagos = settings.lupita_pago_efectivo_cifra or settings.lupita_pago_efectivo or settings.lupita_pago_tarjetas_cifra or settings.lupita_pago_tarjetas or settings.lupita_pago_transferencia_cifra or settings.lupita_pago_transferencia %}
{% set lu_hay_amex = settings.lupita_pago_amex_show and settings.lupita_pago_amex %}

{% if lu_hay_pagos or lu_hay_amex %}
    <section class="lu-pagos lu-pagos-{{ lu_tamano }}" data-store="lupita-medios-de-pago" aria-label="{{ 'Medios de pago' | translate }}">
        {% if lu_tamano == 'grande' %}
        <div class="container">
            <span class="lu-rotulo lu-micro lu-pagos-rotulo">{{ 'Medios de pago' | translate }}</span>
        {% endif %}

            {% if lu_hay_pagos %}
                <ul class="lu-pagos-lista list-unstyled">
                    {% for pago in lu_pagos if pago[0] or pago[1] %}
                        <li class="lu-pagos-item">
                            {% if pago[0] %}<span class="lu-pagos-cifra">{{ pago[0] }}</span>{% endif %}
                            {% if pago[1] %}<span class="lu-pagos-texto">{{ pago[1] }}</span>{% endif %}
                        </li>
                    {% endfor %}
                </ul>
            {% endif %}

            {% if lu_hay_amex %}
                <div class="lu-pagos-amex">
                    <span class="lu-pagos-amex-rotulo">American Express</span>
                    <span class="lu-pagos-amex-texto">{{ settings.lupita_pago_amex }}</span>
                </div>
            {% endif %}

        {% if lu_tamano == 'grande' %}
            {# El 20% en efectivo se paga en las tiendas: el link lleva al mapa #}
            {% include 'snipplets/tiendas-link.tpl' with {tiendas_clase: 'lu-tiendas-pagos'} %}
        </div>
        {% endif %}
    </section>
{% endif %}
