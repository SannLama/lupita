{#/*============================================================================
  lupita.scss.tpl — Sistema visual de Ahi! Lupita
  Brutalismo suizo (Swiss Industrial Print) sobre el theme base de Tiendanube.

  Se carga DESPUES de style-async en layouts/layout.tpl, asi gana la cascada
  por orden de documento sin necesidad de !important en todos lados.

  IMPORTANTE: escrito como CSS plano a proposito (nada de anidado ni $vars de
  SCSS). Tiendanube lo compila igual, y asi el mismo archivo se puede mirar
  crudo en el harness local sin compilar nada.

  Los tres colores y las dos fuentes salen de config/settings.txt, o sea que la
  clienta los sigue manejando desde el panel. Los VALORES no van aca: se
  cambian en config/defaults.txt.
==============================================================================*/#}

/*============================================================================
  #Tokens
==============================================================================*/

:root {
    --lu-papel: {{ settings.background_color }};
    --lu-tinta: {{ settings.text_color }};
    --lu-acento: {{ settings.accent_color }};

    /* Tinta mezclada con papel: grises que no ensucian el sustrato */
    --lu-linea: color-mix(in srgb, {{ settings.text_color }} 14%, {{ settings.background_color }});
    --lu-gris: color-mix(in srgb, {{ settings.text_color }} 55%, {{ settings.background_color }});

    --lu-macro: {{ settings.font_headings }};
    --lu-micro: {{ settings.font_rest }};

    /* El logotipo y la navegacion NO siguen font_headings a proposito, desde
       el 2026-09-11: Santiago pidio una tipografia "romantica y delicada"
       para los titulos grandes (hero, portada, secciones), y font_headings
       paso a ser Italiana para eso. Pero el logotipo es identidad de marca,
       no un titulo de contenido — sigue fijo en la Archivo Black de siempre
       aunque la clienta cambie font_headings desde el panel. Fijo a
       proposito, no via variable: ver #Cabecera. */
    --lu-marca: "Archivo Black", sans-serif;

    /* Tracking mecanico de la micro-tipografia */
    --lu-track: 0.08em;
    --lu-gutter: 1rem;
}

/*============================================================================
  #Reset brutalista
  Rigidez mecanica: 90 grados en todo, sin sombras, sin degradados.
==============================================================================*/

body,
.item,
.item img,
.btn,
input,
select,
textarea,
.form-control,
.card,
.modal-content,
.badge,
.chip,
.pill,
.label {
    border-radius: 0;
    box-shadow: none;
}

body {
    background-color: var(--lu-papel);
    color: var(--lu-tinta);
    font-family: var(--lu-micro);
}

/*============================================================================
  #Tipografia
==============================================================================*/

/* Macro: --lu-macro paso a ser Italiana el 2026-09-11 (pedido de Santiago:
   tipografia "romantica y delicada" para los titulos grandes). El tracking
   negativo y el leading comprimido de antes le iban bien a Archivo Black
   (una masa solida de letras) pero aprietan una serif fina — pasan a
   positivo/normal para que las formas respiren.

   Logotipo, menu de navegacion, buscador y el TOTAL del carrito NO usan
   --lu-macro: son identidad de marca o cifras, no titulos de contenido, y
   se fijaron en --lu-marca (Archivo Black) a proposito. Ver #Tokens. */
h1,
h2,
.lu-macro {
    font-family: var(--lu-macro);
    text-transform: uppercase;
    letter-spacing: 0.02em;
    line-height: 1;
    margin: 0;
    /* Un titulo de dos renglones parte parejo, no deja una palabra sola
       colgando en el segundo (visto con "[ Titulo a definir ]" en la
       Portada: el corchete de cierre quedaba solo en su linea). */
    text-wrap: balance;
}

h1,
.lu-macro {
    font-size: clamp(2.75rem, 10vw, 9rem);
}

h2 {
    font-size: clamp(1.75rem, 4vw, 3rem);
}

h3,
h4,
h5 {
    font-family: var(--lu-macro);
    text-transform: uppercase;
    letter-spacing: 0.01em;
    line-height: 1.1;
}

/* Micro: metadatos, precios, navegacion. Espaciado de maquina de escribir. */
.lu-micro,
.item-name,
.item-price,
.item-installments,
.lu-nav a,
.btn,
.breadcrumbs,
.category-controls {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.72rem;
    line-height: 1.35;
}

/*============================================================================
  #Grilla de productos
  gap:1px sobre fondo linea = divisiones exactas de 1px sin declarar un solo
  borde. Es lo que sostiene fotos heterogeneas: cada una queda encerrada en su
  celda y la estructura hace el trabajo que en Zara hace la uniformidad de las
  fotos de estudio.
==============================================================================*/

.js-product-table.row,
.js-masonry-grid.row {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 1px;
    background-color: var(--lu-linea);
    border-top: 1px solid var(--lu-linea);
    border-bottom: 1px solid var(--lu-linea);
    margin-left: 0;
    margin-right: 0;
}

/* Escalon intermedio: a 768 exactos, cuatro columnas quedan apretadas. */
@media (min-width: 768px) {
    .js-product-table.row,
    .js-masonry-grid.row {
        grid-template-columns: repeat({% if settings.grid_columns == 2 %}2{% else %}3{% endif %}, 1fr);
    }
}

@media (min-width: 1100px) {
    .js-product-table.row,
    .js-masonry-grid.row {
        grid-template-columns: repeat({% if settings.grid_columns == 2 %}2{% else %}4{% endif %}, 1fr);
    }

    /* En un monitor grande la grilla quedaba encajonada por el max-width del
       container, con franjas muertas a los costados y las fotos chicas contra
       la pantalla. El layout ya marca el body con template-<pagina>, asi que se
       suelta el ancho solo donde manda la grilla — sin recurrir a 100vw, que
       mete scroll horizontal cuando hay barra de desplazamiento. */
    .template-category .container,
    .template-search .container {
        max-width: none;
    }
}

/* Arriba de 1600 sobra lugar para una columna mas. */
@media (min-width: 1600px) {
    .js-product-table.row,
    .js-masonry-grid.row {
        grid-template-columns: repeat({% if settings.grid_columns == 2 %}3{% else %}5{% endif %}, 1fr);
    }
}

/* Los items vienen con col-6/col-md-3 de Bootstrap: hay que neutralizar el
   ancho porcentual o pelean con las celdas del grid. */
.js-product-table.row > .item-product,
.js-masonry-grid.row > .item-product {
    width: auto;
    max-width: none;
    flex: none;
    margin: 0;
    padding: var(--lu-gutter);
    background-color: var(--lu-papel);
}

/*============================================================================
  #Tarjeta de producto
  Sin tarjeta: la foto y su ficha, nada mas. Alineado a la izquierda y con las
  filas desparejas a proposito: un nombre largo empuja y no pasa nada.
==============================================================================*/

.item-product {
    text-align: left;
}

/* Dos lineas fijas: alinea los precios de toda la fila aunque los nombres
   midan distinto. Zara los deja desparejos, pero el brutalismo suizo valora la
   alineacion rigida mas que el desborde. */
.item-name {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    min-height: calc(2 * 1.35 * 0.72rem);
    color: var(--lu-tinta);
    margin: 0.85rem 0 0.35rem;
    font-weight: 400;
}

/* El precio manda sobre el nombre: mismo alfabeto, mas cuerpo y mas peso. */
.item-price {
    color: var(--lu-tinta);
    font-weight: 700;
    font-size: 0.84rem;
}

/* En mobile una cifra partida al medio ($ 98.000 / $ 74.500 cortado despues
   del signo) se lee como otro precio. Nunca se parten. */
.item-price,
.item-price-compare,
.compare-price {
    white-space: nowrap;
}

/* Precio tachado de una rebaja */
.item-price-compare,
.compare-price {
    color: var(--lu-gris);
    text-decoration: line-through;
    font-weight: 400;
}

/* El renglon de cuotas: el mejor argumento de venta de esta marca ocupa el
   lugar que en Zara tiene la aclaracion de impuestos. */
.item-installments {
    display: block;
    color: var(--lu-gris);
    margin-top: 0.3rem;
    /* Mas chico y con menos tracking que el resto de la micro: el texto lo
       genera component('installments') y es largo, en mono se parte al medio
       del precio si no se lo achica. */
    font-size: 0.58rem;
    letter-spacing: 0.02em;
    line-height: 1.3;
    /* Si igual parte en dos, que parta parejo y no deje una linea huerfana */
    text-wrap: balance;
    min-height: calc(2 * 1.3 * 0.58rem);
}

/*============================================================================
  #Acento
  Un solo color de acento en todo el theme, y es el de la marca. El turquesa
  no sirve como texto sobre papel (2.17:1, ver LUPITA.md): solo como fondo
  con tinta encima.
==============================================================================*/

.text-accent,
.item-installments strong,
a:hover {
    color: var(--lu-tinta);
}

/* Etiquetas (NUEVO, OFERTA): rectangulos planos, sin redondeo ni sombra */
.item-label,
.label {
    background-color: var(--lu-tinta);
    color: var(--lu-papel);
    padding: 0.2rem 0.5rem;
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.62rem;
}

/* OFERTA: mismo bug que tenia el boton del hero — el turquesa de fondo pide
   texto en tinta, no en papel (8.27:1 contra 2.17:1). */
.item-label-sale,
.label-sale {
    background-color: var(--lu-acento);
    color: var(--lu-tinta);
}

/*============================================================================
  #Botones
  Bloques macizos. El primario es tinta; el acento se reserva para el hover.
==============================================================================*/

/* La transicion de los botones vive en #Movimiento, al final del archivo, con
   el resto de las curvas. Aca solo la forma. */
.btn {
    border: 1px solid var(--lu-tinta);
    padding: 0.85rem 1.5rem;
    font-weight: 400;
}

.btn-primary {
    background-color: var(--lu-tinta);
    color: var(--lu-papel);
}

.btn-primary:hover,
.btn-primary:focus {
    background-color: var(--lu-acento);
    border-color: var(--lu-acento);
    color: var(--lu-tinta);
}

.btn-default,
.btn-secondary {
    background-color: transparent;
    color: var(--lu-tinta);
}

.btn-default:hover,
.btn-secondary:hover {
    background-color: var(--lu-tinta);
    color: var(--lu-papel);
}

/*============================================================================
  #Compartimentacion
  Reglas horizontales que cruzan todo el ancho para separar unidades.
==============================================================================*/

hr,
.lu-regla {
    border: 0;
    border-top: 1px solid var(--lu-linea);
    margin: 0;
}

.lu-seccion {
    border-top: 1px solid var(--lu-linea);
    padding-top: clamp(2rem, 5vw, 4rem);
    padding-bottom: clamp(2rem, 5vw, 4rem);
}

/* Encabezado de seccion: rotulo tecnico a la izquierda, regla al ras */
.lu-seccion-titulo {
    display: flex;
    align-items: baseline;
    gap: 1rem;
    flex-wrap: wrap;
    margin-bottom: clamp(1rem, 3vw, 2rem);
}

/* A 320px los dos rotulos mas la regla del medio no entran, y el segundo se
   cortaba contra el borde. Abajo de 480 la regla se va y los rotulos envuelven
   si hace falta. */
@media (max-width: 480px) {
    .lu-seccion-titulo .lu-regla {
        display: none;
    }
}

/* Rotulo tecnico. Autonomo a proposito: tambien se usa suelto — el "TALLE" de
   la ficha de producto, por ejemplo — y antes solo funcionaba dentro de
   .lu-seccion-titulo, asi que en esos lugares salia en minusculas. */
.lu-rotulo {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.68rem;
    color: var(--lu-gris);
}

/* Los corchetes solo cuando encabeza una seccion */
.lu-seccion-titulo .lu-rotulo {
    white-space: nowrap;
}

.lu-seccion-titulo .lu-rotulo::before {
    content: "[ ";
}

.lu-seccion-titulo .lu-rotulo::after {
    content: " ]";
}

/*============================================================================
  #Ficha de producto
  Marcado del base: templates/product.tpl + snipplets/product/*.
==============================================================================*/

.section-single-product {
    padding-top: clamp(1rem, 3vw, 2.5rem);
    padding-bottom: clamp(2rem, 5vw, 4rem);
}

/* El nombre del producto usa h1, y el h1 del sistema es tamaño portada
   (hasta 9rem). Una prenda con ese cuerpo es absurda: se acota aca. */
#single-product h1 {
    font-size: clamp(1.5rem, 3vw, 2.5rem);
    /* Positivo, como el resto de la macro: el -0.02em venia de cuando la
       macro era Archivo Black y apretaba la serif fina de Italiana. */
    letter-spacing: 0.01em;
    margin-bottom: 1rem;
}

