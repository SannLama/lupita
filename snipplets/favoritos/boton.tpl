{# /*============================================================================
  #Favoritos: boton corazon
  Nace hidden: lupita-favoritos lo muestra solo si el navegador deja guardar.
  fav_vacio: sin datos (compra rapida); el JS le copia los de la tarjeta.
  fav_class: clase de ubicacion (lu-fav-tarjeta, lu-fav-ficha, lu-fav-rapida).
  En la ficha (lu-fav-ficha) es una pildora "Guardar / Guardado" con el
  efecto del "star button" de 21st.dev pero con corazones turquesa (Santiago,
  2026-09-28): al pasar el mouse se llena de turquesa y seis corazoncitos
  salen volando alrededor. Ver #Favoritos: boton de la ficha en lupita.scss.tpl.
==============================================================================*/#}

<button type="button" class="js-fav lu-fav {{ fav_class }}" hidden aria-pressed="false" aria-label="{{ 'Guardar en favoritos' | translate }}"
    {% if not fav_vacio %}
    data-fav-id="{{ product.id }}"
    data-fav-nombre="{{ product.name }}"
    data-fav-url="{{ product.url }}"
    data-fav-imagen="{{ product.featured_image | product_image_url('small') }}"
    data-fav-precio="{{ product.price | money }}"
    {# Para mostrar los precios como el carrito (tarjeta, efectivo, 6 cuotas):
       el numero y el % de descuento en efectivo, el mismo dato de la ficha #}
    {% if product.display_price %}data-fav-precio-num="{{ product.price / 100 }}"{% endif %}
    {% if settings.payment_discount_price and product.maxPaymentDiscount.value > 0 %}data-fav-desc="{{ product.maxPaymentDiscount.value }}"{% endif %}
    {% endif %}>
    <svg class="lu-fav-vacio" aria-hidden="true" viewBox="0 0 512 512"><path d="M458.4 64.3C400.6 15.7 311.3 23 256 79.3 200.7 23 111.4 15.6 53.6 64.3-21.6 127.6-10.6 230.8 43 285.5l175.4 178.7c10 10.2 23.4 15.9 37.6 15.9 14.3 0 27.6-5.6 37.6-15.8L469 285.6c53.5-54.7 64.7-157.9-10.6-221.3zm-23.6 187.5L259.4 430.5c-2.4 2.4-4.4 2.4-6.8 0L77.2 251.8c-36.5-37.2-43.9-107.6 7.3-150.7 38.9-32.7 98.9-27.8 136.5 10.5l35 35.7 35-35.7c37.8-38.5 97.8-43.2 136.5-10.6 51.1 43.1 43.5 113.9 7.3 150.8z"/></svg>
    <svg class="lu-fav-lleno" aria-hidden="true" viewBox="0 0 512 512"><path d="M462.3 62.6C407.5 15.9 326 24.3 275.7 76.2L256 96.5l-19.7-20.3C186.1 24.3 104.5 15.9 49.7 62.6c-62.8 53.6-66.1 149.8-9.9 207.9l193.5 199.8c12.5 12.9 32.8 12.9 45.3 0l193.5-199.8c56.3-58.1 53-154.3-9.8-207.9z"/></svg>
    {% if 'lu-fav-ficha' in fav_class %}
        <span class="lu-fav-rotulo" aria-hidden="true"><span class="lu-fav-rotulo-guardar">{{ 'Guardar' | translate }}</span><span class="lu-fav-rotulo-guardado">{{ 'Guardado' | translate }}</span></span>
        {% for i in 1..6 %}<svg class="lu-fav-mini lu-fav-mini-{{ i }}" aria-hidden="true" viewBox="0 0 512 512"><path d="M462.3 62.6C407.5 15.9 326 24.3 275.7 76.2L256 96.5l-19.7-20.3C186.1 24.3 104.5 15.9 49.7 62.6c-62.8 53.6-66.1 149.8-9.9 207.9l193.5 199.8c12.5 12.9 32.8 12.9 45.3 0l193.5-199.8c56.3-58.1 53-154.3-9.8-207.9z"/></svg>{% endfor %}
    {% endif %}
</button>
