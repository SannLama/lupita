{# /*============================================================================
  #Medios de pago de Lupita
  Un solo bloque para el home (tamano: 'grande'), la ficha y el carrito
  (tamano: 'compacto'). Todos los textos salen de "Personalizar diseño >
  Medios de pago de Lupita": la clienta los cambia en un lugar y se actualizan
  en los tres. American Express va aparte y se apaga con su casilla.
==============================================================================*/#}

{% set lu_tamano = tamano | default('compacto') %}
{% set lu_pagos = [
    [settings.lupita_pago_efectivo_cifra, settings.lupita_pago_efectivo, 'efectivo'],
    [settings.lupita_pago_tarjetas_cifra, settings.lupita_pago_tarjetas, 'tarjetas'],
    [settings.lupita_pago_transferencia_cifra, settings.lupita_pago_transferencia, 'transferencia'],
] %}
{# Con precio (la ficha lo pasa como lu_precio): cada renglon dice que es y
   cuanto sale (Santiago, 2026-09-29): "20% off en efectivo: $77.690" en el
   color de la marca, "6 cuotas sin interes de $16.185", "10% off por
   transferencia: $87.401". El porcentaje y las cuotas se leen de la cifra
   que carga la clienta en el panel ("20% off", "6 cuotas"), asi que si la
   cambia, el calculo la sigue. Lo calcula el script de abajo, que tambien
   lo rehace al cambiar de variante. #}
{% set lu_con_precio = lu_precio is defined and lu_precio %}
{% set lu_hay_pagos = settings.lupita_pago_efectivo_cifra or settings.lupita_pago_efectivo or settings.lupita_pago_tarjetas_cifra or settings.lupita_pago_tarjetas or settings.lupita_pago_transferencia_cifra or settings.lupita_pago_transferencia %}
{% set lu_hay_amex = settings.lupita_pago_amex_show and settings.lupita_pago_amex %}

{% if lu_hay_pagos or lu_hay_amex %}
    <section class="lu-pagos lu-pagos-{{ lu_tamano }}" data-store="lupita-medios-de-pago" aria-label="{{ 'Medios de pago' | translate }}">
        {% if lu_tamano == 'grande' %}
        <div class="container">
        {% endif %}

            {% if lu_hay_pagos and lu_tamano != 'grande' %}
                <ul class="lu-pagos-lista list-unstyled">
                    {% for pago in lu_pagos if pago[0] or pago[1] %}
                        <li class="lu-pagos-item lu-pagos-{{ pago[2] }}"{% if lu_con_precio %} data-lu-pago="{{ pago[2] }}" data-lu-cifra="{{ pago[0] }}"{% endif %}>
                            {% if pago[0] %}<span class="lu-pagos-cifra">{{ pago[0] }}</span>{% endif %}
                            {% if lu_con_precio %}<span class="js-lu-pago-detalle lu-pagos-detalle"></span>{% endif %}
                            {% if false %}<span class="lu-pagos-texto">{{ pago[1] }}</span>{% endif %}
                        </li>
                    {% endfor %}
                </ul>
                {% if lu_con_precio %}
                    <script type="text/javascript">
                        (function () {
                            var lista = document.currentScript.previousElementSibling;
                            var base = {{ lu_precio / 100 }};
                            function pesos(n) { return '$' + Math.round(n).toLocaleString('es-AR'); }
                            function precio() {
                                var el = document.querySelector('#single-product #price_display');
                                var n = el ? parseFloat(el.textContent.replace(/[^\d,]/g, '').replace(',', '.')) : 0;
                                return n || base;
                            }
                            function pintar() {
                                var p = precio();
                                lista.querySelectorAll('[data-lu-pago]').forEach(function (li) {
                                    var cifra = li.getAttribute('data-lu-cifra') || '';
                                    var num = parseFloat((cifra.match(/\d+([.,]\d+)?/) || ['0'])[0].replace(',', '.'));
                                    var tipo = li.getAttribute('data-lu-pago'), txt = '';
                                    if (num) {
                                        if (tipo === 'efectivo') txt = 'en efectivo: ' + pesos(p * (100 - num) / 100);
                                        else if (tipo === 'transferencia') txt = 'por transferencia: ' + pesos(p * (100 - num) / 100);
                                        else if (tipo === 'tarjetas') txt = 'sin interés de ' + pesos(p / num);
                                    }
                                    var d = li.querySelector('.js-lu-pago-detalle');
                                    if (d.textContent !== txt) d.textContent = txt;
                                });
                            }
                            pintar();
                            var fuente = document.querySelector('#single-product #price_display');
                            if (fuente) new MutationObserver(pintar).observe(fuente, { childList: true, characterData: true, subtree: true });
                        })();
                    </script>
                {% endif %}
            {% endif %}

            {% if lu_hay_amex %}
                <div class="lu-pagos-amex">
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