/* La ficha se queda a la vista mientras se recorren las fotos, como en
   Zara: en desktop la columna de fotos es mas alta que la de la ficha, y
   sin esto el boton de comprar se iba de la pantalla en la segunda foto.
   El top es la altura de la cabecera fija mas un respiro; align-self hace
   falta porque el .row es flex y estiraria la columna a todo el alto. */
@media (min-width: 768px) {
    #single-product .section-single-product > .col {
        position: sticky;
        top: 4.5rem;
        align-self: flex-start;
    }
}

#single-product .js-price-display {
    font-family: var(--lu-micro);
    font-weight: 700;
    font-size: clamp(1.25rem, 2.5vw, 1.75rem);
    letter-spacing: 0.02em;
    color: var(--lu-tinta);
}

#single-product .price-compare {
    font-family: var(--lu-micro);
    text-decoration: line-through;
    color: var(--lu-gris);
    font-size: 0.9rem;
}

/* El precio viejo y el nuevo son un solo bloque: sin el margen de parrafo que
   arrastran, quedaban separados como si fueran dos datos distintos. */
#single-product .price-container p {
    margin: 0 0 0.2rem;
}

/* La descripcion es el unico texto largo del theme: va en minusculas y con
   interlineado ancho. Mayusculas y tracking sirven para metadatos, no para
   parrafos — un texto de venta en versales no lo lee nadie. */
.product-description,
.product-description p {
    font-family: var(--lu-micro);
    text-transform: none;
    letter-spacing: 0;
    font-size: 0.82rem;
    line-height: 1.75;
    color: var(--lu-tinta);
}

/* Comprar: el bloque mas macizo de la pagina. El margen de abajo lo
   separa de la descripcion, que arranca sin margen superior (p del base). */
#single-product .js-addtocart {
    width: 100%;
    padding: 1.15rem 1.5rem;
    font-size: 0.78rem;
    margin-bottom: 1.5rem;
}

/*============================================================================
  #Hero: el slider de la home
  Las fotos se pasan solas (autoplay en config/defaults.txt y el delay en
  static/js/store.js.tpl). El marcado es el del base — snipplets/home/
  home-slider.tpl — y todo esto lo restila por sus clases.
==============================================================================*/

.nube-slider-home {
    position: relative;
    height: 72vh;
    max-height: 900px;
    overflow: hidden;
}

@media (min-width: 768px) {
    .nube-slider-home {
        height: 88vh;
    }
}

.nube-slider-home .slider-slide {
    position: relative;
    height: 100%;
}

.nube-slider-home .slider-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
}

/* El texto se apoya directo sobre la foto, sin nada atras — decision de
   Santiago el 2026-09-10. Antes iba dentro de un bloque macizo de tinta.

   ⚠️ Esto depende de la foto: si la campana es clara justo donde cae el
   titulo, el texto se pierde. Probado con fotos reales el 2026-09-11: en una
   foto de playa clara (cielo y arena) el titulo crema casi desaparece.

   La salida NO es un bloque nuevo: el propio home-slider.tpl del base ya
   manda `slide.color` -> clase `swiper-white` / `swiper-black` (el selector
   de color de texto que la clienta tiene en el panel, por slide). Antes esta
   regla fijaba el color en `.swiper-text` sin importar esa clase, asi que el
   selector del panel no hacia nada. Ahora el color sale de esas dos clases:
   para una foto clara, la clienta elige "oscuro" en el panel y el titulo pasa
   a tinta, sin tocar codigo. */
/* .section-cover-home y .section-capsule-home comparten estas cinco reglas
   con el hero a proposito (ver #Portada y #Capsula mas abajo): mismo riesgo
   de contraste, mismo arreglo. */
.nube-slider-home .swiper-text,
.section-cover-home .swiper-text,
.section-capsule-home .swiper-text {
    position: absolute;
    left: 50%;
    bottom: clamp(2rem, 6vh, 5rem);
    transform: translateX(-50%);
    z-index: 2;
    max-width: min(88vw, 38rem);
    padding: 0;
    background-color: transparent;
    text-align: center;
}

.nube-slider-home .swiper-text.swiper-white,
.section-cover-home .swiper-text.swiper-white,
.section-capsule-home .swiper-text.swiper-white {
    color: var(--lu-papel);
}

.nube-slider-home .swiper-text.swiper-black,
.section-cover-home .swiper-text.swiper-black,
.section-capsule-home .swiper-text.swiper-black {
    color: var(--lu-tinta);
}

.nube-slider-home .swiper-title,
.section-cover-home .swiper-title,
.section-capsule-home .swiper-title {
    font-family: var(--lu-macro);
    text-transform: uppercase;
    letter-spacing: 0.02em;
    line-height: 1.05;
    font-size: clamp(1.75rem, 5vw, 4rem);
    color: inherit;
    margin: 0;
    text-wrap: balance;
}

.nube-slider-home .swiper-description,
.section-cover-home .swiper-description,
.section-capsule-home .swiper-description {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.7rem;
    line-height: 1.5;
    color: inherit;
    margin-top: 0.9rem;
}

/* El unico turquesa del hero, para que el ojo sepa donde tocar.
   Texto en tinta y no en papel: turquesa+papel da 2.17:1 (ver la nota de
   contraste general), turquesa+tinta da 8.27:1. */
.nube-slider-home .swiper-btn,
.section-cover-home .swiper-btn,
.section-capsule-home .swiper-btn {
    display: inline-block;
    margin-top: 1.25rem;
    background-color: var(--lu-acento);
    border-color: var(--lu-acento);
    color: var(--lu-tinta);
}

/*  Contador tipo "01 / 04" en lugar de los puntitos del base.
    Los bullets siguen en el marcado: cada uno incrementa un contador, el
    activo muestra su numero, y el ::after del contenedor —que se renderiza
    despues de todos los hijos— muestra el total. Asi no hay que tocar el .tpl. */
.nube-slider-home .swiper-pagination {
    counter-reset: lu-slide;
    position: absolute;
    right: clamp(1rem, 3vw, 2.5rem);
    top: clamp(1rem, 3vh, 2rem);
    bottom: auto;
    left: auto;
    width: auto;
    z-index: 3;
    display: flex;
    align-items: baseline;
    font-family: var(--lu-micro);
    font-size: 0.68rem;
    letter-spacing: var(--lu-track);
    color: var(--lu-papel);
    mix-blend-mode: difference;
}

.nube-slider-home .swiper-pagination-bullet {
    counter-increment: lu-slide;
    width: auto;
    height: auto;
    background: none;
    opacity: 1;
    margin: 0;
    font-size: 0;
    border-radius: 0;
}

.nube-slider-home .swiper-pagination-bullet-active::before {
    content: counter(lu-slide, decimal-leading-zero);
    font-size: 0.68rem;
}

/* Espacios duros: los normales se colapsan y queda "01/ 03" */
.nube-slider-home .swiper-pagination::after {
    content: "\00a0/\00a0" counter(lu-slide, decimal-leading-zero);
    font-size: 0.68rem;
}

/* Flechas: sin fondo, sin circulo, sin sombra. */
.nube-slider-home .swiper-button-prev,
.nube-slider-home .swiper-button-next {
    background: none;
    border: 0;
    width: auto;
    height: auto;
    z-index: 3;
    filter: none;
}

/*============================================================================
  #Portada
  home_order_position_8 = cover -> home-cover.tpl (nuevo, no viene del
  base): una sola foto a pantalla completa con un titulo grande y sin
  carrusel. Idea de Santiago (referencia Lara Casa) — 2026-09-11.

  Mas baja que el hero (56vh/72vh contra 72vh/88vh) a proposito: si va
  cerca del hero en la pagina, misma altura hubiera leido como "otro slide
  mas" en vez de una pausa distinta. El texto reusa las clases del hero
  (swiper-text, swiper-white/black) — ver la regla compartida mas arriba —
  asi hereda el mismo arreglo de contraste sin duplicar CSS.
==============================================================================*/

.section-cover-home {
    position: relative;
}

.cover-image,
.capsule-media {
    position: relative;
    height: 56vh;
    max-height: 680px;
    overflow: hidden;
}

@media (min-width: 768px) {
    .cover-image,
    .capsule-media {
        height: 72vh;
    }
}

.cover-image-background {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
}

/*============================================================================
  #Capsula
  home_order_position_9 = capsule -> home-capsule.tpl (nuevo, no viene del
  base): video en loop, sin sonido, de fondo — la marca lo pidio para su
  capsula actual ("The Trip"). Idea de Santiago — 2026-09-11.

  Comparte alto con la Portada (.capsule-media agrupado arriba con
  .cover-image) para que las dos "pausas graficas" del home midan lo mismo.
==============================================================================*/

.section-capsule-home {
    position: relative;
}

.capsule-video {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
}

/*============================================================================
  #Barra de aviso
  El renglon que corona la pagina, y el unico lugar donde el mejor dato de la
  marca — 20% en efectivo, 3 y 6 cuotas — esta antes que cualquier foto.

  Iba en negativo (papel sobre tinta) hasta el 2026-09-10: Santiago pidio sacar
  el negro. Queda como rotulo tecnico sobre papel, separado de la cabecera por
  una regla de 1px para que no se lean como un solo bloque.
==============================================================================*/

.section-advertising {
    background-color: var(--lu-papel);
    color: var(--lu-tinta);
    padding: 0.6rem 0;
    border-bottom: 1px solid var(--lu-linea);
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.6rem;
    line-height: 1.3;
}

.section-advertising a,
.section-advertising .link-contrast {
    color: var(--lu-tinta);
    text-decoration: none;
}

.section-advertising a:hover {
    color: var(--lu-tinta);
    text-decoration: underline;
}

/* Si la clienta escribe mas de un mensaje separados por "—" en el mismo
   campo (ver header-advertising.tpl), rotan solos en vez de ir todos
   pegados. Truco de siempre para un ticker sin JS: el contenedor mide una
   linea y recorta, adentro los mensajes se apilan en columna (el track mide
   N lineas), y una sola animacion con steps(N) — N mensajes, resuelto por
   Twig al renderizar — corre el track de a un mensaje por vez, sin
   transicion entre pasos.

   ⚠️ El destino del keyframe es -100% (la altura del track), NO
   -(N-1)/N*100% como parece "logico" para terminar en el ultimo mensaje.
   Probado en pantalla el 2026-09-11: con steps(N) el valor sostenido en el
   paso i es (i/N) del destino, no (i/(N-1)). Con destino -100% eso da
   exactamente i mensajes de alto en cada paso (0, 1, 2... N-1), que es lo
   que hace falta; con (N-1)/N el ultimo paso quedaba a mitad de camino del
   ultimo mensaje. */
.ad-rotator {
    display: inline-block;
    overflow: hidden;
    height: 1.3em;
    vertical-align: top;
}

.ad-track {
    display: flex;
    flex-direction: column;
    animation-name: lu-ad-cycle;
    animation-iteration-count: infinite;
}

.ad-msg {
    height: 1.3em;
    line-height: 1.3;
}

@keyframes lu-ad-cycle {
    to {
        transform: translateY(-100%);
    }
}

@media (prefers-reduced-motion: reduce) {
    .ad-track {
        animation: none;
    }
}

/*============================================================================
  #Cabecera
  El base la arma en tres columnas: hamburguesa / logo / utilidades. Se
  conserva esa estructura (es la de Zara) y se le cambia el peso: fondo papel,
  una regla de 2px al ras que la ancla a la grilla, y todo lo demas en micro.
==============================================================================*/

.head-main {
    background-color: var(--lu-papel);
    border-bottom: 2px solid var(--lu-tinta);
}

/* La regla de abajo tiene que cruzar la pantalla entera, como las de la
   grilla: si queda encajonada en el container, la cabecera flota. */
.head-main > .container {
    max-width: none;
}

