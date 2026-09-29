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
    {# Titulo, encaje y "Kit n' Couch" tenue recortados de la propia imagen
       del diseno, para que sean iguales (Santiago, 2026-09-28) #}
    <h2 class="lu-probatelo-movil-titulo"><img src="{{ 'images/probatelo-titulo.png' | static_url }}" alt="Probátelo en las tiendas" width="696" height="282"></h2>
    <p>Contá con nosotros y dejá la elección de tus looks en nuestras manos. Guardá en la <strong>wishlist</strong> lo que te guste y vení a probártelo a cualquiera de nuestras tiendas.</p>
    <p>Lomitas y Banfield: accedé a un 20% de descuento abonando en efectivo o hasta 6 cuotas sin interés con tarjetas bancarizadas y American Express.</p>
    <a class="lu-probatelo-link" href="{{ store.url }}/locales/">{{ 'Conocé nuestras tiendas' | translate }}</a>
    <img class="lu-probatelo-movil-kit" src="{{ 'images/probatelo-kitncouch.png' | static_url }}" alt="" aria-hidden="true" width="940" height="320">
</section>

<section class="lu-probatelo-img" data-store="home-image-text-module">
    <img src="{{ 'images/probatelo-diseno.jpg' | static_url }}" width="2208" height="1440" loading="lazy"
        alt="Probátelo en las tiendas. Contá con nosotros y dejá la elección de tus looks en nuestras manos. Guardá en la wishlist lo que te guste y vení a probártelo a cualquiera de nuestras tiendas. Lomitas y Banfield: accedé a un 20% de descuento abonando en efectivo o hasta 6 cuotas sin interés con tarjetas bancarizadas y American Express. Foto de nuestra tienda de Belgrano 1470, Banfield.">
    <a class="lu-probatelo-img-link" href="{{ store.url }}/locales/">{{ 'Conocé nuestras tiendas' | translate }}</a>

    {# Las 3 tiendas pasando como slide sobre la mitad derecha de la imagen
       (Santiago, 2026-09-28). Arranca en el x=1040 de 2208 de la imagen, donde
       empieza su foto. Las fotos de Lomas estan llevadas al tono y grano de la
       de Banfield del diseno. Cambia cada 4 s con fundido; con movimiento
       reducido queda en la primera. #}
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
        {# Sin frenos largos (Santiago, 2026-09-29: "que no se pausen por mucho
           tiempo cuando llegan al final"): antes se detenia con el mouse encima
           (sin tope: si el cursor quedaba apoyado, no avanzaba mas) y las fotos
           2 y 3 eran lazy e invisibles, asi que la primera vuelta esperaba a que
           bajaran. Ahora las tres se precargan cuando la seccion se acerca, y
           si la siguiente todavia no esta lista espera solo lo que falte. #}
        (function () {
            var c = document.querySelector('.js-lu-locales');
            if (!c) return;
            var fs = c.querySelectorAll('.lu-local'), ps = c.querySelectorAll('.lu-locales-puntos span');
            var imgs = c.querySelectorAll('img');
            var precargar = function () { imgs.forEach(function (im) { im.loading = 'eager'; }); };
            if ('IntersectionObserver' in window) {
                var io = new IntersectionObserver(function (e) {
                    if (e[0].isIntersecting) { precargar(); io.disconnect(); }
                }, { rootMargin: '800px 0px' });
                io.observe(c);
            } else { precargar(); }
            if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
            var i = 0;
            var lista = function (n) { var im = fs[n].querySelector('img'); return !im || (im.complete && im.naturalWidth > 0); };
            var avanzar = function () {
                var sig = (i + 1) % fs.length;
                if (document.hidden || !lista(sig)) { setTimeout(avanzar, 300); return; }
                fs[i].classList.remove('is-activo'); ps[i].classList.remove('is-activo');
                i = sig;
                fs[i].classList.add('is-activo'); ps[i].classList.add('is-activo');
                setTimeout(avanzar, 4000);
            };
            setTimeout(avanzar, 4000);
        })();
    </script>
</section>
