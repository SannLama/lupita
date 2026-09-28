{# /*============================================================================
  #Probatelo en las tiendas (Santiago, 2026-09-28)
  Primero se armo con HTML (lino, encaje, textos y la foto de Banfield);
  despues Santiago paso el diseno terminado como imagen y pidio usar la
  imagen tal cual y agregar solo el boton. La imagen es
  static/images/probatelo-diseno.jpg (2208x1440); el link a las tiendas va
  encima, en porcentajes, alineado con el texto de la imagen y debajo del
  ultimo parrafo, asi acompana a la imagen en cualquier ancho.
  El texto de la imagen queda como alt, para lectores de pantalla y buscadores.
==============================================================================*/#}

<section class="lu-probatelo-img" data-store="home-image-text-module">
    <img src="{{ 'images/probatelo-diseno.jpg' | static_url }}" width="2208" height="1440" loading="lazy"
        alt="Probátelo en las tiendas. Contá con nosotros y dejá la elección de tus looks en nuestras manos. Guardá en la wishlist lo que te guste y vení a probártelo a cualquiera de nuestras tiendas. Lomitas y Banfield: accedé a un 20% de descuento abonando en efectivo o hasta 6 cuotas sin interés con tarjetas bancarizadas y American Express. Foto de nuestra tienda de Belgrano 1470, Banfield.">
    <a class="lu-probatelo-img-link" href="{{ store.url }}/locales/">{{ 'Conocé nuestras tiendas' | translate }}</a>
</section>