/* El logotipo llega con class "h1", y el h1 del sistema es tamano portada
   (clamp hasta 9rem). Sin esto la cabecera mide media pantalla.

   Y no se parte nunca: "AHI ! LUPITA" cortado en dos renglones deja de ser un
   logotipo. Si la clienta carga el logo como imagen esto no se usa, pero el
   theme tiene que aguantar tambien sin ella. */
.head-main .h1,
.head-main .logo-text {
    font-family: var(--lu-marca);
    font-size: clamp(0.9rem, 2.4vw, 1.5rem);
    text-transform: uppercase;
    letter-spacing: -0.03em;
    line-height: 1;
    margin: 0;
    white-space: nowrap;
}

/* Las tres columnas del base son tercios iguales, y en 320 el tercio del medio
   es mas angosto que la palabra. La del logo pasa a medir lo que mide el logo
   y las de los costados se reparten lo que sobra. */
.head-main .row > .col:nth-child(2) {
    flex: 0 1 auto;
}

.head-main .row > .col:first-child,
.head-main .row > .col:last-child {
    flex: 1 1 0;
}

.logo-text-container,
.logo-img-container {
    max-width: none;
    padding: 0;
}

.logo-img {
    margin: 0;
    max-height: 40px;
}

@media (min-width: 768px) {
    .logo-img {
        max-height: 52px;
    }
}

/* Utilidades: los iconos del base pasan a ser rotulos tecnicos. */
.utilities-item {
    padding: 0.9rem 0;
    font-size: 0.72rem;
}

.utilities-container > .utilities-item + .utilities-item {
    margin-left: 0.9rem;
}

.utilities-link,
.cart-summary a {
    color: var(--lu-tinta);
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.62rem;
    text-decoration: none;
}

.utilities-link:hover,
.cart-summary a:hover {
    color: var(--lu-tinta);
    text-decoration: underline;
}

/* Corchetes alrededor del contador de la bolsa: la sintaxis tecnica que el
   resto del theme usa en los rotulos, aplicada al unico numero que cambia. */
.cart-widget-amount {
    font-family: var(--lu-micro);
    letter-spacing: var(--lu-track);
    font-size: 0.62rem;
}

.cart-widget-amount::before {
    content: "\00a0[";
}

.cart-widget-amount::after {
    content: "]";
}

/* Rotulos al lado de los iconos: un menu hamburguesa sin palabra es la parte
   mas floja del base. El texto sale de translate, no hardcodeado, asi sigue
   el idioma de la tienda. Solo arriba de 768, que es donde entra.

   El espacio despues del \00a0 no es cosmetico: cierra el escape. Sin el,
   "\00a0B" se lee como UN codigo de seis digitos hexadecimales y BUSCAR
   aparecia como un cuadrito seguido de USCAR. */
@media (min-width: 768px) {
    .utilities-link[data-toggle="#nav-hamburger"]::after {
        content: "\00a0 {{ 'Menú' | translate }}";
    }

    .utilities-link[data-toggle="#nav-search"]::after {
        content: "\00a0 {{ 'Buscar' | translate }}";
    }
}

/*============================================================================
  #Panel de navegacion
  El menu es la unica pantalla del theme sin fotos: es puro texto, asi que se
  trata como tipografia macro. Cada rubro es un bloque con su division de 1px,
  igual que las celdas de la grilla.
==============================================================================*/

.modal-nav-hamburger,
.modal-nav-hamburger .modal-body,
#nav-search,
#nav-search .modal-body {
    background-color: var(--lu-papel);
}

/* El titulo del modal (Filtros, Carrito de Compras) es un rotulo tecnico: no
   compite con el contenido, solo dice donde esta parado el visitante. */
.modal-header {
    border-bottom: 1px solid var(--lu-linea);
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.66rem;
}

.modal-header,
.modal-footer {
    border-radius: 0;
}

.nav-primary {
    padding-bottom: 2rem;
}

.nav-primary .nav-list,
.nav-primary .nav-list ul {
    padding: 0;
    margin: 0;
    list-style: none;
}

/* display:block explicito: la division de 1px de cada rubro tiene que cruzar
   el panel entero, no terminar donde termina la palabra. */
.nav-primary .nav-list .nav-list-link {
    display: block;
    font-family: var(--lu-marca);
    text-transform: uppercase;
    letter-spacing: -0.02em;
    line-height: 1;
    font-size: clamp(1.35rem, 5.5vw, 2rem);
    font-weight: 400;
    color: var(--lu-tinta);
    padding: 0.85rem 1.25rem;
    border-bottom: 1px solid var(--lu-linea);
}

.nav-primary .nav-list .nav-list-link:hover {
    background-color: var(--lu-tinta);
    color: var(--lu-papel);
}

/* Los subrubros bajan a micro: no compiten con el rubro que los contiene. */
.nav-primary .nav-list .list-subitems .nav-list-link {
    font-family: var(--lu-micro);
    font-size: 0.7rem;
    letter-spacing: var(--lu-track);
    padding-left: 2.5rem;
}

.nav-list-arrow {
    top: 1.1rem;
    right: 1.25rem;
}

/* Cuenta: la unidad de abajo del panel, separada por una regla maciza. */
.nav-account {
    background-color: var(--lu-papel);
    border-top: 2px solid var(--lu-tinta);
    margin: 0;
    padding: 0.5rem 1.25rem;
    list-style: none;
}

.nav-accounts-link {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.66rem;
    color: var(--lu-tinta);
}

/*============================================================================
  #Buscador
  Un renglon macro sobre una regla de 2px, sin caja: la unica forma de campo
  que no contradice el "sin bordes redondeados, sin sombras".
==============================================================================*/

.search-input,
.search-input.form-control {
    background-color: transparent;
    border: 0;
    border-bottom: 2px solid var(--lu-tinta);
    padding: 0.5rem 2.25rem 0.5rem 0;
    height: auto;
    font-family: var(--lu-marca);
    text-transform: uppercase;
    letter-spacing: -0.02em;
    font-size: clamp(1.25rem, 4.5vw, 1.75rem);
    color: var(--lu-tinta);
}

/* Foco: el campo se tiñe, la regla no cambia de color. Antes pasaba a
   turquesa, que contra el papel da 2.17:1 — un indicador de foco pide 3:1
   (WCAG 1.4.11), asi que el cambio se veia menos que el estado normal. */
.search-input:focus {
    outline: none;
    background-color: color-mix(in srgb, var(--lu-tinta) 5%, var(--lu-papel));
}

.search-input::placeholder {
    color: var(--lu-gris);
}

.search-input-submit {
    top: 0.75rem;
    color: var(--lu-tinta);
}

.search-suggest-list {
    padding: 1rem 0;
    border-top: 1px solid var(--lu-linea);
}

/*============================================================================
  #Pie
  El base lo centra todo. Centrado no hay grilla: cada unidad pasa a la
  izquierda, separada por reglas, con su rotulo tecnico.
==============================================================================*/

footer {
    border-top: 2px solid var(--lu-tinta);
    margin-top: clamp(3rem, 8vw, 6rem);
}

/* Las utilidades de Bootstrap traen !important: para ganarles hace falta
   !important tambien, acotado al pie y nada mas. */
footer .text-center,
footer .text-md-left,
footer .text-md-right {
    text-align: left !important;
}

/* Mismo recurso que la grilla de productos: gap de 1px sobre fondo linea. Las
   unidades del pie quedan compartimentadas en las dos direcciones, y de paso
   dejan de ser una columna larga con medio ancho de pantalla vacio al lado.
   El auto-fit no depende del ORDEN de las filas, que es lo unico prudente:
   social, menu y logos son opcionales y la clienta los prende y apaga. */
footer > .container {
    display: flex;
    flex-wrap: wrap;
    gap: 1px;
    background-color: var(--lu-linea);
    padding: 0;
}

/* Flex y no grid a proposito: con grid, las columnas que sobran quedan vacias
   y dejan ver el fondo de linea como un bloque gris. En flex cada renglon se
   reparte entre las unidades que hay, sean tres o una. */
footer > .container > div {
    flex: 1 1 240px;
    min-width: 240px;
    margin: 0;
    padding: clamp(1.25rem, 3vw, 2rem);
    background-color: var(--lu-papel);
}

footer .col,
footer [class*="col-"] {
    padding: 0;
}

/* Las unidades anchas ocupan la fila entera: el newsletter porque encabeza
   (es la unica fila sin .element-footer), los logos porque son una tira, y la
   firma legal porque cierra. */
footer > .container > .row:not(.element-footer),
footer > .container > .footer-payments-shipping-logos,
footer > .container > div:last-of-type {
    flex-basis: 100%;
}

footer .contact-item,
footer .footer-menu-item,
footer .copyright,
footer .powered-by,
footer .contact-link,
footer .footer-menu-link {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.66rem;
    line-height: 1.6;
    color: var(--lu-tinta);
}

footer .contact-info,
footer .footer-menu {
    list-style: none;
    margin: 0;
    padding: 0;
}

footer .footer-menu-item {
    margin: 0 0 0.4rem 0;
}

footer .contact-item {
    margin-bottom: 0.4rem;
}

/* Iconos sociales: cuadrados de 1px, no circulos. */
.social-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 2.4rem;
    height: 2.4rem;
    border: 1px solid var(--lu-tinta);
    color: var(--lu-tinta);
    margin: 0 0.4rem 0.4rem 0;
}

.social-icon:hover {
    background-color: var(--lu-tinta);
    color: var(--lu-papel);
}

/* Newsletter: el titulo es lo unico macro del pie. */
.newsletter h3 {
    font-size: clamp(1.35rem, 4vw, 2.25rem);
    margin: 0 0 0.5rem;
}

.newsletter p {
    font-family: var(--lu-micro);
    font-size: 0.72rem;
    letter-spacing: 0.02em;
    line-height: 1.6;
    max-width: 46ch;
    color: var(--lu-gris);
    text-transform: none;
}

.newsletter .form-control {
    background-color: transparent;
    border: 0;
    border-bottom: 2px solid var(--lu-tinta);
    border-radius: 0;
    padding: 0.6rem 6rem 0.6rem 0;
    height: auto;
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.72rem;
    color: var(--lu-tinta);
}

/* Mismo criterio que el buscador: se tiñe el campo, la regla sigue en tinta */
.newsletter .form-control:focus {
    outline: none;
    background-color: color-mix(in srgb, var(--lu-tinta) 5%, var(--lu-papel));
}

.newsletter form .newsletter-btn {
    top: 0;
    right: 0;
    padding: 0.6rem 0.9rem;
    background-color: var(--lu-tinta);
    color: var(--lu-papel);
    border: 0;
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.66rem;
}

.newsletter form .newsletter-btn:hover {
    background-color: var(--lu-acento);
    color: var(--lu-tinta);
}

/* Los logos de pago y envio vienen en los colores de cada marca y son una
   fuga de color en una paleta de tres. En gris se leen igual. */
.footer-payments-shipping-logos img {
    filter: grayscale(1);
    opacity: 0.75;
}

/* La firma de Tiendanube es obligatoria por sus terminos: se la trata como
   metadato, no se la esconde. */
footer .copyright,
footer .powered-by {
    font-size: 0.58rem;
    color: var(--lu-gris);
}

/* Link suelto: tinta con subrayado, no turquesa (ver #Acento). */
footer a:hover {
    color: var(--lu-tinta);
    text-decoration: underline;
}

/*============================================================================
  #Encabezado de categoria
  El base lo centra y lo encajona en col-lg-6 offset-lg-3. El nombre de la
  seccion es el titulo mas grande de la pagina: va al ras de la izquierda,
  como el resto de la grilla.
==============================================================================*/

.category-header {
    margin-top: 0;
}

.category-header .page-header {
    margin-top: 0;
}

.category-header .page-header [class*="col"] {
    text-align: left !important;
    flex: 1 1 auto;
    max-width: none;
    margin-left: 0;
}

.category-header .page-header-text {
    font-family: var(--lu-micro);
    font-size: 0.72rem;
    line-height: 1.6;
    letter-spacing: 0.02em;
    max-width: 60ch;
    color: var(--lu-gris);
    margin: 0.75rem 0 0;
}

