{# /*============================================================================
  #Pagina "Medios de pago": lista con dibujos y logos (2026-09-25)
  Pedido de Santiago sobre una captura: cada medio con su dibujo en un
  circulo a la izquierda, el nombre en negrita, logos de las tarjetas y este
  orden: credito, transferencia, debito, Mercado Pago, efectivo. Reemplaza
  el texto que estaba en el contenido de la pagina (que ya no se muestra,
  ver pagina-lupita.tpl). Los logos son los oficiales de Tiendanube
  (filtro payment_new_logo), los mismos del pie. #}

{# [nombre, dibujo, texto, logos separados por coma] (sin diccionarios:
   el Twig de Tiendanube no los acepta, ver replace({...}) en la gift card) #}
{% set lu_ml = [
    ['Tarjeta de crédito', 'credito', '¡Aprovechá hasta 6 cuotas sin interés con tarjetas bancarizadas!', 'visa,mastercard,amex,ar_cabal,ar_tarjeta-naranja'],
    ['Transferencia o depósito bancario', 'transferencia', 'Conseguí un 10% OFF abonando en este medio. Se aguardará un plazo máximo de 24 hs para recibir el comprobante y poder empezar a empaquetar el producto. En caso de no recibir el comprobante de pago, la compra será cancelada.', ''],
    ['Tarjeta de débito', 'debito', '', 'visadebit,maestro,ar_cabaldebit'],
    ['Mercado Pago', 'mercadopago', 'Mercado Pago está afiliado a nuestra tienda ofreciendo hasta 3 pagos sin interés en todos los productos. El descuento del 10% es solo abonando con transferencia o depósito de dinero.', 'mercadopago'],
    ['Efectivo', 'efectivo', 'Acercándote a nuestras tiendas.', '']
] %}

<div class="container">
    <div class="lu-ml">
        <p class="lu-ml-pregunta">{{ '¿Cómo puedo abonar mis productos?' | translate }}</p>
        <ul class="lu-ml-lista list-unstyled">
            {% for lu_m in lu_ml %}
                <li class="lu-ml-item">
                    <span class="lu-ml-dibujo" aria-hidden="true">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                            {% if lu_m[1] == 'credito' %}
                                <rect x="2.5" y="5" width="19" height="14" rx="2.5"/><path d="M2.5 9.5h19"/><path d="M6 15h4"/><path d="M15.5 15h2.5"/>
                            {% elseif lu_m[1] == 'transferencia' %}
                                <path d="M4 8h14"/><path d="M14.5 4.5 18 8l-3.5 3.5"/><path d="M20 16H6"/><path d="M9.5 12.5 6 16l3.5 3.5"/>
                            {% elseif lu_m[1] == 'debito' %}
                                <rect x="2.5" y="5" width="19" height="14" rx="2.5"/><rect x="5.5" y="9" width="4.5" height="3.5" rx="0.8"/><path d="M5.5 15.5h7"/><path d="M16.5 15.5h2"/>
                            {% elseif lu_m[1] == 'mercadopago' %}
                                <rect x="6.5" y="2.5" width="11" height="19" rx="2.5"/><path d="M10.5 18.5h3"/><path d="M13.5 8.8c-.4-.6-1-.9-1.6-.9-1 0-1.7.6-1.7 1.3 0 1.8 3.5 1 3.5 2.9 0 .8-.8 1.4-1.8 1.4-.7 0-1.4-.3-1.8-.9"/><path d="M11.9 7v.9"/><path d="M11.9 13.4v.9"/>
                            {% else %}
                                <rect x="2.5" y="6" width="19" height="12" rx="2"/><circle cx="12" cy="12" r="2.8"/><path d="M5.5 9v.01"/><path d="M18.5 15v.01"/>
                            {% endif %}
                        </svg>
                    </span>
                    <div class="lu-ml-cuerpo">
                        <h2 class="lu-ml-nombre">{{ lu_m[0] | translate }}</h2>
                        {% if lu_m[2] %}
                            <p class="lu-ml-texto">{{ lu_m[2] | translate }}</p>
                        {% endif %}
                        {% if lu_m[3] %}
                            <div class="lu-ml-logos">
                                {% for lu_logo in lu_m[3] | split(',') %}
                                    <img class="lu-ml-logo lazyload" src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ lu_logo | payment_new_logo }}" alt="{{ lu_logo }}" width="50" height="35">
                                {% endfor %}
                            </div>
                        {% endif %}
                    </div>
                </li>
            {% endfor %}
        </ul>
    </div>
</div>
