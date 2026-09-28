{# /*============================================================================
  #Probatelo en la tienda (Santiago, 2026-09-28, con un diseno: "copialo igual")
  Reemplaza al modulo de imagen y texto del base en la home (la seccion
  "modules" del orden de la home sigue siendo este lugar). A la izquierda,
  un panel con textura de lino, una tira de encaje al borde y firuletes
  turquesa tenues de fondo; "Probatelo / En la tienda" en turquesa, el texto
  y el link a las tiendas. A la derecha, la foto de Banfield con la direccion.
  Las tres imagenes estan en static/images (probatelo-*). Los textos van
  aca: los campos del "Modulo de imagen y texto" del panel ya no se usan.
==============================================================================*/#}

<section class="lu-probatelo" data-store="home-image-text-module">
    <div class="lu-probatelo-panel" style="background-image: url('{{ 'images/probatelo-lino.jpg' | static_url }}');">
        <span class="lu-probatelo-encaje" style="background-image: url('{{ 'images/probatelo-encaje.png' | static_url }}');" aria-hidden="true"></span>
        <span class="lu-probatelo-firulete lu-probatelo-firulete-arriba" aria-hidden="true">Ahí</span>
        <span class="lu-probatelo-firulete lu-probatelo-firulete-abajo" aria-hidden="true">Lupita</span>

        <div class="lu-probatelo-texto">
            <h2 class="lu-probatelo-titulo">
                <span class="lu-probatelo-titulo-grande">Probátelo</span>
                <span class="lu-probatelo-titulo-bajo"><span class="lu-probatelo-en">En</span> la tienda</span>
            </h2>
            <p>Contá con nosotros y dejá la elección de tus looks en nuestras manos. Guardá en la <strong>wishlist</strong> lo que te guste, y vení a probártelo a cualquiera de nuestras tiendas.</p>
            <p>Lomitas y Banfield, accedé a un 20% de descuento abonando en efectivo o hasta 6 cuotas sin interés con tarjetas bancarizadas y American Express.</p>
            <a class="lu-probatelo-link" href="{{ store.url }}/locales/">{{ 'Conocé nuestras tiendas' | translate }}</a>
        </div>
    </div>

    <figure class="lu-probatelo-foto">
        <img src="{{ 'images/probatelo-banfield.jpg' | static_url }}" alt="{{ 'Nuestra tienda de Belgrano 1470, Banfield' | translate }}" loading="lazy" width="480" height="586">
        <figcaption>Belgrano 1470 - Banfield</figcaption>
    </figure>
</section>