/* El separador del base es un bloquecito centrado (col-2 offset-5). Aca es una
   regla al ancho completo — pero fina y en linea, no en tinta: abajo viene el
   riel de secciones con su propio borde y dos reglas macizas juntas se leen
   como un error de imprenta. */
.category-header .divider {
    max-width: none;
    margin: 1.5rem 0 0;
    padding: 0;
    height: 1px;
    background-color: var(--lu-linea);
}

/*============================================================================
  #Categorias con foto
  home_order_position_2 = categories -> home-banners.tpl del base: 3 fotos
  con titulo y link que la clienta carga desde el panel (Diseño -> Banners de
  categorias), sin tocar codigo. Estaba sin restylar (Bootstrap de fabrica,
  bordes redondeados). Idea de Santiago (referencia con 3 fotos y categoria
  superpuesta) — 2026-09-11.

  Se descarta la tipografia script/cursiva de la referencia: contradice
  Archivo Black en mayusculas, que es la macro del sistema. El titulo va en
  el mismo chip solido de tinta que ya usan las etiquetas de producto
  (.item-label, OFERTA/NUEVO) en vez de flotar crema sobre la foto — asi no
  depende de que la foto sea oscura ahi (el home-banners.tpl del base no
  tiene, a diferencia del hero, un selector de color de texto por foto).
==============================================================================*/

.section-banners-home .row {
    background-color: var(--lu-linea);
    gap: 1px;
}

.section-banners-home .col-md {
    background-color: var(--lu-papel);
    padding: 0;
}

.textbanner {
    position: relative;
    height: 100%;
}

.textbanner-link {
    display: block;
    height: 100%;
    color: inherit;
    text-decoration: none;
}

/* padding-top: 0 a proposito: el base arma el alto con padding-top: 100%
   (un cuadrado) y la foto en absoluto adentro. Con el aspect-ratio encima
   de ese padding la caja iba a medir cuadrado + tres cuartos. El harness no
   copiaba ese padding, asi que aca se veia bien y en la tienda no. */
.textbanner-image {
    position: relative;
    padding-top: 0;
    aspect-ratio: 3 / 4;
    overflow: hidden;
}

/* transform Y opacity: el base carga las fotos con lazyload y las funde
   con .fade-in (transition: opacity .2s). Declarar solo transform pisaba
   esa transicion y la foto aparecia de golpe. */
.textbanner-image-background {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
    transition-property: transform, opacity;
    transition-duration: 420ms, 200ms;
    transition-timing-function: var(--lu-entrada), ease;
}

/* La foto respira, igual que en la grilla de productos. Solo con mouse:
   en un telefono el hover se dispara al tocar y la foto quedaba agrandada
   hasta tocar otra cosa. */
@media (hover: hover) and (pointer: fine) {
    .textbanner-link:hover .textbanner-image-background {
        transform: scale(1.04);
    }
}

/* top/right/width/transform: el base centra este bloque con top: 50%,
   left: 50%, width: 100% y translate(-50%, -50%). Sin apagar los cuatro,
   el chip era una caja de tinta del ancho del banner, corrida a la
   izquierda — se vio recien cuando el harness copio esas reglas. */
.textbanner-text.over-image {
    position: absolute;
    top: auto;
    right: auto;
    left: 0.75rem;
    bottom: 0.75rem;
    width: auto;
    transform: none;
    background-color: var(--lu-tinta);
    color: var(--lu-papel);
    padding: 0.4rem 0.65rem;
}

.textbanner-title {
    font-family: var(--lu-micro);
    font-size: 0.72rem;
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    margin: 0;
}

.textbanner-paragraph {
    font-family: var(--lu-micro);
    font-size: 0.6rem;
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    opacity: 0.75;
    margin-top: 0.2rem;
}

.textbanner-text .btn {
    display: inline-block;
    margin-top: 0.4rem;
    border: 1px solid var(--lu-papel);
    color: var(--lu-papel);
    background: transparent;
    padding: 0.3rem 0.6rem;
    font-family: var(--lu-micro);
    font-size: 0.58rem;
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
}

/*============================================================================
  #Riel de secciones
  Ahi! Lupita vende SOLO ropa de mujer: no hay un nivel de genero que separar,
  asi que las secciones son directamente las prendas (vestidos, pantalones,
  abrigos). Por eso pueden estar todas a la vista en un solo renglon.

  Misma mecanica que la grilla: gap de 1px sobre fondo linea. Abajo de cierto
  ancho no entran y el riel se recorre de costado, como en cualquier tienda de
  ropa; arriba, las celdas crecen y ocupan el ancho completo.
==============================================================================*/

.lu-secciones {
    border-top: 1px solid var(--lu-linea);
    border-bottom: 1px solid var(--lu-linea);
    overflow-x: auto;
    overscroll-behavior-x: contain;
    -webkit-overflow-scrolling: touch;
    scrollbar-width: none;
}

.lu-secciones::-webkit-scrollbar {
    display: none;
}

.lu-secciones-lista {
    display: flex;
    gap: 1px;
    margin: 0;
    padding: 0;
    list-style: none;
    background-color: var(--lu-linea);
    /* max-content mide el contenido; el min-width lo estira hasta el ancho
       disponible cuando sobra lugar, y ahi el flex-grow reparte. */
    width: max-content;
    min-width: 100%;
}

.lu-secciones-lista > li {
    flex: 1 0 auto;
    background-color: var(--lu-papel);
}

.lu-seccion-link {
    display: block;
    padding: 0.9rem 1.25rem;
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.66rem;
    line-height: 1;
    color: var(--lu-tinta);
    white-space: nowrap;
    text-align: center;
}

.lu-seccion-link:hover,
.lu-seccion-link:focus {
    background-color: var(--lu-tinta);
    color: var(--lu-papel);
}

/*============================================================================
  #Controles de categoria
  La fila de "Filtrar" y el orden. Es sticky en el base y se respeta: al
  recorrer una grilla larga, es lo unico que hace falta tener a mano.
==============================================================================*/

/* Ojo con el margin: es un .row de Bootstrap y su margen negativo de -.75rem
   es lo que compensa el padding de las columnas. Anulandolo, todo el renglon
   se corria 12px a la derecha y dejaba de alinear con el riel. */
.category-controls {
    padding: 0.6rem 0;
    border-bottom: 1px solid var(--lu-linea);
    background-color: var(--lu-papel);
}

.filter-link {
    width: auto;
    padding: 0;
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.66rem;
    color: var(--lu-tinta);
}

/* Corchetes: la misma sintaxis tecnica de los rotulos y del contador de la
   bolsa. El espacio despues del \00a0 cierra el escape. */
.filter-link::before {
    content: "[\00a0 ";
}

.filter-link::after {
    content: "\00a0 ]";
}

.filter-link:hover {
    color: var(--lu-tinta);
    text-decoration: underline;
}

/* El selector de orden lo arma un component() de la plataforma, asi que se lo
   ataca por lo unico seguro: que adentro hay un select. */
.category-controls select,
.category-controls .form-control {
    background-color: transparent;
    border: 0;
    border-radius: 0;
    box-shadow: none;
    height: auto;
    padding: 0 1.25rem 0 0;
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.66rem;
    color: var(--lu-tinta);
    text-align: right;
    text-align-last: right;
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
}

/*============================================================================
  #Panel de filtros
  Lo que queda adentro del modal despues de sacarle las secciones: talle,
  color, precio. Un filtro no es una decision de marca, es una tarea — asi que
  todo micro, sin tipografia macro que compita con el catalogo.
==============================================================================*/

.modal-filters,
.modal-filters .modal-body {
    background-color: var(--lu-papel);
}

.filters-container {
    margin: 0;
    padding: 1.25rem;
    border-bottom: 1px solid var(--lu-linea);
}

/* El h6 del base es el nombre del grupo (TALLE, COLOR): rotulo tecnico. */
.filters-container h6 {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.62rem;
    font-weight: 400;
    color: var(--lu-gris);
    margin: 0 0 0.9rem;
}

.filters-container .checkbox {
    margin-bottom: 0.7rem;
}

.filters-container .checkbox-text {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.68rem;
    font-weight: 400;
}

/* Marcado = cuadrado lleno de tinta con el tilde en papel. El base solo
   dibujaba el tilde sobre fondo claro. */
.checkbox-container .checkbox input:checked ~ .checkbox-icon {
    background-color: var(--lu-tinta);
}

.checkbox-container .checkbox input:checked ~ .checkbox-icon:after {
    border-color: var(--lu-papel);
}

/* La muestra de color venia redonda; en este theme no hay una sola curva. */
.checkbox-container .checkbox-color {
    border-radius: 0;
    width: 12px;
    height: 12px;
}

.js-accordion-toggle {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.62rem;
    color: var(--lu-tinta);
}

.filters-overlay {
    background-color: var(--lu-papel);
}

/*============================================================================
  #Filtros aplicados
  La fila de fichas arriba de la grilla. Es el unico lugar donde el visitante
  ve, en una linea, que recorte esta mirando.
==============================================================================*/

.js-remove-filter.chip,
.chip {
    background-color: transparent;
    color: var(--lu-tinta);
    border: 1px solid var(--lu-tinta);
    border-radius: 0;
    padding: 0.4rem 0.6rem;
    margin: 0 0.4rem 0.4rem 0;
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.62rem;
    line-height: 1;
}

.chip:hover {
    background-color: var(--lu-tinta);
    color: var(--lu-papel);
}

.chip:hover .chip-remove-icon {
    fill: var(--lu-papel);
}

.js-remove-all-filters {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.62rem;
    color: var(--lu-tinta);
    text-decoration: underline;
}

/* El "Filtrado por:" del base no tiene clase propia, asi que se le agrego
   .lu-aplicados al contenedor — una palabra en filters.tpl, nada mas. */
.lu-aplicados {
    /* .75rem horizontal = el padding de columna de Bootstrap, que cancela el
       margen negativo de su .row y deja el renglon al ras del container. */
    padding: 0.9rem 0.75rem;
    border-bottom: 1px solid var(--lu-linea);
}

.lu-aplicados > div {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.62rem;
    color: var(--lu-gris);
    margin-bottom: 0;
}

/*============================================================================
  #Avisos
  El base los pinta con fondos de color y los centra. Aca son bloques planos:
  el que informa se queda en una regla de 1px, y el que frena una compra se
  pone macizo, que es como el theme dice "pare".
==============================================================================*/

.alert {
    border: 1px solid var(--lu-linea);
    border-radius: 0;
    background-color: transparent;
    color: var(--lu-tinta);
    padding: 0.9rem 1rem;
    text-align: left;
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.62rem;
    line-height: 1.6;
}

.alert-info {
    color: var(--lu-gris);
}

/* Exito (cupon aplicado, newsletter enviado): el unico aviso en turquesa,
   y como fondo con tinta encima — la unica combinacion del acento que
   contrasta (8.27:1). Antes era solo un borde turquesa sobre papel, que a
   2.17:1 casi no se distinguia del aviso neutro. */
.alert-success {
    background-color: var(--lu-acento);
    border-color: var(--lu-acento);
    color: var(--lu-tinta);
}

/* Etiquetas del carrito (envio gratis, promocion): misma regla que OFERTA */
.label-accent {
    background-color: var(--lu-acento);
    color: var(--lu-tinta);
}

.label-secondary {
    background-color: transparent;
    border: 1px solid var(--lu-linea);
    color: var(--lu-gris);
}

/* Falta stock, no llega al minimo de compra: son las unicas dos veces que el
   theme le corta el paso a alguien, y se nota. */
.alert-warning,
.alert-danger {
    background-color: var(--lu-tinta);
    border-color: var(--lu-tinta);
    color: var(--lu-papel);
}

.alert-warning a,
.alert-danger a {
    color: var(--lu-papel);
    text-decoration: underline;
}

/* "¡Estás a un paso de crear tu cuenta!" (register.tpl): ni informa un dato
   neutro (.alert-info) ni frena una compra (.alert-danger) — mismo trato que
   .alert-info, borde fino sin relleno. */
.alert-primary {
    color: var(--lu-gris);
}

/*============================================================================
  #Formularios y cuenta
  Contacto, login/registro, direcciones y pedidos: el ultimo tramo del base
  sin restylar (LUPITA.md, "Lo que sigue en el codigo"). Los tres snipplets
  compartidos (form.tpl, form-input.tpl, form-select.tpl) alcanzan para
  cubrir las once plantillas: nada de esto se scopea por pantalla.
==============================================================================*/

