{# Product payments details #}

{% if product.installments_info_from_any_variant %}

    {% embed "snipplets/modal.tpl" with{
        modal_id: 'installments-modal', 
        modal_position: 'bottom', 
        modal_transition: 'slide', 
        modal_header: true, 
        modal_footer: true, 
        modal_width: 'centered', 
        modal_mobile_full_screen: 'true'} %}
        {% block modal_head %}
            {{ 'Medios de pago' | translate }}
        {% endblock %}
        {% block modal_body %}

            {# Modal header and gateways tab links #}

            {{ component('payments/payments-details',
                {
                    text_classes: {
                        text_accent: "label label-accent ml-1",
                        subtitles: "h6 mb-3",
                        text_big: "font-big",
                        text_small: "font-small",
                        align_right: "text-right",
                        opacity: "opacity-60"
                    },
                    spacing_classes: {
                        top_1x: "mt-1",
                        top_2x: "mt-2",
                        top_3x: "mt-3",
                        right_1x: "mr-1",
                        right_2x: "mr-2",
                        right_3x: "mr-3",
                        bottom_1x: "mb-1",
                        bottom_2x: "mb-2",
                        bottom_3x: "mb-3",
                        left_3x: "ml-3",
                    },
                    container_classes : {
                        payment_method: "card p-3"
                    },
                    discounts_conditional_visibility: true
                })
            }}
            {# Efectivo con su descuento (Santiago, 2026-09-29: "cuando tocas medios
               de pago y te aparece efectivo esta mal el precio"): el componente
               nativo muestra "Precio: $97.112" sin el 20%. Se reescribe con el
               precio en efectivo y el lleno tachado; el % es el mismo descuento
               del panel (maxPaymentDiscount). Si Tiendanube vuelve a pintar el
               precio (cambio de variante), se recalcula. #}
            {% if product.maxPaymentDiscount.value > 0 %}
                <script type="text/javascript">
                    (function () {
                        var desc = {{ product.maxPaymentDiscount.value }};
                        var modal = document.getElementById('installments-modal');
                        if (!modal) return;
                        function pesos(n) { return '$' + Math.round(n).toLocaleString('es-AR'); }
                        function num(t) { return parseFloat(String(t).replace(/[^\d,]/g, '').replace(',', '.')) || 0; }
                        function arreglar() {
                            modal.querySelectorAll('.card').forEach(function (card) {
                                var t = card.querySelector('.h6');
                                var el = card.querySelector('.js-installments-one-payment');
                                if (!t || !el || !/efectivo/i.test(t.textContent)) return;
                                if (el.textContent === el.getAttribute('data-lu-puesto')) return;
                                var base = num(el.textContent);
                                if (!base) return;
                                var final = pesos(base * (100 - desc) / 100);
                                el.setAttribute('data-lu-puesto', final);
                                el.textContent = final;
                                var tach = card.querySelector('.lu-efectivo-lleno');
                                if (!tach) {
                                    tach = document.createElement('span');
                                    tach.className = 'lu-efectivo-lleno';
                                    el.parentNode.appendChild(tach);
                                }
                                tach.textContent = pesos(base);
                                var off = card.querySelector('.lu-efectivo-off');
                                if (!off) {
                                    off = document.createElement('span');
                                    off.className = 'lu-efectivo-off';
                                    el.parentNode.appendChild(off);
                                }
                                off.textContent = desc + '% off';
                            });
                        }
                        arreglar();
                        new MutationObserver(arreglar).observe(modal, { childList: true, subtree: true, characterData: true });
                    })();
                </script>
            {% endif %}
        {% endblock %}
        {% block modal_foot %}
            <div class="text-right">
                <span class="js-modal-close js-fullscreen-modal-close btn-link pull-right">{{ 'Volver al producto' | translate }}</span>
            </div>
        {% endblock %}
    {% endembed %}

{% endif %}
