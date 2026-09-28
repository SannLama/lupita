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

{# Celular (Santiago, 2026-09-28: "en mobile que no se vea esta imagen y que
   el texto se estire centrado"): en vez de la imagen, el mismo texto armado
   con letra real, centrado sobre el lino, sin la foto. #}
<section class="lu-probatelo-movil" data-store="home-image-text-module">
    <h2 class="lu-probatelo-titulo">
        <span class="lu-probatelo-titulo-grande">Probátelo</span>
        <span class="lu-probatelo-titulo-bajo"><span class="lu-probatelo-en">En</span> las tiendas</span>
    </h2>
    <p>Contá con nosotros y dejá la elección de tus looks en nuestras manos. Guardá en la <strong>wishlist</strong> lo que te guste y vení a probártelo a cualquiera de nuestras tiendas.</p>
    <p>Lomitas y Banfield: accedé a un 20% de descuento abonando en efectivo o hasta 6 cuotas sin interés con tarjetas bancarizadas y American Express.</p>
    <a class="lu-probatelo-link" href="{{ store.url }}/locales/">{{ 'Conocé nuestras tiendas' | translate }}</a>
</section>

<section class="lu-probatelo-img" data-store="home-image-text-module">
    <img src="{{ 'images/probatelo-diseno.jpg' | static_url }}" width="2208" height="1440" loading="lazy"
        alt="Probátelo en las tiendas. Contá con nosotros y dejá la elección de tus looks en nuestras manos. Guardá en la wishlist lo que te guste y vení a probártelo a cualquiera de nuestras tiendas. Lomitas y Banfield: accedé a un 20% de descuento abonando en efectivo o hasta 6 cuotas sin interés con tarjetas bancarizadas y American Express. Foto de nuestra tienda de Belgrano 1470, Banfield.">
    <a class="lu-probatelo-img-link" href="{{ store.url }}/locales/">{{ 'Conocé nuestras tiendas' | translate }}</a>

    {# Las 3 tiendas pasando como slide sobre la mitad derecha de la imagen
       (Santiago, 2026-09-28). Arranca en el x=1040 de 2208 de la imagen, donde
       empieza su foto. Las fotos de Lomas estan llevadas al tono y grano de la
       de Banfield del diseno. Cambia cada 4.5 s con fundido; se frena con el
       mouse encima y con movimiento reducido queda en la primera. #}
    <div class="lu-locales js-lu-locales" aria-label="{{ 'Nuestras tiendas' | translate }}">
        {% for local in [
            ['local-banfield.jpg', 'Belgrano 1470 - Banfield'],
            ['local-espana.jpg', 'España 137 - Lomas de Zamora'],
            ['local-esquina.jpg', 'España 202 y Loria - Lomas de Zamora']
        ] %}
            <figure class="lu-local{% if loop.first %} is-activo{% endif %}">
                <img src="{{ ('images/' ~ local[0]) | static_url }}" alt="{{ 'Tienda de' | translate }} {{ local[1] }}" loading="lazy" width="1168" height="1440">
                <figcaption>{{ local[1] }}</figcaption>
            </figure>
        {% endfor %}
        <div class="lu-locales-puntos" aria-hidden="true">
            <span class="is-activo"></span><span></span><span></span>
        </div>
    </div>
    <script>
        (function () {
            var c = document.querySelector('.js-lu-locales');
            if (!c) return;
            var fs = c.querySelectorAll('.lu-local'), ps = c.querySelectorAll('.lu-locales-puntos span');
            if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
            var i = 0, quieto = false;
            c.addEventListener('mouseenter', function () { quieto = true; });
            c.addEventListener('mouseleave', function () { quieto = false; });
            setInterval(function () {
                if (quieto || document.hidden) return;
                fs[i].classList.remove('is-activo'); ps[i].classList.remove('is-activo');
                i = (i + 1) % fs.length;
                fs[i].classList.add('is-activo'); ps[i].classList.add('is-activo');
            }, 4500);
        })();
    </script>
</section>