.form-label {
    display: block;
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.66rem;
    color: var(--lu-gris);
    margin-bottom: 0.5rem;
}

/* Caja con borde, como el .btn: es la unica forma de campo que no contradice
   "sin redondeo, sin sombra" cuando el campo no vive solo en una linea (ver
   #Buscador, que si puede ser un renglon con regla inferior). El texto
   tipeado se queda en minuscula/mayuscula normal a proposito: un email o una
   contraseña en VERSALITA es mas dificil de revisar antes de enviar. */
.form-control,
.form-select {
    display: block;
    width: 100%;
    border: 1px solid var(--lu-tinta);
    background-color: var(--lu-papel);
    color: var(--lu-tinta);
    padding: 0.85rem 1rem;
    height: auto;
    font-family: var(--lu-micro);
    font-size: 0.8rem;
    letter-spacing: 0.02em;
}

/* Foco: el borde se engrosa a 2px sin mover nada (el inset no ocupa
   lugar). No pasa a turquesa: 2.17:1 contra papel, abajo del 3:1 que pide
   un indicador de foco. El box-shadow no es una sombra visible, es la forma
   de sumar 1px de borde sin reflow. */
.form-control:focus,
.form-select:focus {
    outline: none;
    border-color: var(--lu-tinta);
    box-shadow: inset 0 0 0 1px var(--lu-tinta);
}

.form-control::placeholder {
    color: var(--lu-gris);
}

.form-control-area {
    min-height: 9rem;
    resize: vertical;
}

/* El base dibuja su propio dropdown (form-select-icon, .open) y ya lo
   posiciona en style-critical.tpl — falta apagar la flecha nativa del
   navegador, que si no queda una al lado de la otra, y dejarle aire al
   texto para que no pise el icono. */
.form-select {
    appearance: none;
    -webkit-appearance: none;
    -moz-appearance: none;
    padding-right: 2.5rem;
}

.form-select-icon {
    right: 1rem;
}

/* Contacto y cuenta respiran igual que el resto de las secciones del home. */
.account-page,
.contact-page {
    padding-top: clamp(1.5rem, 4vw, 3rem);
    padding-bottom: clamp(3rem, 6vw, 5rem);
}

/* Mismo ajuste que .category-header .divider: una regla fina de linea a
   ancho completo, no el bloque de color chico del base. */
.account-page hr.divider {
    max-width: none;
    margin: 0 0 1.25rem;
    padding: 0;
    height: 1px;
    background-color: var(--lu-linea);
    border: 0;
}

/* "Mis datos", "Principal", "Detalles", "Productos": son rotulos tecnicos
   que anteceden una regla, no titulos de contenido — van en la microtipo-
   grafia del sistema (como .lu-rotulo), no en la serif macro de los h1/h2. */
.account-page .h5 {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.68rem;
    color: var(--lu-gris);
}

/* El total de una orden es una cifra de plata, como el TOTAL del carrito
   (#Carrito, mas abajo): --lu-marca fija, no la serif de los titulos. */
.account-page .h3 {
    font-family: var(--lu-marca);
    text-transform: uppercase;
    letter-spacing: -0.02em;
    font-size: clamp(1.1rem, 3vw, 1.5rem);
}

/* Links sueltos (Editar, Ver detalle, ¿Olvidaste tu contraseña?): tinta con
   subrayado en hover, el mismo lenguaje que .filter-link. .btn-link-primary
   es el llamado a la accion (Crear cuenta, Iniciar sesión) y se queda
   subrayado siempre, no solo al pasar el mouse. */
.btn-link,
.btn-link-primary {
    text-decoration: none;
}

.btn-link:hover {
    text-decoration: underline;
}

.btn-link-primary {
    text-decoration: underline;
    font-weight: 700;
}

/* "Mis compras" (orders.tpl) y el detalle de una orden (order.tpl): el
   mismo contenedor con borde de 1px que usa el resto del sistema en vez de
   la sombra/redondeo del base — .card ya viene sin ninguna de las dos por
   el reset de arriba, aca solo falta el borde y el aire interno. */
.card {
    border: 1px solid var(--lu-linea);
}

.card-header,
.card-body,
.card-footer {
    padding: 1rem 1.25rem;
}

.card-header {
    border-bottom: 1px solid var(--lu-linea);
}

.card-footer {
    border-top: 1px solid var(--lu-linea);
}

/*============================================================================
  #Carrito
  El panel lateral (#modal-cart) y la pagina del carrito comparten estos
  snipplets — cart-item-ajax.tpl y cart-totals.tpl —, asi que casi todo esto
  sirve para los dos. Lo que difiere va scopeado.
==============================================================================*/

#modal-cart,
#modal-cart .modal-body {
    background-color: var(--lu-papel);
}

/* Renglon de producto. El base lo arma con col-2 + col-10 + col-1, o sea
   TRECE columnas de doce: el tacho de basura se caia a una linea propia. En
   grilla explicita entra donde tiene que entrar, y de paso queda la division
   de 1px que usa el resto del theme. */
.cart-item {
    display: grid;
    grid-template-columns: 56px 1fr auto;
    align-items: start;
    gap: 0.85rem;
    margin: 0;
    padding: 1rem 0;
    border-bottom: 1px solid var(--lu-linea);
}

.cart-item > [class*="col"] {
    flex: none;
    width: auto;
    max-width: none;
    padding: 0;
}

@media (min-width: 768px) {
    .template-cart .cart-item {
        grid-template-columns: 96px 1fr auto;
        gap: 1.25rem;
    }
}

.cart-item img {
    display: block;
    width: 100%;
    height: auto;
}

/* El nombre llega como h6 y el h6 no esta en la escala macro: se lo trata como
   metadato, igual que el nombre en la grilla de productos. */
.cart-item h6,
.cart-item .cart-item-name {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.66rem;
    font-weight: 400;
    line-height: 1.4;
    margin: 0;
    padding: 0;
    color: var(--lu-tinta);
}

.cart-item .cart-item-name a,
.cart-item h6 a {
    color: var(--lu-tinta);
}

/* La variante (talle, color) baja un escalon: es la aclaracion, no el nombre */
.cart-item .cart-item-name small {
    display: block;
    color: var(--lu-gris);
    font-size: 0.58rem;
    letter-spacing: var(--lu-track);
    margin-top: 0.25rem;
}

.cart-item-subtotal {
    font-weight: 700;
    font-size: 0.72rem;
    margin: 0.6rem 0 0;
}

/* El +/- y la cantidad son una sola pieza encerrada en 1px, no tres controles
   sueltos. El .btn del sistema es un bloque macizo con padding grande: aca hay
   que sacarselo de encima o cada signo mide como un boton de comprar. */
.cart-item-quantity .row {
    display: inline-flex;
    align-items: center;
    border: 1px solid var(--lu-linea);
    margin: 0;
}

.cart-item-btn.btn {
    border: 0;
    padding: 0.35rem 0.55rem;
    opacity: 1;
    background-color: transparent;
    color: var(--lu-tinta);
    font-size: 0.7rem;
    line-height: 1;
}

.cart-item-btn.btn:hover {
    opacity: 1;
    background-color: var(--lu-tinta);
    color: var(--lu-papel);
}

.cart-item-input.form-control {
    width: 2.2rem;
    height: auto;
    border: 0;
    border-radius: 0;
    background-color: transparent;
    padding: 0.35rem 0;
    font-family: var(--lu-micro);
    font-size: 0.68rem;
    letter-spacing: var(--lu-track);
    text-align: center;
    color: var(--lu-tinta);
}

/* El tacho tampoco es un boton macizo. */
.cart-item-delete .btn {
    border: 0;
    padding: 0.2rem;
    background-color: transparent;
    color: var(--lu-gris);
}

.cart-item-delete .btn:hover {
    color: var(--lu-tinta);
}

/*============================================================================
  #Totales del carrito
  La unica cifra macro del panel es el TOTAL. Todo lo demas — subtotal,
  descuentos, cuotas — es metadato alrededor.
==============================================================================*/

#modal-cart .cart-row {
    padding: 1.25rem;
}

#modal-cart .js-ajax-cart-list.cart-row {
    padding-top: 0;
    padding-bottom: 0;
}

/* La barra de envio gratis no viene adentro de ningun .cart-row, asi que se
   quedaba sin margen y el mensaje salia contra el borde del panel. */
#modal-cart .js-fulfillment-info {
    padding: 1.25rem 1.25rem 0;
}

/* El .container-fluid del base agrega SUS 15px arriba del padding del panel, y
   el boton de comprar quedaba mas adentro que todo lo demas. */
#modal-cart .container-fluid {
    padding: 0;
}

/* La unidad de totales se separa del resto con una regla maciza. Se la agarra
   por ser el ultimo hijo y no por una clase, porque .cart-row la comparte con
   la lista y con el mensaje de carrito vacio. */
#modal-cart .modal-body > .cart-row:last-child {
    border-top: 2px solid var(--lu-tinta);
    margin-top: 1.25rem;
}

.cart-row .h5,
.cart-row .h6,
.js-total-promotions,
.ship-free-rest-message {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.66rem;
    line-height: 1.6;
}

.js-cart-subtotal,
.js-ajax-cart-total {
    font-weight: 700;
}

/* TOTAL: llega con class="h2", que es una clase de Bootstrap y NO el elemento
   h2, asi que la escala macro del sistema no lo agarraba sola.

   Fijo en --lu-marca (Archivo Black) y no en --lu-macro a proposito, desde
   que font_headings paso a Italiana (2026-09-11): es una cifra de plata, no
   un titulo — se queda estructural, fuera del alcance que pidio Santiago
   ("solo los titulos grandes: hero, portada, secciones"). */
.js-cart-total-container .h2 {
    font-family: var(--lu-marca);
    text-transform: uppercase;
    letter-spacing: -0.03em;
    line-height: 1;
    font-size: clamp(1.5rem, 5vw, 2.25rem);
    align-items: baseline;
}

/* En el panel, "TOTAL:" y la cifra en el mismo renglon no entran: en 380px la
   cifra se partia despues del signo — $ / 219.500 —, que es exactamente el
   error que ya habiamos corregido en la grilla. Se apilan: la palabra pasa a
   rotulo y la cifra se queda con el renglon entero. */
#modal-cart .js-cart-total-container {
    margin-top: 1.1rem;
}

#modal-cart .js-cart-total-container .h2 {
    display: block;
    font-size: 1.9rem;
}

/* !important: el span de la cifra llega con .text-right, que en Bootstrap
   es !important; sin esto la cifra iba a la derecha en la tienda. */
#modal-cart .js-cart-total-container .h2 > span {
    display: block;
    max-width: none;
    flex: none;
    text-align: left !important;
    padding: 0;
}

#modal-cart .js-cart-total-container .h2 > span:first-child {
    font-family: var(--lu-micro);
    font-size: 0.62rem;
    letter-spacing: var(--lu-track);
    color: var(--lu-gris);
    margin: 0 0 0.35rem;
}

#modal-cart .js-cart-total {
    white-space: nowrap;
}

#modal-cart .js-cart-total-container .installments,
#modal-cart .js-cart-total-container [class*="installment"] {
    text-align: left;
}

.js-cart-total-container .total-price {
    display: none;
}

/* Las cuotas otra vez: el mejor argumento de venta de la marca, en el ultimo
   lugar donde alguien duda antes de pagar. */
.js-cart-total-container .installments,
.js-cart-total-container [class*="installment"] {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: 0.02em;
    font-size: 0.6rem;
    color: var(--lu-gris);
}

/* Barra de envio gratis. Sin redondeo, como todo lo demas.

   Y en TINTA, no en el turquesa de la marca: medido, el acento da 2.17:1
   contra el papel — abajo del 3:1 que pide un elemento grafico que transmite
   informacion, y esta barra dice cuanto falta. Contra tinta el turquesa da
   8.27:1, asi que sirve como fondo con letras oscuras encima, no como color
   sobre papel. Ver la nota de contraste en LUPITA.md. */
.bar-progress {
    height: 4px;
    border-radius: 0;
    background-color: var(--lu-linea);
    overflow: hidden;
}

.bar-progress-active {
    height: 4px;
    border-radius: 0;
    background-color: var(--lu-tinta);
}

.ship-free-rest-message {
    margin-top: 0.6rem;
    color: var(--lu-gris);
}

/* El color ya viene de .text-accent (tinta, ver #Acento); esto solo agrega
   el peso para que se note el "te faltan $X". */
.ship-free-rest-message .text-accent {
    font-weight: 700;
}

/* Iniciar Compra: el bloque mas macizo del panel, igual que Comprar en la
   ficha de producto. Es la misma accion. */
.js-ajax-cart-submit .btn,
#go-to-checkout {
    display: block;
    width: 100%;
    padding: 1.1rem 1rem;
    font-size: 0.72rem;
}

.js-ajax-cart-submit {
    margin: 0;
}

/*============================================================================
  #Foco visible
  El base apaga el outline en varios lados y no pone nada a cambio: con
  teclado no se sabe donde se esta parado. Un rectangulo de 2px en tinta,
  separado 2px del borde — cuadrado y sin sombra, como todo lo demas.
  :focus-visible y no :focus, para que un click con el mouse no lo dibuje.
  Los campos de texto tienen su propio estado (borde a 2px o campo teñido)
  y no lo necesitan encima.
==============================================================================*/

a:focus-visible,
button:focus-visible,
[tabindex]:focus-visible,
input[type="submit"]:focus-visible,
input[type="checkbox"]:focus-visible,
select:focus-visible,
.btn:focus-visible {
    outline: 2px solid var(--lu-tinta);
    outline-offset: 2px;
}

/* Sobre foto o sobre tinta el rectangulo va en papel, si no desaparece */
.swiper-btn:focus-visible,
.textbanner-link:focus-visible,
.btn-primary:focus-visible,
.nav-list-link:focus-visible,
.social-icon:focus-visible,
.btn-whatsapp:focus-visible {
    outline-color: var(--lu-papel);
    outline-offset: -4px;
}

.form-control:focus-visible,
.form-select:focus-visible,
.search-input:focus-visible,
.newsletter .form-control:focus-visible {
    outline: none;
}

/*============================================================================
  #Migas
  El base las arma con ">" entre las migas. Se las trata como un rotulo
  tecnico, y el ">" se reemplaza por una raya vertical de 1px — la misma
  linea que divide todo lo demas — sin tocar breadcrumbs.tpl.
==============================================================================*/

.breadcrumbs {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.62rem;
    line-height: 1.4;
    color: var(--lu-gris);
    margin: 0 0 1rem;
}

.breadcrumbs .crumb {
    color: var(--lu-gris);
    text-decoration: none;
}

.breadcrumbs a.crumb:hover {
    color: var(--lu-tinta);
    text-decoration: underline;
}

.breadcrumbs .crumb.active {
    color: var(--lu-tinta);
}

.breadcrumbs .divider {
    display: inline-block;
    width: 1px;
    height: 0.6rem;
    margin: 0 0.6rem;
    vertical-align: -0.1em;
    background-color: var(--lu-gris);
    font-size: 0;
    line-height: 0;
    color: transparent;
}

/*============================================================================
  #Encabezado de pagina
  page-header.tpl lo comparten todas las paginas que no son la categoria
  (carrito, busqueda, institucionales, 404, contacto, cuenta). El base lo
  centra; aca va al ras de la izquierda como el resto, y con un cuerpo mas
  chico que el titulo de categoria: "Carrito de compras" a 9rem es un
  cartel, no un titulo. La categoria conserva su escala (#Encabezado de
  categoria) y el producto la suya (#Ficha de producto).
==============================================================================*/

.page-header [class*="col"] {
    text-align: left !important;
}

.page-header h1 {
    font-size: clamp(2rem, 6vw, 5rem);
}

.category-header .page-header h1 {
    font-size: clamp(2.75rem, 10vw, 9rem);
}

body:not(.template-product):not(.template-category) .page-header {
    margin-top: clamp(1.5rem, 4vw, 3rem);
    margin-bottom: clamp(1.5rem, 4vw, 3rem);
    padding-bottom: clamp(1rem, 3vw, 2rem);
    border-bottom: 1px solid var(--lu-linea);
}

/*============================================================================
  #Texto institucional
  "Como comprar", "Cambios y devoluciones", "Envios": las paginas que la
  clienta escribe desde el panel (page.tpl -> .user-content). Junto con la
  descripcion del producto son el unico texto largo del theme, y se leen
  igual: minusculas, sin tracking, interlineado ancho, 68 caracteres de
  ancho como maximo. Los subtitulos si van en la macro.
==============================================================================*/

/* Solo en la pagina institucional: la descripcion del producto tambien
   lleva .user-content y no necesita este aire al pie. */
.template-page .user-content {
    padding-bottom: clamp(3rem, 6vw, 5rem);
}

/* El base centra la columna (justify-content-md-center); en este theme el
   texto arranca donde arranca todo lo demas. */
.user-content .row {
    justify-content: flex-start !important;
}

.user-content,
.user-content p,
.user-content li,
.user-content td,
.user-content th {
    font-family: var(--lu-micro);
    text-transform: none;
    letter-spacing: 0;
    font-size: 0.9rem;
    line-height: 1.75;
    color: var(--lu-tinta);
}

.user-content p {
    margin: 0 0 1.25rem;
    max-width: 68ch;
    text-wrap: pretty;
}

.user-content h1,
.user-content h2,
.user-content h3,
.user-content h4 {
    margin: 2.25rem 0 0.75rem;
    max-width: 30ch;
}

.user-content h1,
.user-content h2 {
    font-size: clamp(1.5rem, 3vw, 2.25rem);
}

.user-content h3,
.user-content h4 {
    font-size: 1.15rem;
}

.user-content ul,
.user-content ol {
    padding-left: 1.25rem;
    margin: 0 0 1.25rem;
    max-width: 68ch;
}

.user-content li {
    margin-bottom: 0.4rem;
}

.user-content a {
    color: var(--lu-tinta);
    text-decoration: underline;
    text-underline-offset: 0.15em;
}

.user-content img {
    display: block;
    max-width: 100%;
    height: auto;
}

/* Una tabla de talles, por ejemplo: reglas de 1px y cabecera en rotulo */
.user-content table {
    width: 100%;
    max-width: 68ch;
    border-collapse: collapse;
    margin: 0 0 1.5rem;
}

.user-content th,
.user-content td {
    padding: 0.6rem 0.75rem 0.6rem 0;
    border-bottom: 1px solid var(--lu-linea);
    text-align: left;
    vertical-align: top;
}

.user-content th {
    font-size: 0.66rem;
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    color: var(--lu-gris);
    font-weight: 400;
    border-bottom-color: var(--lu-tinta);
}

/*============================================================================
  #Vacios
  Busqueda sin resultados, 404, carrito vacio. El base los centra en un
  parrafo suelto; aca son un rotulo al ras de la izquierda con su regla,
  como un cartel de "no hay" en una estanteria.
==============================================================================*/

.category-body > .container > .text-center,
#\34 04 .text-center,
#\34 04 p {
    text-align: left !important;
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.72rem;
    line-height: 1.6;
    color: var(--lu-tinta);
    margin: 0;
}

.category-body > .container > .text-center {
    padding: clamp(2rem, 5vw, 4rem) 0;
    border-top: 1px solid var(--lu-linea);
    border-bottom: 1px solid var(--lu-linea);
}

#\34 04 .container {
    padding-bottom: clamp(3rem, 6vw, 5rem);
}

#\34 04 br {
    display: none;
}

#\34 04 .row.mt-3 {
    margin-top: clamp(1.5rem, 4vw, 3rem) !important;
}

/*============================================================================
  #WhatsApp
  El boton flotante del base es un circulo verde con sombra: un logo de
  otra marca pegado sobre la paleta de tres. Pasa a un cuadrado de tinta con
  el icono en papel, del tamano de un boton, en la esquina de siempre. Verde
  no: el icono ya dice que es WhatsApp.
==============================================================================*/

.btn-whatsapp {
    bottom: 1rem;
    right: 1rem;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 3rem;
    height: 3rem;
    background-color: var(--lu-tinta);
    color: var(--lu-papel);
    border: 0;
    border-radius: 0;
    box-shadow: none;
    transition-property: background-color;
    transition-duration: 120ms;
    transition-timing-function: var(--lu-entrada);
}

.btn-whatsapp svg {
    width: 1.35rem;
    height: 1.35rem;
    padding: 0;
    fill: var(--lu-papel);
}

.btn-whatsapp:hover,
.btn-whatsapp:active {
    background-color: var(--lu-acento);
}

.btn-whatsapp:hover svg,
.btn-whatsapp:active svg {
    fill: var(--lu-tinta);
}

/* Abajo de 768 el boton se corre para no tapar el "Agregar al carrito"
   de la ficha, que en mobile queda al pie de la pantalla. */
@media (max-width: 767px) {
    .btn-whatsapp {
        bottom: 0.75rem;
        right: 0.75rem;
        width: 2.75rem;
        height: 2.75rem;
    }
}

/*============================================================================
  #Notificacion del carrito
  cart_open_type = show_notification: al agregar un producto, el base
  despliega una tarjeta debajo de la cabecera (notification-cart.tpl), con
  sombra y una rotacion 3D en el eje X. Aca es una caja de 1px en tinta
  sobre papel, que baja medio centimetro y se funde — entrada 220ms, salida
  mas corta, como los paneles. Mismo contenido, mismas clases.
==============================================================================*/

.notification {
    background-color: var(--lu-papel);
    border: 1px solid var(--lu-tinta);
    border-radius: 0;
    padding: 1.1rem 1.25rem 1.25rem;
    text-align: left;
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.62rem;
    line-height: 1.5;
    color: var(--lu-tinta);
}

.notification-floating {
    margin-top: 0.5rem;
}

.notification-floating .notification {
    box-shadow: none;
}

.notification .h6 {
    font-size: 0.66rem;
    font-weight: 700;
    text-align: left !important;
    margin: 0 1.75rem 0.9rem 0 !important;
}

.notification-close {
    top: 0.85rem;
    right: 0.85rem;
    font-size: 0.85rem;
    padding: 0.25rem;
    cursor: pointer;
}

.notification .js-cart-notification-item {
    padding-bottom: 0.9rem;
    border-bottom: 1px solid var(--lu-linea);
}

.notification .notification-img img {
    display: block;
    width: 100%;
    height: auto;
}

.notification .js-cart-notification-item-variant-container {
    color: var(--lu-gris);
}

/* "Total (2 productos): $ 219.500" */
.notification .h5 {
    font-size: 0.66rem;
    font-weight: 400;
    color: var(--lu-tinta);
    margin: 0.9rem 0 1rem !important;
}

.notification .h5 strong {
    font-weight: 700;
}

.notification .btn {
    margin: 0;
}

/* Movimiento: bajar y fundir, en vez de la rotacion 3D del base */
.notification-hidden {
    transform: translate3d(0, -0.5rem, 0);
    opacity: 0;
    transition-property: transform, opacity;
    transition-duration: 160ms;
    transition-timing-function: var(--lu-salida);
    pointer-events: none;
}

.notification-visible {
    transform: translate3d(0, 0, 0);
    opacity: 1;
    transition-property: transform, opacity;
    transition-duration: 220ms;
    transition-timing-function: var(--lu-entrada);
}

/*============================================================================
  #Cookies y aviso de compra
  notification.tpl: el banner de cookies (fijo al pie, .notification-fixed-
  bottom) y el "Segui aca tu ultima compra" (debajo de la cabecera). Los dos
  llegan con .notification-secondary, que el base pinta con un fondo apenas
  mas oscuro y texto al 80%. Aca: papel, regla maciza de 2px y micro — el
  mismo trato que el pie, que es lo que tienen al lado.
==============================================================================*/

.notification-secondary {
    padding: 0.9rem 0;
    background-color: var(--lu-papel);
    color: var(--lu-tinta);
    border: 0;
    border-top: 2px solid var(--lu-tinta);
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.62rem;
    line-height: 1.6;
    text-align: left;
}

.notification-secondary .text-foreground {
    color: var(--lu-tinta);
}

/* El texto va al ras: el base lo corre dos columnas (offset-md-2) */
.notification-secondary .offset-md-2 {
    margin-left: 0;
}

.notification-secondary .col-md-7 {
    flex: 1 1 auto;
    max-width: none;
}

.notification-secondary .text-center {
    text-align: left !important;
}

.notification-secondary .btn {
    padding: 0.6rem 1.25rem;
    font-size: 0.62rem;
}

/* El aviso de "segui tu compra" no es un boton macizo: es un renglon */
.js-notification-status-page .btn {
    border: 0;
    padding: 0;
    background: transparent;
    color: var(--lu-tinta);
    text-decoration: underline;
}

/*============================================================================
  #Hojas desde abajo
  Los modales que suben desde el pie de la pantalla: "Agregado al carrito"
  con recomendados (add_to_cart_recommendations) y la promo cruzada. La
  mecanica es del base; aca solo el papel, la regla y el rotulo.
==============================================================================*/

.modal-bottom-sheet {
    background-color: var(--lu-papel);
    border-top: 2px solid var(--lu-tinta);
    border-radius: 0;
}

.modal-bottom-sheet .modal-header {
    border-bottom: 0;
}

/*============================================================================
  #Servicios
  home_order_position_5 = informatives -> banner-services.tpl: hasta tres
  renglones de "envios", "cuotas", "compra segura" con un icono cada uno.
  El base los centra con el icono arriba. Aca son tres celdas de la misma
  grilla de 1px, icono a la izquierda, todo en micro. En mobile el base los
  pasa por Swiper de a uno, con sus puntitos: los puntitos pasan a cuadrados.
==============================================================================*/

.section-informative-banners {
    padding: 0;
    text-align: left;
    border-top: 1px solid var(--lu-linea);
    border-bottom: 1px solid var(--lu-linea);
}

.section-informative-banners > .container {
    max-width: none;
    padding: 0;
}

.section-informative-banners .row {
    margin: 0;
}

.js-informative-banners {
    width: 100%;
}

.service-item-container {
    padding: 0 !important;
}

/* Divisiones verticales entre celdas, recien cuando estan lado a lado */
@media (min-width: 768px) {
    .service-item-container + .service-item-container {
        border-left: 1px solid var(--lu-linea);
    }
}

.service-item {
    display: flex;
    flex-wrap: nowrap;
    align-items: flex-start;
    justify-content: flex-start;
    gap: 0.9rem;
    margin: 0;
    padding: clamp(1.25rem, 3vw, 2rem) clamp(1rem, 3vw, 2rem);
    text-align: left;
}

.service-item > [class*="col"] {
    flex: none;
    width: auto;
    max-width: none;
    padding: 0;
}

.service-item > .col {
    flex: 1 1 auto;
    min-width: 0;
}

.service-icon {
    display: block;
    width: 1.25rem;
    height: 1.25rem;
    margin: 0;
    fill: var(--lu-tinta);
}

.service-item .service-icon-big {
    font-size: inherit;
}

.service-item a {
    color: inherit;
    text-decoration: none;
}

.service-item a:hover .service-title {
    text-decoration: underline;
}

.service-title {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.72rem;
    line-height: 1.35;
    font-weight: 700;
    margin: 0 0 0.3rem;
    color: var(--lu-tinta);
}

.service-item p {
    font-family: var(--lu-micro);
    text-transform: none;
    letter-spacing: 0.02em;
    font-size: 0.72rem;
    line-height: 1.55;
    color: var(--lu-gris);
    margin: 0;
    max-width: 40ch;
}

.service-pagination {
    margin: 0 0 1rem;
    line-height: 0;
}

.service-pagination .swiper-pagination-bullet {
    width: 6px;
    height: 6px;
    margin: 0 4px;
    border-radius: 0;
    background-color: var(--lu-tinta);
    opacity: 0.25;
}

.service-pagination .swiper-pagination-bullet-active {
    opacity: 1;
}

@media (min-width: 768px) {
    .service-pagination {
        display: none;
    }
}

/*============================================================================
  #Modulos de imagen y texto
  home_order_position_3 = modules -> home-modules.tpl: hasta dos bloques de
  foto a un lado y texto al otro (la clienta elige el lado). Es la seccion
  de "quienes somos" o de una campana con texto largo. Comparte marcado con
  los banners de categoria (.textbanner), asi que hay que sacarle el chip
  micro que le pusimos al titulo de aquellos: aca el titulo es macro y el
  texto es parrafo.
==============================================================================*/

.section-home-modules {
    border-top: 1px solid var(--lu-linea);
}

.section-home-modules .textbanner {
    margin: 0;
}

/* stretch y no center (el tpl trae align-items-center): con las columnas
   de distinto alto, la mas baja dejaba ver el fondo de linea como un
   bloque gris. Las dos miden lo mismo; la foto se estira a llenar la suya
   y el texto se centra adentro de la suya. */
.section-home-modules .row {
    margin: 0;
    background-color: var(--lu-linea);
    gap: 1px;
    align-items: stretch;
}

.section-home-modules .col-md {
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 0;
    background-color: var(--lu-papel);
}

.section-home-modules .textbanner {
    flex: 1 1 auto;
    display: flex;
}

.section-home-modules .textbanner-image {
    flex: 1 1 auto;
    aspect-ratio: 4 / 5;
}

.module-with-text-link {
    display: block;
    color: inherit;
    text-decoration: none;
}

.section-home-modules .textbanner-text {
    position: relative;
    padding: clamp(2rem, 5vw, 4.5rem) clamp(1.25rem, 4vw, 4rem);
    text-align: left;
    color: var(--lu-tinta);
}

.section-home-modules .textbanner-title {
    font-family: var(--lu-macro);
    text-transform: uppercase;
    letter-spacing: 0.02em;
    font-size: clamp(1.75rem, 4vw, 3rem);
    line-height: 1.05;
    margin: 0 0 1.25rem;
    text-wrap: balance;
}

.section-home-modules .textbanner-paragraph {
    display: block;
    font-family: var(--lu-micro);
    text-transform: none;
    letter-spacing: 0.02em;
    font-size: 0.82rem;
    line-height: 1.7;
    color: var(--lu-gris);
    opacity: 1;
    overflow: visible;
    -webkit-line-clamp: unset;
    max-width: 48ch;
    margin: 0 0 1.75rem;
    text-wrap: pretty;
}

.section-home-modules .textbanner-text .btn {
    border-color: var(--lu-tinta);
    color: var(--lu-papel);
    background-color: var(--lu-tinta);
    padding: 0.85rem 1.5rem;
    font-size: 0.72rem;
    margin: 0;
}

.section-home-modules .textbanner-text .btn:hover {
    background-color: var(--lu-acento);
    border-color: var(--lu-acento);
    color: var(--lu-tinta);
}

/* Cuando la foto y el texto se apilan (mobile), el texto queda debajo de
   la foto sin importar el lado elegido en el panel. */
@media (max-width: 767px) {
    .section-home-modules .col-md.order-md-2 {
        order: 0;
    }
}

/*============================================================================
  #Bienvenida
  home_order_position_6 = welcome -> home-welcome-message.tpl: una frase
  de la marca y, si quiere, un parrafo. Es la unica seccion del home que es
  solo texto: se queda centrada a proposito — una pausa entre bloques de
  fotos — pero con la escala del sistema y sin el aire de 70px del base.
==============================================================================*/

.section-welcome-home {
    padding: clamp(3rem, 8vw, 6rem) 0;
    border-top: 1px solid var(--lu-linea);
    text-align: center;
}

.section-welcome-home .col-md-8 {
    flex: 0 0 100%;
    max-width: 100%;
    margin-left: 0;
}

.welcome-title {
    font-size: clamp(1.75rem, 4vw, 3rem);
    margin: 0 auto 1rem;
    max-width: 24ch;
}

.welcome-text {
    font-family: var(--lu-micro);
    text-transform: none;
    letter-spacing: 0.02em;
    font-size: 0.82rem;
    line-height: 1.7;
    color: var(--lu-gris);
    max-width: 52ch;
    margin: 0 auto;
    text-wrap: pretty;
}

/*============================================================================
  #Instagram
  home_order_position_4 = instafeed -> home-instafeed.tpl. La cuenta
  (131 mil seguidoras, verificada) es el activo mas grande de la marca, asi
  que la seccion no se esconde: el usuario en la macro, con la arroba, y las
  nueve fotos en la misma grilla de 1px que el catalogo. El base lo arma con
  col-4 flotantes: con gap de 1px tres tercios no entran y la tercera foto
  se caia — pasa a grid.
==============================================================================*/

.section-instafeed-home {
    padding-top: clamp(2rem, 5vw, 4rem);
    border-top: 1px solid var(--lu-linea);
}

.instafeed-title {
    display: inline-flex;
    flex-direction: column;
    align-items: center;
    gap: 0.75rem;
    color: var(--lu-tinta);
    text-decoration: none;
}

.instafeed-title svg {
    width: 1.1rem;
    height: 1.1rem;
    fill: var(--lu-tinta);
}

/* El usuario va en minusculas con la arroba: un handle en versales no es un
   handle. text-transform pisa el uppercase del h2 del sistema. */
.instafeed-user {
    display: block;
    margin: 0;
    line-height: 1;
    font-size: clamp(1.75rem, 4vw, 3rem);
    text-transform: none;
    letter-spacing: 0.01em;
}

.instafeed-user::before {
    content: "@";
}

.instafeed-title:hover .instafeed-user {
    text-decoration: underline;
    text-underline-offset: 0.12em;
    text-decoration-thickness: 1px;
}

.js-ig-fallback {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.66rem;
    color: var(--lu-gris);
}

.js-ig-fallback .btn-link {
    color: var(--lu-tinta);
    text-decoration: underline;
    padding: 0;
    border: 0;
}

#instagram-feed {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1px;
    background-color: var(--lu-linea);
    border-top: 1px solid var(--lu-linea);
    border-bottom: 1px solid var(--lu-linea);
    margin: clamp(1.5rem, 4vw, 3rem) 0 0;
}

#instagram-feed .col-4 {
    flex: none;
    width: auto;
    max-width: none;
    padding: 0;
    background-color: var(--lu-papel);
}

.instafeed-link .instafeed-img {
    transition-property: transform, opacity;
    transition-duration: 420ms, 200ms;
    transition-timing-function: var(--lu-entrada), ease;
}

.instafeed-link:hover .instafeed-img,
.instafeed-link:focus .instafeed-img {
    transform: none;
}

@media (hover: hover) and (pointer: fine) {
    .instafeed-link:hover .instafeed-img {
        transform: scale(1.04);
    }
}

/*============================================================================
  #Compra rapida
  quick_shop (apagado por defecto, la clienta lo prende desde el panel): el
  modal que abre "Agregar al carrito" desde la grilla para elegir talle.
  Solo la tipografia — el nombre llega con class h1 (la de Bootstrap, no el
  elemento) y el precio con h4 — y los bordes. La mecanica del modal
  (bottom-sheet en mobile, centrado en desktop) es del base y se respeta.
==============================================================================*/

.modal-quickshop,
.modal-quickshop .modal-body {
    background-color: var(--lu-papel);
}

.modal-quickshop .modal-body {
    padding: 1.25rem;
    text-align: left;
}

.modal-quickshop .js-item-name {
    font-family: var(--lu-macro);
    text-transform: uppercase;
    letter-spacing: 0.02em;
    font-size: clamp(1.5rem, 3vw, 2.25rem);
    line-height: 1.05;
    font-weight: 400;
    text-wrap: balance;
}

.modal-quickshop .js-price-display {
    font-family: var(--lu-micro);
    font-weight: 700;
    font-size: 1.1rem;
    letter-spacing: 0.02em;
}

.modal-quickshop .js-compare-price-display {
    font-family: var(--lu-micro);
    text-decoration: line-through;
    color: var(--lu-gris);
    font-size: 0.9rem;
    font-weight: 400;
    margin-right: 0.5rem;
}

.modal-quickshop .modal-footer {
    border-top: 1px solid var(--lu-linea);
    padding: 1rem 1.25rem;
}

/*============================================================================
  #Pagina del carrito
  templates/cart.tpl: el mismo renglon de producto que el panel
  (cart-item-ajax.tpl con cart_page = true) y los totales a la derecha. El
  base apila y centra; aca: lista arriba con sus divisiones de 1px, y abajo
  una fila con el envio a la izquierda y el resumen a la derecha, pegado
  mientras se recorre la lista (el base lo declara sticky sin top).
==============================================================================*/

#shoppingCartPage {
    padding-bottom: clamp(3rem, 6vw, 5rem);
}

.template-cart .js-ajax-cart-list {
    border-top: 1px solid var(--lu-linea);
}

/* El tpl pega mb-5 / mb-2 (con !important, son utilidades de Bootstrap) a
   cada renglon: sin esto quedaba la division de 1px y despues 3rem de nada. */
.template-cart .cart-item.mb-5,
.template-cart .cart-item.mb-2 {
    margin-bottom: 0 !important;
}

.template-cart .cart-item {
    padding: 1.25rem 0;
}

/* Dentro del renglon, el base reparte nombre / cantidad / subtotal en
   6 / 3 / 3 de doce a partir de 768. Se respeta; solo se alinea. */
.template-cart .cart-item h6.col-12 {
    font-size: 0.72rem;
}

.template-cart .cart-item-quantity .form-quantity {
    margin: 0 !important;
}

.template-cart .cart-item-subtotal {
    font-size: 0.84rem;
    margin: 0;
    text-align: right !important;
}

@media (min-width: 768px) {
    .template-cart .cart-item-quantity .row {
        justify-content: flex-start;
    }
}

/* Los totales: el base mete un .divider (que no tiene CSS propio en el
   base) y una fila de dos columnas. La regla es maciza porque abajo esta
   la cifra que decide la compra. */
.template-cart .cart-row .divider {
    height: 2px;
    background-color: var(--lu-tinta);
    margin: 0 0 clamp(1.5rem, 4vw, 2.5rem);
}

.template-cart #cart-sticky-summary {
    top: 4.5rem;
    padding: 0;
}

.template-cart #cart-sticky-summary > .row {
    margin: 0;
}

/* Hijo directo de la fila: el subtotal de adentro tambien lleva
   .col-md-auto y con la regla suelta se iba a un renglon propio. */
.template-cart #cart-sticky-summary > .row > .col-md-auto {
    padding: 0;
    width: 100%;
    max-width: 22rem;
    margin-left: auto;
}

@media (max-width: 767px) {
    .template-cart #cart-sticky-summary > .row > .col-md-auto {
        max-width: none;
    }
}

/* Subtotal y descuentos: una linea cada uno, cifra a la derecha */
.template-cart .cart-row .h5.row {
    justify-content: space-between !important;
    margin: 0 0 0.35rem;
}

.template-cart .cart-row .h5 .col,
.template-cart .cart-row .h5 .col-md-auto {
    flex: 0 0 auto;
    width: auto;
    max-width: none;
    padding: 0;
}

.template-cart .js-total-promotions {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.66rem;
    line-height: 1.6;
}

.template-cart .js-total-promotions .row {
    margin: 0;
    justify-content: space-between;
}

.template-cart .js-total-promotions .col {
    flex: 0 0 auto;
    width: auto;
    padding: 0;
}

/* TOTAL: rotulo arriba, cifra entera debajo — igual que en el panel */
.template-cart .js-cart-total-container {
    margin-top: 1.1rem;
    padding-top: 1.1rem;
    border-top: 1px solid var(--lu-linea);
}

.template-cart .js-cart-total-container .h2 {
    display: block;
    margin: 0;
}

.template-cart .js-cart-total-container .h2 > span {
    display: block;
    flex: none;
    max-width: none;
    width: auto;
    padding: 0;
    margin: 0;
    text-align: left !important;
}

.template-cart .js-cart-total-container .h2 > span:first-child {
    font-family: var(--lu-micro);
    font-size: 0.62rem;
    letter-spacing: var(--lu-track);
    color: var(--lu-gris);
    margin-bottom: 0.35rem;
}

.template-cart .js-cart-total {
    white-space: nowrap;
}

.template-cart .js-cart-total-container .installments,
.template-cart .js-cart-total-container [class*="installment"],
.template-cart .js-cart-total-container .text-accent {
    text-align: left !important;
}

.template-cart #go-to-checkout {
    margin: 1.25rem 0 0.75rem !important;
}

.template-cart .cart-row .btn-link {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.62rem;
    color: var(--lu-tinta);
    text-decoration: underline;
    border: 0;
    padding: 0.5rem 0;
}

/* Calculador de envio (columna izquierda): rotulos y campos del sistema */
.template-cart .js-shipping-calculator-container {
    padding: 0;
}

.template-cart .js-shipping-calculator-container .row {
    margin: 0;
}

/*============================================================================
  #Paginacion
  "Mostrar mas productos" (infinite scroll del base) y la version numerada.
==============================================================================*/

.js-load-more.btn {
    background-color: transparent;
    color: var(--lu-tinta);
    padding: 1rem 2.5rem;
}

.js-load-more.btn:hover {
    background-color: var(--lu-tinta);
    color: var(--lu-papel);
}

.category-body .font-big {
    font-family: var(--lu-micro);
    font-size: 0.72rem;
    letter-spacing: var(--lu-track);
}

/*============================================================================
  #Hero: el texto asoma
  Unica animacion de carga del theme, y solo en el hero: el bloque de texto
  sube medio centimetro y se funde, 700ms, despues de que la foto ya esta.
  backwards y no both: si la animacion no corre (pestana oculta, motor sin
  animaciones), el texto esta visible igual — el estado final es el normal.
  Swiper clona los slides para el loop; los clones la corren invisibles y
  no importa. Con prefers-reduced-motion se apaga (ver #Movimiento reducido).
==============================================================================*/

@keyframes lu-asomar {
    from {
        opacity: 0;
        transform: translate3d(-50%, 0.75rem, 0);
    }
}

.nube-slider-home .swiper-text {
    animation: lu-asomar 700ms var(--lu-entrada) 150ms backwards;
}

/*============================================================================
  #Movimiento
  Criterio: WWDC "Designing Fluid Interfaces". Se aplica la parte que sirve a
  esta marca — respuesta inmediata, caminos simetricos, propiedades que no
  disparan layout, y respeto por prefers-reduced-motion.

  Lo que NO se aplica, a proposito: materiales translucidos, backdrop-filter,
  sombras contextuales y esquinas redondeadas. Toda esa parte de la guia
  contradice la direccion del theme, que es brutalismo suizo — 90 grados, sin
  sombras y sin degradados. La fisica del movimiento es prestable; el material
  de iOS no.

  Y una limitacion honesta: los paneles los abre el store.js de Tiendanube con
  una clase, asi que esto son transiciones CSS. Una transicion no se puede
  agarrar y revertir a mitad de camino — para eso hacen falta resortes en JS,
  que es Etapa 2 y recien se puede probar con la tienda arriba.
==============================================================================*/

/* Curvas. Sin rebote a proposito: el rebote se justifica cuando el gesto trajo
   inercia — un flick, un arrastre — y aca todo se abre con un toque. */
:root {
    /* Entrada: frena al llegar */
    --lu-entrada: cubic-bezier(0.16, 0.84, 0.44, 1);
    /* Salida: la inversa, para que el camino de ida y el de vuelta sean el
       mismo recorrido en espejo */
    --lu-salida: cubic-bezier(0.56, 0, 0.84, 0.16);
    --lu-respuesta: 340ms;
    --lu-respuesta-salida: 260ms;
}

/*  Los paneles: transform en vez de left/right.
    El base los mueve con `left: -100% -> 0` y `transition: all`. Animar left
    en un elemento de alto completo obliga al navegador a recalcular layout y
    repintar en CADA frame; transform lo resuelve el compositor. Es el cambio
    que mas se nota en un telefono, y no toca ni una plantilla ni el store.js:
    el panel se ancla en su posicion final y se lo corre con transform.        */

.modal-left,
.modal-right {
    transition-property: transform;
    transition-duration: var(--lu-respuesta-salida);
    transition-timing-function: var(--lu-salida);
    will-change: transform;
}

.modal-left {
    left: 0;
    right: auto;
    transform: translate3d(-100%, 0, 0);
}

.modal-right {
    right: 0;
    left: auto;
    transform: translate3d(100%, 0, 0);
}

.modal-left.modal-show,
.modal-right.modal-show {
    transform: translate3d(0, 0, 0);
    transition-duration: var(--lu-respuesta);
    transition-timing-function: var(--lu-entrada);
}

/*============================================================================
  #Respuesta
  Lo primero de la guia: el estado se muestra al APRETAR, no al soltar. Un
  boton que solo reacciona en el hover no existe en un telefono, que es de
  donde viene el trafico de esta tienda.

  La forma de la respuesta es la del theme y no la de iOS: en vez de encoger
  el elemento, se lo invierte. Es el mismo idioma que ya usa el hover.
==============================================================================*/

.btn:active,
.chip:active,
.utilities-link:active,
.filter-link:active,
.lu-seccion-link:active,
.nav-list-link:active,
.cart-item-btn.btn:active,
.footer-menu-link:active,
.social-icon:active {
    background-color: var(--lu-tinta);
    color: var(--lu-papel);
    transition-duration: 0s;
}

.social-icon:active svg,
.cart-item-btn.btn:active svg {
    fill: var(--lu-papel);
}

/* Las transiciones de color son cortas: acompañan, no se hacen notar. */
.btn,
.chip,
.utilities-link,
.filter-link,
.lu-seccion-link,
.nav-list-link,
.social-icon,
.cart-item-btn.btn {
    transition-property: background-color, color, border-color;
    transition-duration: 120ms;
    transition-timing-function: var(--lu-entrada);
}

/*============================================================================
  #Grilla: la foto respira al pasar por encima
  Unico movimiento continuo del catalogo. Es transform puro — sin sombras ni
  degradados — y la celda ya tiene overflow:hidden, asi que la foto crece
  dentro de su division de 1px y no la pisa.
==============================================================================*/

/* transform Y opacity, no el shorthand: las fotos de la grilla llegan con
   lazyload y .fade-in (transition: opacity .2s en style-critical). El
   shorthand con transform solo la pisaba y la foto aparecia de golpe — y
   de paso rompia el fundido a la segunda foto (product_hover), que el
   base hace con opacity. */
.item-image img {
    transition-property: transform, opacity;
    transition-duration: 420ms, 200ms;
    transition-timing-function: var(--lu-entrada), ease;
}

/* Solo con mouse de verdad: en un telefono el hover se dispara al tocar y
   la foto quedaba agrandada (y con la segunda foto encima) hasta que se
   tocaba otra cosa. */
@media (hover: hover) and (pointer: fine) {
    .item-product:hover .item-image img {
        transform: scale(1.04);
    }
}

/* El nombre se subraya en vez de cambiar de color: el turquesa sobre papel da
   2.17:1 y no se lee. Ver la nota de contraste. */
.item-product:hover .item-name {
    text-decoration: underline;
    text-underline-offset: 0.2em;
}

/*============================================================================
  #Movimiento reducido
  No es "sin feedback": es el mismo estado sin desplazamiento. Los paneles
  aparecen con un fundido corto y el resto de los cambios de color se queda,
  porque ayudan a entender que paso.
==============================================================================*/

@media (prefers-reduced-motion: reduce) {
    .modal-left,
    .modal-right {
        transform: none;
        opacity: 0;
        pointer-events: none;
        transition-property: opacity;
        transition-duration: 160ms;
        will-change: auto;
    }

    .modal-left.modal-show,
    .modal-right.modal-show {
        transform: none;
        opacity: 1;
        pointer-events: auto;
        transition-duration: 160ms;
    }

    .item-image img,
    .item-product:hover .item-image img,
    .textbanner-image-background,
    .textbanner-link:hover .textbanner-image-background,
    .instafeed-link .instafeed-img,
    .instafeed-link:hover .instafeed-img {
        transition: none;
        transform: none;
    }

    .transition-soft,
    .transition-soft-slow,
    .bar-progress-active {
        transition-duration: 0.01ms;
    }

    /* El texto del hero aparece sin subir; la notificacion, sin desplazarse */
    .nube-slider-home .swiper-text {
        animation: none;
    }

    .notification-hidden,
    .notification-visible {
        transform: none;
        transition-property: opacity;
    }

    /* El parpadeo gris mientras carga una foto es movimiento continuo */
    .placeholder-fade {
        animation: none;
    }
}
