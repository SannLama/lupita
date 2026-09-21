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

    /* Desde el 2026-09-15: cuatro voces. Titulos y texto los elige la clienta
       en el panel (font_headings = Great Vibes, font_rest = Instrument Sans);
       subtitulos, rotulos y marca son fijos y se cargan con un <link> propio
       en layout.tpl y password.tpl — el panel solo carga las dos elegidas.
       Great Vibes reemplaza a Liza Pro y Bodoni Moda a Bigilla (que a su
       vez habia reemplazado a Caveat/Brown Sugar), las dos pagas: con
       licencia web, se cambian aca y en el @font-face, nada mas. */
    --lu-macro: {{ settings.font_headings }};
    --lu-texto: {{ settings.font_rest }};
    --lu-sub: "Bodoni Moda", serif;
    /* Rotulos: hasta el 2026-09-16 eran Roboto Mono, la maquina de escribir
       del brutalismo. Santiago pidio sacarla por la estetica romantica: pasan
       a la misma letra del texto, en versal espaciada. */
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
    font-family: var(--lu-texto);
}

/*============================================================================
  #Tipografia
==============================================================================*/

/* Macro: --lu-macro es Great Vibes desde el 2026-09-15 (antes Italiana, y
   antes Archivo Black). Es una script ligada: en MAYUSCULAS no se lee, y el
   tracking separa letras que tienen que tocarse — minuscula normal y
   letter-spacing 0. El interlineado se abre para que los adornos de un
   renglon no pisen el de abajo.

   Logotipo, menu de navegacion, buscador y el TOTAL del carrito NO usan
   --lu-macro: son identidad de marca o cifras, no titulos de contenido, y
   se fijaron en --lu-marca (Archivo Black) a proposito. Ver #Tokens. */
h1,
h2,
.lu-macro {
    font-family: var(--lu-macro);
    font-weight: 400;
    /* Great Vibes tiene un solo peso (ver mas abajo, .welcome-title): el
       navegador la "engordaba a mano" con font-weight 700 y quedaba rota.
       Un trazo fino del mismo color le suma cuerpo sin ese efecto (pedido
       de Santiago 2026-09-18: se perdia en la pagina). */
    -webkit-text-stroke: 0.7px currentColor;
    text-transform: none;
    letter-spacing: 0;
    line-height: 1.15;
    margin: 0;
    /* Un titulo de dos renglones parte parejo, no deja una palabra sola
       colgando en el segundo (visto con "[ Titulo a definir ]" en la
       Portada: el corchete de cierre quedaba solo en su linea). */
    text-wrap: balance;
}

h1,
.lu-macro {
    font-size: clamp(3rem, 10vw, 9rem);
}

/* La script tiene la x baja: a igual cuerpo que la serif se leia chica */
h2 {
    font-size: clamp(2.25rem, 5vw, 3.75rem);
}

/* Subtitulos: Bodoni Moda (en lugar de Bigilla). Ver #Subtitulos al final
   para el peso y las ligaduras/alternates que les dan el caracter. */
h3,
h4,
h5 {
    font-family: var(--lu-sub);
    font-weight: 400;
    text-transform: none;
    letter-spacing: 0;
    line-height: 1.15;
}

/* Micro: metadatos, precios, navegacion. Espaciado de maquina de escribir. */
.lu-micro,
.item-name,
.item-price,
.item-installments,
.item-price-compare,
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

/* Estados animados en turquesa con tinta, nunca negro (Santiago, 2026-09-15) */
.btn-default:hover,
.btn-secondary:hover {
    background-color: var(--lu-acento);
    border-color: var(--lu-acento);
    color: var(--lu-tinta);
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

/* Los corchetes que encabezaban las secciones se sacaron el 2026-09-16
   (estetica romantica, pedido de Santiago) */
.lu-seccion-titulo .lu-rotulo {
    white-space: nowrap;
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
    font-family: var(--lu-texto);
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
    font-weight: 400;
    text-transform: none;
    letter-spacing: 0;
    line-height: 1.15;
    font-size: clamp(2.5rem, 6.5vw, 5.25rem);
    color: inherit;
    margin: 0;
    text-wrap: balance;
}

.nube-slider-home .swiper-description,
.section-cover-home .swiper-description,
.section-capsule-home .swiper-description {
    font-family: var(--lu-sub);
    font-weight: 500;
    text-transform: none;
    letter-spacing: 0;
    font-size: clamp(1.25rem, 2.5vw, 1.75rem);
    line-height: 1.2;
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

/* Sin contador desde el 2026-09-15 (pedido de Santiago): el "01 / 04" de
   arriba a la derecha se saca. Se oculta la paginacion entera; las fotos se
   siguen pasando solas y con las flechas. Las reglas de arriba quedan por
   si vuelve. */
.nube-slider-home .swiper-pagination {
    display: none;
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

/* Galeria de campanas (home-campanas.tpl): las piezas con el titulo impreso
   van enteras, sin recorte, con divisiones de 1px como la grilla. */
.lu-campanas {
    padding-block: clamp(2rem, 5vw, 3.5rem) 0;
}

.lu-campanas-rotulo {
    display: block;
    margin-bottom: 1rem;
}

.lu-campanas-grilla {
    display: grid;
    grid-template-columns: 1fr;
    gap: 1px;
    background-color: var(--lu-linea);
    border-block: 1px solid var(--lu-linea);
}

@media (min-width: 768px) {
    .lu-campanas-grilla {
        grid-template-columns: repeat(3, 1fr);
    }
}

.lu-campana {
    margin: 0;
    background-color: var(--lu-papel);
    display: flex;
    align-items: center;
}

.lu-campana img {
    display: block;
    width: 100%;
    height: auto;
}

/* Los titulos de los dos videos (Portada y Capsula) van en el centro de la
   pieza, no abajo como en el hero (Santiago, 2026-09-15). Mas especifico que
   la regla compartida con el hero de #Hero. */
.section-cover-home .cover-image .swiper-text,
.section-capsule-home .capsule-media .swiper-text {
    top: 50%;
    bottom: auto;
    transform: translate(-50%, -50%);
}

/*============================================================================
  #Barra de aviso
  El renglon que corona la pagina, y el unico lugar donde el mejor dato de la
  marca — 20% en efectivo, 3 y 6 cuotas — esta antes que cualquier foto.

  Iba en negativo (papel sobre tinta) hasta el 2026-09-10: Santiago pidio sacar
  el negro. Queda como rotulo tecnico sobre papel, separado de la cabecera por
  una regla de 1px para que no se lean como un solo bloque.
==============================================================================*/

/* 2026-09-15: pasa a fondo turquesa (Santiago) con la letra en tinta, la
   unica combinacion del acento que contrasta (8.27:1). */
.section-advertising {
    background-color: var(--lu-acento);
    color: var(--lu-tinta);
    padding: 0.6rem 0;
    border-bottom: 1px solid var(--lu-acento);
    overflow: hidden;
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

/* Marquesina continua (2026-09-15; reemplaza al rotador que cambiaba de
   mensaje de golpe). Ver header-advertising.tpl: dos grupos iguales, el track
   corre -50% en loop lineal. min-width: 100vw en cada grupo evita el hueco
   cuando los mensajes no llenan la pantalla. Se frena al pasar el mouse para
   poder leer; con movimiento reducido queda quieta y recortada. */
.ad-marquee {
    overflow: hidden;
    white-space: nowrap;
}

.ad-marquee-track {
    display: flex;
    width: max-content;
    animation-name: lu-ad-marquee;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
}

.ad-marquee-grupo {
    display: flex;
    flex: 0 0 auto;
    min-width: 100vw;
    justify-content: space-around;
}

.ad-msg {
    padding-inline: 1.5rem;
    line-height: 1.3;
}

/* Separador entre mensajes: un punto de tinta, no el "—" que la clienta usa
   para cortar el texto en el panel. */
.ad-msg::after {
    content: "\2022";
    margin-left: 3rem;
}

.ad-marquee:hover .ad-marquee-track {
    animation-play-state: paused;
}

@keyframes lu-ad-marquee {
    to {
        transform: translateX(-50%);
    }
}

@media (prefers-reduced-motion: reduce) {
    .ad-marquee-track {
        animation: none;
    }
}

/*============================================================================
  #Cabecera
  El base la arma en tres columnas: hamburguesa / logo / utilidades. Se
  conserva esa estructura (es la de Zara) y se le cambia el peso: fondo papel,
  una regla de 2px al ras que la ancla a la grilla, y todo lo demas en micro.
==============================================================================*/

/* Lineas de marco en turquesa (Santiago, 2026-09-15). Son decorativas: no
   llevan informacion, asi que el 2.17:1 contra el papel no es un problema. */
.head-main {
    background-color: var(--lu-papel);
    border-bottom: 2px solid var(--lu-acento);
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

/* Logo "A!" de la marca (snipplets/svg/logo-lupita.tpl), en turquesa. Es un
   logotipo: la regla de contraste de texto no aplica (WCAG 1.4.3 exceptua
   logos). Alto fijo, ancho segun la proporcion del dibujo (~1.24:1). */
.lu-logo-marca {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding-block: 0.35rem;
    color: var(--lu-acento);
    line-height: 0;
    text-decoration: none;
}

.lu-logo-marca .lu-logo-svg {
    display: block;
    height: 2.1rem;
    width: auto;
}

@media (min-width: 768px) {
    .lu-logo-marca .lu-logo-svg {
        height: 2.75rem;
    }
}

.lu-logo-marca:hover {
    color: var(--lu-acento);
    opacity: 0.85;
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

/* Contador de la bolsa: hasta el 2026-09-16 iba entre corchetes; ahora es
   un circulito turquesa (ver #Contadores, al final de la hoja) */
.cart-widget-amount {
    font-family: var(--lu-micro);
    font-size: 0.62rem;
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

/* Hover en turquesa con la letra en tinta (8.27:1), no negro (Santiago,
   2026-09-15). Tinta y no papel encima: papel sobre turquesa da 2.17:1. */
.nav-primary .nav-list .nav-list-link:hover {
    background-color: var(--lu-acento);
    color: var(--lu-tinta);
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
    border-top: 2px solid var(--lu-acento);
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

/* La cruz azul que Chrome/Edge le agregan solos a input[type=search] al
   escribir (Santiago, 2026-09-15: "sacá la cruz azul"). Se borra con la
   tecla Escape o a mano; no hace falta un boton extra. */
.search-input::-webkit-search-cancel-button,
.search-input::-webkit-search-decoration {
    -webkit-appearance: none;
    appearance: none;
    display: none;
}

.search-input::-ms-clear {
    display: none;
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
    border-top: 2px solid var(--lu-acento);
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
    background-color: var(--lu-acento);
    border-color: var(--lu-acento);
    color: var(--lu-tinta);
}

/* Newsletter: el titulo es lo unico macro del pie. */
.newsletter h3 {
    font-size: clamp(1.35rem, 4vw, 2.25rem);
    margin: 0 0 0.5rem;
}

.newsletter p {
    font-family: var(--lu-texto);
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

/* Canal de difusion (reemplaza al newsletter): el mismo boton de tinta, ahora
   suelto, sin campo de mail al lado. */
.lu-canal .lu-canal-btn {
    display: inline-block;
    margin-top: 0.75rem;
    padding: 0.7rem 1.1rem;
    background-color: var(--lu-tinta);
    border: 0;
    border-radius: 0;
    color: var(--lu-papel);
    font-family: var(--lu-texto);
    font-weight: 600;
    font-size: 0.85rem;
    text-transform: none;
    letter-spacing: 0;
    text-decoration: none;
}

.lu-canal .lu-canal-btn:hover {
    background-color: var(--lu-acento);
    color: var(--lu-tinta);
}

/* Popup del canal de difusion (snipplets/popup-canal.tpl): velo de tinta,
   caja de papel con regla turquesa arriba, entra subiendo medio centimetro */
.lu-canal-popup {
    position: fixed;
    inset: 0;
    z-index: 1060;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 1rem;
    background-color: color-mix(in srgb, var(--lu-tinta) 45%, transparent);
    opacity: 0;
    transition: opacity 220ms var(--lu-entrada);
}

/* El "display: flex" de arriba le gana a la regla nativa del navegador para
   [hidden] (misma especificidad, pero esta hoja va despues): sin esto, los
   primeros 6 segundos de CUALQUIER pagina quedaban con una capa invisible
   tapando toda la pantalla, comiendose los clics. Encontrado probando el
   asesor en el navegador real, 2026-09-18 (nunca se habia clickeado esta
   ventana en vivo, solo capturas). */
.lu-canal-popup[hidden] {
    display: none;
}

.lu-canal-popup-visible {
    opacity: 1;
}

.lu-canal-popup-caja {
    position: relative;
    width: min(26rem, 100%);
    padding: clamp(1.5rem, 5vw, 2.25rem);
    border-top: 4px solid var(--lu-acento);
    background-color: var(--lu-papel);
    color: var(--lu-tinta);
    text-align: left;
    transform: translateY(0.5rem);
    transition: transform 220ms var(--lu-entrada);
}

.lu-canal-popup-visible .lu-canal-popup-caja {
    transform: none;
}

.lu-canal-popup-cerrar {
    position: absolute;
    top: 0.5rem;
    right: 0.5rem;
    width: 2.5rem;
    height: 2.5rem;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 0;
    background: transparent;
    color: var(--lu-tinta);
    cursor: pointer;
}

.lu-canal-popup-cerrar svg {
    width: 0.9rem;
    height: 0.9rem;
    fill: currentColor;
}

.lu-canal-popup-cerrar:hover {
    background-color: var(--lu-acento);
}

.lu-canal-popup-red {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    font-family: var(--lu-micro);
    font-size: 0.66rem;
    letter-spacing: var(--lu-track);
    text-transform: uppercase;
}

.lu-canal-popup-red svg {
    width: 1rem;
    height: 1rem;
    fill: currentColor;
}

.lu-canal-popup-titulo {
    margin: 0.75rem 0 0.5rem;
    font-family: var(--lu-macro);
    font-size: clamp(2rem, 7vw, 2.6rem);
    line-height: 1.1;
}

.lu-canal-popup-texto {
    margin: 0 0 1.25rem;
    font-family: var(--lu-texto);
    font-size: 0.95rem;
    line-height: 1.6;
}

.lu-canal-popup .lu-canal-popup-btn {
    display: block;
    width: 100%;
    margin: 0;
    padding: 0.85rem 1rem;
    border: 0;
    border-radius: 0;
    background-color: var(--lu-tinta);
    color: var(--lu-papel);
    font-family: var(--lu-texto);
    font-weight: 600;
    font-size: 0.95rem;
    text-align: center;
    text-decoration: none;
}

.lu-canal-popup .lu-canal-popup-btn:hover {
    background-color: var(--lu-acento);
    color: var(--lu-tinta);
}

.lu-canal-popup-despues {
    display: block;
    margin: 0.75rem auto 0;
    padding: 0.35rem 0.5rem;
    border: 0;
    background: transparent;
    color: var(--lu-tinta);
    font-family: var(--lu-texto);
    font-size: 0.85rem;
    text-decoration: underline;
    text-underline-offset: 3px;
    cursor: pointer;
}

@media (prefers-reduced-motion: reduce) {
    .lu-canal-popup,
    .lu-canal-popup-caja {
        transition: none;
    }
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
    font-family: var(--lu-sub);
    font-weight: 500;
    font-size: clamp(1.2rem, 2.2vw, 1.5rem);
    line-height: 1.3;
    letter-spacing: 0;
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

  Desde el 2026-09-15 (pedido de Santiago): sin el chip de tinta. La palabra
  va centrada sobre la foto, en la tipografia de titulo (Great Vibes) y en
  papel. Como el home-banners.tpl del base no trae selector de color de
  texto por foto, un velo plano de tinta al 22% sobre la imagen asegura que
  se lea aunque la foto sea clara ahi — plano, sin degradado ni sombra.
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

/* Centrado como lo arma el base (top/left 50% + translate), sin el chip:
   la palabra flota en el medio de la foto, en papel. */
.textbanner-text.over-image {
    position: absolute;
    top: 50%;
    left: 50%;
    right: auto;
    bottom: auto;
    z-index: 1;
    width: 100%;
    padding: 0 1rem;
    transform: translate(-50%, -50%);
    background-color: transparent;
    color: var(--lu-papel);
    text-align: center;
}

/* Velo plano para que el papel se lea sobre cualquier foto */
.section-banners-home .textbanner-image::after {
    content: "";
    position: absolute;
    inset: 0;
    background-color: color-mix(in srgb, var(--lu-tinta) 22%, transparent);
    pointer-events: none;
    transition: opacity 320ms var(--lu-entrada);
}

/* Al pasar el mouse el velo se va y la foto queda limpia (pedido de
   Santiago, 2026-09-16). Solo con mouse, por lo mismo que la escala. */
@media (hover: hover) and (pointer: fine) {
    .section-banners-home .textbanner-link:hover .textbanner-image::after {
        opacity: 0;
    }
}

.section-banners-home .textbanner-title {
    font-family: var(--lu-macro);
    font-weight: 400;
    text-transform: none;
    letter-spacing: 0;
    font-size: clamp(2.5rem, 5vw, 4.25rem);
    line-height: 1.1;
    color: var(--lu-papel);
}

.section-banners-home .textbanner-text .btn {
    margin-top: 0.75rem;
}

.textbanner-title {
    font-family: var(--lu-micro);
    font-size: 0.72rem;
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    margin: 0;
}

.textbanner-paragraph {
    font-family: var(--lu-sub);
    font-weight: 500;
    font-size: 1.1rem;
    line-height: 1.2;
    text-transform: none;
    letter-spacing: 0;
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
    background-color: var(--lu-acento);
    color: var(--lu-tinta);
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
    background-color: var(--lu-acento);
    border-color: var(--lu-acento);
    color: var(--lu-tinta);
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
    background-color: var(--lu-acento);
    color: var(--lu-tinta);
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

/* Quitar (2026-09-15): el tacho era gris y de 1em y no se encontraba. Pasa a
   tinta, mas grande y con area de toque de 2.5rem; en la pagina del carrito
   lleva la palabra "Quitar". Hover en turquesa con tinta, no negro. */
.cart-item-delete .btn.lu-quitar {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.35rem;
    min-width: 2.5rem;
    min-height: 2.5rem;
    border: 0;
    padding: 0.35rem;
    background-color: transparent;
    color: var(--lu-tinta);
}

.cart-item-delete .btn.lu-quitar svg {
    width: 1.1rem;
    height: 1.1rem;
    fill: currentColor;
}

.cart-item-delete .btn.lu-quitar:hover {
    background-color: var(--lu-acento);
    color: var(--lu-tinta);
}

.lu-quitar-texto {
    display: none;
    font-size: 0.8rem;
    text-decoration: underline;
    text-underline-offset: 3px;
}

/* Solo en la pagina, desde 768: ahi la columna tiene lugar para la palabra */
@media (min-width: 768px) {
    .template-cart .cart-item-delete {
        flex: 0 0 auto;
        max-width: none;
        width: auto;
    }

    .template-cart .lu-quitar-texto {
        display: inline;
    }
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
    border-top: 2px solid var(--lu-acento);
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
    font-family: var(--lu-texto);
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

/* Caveat tiene la x chica: a 1.15rem un subtitulo se leia como nota al pie */
.user-content h3,
.user-content h4 {
    font-size: 1.6rem;
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
    font-family: var(--lu-texto);
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
    /* Circulo del color de la marca con el icono en tinta (8,27:1), pedido
       de Santiago 2026-09-15. Antes: cuadrado de tinta con icono en papel. */
    background-color: var(--lu-acento);
    color: var(--lu-tinta);
    border: 0;
    border-radius: 50%;
    box-shadow: none;
    transition-property: background-color;
    transition-duration: 120ms;
    transition-timing-function: var(--lu-entrada);
}

.btn-whatsapp svg {
    width: 1.35rem;
    height: 1.35rem;
    padding: 0;
    fill: var(--lu-tinta);
    /* Centrado optico (pedido de Santiago, 2026-09-16): la caja del icono ya
       estaba al centro exacto del circulo, pero la colita del globo tira el
       peso hacia abajo a la izquierda. Se corre un poco al reves. */
    transform: translate(0.08em, -0.08em);
}

/* Al pasar el mouse crece un poco y sigue turquesa con el icono en tinta:
   no se oscurece (pedido de Santiago, 2026-09-15). Solo transform. */
.btn-whatsapp {
    transition: transform 180ms var(--lu-entrada);
}

.btn-whatsapp:hover,
.btn-whatsapp:active {
    background-color: var(--lu-acento);
    transform: scale(1.12);
}

.btn-whatsapp:hover svg,
.btn-whatsapp:active svg {
    fill: var(--lu-tinta);
}

@media (prefers-reduced-motion: reduce) {
    .btn-whatsapp:hover,
    .btn-whatsapp:active {
        transform: none;
    }
}

/* Sobre turquesa el foco en papel no se ve (2,17:1): va en tinta, afuera */
.btn-whatsapp:focus-visible {
    outline-color: var(--lu-tinta);
    outline-offset: 2px;
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
  #Guia de asesoramiento
  Segundo boton flotante, apilado arriba del de WhatsApp (snipplets/asesor.tpl).
  Mismo circulo, colores invertidos (tinta de fondo, icono en papel) para que
  no compita con el turquesa, que queda reservado al de WhatsApp.
==============================================================================*/

.btn-asesor {
    position: fixed;
    bottom: 4.75rem;
    right: 1rem;
    z-index: 100;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 3rem;
    height: 3rem;
    background-color: var(--lu-tinta);
    color: var(--lu-papel);
    border: 0;
    border-radius: 50%;
    box-shadow: none;
    cursor: pointer;
    transition: transform 180ms var(--lu-entrada);
}

.btn-asesor svg {
    width: 1.25rem;
    height: 1.25rem;
    fill: var(--lu-papel);
}

.btn-asesor:hover,
.btn-asesor:active {
    background-color: var(--lu-acento);
    transform: scale(1.12);
}

.btn-asesor:hover svg,
.btn-asesor:active svg {
    fill: var(--lu-tinta);
}

.btn-asesor:focus-visible {
    outline-color: var(--lu-tinta);
    outline-offset: 2px;
}

@media (prefers-reduced-motion: reduce) {
    .btn-asesor:hover,
    .btn-asesor:active {
        transform: none;
    }
}

@media (max-width: 767px) {
    .btn-asesor {
        bottom: 4.1rem;
        right: 0.75rem;
        width: 2.75rem;
        height: 2.75rem;
    }
}

/* Ventana del mini-quiz: mismo tratamiento que el popup del canal (velo de
   tinta, caja de papel con regla turquesa arriba, entra subiendo). */
.lu-asesor-popup {
    position: fixed;
    inset: 0;
    z-index: 1060;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 1rem;
    background-color: color-mix(in srgb, var(--lu-tinta) 45%, transparent);
    opacity: 0;
    transition: opacity 220ms var(--lu-entrada);
}

/* El "display: flex" de arriba le gana a la regla nativa del navegador para
   [hidden] (misma especificidad, pero esta hoja va despues): sin esto, el
   popup "cerrado" quedaba como una capa invisible tapando toda la pantalla y
   comiendose los clics (encontrado probando el flujo real, 2026-09-18). */
.lu-asesor-popup[hidden] {
    display: none;
}

.lu-asesor-popup-visible {
    opacity: 1;
}

.lu-asesor-caja {
    position: relative;
    width: min(24rem, 100%);
    padding: clamp(1.5rem, 5vw, 2.25rem);
    border-top: 4px solid var(--lu-acento);
    background-color: var(--lu-papel);
    color: var(--lu-tinta);
    text-align: left;
    transform: translateY(0.5rem);
    transition: transform 220ms var(--lu-entrada);
}

.lu-asesor-popup-visible .lu-asesor-caja {
    transform: none;
}

.lu-asesor-cerrar {
    position: absolute;
    top: 0.5rem;
    right: 0.5rem;
    width: 2.5rem;
    height: 2.5rem;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 0;
    background: transparent;
    color: var(--lu-tinta);
    cursor: pointer;
}

.lu-asesor-cerrar svg {
    width: 0.9rem;
    height: 0.9rem;
    fill: currentColor;
}

.lu-asesor-cerrar:hover {
    background-color: var(--lu-acento);
}

.lu-asesor-etiqueta {
    display: inline-block;
    font-family: var(--lu-micro);
    font-size: 0.66rem;
    letter-spacing: var(--lu-track);
    text-transform: uppercase;
}

.lu-asesor-titulo {
    margin: 0.5rem 0 1rem;
    font-family: var(--lu-texto);
    font-weight: 600;
    font-size: 1.1rem;
    line-height: 1.4;
}

.lu-asesor-opciones {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
}

.lu-asesor-opcion {
    padding: 0.5rem 1rem;
    background-color: transparent;
    color: var(--lu-tinta);
    border: 1px solid var(--lu-tinta);
    border-radius: var(--lu-radio-pildora);
    font-family: var(--lu-texto);
    font-size: 0.9rem;
    cursor: pointer;
    transition: background-color 140ms var(--lu-entrada), color 140ms var(--lu-entrada);
}

.lu-asesor-opcion:hover {
    background-color: var(--lu-acento);
    border-color: var(--lu-acento);
}

.lu-asesor-volver {
    display: inline-block;
    margin: 0 0 1rem;
    padding: 0;
    border: 0;
    background: transparent;
    color: var(--lu-tinta);
    font-family: var(--lu-texto);
    font-size: 0.85rem;
    text-decoration: underline;
    text-underline-offset: 3px;
    cursor: pointer;
}

/* Paso 3 del asesor: medidas para calcular el talle */
.lu-asesor-medidas {
    display: flex;
    flex-wrap: wrap;
    gap: 0.75rem;
    margin-bottom: 1rem;
}

.lu-asesor-campo {
    flex: 1 1 6rem;
    font-family: var(--lu-micro);
    font-size: 0.62rem;
    letter-spacing: var(--lu-track);
    text-transform: uppercase;
    color: var(--lu-tinta);
}

.lu-asesor-campo .form-control {
    display: block;
    width: 100%;
    margin-top: 0.35rem;
    padding: 0.5rem 0.6rem;
    border: 1px solid var(--lu-tinta);
    background-color: var(--lu-papel);
    color: var(--lu-tinta);
    font-family: var(--lu-texto);
    font-size: 0.95rem;
    text-transform: none;
    letter-spacing: 0;
}

.lu-asesor-calcular {
    display: block;
    width: 100%;
    margin: 0;
    padding: 0.85rem 1rem;
    border: 0;
    border-radius: 0;
    background-color: var(--lu-tinta);
    color: var(--lu-papel);
    font-family: var(--lu-texto);
    font-weight: 600;
    font-size: 0.95rem;
    text-align: center;
    cursor: pointer;
}

.lu-asesor-calcular:hover {
    background-color: var(--lu-acento);
    color: var(--lu-tinta);
}

.lu-asesor-resultado {
    margin: 1rem 0 0;
    font-family: var(--lu-texto);
    font-size: 0.9rem;
    line-height: 1.5;
}

@media (prefers-reduced-motion: reduce) {
    .lu-asesor-popup,
    .lu-asesor-caja {
        transition: none;
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
    border-top: 2px solid var(--lu-acento);
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
    border-top: 2px solid var(--lu-acento);
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

/* Aire afuera (2026-09-15, pedido de Santiago): entre los destacados y los
   banners de categorias la franja quedaba pegada a las dos grillas. */
.section-informative-banners {
    padding: 0;
    margin-block: clamp(2.5rem, 6vw, 5rem);
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
    padding: clamp(1.75rem, 4vw, 2.75rem) clamp(1.25rem, 3.5vw, 2.5rem);
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
    font-family: var(--lu-texto);
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
    font-weight: 400;
    text-transform: none;
    letter-spacing: 0;
    font-size: clamp(2.25rem, 5vw, 3.75rem);
    line-height: 1.15;
    margin: 0 0 1.25rem;
    text-wrap: balance;
}

.section-home-modules .textbanner-paragraph {
    display: block;
    font-family: var(--lu-texto); /* parrafo largo: texto, no subtitulo */
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

/* 2026-09-15 (Santiago): sin la caja negra. Queda como link subrayado en
   tinta; al pasar el mouse, fondo turquesa con tinta (reglas de abajo). */
.section-home-modules .textbanner-text .btn {
    border-color: transparent;
    color: var(--lu-tinta);
    background-color: transparent;
    text-decoration: underline;
    text-underline-offset: 4px;
    display: inline-block;
    padding: 0.5rem 0;
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

/* style-critical le pone text-transform: uppercase a .welcome-title, y con
   Great Vibes eso era ilegible ("ROPA DE MUJER, AL SUR DE LA CIUDAD" en
   versales script). Tambien el h2 del base trae font-weight 700 y Great
   Vibes tiene un solo peso: el navegador la engordaba a mano. */
.welcome-title {
    font-size: clamp(2.5rem, 6vw, 4.5rem);
    font-weight: 400;
    text-transform: none;
    letter-spacing: 0;
    line-height: 1.15;
    margin: 0 auto 1.25rem;
    max-width: 22ch;
}

.welcome-text {
    font-family: var(--lu-texto);
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
  home-instafeed.tpl. La cuenta (131 mil seguidoras, verificada) es el
  activo mas grande de la marca. El base arma el feed con col-4 flotantes:
  con gap tres tercios no entran y la tercera foto se caia — pasa a grid.
==============================================================================*/

.section-instafeed-home {
    padding-top: clamp(2rem, 5vw, 4rem);
    border-top: 1px solid var(--lu-linea);
}

/* El logo de Instagram baja a la linea del usuario, a su izquierda, y crece
   (pedido de Santiago, 2026-09-15). flex-wrap: el aviso de respaldo del base
   (.js-ig-fallback) sigue yendo en su propio renglon. */
.instafeed-title {
    display: inline-flex;
    flex-direction: row;
    flex-wrap: wrap;
    justify-content: center;
    align-items: center;
    gap: 0.6rem;
    color: var(--lu-tinta);
    text-decoration: none;
}

.instafeed-title > svg {
    width: 1.9rem;
    height: 1.9rem;
    fill: var(--lu-tinta);
}

.instafeed-title .js-ig-fallback {
    flex-basis: 100%;
}

/* Instagram y TikTok en la misma fila (2026-09-15); en celular se apilan
   solos si no entran. */
.lu-redes-fila {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    align-items: center;
    gap: 1rem 2.5rem;
}

.lu-redes-fila .instafeed-title {
    color: var(--lu-tinta);
    text-decoration: none;
}

.instafeed-user-fila {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
}

/* El usuario como se escribe en Instagram (pedido de Santiago, 2026-09-15):
   @usuario en la tipografia del sistema operativo — la que usa la app —, en
   negrita y en minusculas, con el tilde azul de verificada al lado. Es la
   unica pieza del theme que no usa las fuentes de Lupita: tiene que
   reconocerse como un handle de Instagram. */
.instafeed-user {
    display: block;
    margin: 0;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    font-weight: 700;
    font-size: clamp(1.1rem, 2.2vw, 1.5rem);
    line-height: 1.1;
    letter-spacing: -0.01em;
    text-transform: none;
    color: #000000;
}

/* El h2 llega con .mt-2 de Bootstrap: en la misma linea que el logo lo
   desalineaba hacia abajo */
.instafeed-title .instafeed-user.mt-2 {
    margin-top: 0 !important;
}

.instafeed-user::before {
    content: "@";
}

.instafeed-verificada {
    flex: none;
    width: clamp(0.95rem, 1.8vw, 1.15rem);
    height: clamp(0.95rem, 1.8vw, 1.15rem);
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

@media (hover: hover) and (pointer: fine) {
    .instafeed-link:hover .instafeed-img {
        transform: scale(1.04);
    }
}

/*============================================================================
  #Conocer las tiendas (2026-09-15)
  snipplets/tiendas-link.tpl: lleva a la lista de Google Maps. Link subrayado
  en la voz del texto; en el pie, rotulo como el resto de la columna.
==============================================================================*/

.lu-tiendas-link {
    display: inline-block;
    font-family: var(--lu-texto);
    font-size: 0.9rem;
    font-weight: 600;
    color: var(--lu-tinta);
    text-decoration: underline;
    text-underline-offset: 0.2em;
}

.lu-tiendas-favs,
.lu-tiendas-pagos {
    margin-top: 0.75rem;
}

.lu-tiendas-favs::after,
.lu-tiendas-pagos::after {
    content: "\00a0→";
}

.lu-tiendas-pagos {
    margin-top: 1.25rem;
}

.lu-tiendas-pie {
    margin-top: 1rem;
    font-family: var(--lu-micro);
    font-size: 0.66rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
}

.lu-tiendas-sobre {
    margin-top: 0.25rem;
}

.lu-tiendas-sobre::after {
    content: "\00a0→";
}

/*============================================================================
  #Sobre nosotros (2026-09-15)
  snipplets/home/home-sobre-nosotros.tpl. Texto a la izquierda en las voces
  del sistema — titulo en Great Vibes, la frase del asesoramiento (la
  especialidad de la tienda) en Bodoni Moda, grande, con una regla turquesa
  decorativa al costado — y tres fotos a la derecha: la primera alta, las
  otras dos apiladas, con divisiones de 1px como el resto del theme.
==============================================================================*/

.lu-sobre {
    border-top: 1px solid var(--lu-linea);
    padding-block: clamp(3rem, 7vw, 6rem);
}

.lu-sobre-grilla {
    display: grid;
    grid-template-columns: 1fr;
    gap: clamp(2rem, 5vw, 4.5rem);
    align-items: center;
}

@media (min-width: 900px) {
    .lu-sobre-grilla {
        grid-template-columns: 5fr 7fr;
    }
}

.lu-sobre-solo-texto {
    grid-template-columns: 1fr !important;
    max-width: 46rem;
    margin-inline: auto;
    text-align: center;
}

.lu-sobre-titulo {
    margin: 0 0 1.5rem;
    font-family: var(--lu-macro);
    font-weight: 400;
    font-size: clamp(3rem, 7vw, 6rem);
    line-height: 1.05;
}

.lu-sobre-parrafo {
    max-width: 42ch;
    margin: 0 0 1.75rem;
    font-family: var(--lu-texto);
    font-size: 1rem;
    line-height: 1.7;
}

.lu-sobre-asesoramiento {
    max-width: 30ch;
    margin: 0 0 1.75rem;
    padding-left: 1rem;
    border-left: 3px solid var(--lu-acento);
    font-family: var(--lu-sub);
    font-feature-settings: "liga" 1, "dlig" 1, "hlig" 1, "ss01" 1;
    font-size: clamp(1.45rem, 2.4vw, 2rem);
    line-height: 1.25;
}

.lu-sobre-cierre {
    margin: 0 0 1rem;
    font-family: var(--lu-micro);
    font-size: 0.72rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
}

.lu-sobre-solo-texto .lu-sobre-parrafo,
.lu-sobre-solo-texto .lu-sobre-asesoramiento {
    margin-inline: auto;
}

.lu-sobre-solo-texto .lu-sobre-asesoramiento {
    padding-left: 0;
    border-left: 0;
}

.lu-sobre-fotos {
    display: grid;
    grid-template-columns: 1.25fr 1fr;
    grid-template-rows: 1fr 1fr;
    gap: 1px;
    background-color: var(--lu-linea);
    border: 1px solid var(--lu-linea);
}

.lu-sobre-foto {
    margin: 0;
    overflow: hidden;
    background-color: var(--lu-papel);
}

.lu-sobre-foto:first-child {
    grid-row: 1 / span 2;
}

.lu-sobre-foto img {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: cover;
}

/* Con una sola foto cargada, ocupa todo el bloque */
.lu-sobre-foto:only-child {
    grid-column: 1 / -1;
}

@media (max-width: 899px) {
    .lu-sobre-fotos {
        aspect-ratio: 4 / 3;
    }
}

/*============================================================================
  #Preguntas frecuentes (2026-09-15)
  snipplets/preguntas-frecuentes.tpl. Titulo en Great Vibes como "Sobre
  nosotros"; la lista son renglones de 1px (el mismo corte que el pie y el
  carrito). La pregunta en Bodoni Moda y un "+" que gira a "×" al abrir.
  El boton de arrepentimiento cierra la pagina chico, en rotulo gris.
==============================================================================*/

.lu-faq {
    border-top: 1px solid var(--lu-linea);
    padding-block: clamp(3rem, 7vw, 6rem);
}

.lu-faq-caja {
    max-width: 46rem;
    margin-inline: auto;
}

.lu-faq-titulo {
    margin: 0 0 clamp(1.75rem, 4vw, 3rem);
    font-family: var(--lu-macro);
    font-weight: 400;
    font-size: clamp(3rem, 7vw, 6rem);
    line-height: 1.05;
    text-align: center;
}

.lu-faq-lista {
    border-top: 1px solid var(--lu-linea);
}

.lu-faq-item {
    border-bottom: 1px solid var(--lu-linea);
}

.lu-faq-pregunta {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 1.5rem;
    padding-block: 1.35rem;
    cursor: pointer;
    list-style: none;
    font-family: var(--lu-sub);
    font-feature-settings: "liga" 1, "dlig" 1, "hlig" 1, "ss01" 1;
    font-size: clamp(1.2rem, 2.2vw, 1.55rem);
    line-height: 1.25;
    color: var(--lu-tinta);
}

.lu-faq-pregunta::-webkit-details-marker {
    display: none;
}

.lu-faq-pregunta::after {
    content: "+";
    flex: 0 0 auto;
    font-family: var(--lu-texto);
    font-size: 1.6rem;
    font-weight: 300;
    line-height: 1;
    transition: transform 0.25s ease;
}

.lu-faq-item[open] > .lu-faq-pregunta::after {
    transform: rotate(45deg);
}

.lu-faq-pregunta:focus-visible {
    outline: 2px solid var(--lu-tinta);
    outline-offset: 4px;
}

.lu-faq-respuesta {
    padding-bottom: 1.5rem;
    max-width: 62ch;
}

.lu-faq-respuesta p {
    margin: 0 0 1rem;
    font-family: var(--lu-texto);
    font-size: 1rem;
    line-height: 1.7;
}

.lu-faq-respuesta p:last-child {
    margin-bottom: 0;
}

/* Tiendas dentro de una respuesta: renglones con la regla turquesa de
   "Sobre nosotros" al costado; el horario cierra en rotulo. */
.lu-faq-tiendas {
    margin: 0 0 1rem;
    padding-left: 1rem;
    border-left: 3px solid var(--lu-acento);
}

.lu-faq-tienda {
    font-family: var(--lu-texto);
    font-size: 1rem;
    line-height: 1.7;
}

.lu-faq-tienda.lu-tienda-horario {
    margin-top: 0.4rem;
    font-family: var(--lu-micro);
    font-size: 0.72rem;
    letter-spacing: var(--lu-track);
    text-transform: uppercase;
}

.lu-faq-tiendas:last-child {
    margin-bottom: 0;
}

/*  Paginas "Medios de pago" y "Como comprar" (snipplets/pagina-lupita.tpl):
    mismo titulo que preguntas frecuentes. Los pasos: numero grande en
    Bodoni Moda a la izquierda, renglones de 1px como la lista de preguntas. */
.lu-pagina {
    border-top: 1px solid var(--lu-linea);
    padding-block: clamp(3rem, 7vw, 6rem);
}

.lu-pagina-titulo {
    margin: 0 0 clamp(1.75rem, 4vw, 3rem);
    font-family: var(--lu-macro);
    font-weight: 400;
    font-size: clamp(3rem, 7vw, 6rem);
    line-height: 1.05;
    text-align: center;
}

/* El bloque de pagos trae su propio margen y el rotulo "Medios de pago":
   debajo de un titulo con ese mismo nombre, el rotulo sobra. */
.lu-pagina-pagos .lu-pagos-grande {
    margin-top: 0;
    padding-top: 0;
    border-top: 0;
}

.lu-pagina-pagos .lu-pagos-rotulo {
    display: none;
}

.lu-pasos {
    max-width: 46rem;
    margin: 0 auto;
    padding: 0;
    border-top: 1px solid var(--lu-linea);
}

.lu-paso {
    display: grid;
    grid-template-columns: 3.25rem 1fr;
    gap: 1rem;
    align-items: baseline;
    padding-block: 1.5rem;
    border-bottom: 1px solid var(--lu-linea);
}

.lu-paso-numero {
    font-family: var(--lu-sub);
    font-feature-settings: "liga" 1, "dlig" 1, "hlig" 1, "ss01" 1;
    font-size: clamp(2rem, 4vw, 2.75rem);
    line-height: 1;
    color: var(--lu-tinta);
}

.lu-paso-titulo {
    margin: 0 0 0.4rem;
    font-family: var(--lu-sub);
    font-feature-settings: "liga" 1, "dlig" 1, "hlig" 1, "ss01" 1;
    font-weight: 500;
    font-size: clamp(1.2rem, 2.2vw, 1.55rem);
    line-height: 1.25;
    text-transform: none;
    letter-spacing: 0;
}

.lu-paso-texto {
    margin: 0;
    font-family: var(--lu-texto);
    font-size: 1rem;
    line-height: 1.7;
}

.lu-pagina-extra {
    max-width: 46rem;
    margin: 2.5rem auto 0;
}

.lu-faq-extra {
    margin-top: 2.5rem;
}

.lu-faq-arrepentimiento {
    margin: clamp(3rem, 7vw, 5rem) 0 0;
    text-align: center;
}

/* El link chico: el del final de preguntas frecuentes y el del pie */
.lu-arrepentimiento-link,
footer .lu-arrepentimiento-link {
    font-family: var(--lu-micro);
    font-size: 0.65rem;
    font-weight: 400;
    letter-spacing: var(--lu-track);
    text-transform: uppercase;
    color: var(--lu-gris, #6B6B66);
    text-decoration: underline;
    text-underline-offset: 3px;
}

.lu-arrepentimiento-link:hover {
    color: var(--lu-tinta);
}

/* En el pie, a la medida del copyright (0.58rem): ni un punto mas grande.
   "ingresá acá" (defensa del consumidor) llegaba en el azul del navegador. */
footer .lu-arrepentimiento-link,
footer .lu-reclamo-link {
    font-size: 0.58rem;
    color: var(--lu-gris);
    text-decoration: underline;
    text-underline-offset: 3px;
}

@media (prefers-reduced-motion: reduce) {
    .lu-faq-pregunta::after {
        transition: none;
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

/*============================================================================
  #Variantes y catalogo (2026-09-15)
  Talles y colores (snipplets/product/product-variants.tpl, con
  bullet_variants: botones .btn-variant), muestras de color en la grilla
  (item-colors.tpl, product_color_variants) y carrusel de fotos por prenda
  (component product-item-image con product_item_slider). Hasta aca salian
  con el estilo del base: bordes redondeados grises, elegido casi igual al
  resto. El harness no lo mostraba porque la ficha usaba botones inventados.

  store.js pone .selected en la opcion elegida y .btn-variant-no-stock en la
  que no tiene stock para la combinacion actual. Elegido = turquesa con tinta
  (la unica combinacion del acento que contrasta).
==============================================================================*/

.btn-variant {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 2.75rem;
    min-height: 2.75rem;
    margin: 0 0.4rem 0.4rem 0;
    padding: 0;
    border: 1px solid var(--lu-linea);
    border-radius: 0;
    background-color: var(--lu-papel);
    color: var(--lu-tinta);
    font-family: var(--lu-texto);
    font-size: 0.85rem;
    line-height: 1;
    vertical-align: top;
}

.btn-variant .btn-variant-content {
    min-width: 0;
    min-height: 0;
    margin: 0.7rem 0.85rem;
    line-height: 1;
}

.btn-variant:hover {
    border-color: var(--lu-tinta);
    color: var(--lu-tinta);
}

.btn-variant.selected {
    background-color: var(--lu-acento);
    border-color: var(--lu-acento);
    color: var(--lu-tinta);
}

/* Color: la muestra ocupa el boton; el borde gris #eee viene inline del tpl */
.btn-variant.btn-variant-color {
    padding: 3px;
    background-color: var(--lu-papel);
}

.btn-variant.btn-variant-color .btn-variant-content {
    width: 2.1rem;
    height: 2.1rem;
    margin: 0;
    border: 1px solid var(--lu-linea) !important;
}

.btn-variant.btn-variant-color.selected {
    background-color: var(--lu-papel);
    border: 2px solid var(--lu-acento);
    padding: 2px;
}

/* Sin stock para la combinacion: gris y cruzado por una diagonal de tinta */
.btn-variant.btn-variant-no-stock {
    position: relative;
    overflow: hidden;
    color: var(--lu-gris);
    background-color: var(--lu-papel);
}

.btn-variant.btn-variant-no-stock::after {
    content: "";
    position: absolute;
    inset: 0;
    z-index: 2;
    background: linear-gradient(to top left, transparent calc(50% - 0.5px), var(--lu-gris) calc(50% - 0.5px), var(--lu-gris) calc(50% + 0.5px), transparent calc(50% + 0.5px));
}

.btn-variant.btn-variant-no-stock.selected {
    background-color: var(--lu-papel);
    border-color: var(--lu-tinta);
    color: var(--lu-tinta);
}

.js-product-variants .form-label {
    margin-bottom: 0.6rem !important;
}

/* Muestras de color en la grilla: franja de papel al pie de la foto */
.item-colors {
    left: 0;
    bottom: 0;
    padding: 0.4rem 0.5rem;
    background: color-mix(in srgb, var(--lu-papel) 90%, transparent);
    text-align: left;
    line-height: 0;
}

.item-colors .item-colors-bullet {
    display: inline-block;
    min-width: 0.9rem;
    width: 0.9rem;
    height: 0.9rem;
    margin: 0 0.3rem 0 0;
    border: 1px solid var(--lu-linea);
    border-radius: 0;
    opacity: 1;
    vertical-align: middle;
    cursor: pointer;
}

.item-colors .item-colors-bullet.selected,
.item-colors .item-colors-bullet:hover {
    outline: 1px solid var(--lu-tinta);
    outline-offset: 1px;
}

/* "3 colores" / "+2": texto, no muestra */
.item-colors a.item-colors-bullet,
.item-colors .item-colors-bullet-text {
    width: auto;
    height: auto;
    border: 0;
    background: transparent !important;
    color: var(--lu-tinta) !important;
    font-family: var(--lu-micro);
    font-size: 0.62rem;
    letter-spacing: var(--lu-track);
    line-height: 0.9rem;
    text-decoration: none;
    outline: 0;
}

/* Carrusel de fotos por prenda (secciones y busqueda) */
.item-image .swiper-container {
    top: 0;
    left: 0;
}

.item-slider-controls-container {
    width: 2.25rem;
    height: 2.25rem;
    margin-top: -1.125rem;
    background-color: var(--lu-papel);
    border: 1px solid var(--lu-linea);
    color: var(--lu-tinta);
    display: flex;
    align-items: center;
    justify-content: center;
}

.item-slider-controls-container::after {
    display: none;
}

.item-slider-controls-container:hover {
    background-color: var(--lu-acento);
    border-color: var(--lu-acento);
}

.item-slider-controls-container svg {
    display: block;
    width: 0.5rem;
    height: 0.9rem;
    margin: auto;
    fill: currentColor;
}

/* .d-md-block (Bootstrap, !important) le ganaba al flex y la flecha quedaba
   pegada arriba a la izquierda del cuadrado */
@media (min-width: 768px) {
    .item-slider-controls-container.d-md-block {
        display: flex !important;
    }
}

/* Contador "1 / 3" (solo celular): abajo a la derecha, sobre la franja de
   colores. Arriba chocaba con el corazon (derecha) y con OFERTA/NUEVO
   (izquierda); la franja deja libre ese rincon. */
.item-slider-pagination {
    left: auto;
    right: 0.5rem;
    top: auto;
    bottom: 0.35rem;
    z-index: 10;
    width: auto;
    padding: 0.2rem 0.4rem;
    background-color: var(--lu-papel);
    color: var(--lu-tinta);
    font-family: var(--lu-micro);
    font-size: 0.6rem;
    letter-spacing: var(--lu-track);
}

.item-more-images-message {
    font-family: var(--lu-micro);
    font-size: 0.62rem;
    letter-spacing: var(--lu-track);
    text-transform: uppercase;
    color: var(--lu-tinta);
}

/* Compra rapida desde la grilla: el disparador es un link subrayado, no un
   segundo boton macizo debajo de cada prenda */
.item-actions .btn.btn-primary {
    width: auto;
    padding: 0.35rem 0;
    border-color: transparent;
    background-color: transparent;
    color: var(--lu-tinta);
    font-family: var(--lu-texto);
    font-size: 0.8rem;
    text-decoration: underline;
    text-underline-offset: 3px;
}

.item-actions .btn.btn-primary:hover {
    background-color: var(--lu-acento);
    border-color: var(--lu-acento);
    color: var(--lu-tinta);
    padding-inline: 0.4rem;
}

/*============================================================================
  #Funciones de la ficha y del home (2026-09-15)
  Lo que el base todavia mostraba con su estilo de fabrica: productos
  relacionados (component products-section en product-related.tpl), aviso de
  ultima unidad (product-quantity.tpl, .lu-ultimo), guia de talles (link +
  #size-guide-modal), calculador de envio en la ficha
  (.product-shipping-calculator) y popup del home (#home-modal). Solo forma y
  color: la posicion y la mecanica son del base y de store.js.
==============================================================================*/

/* Relacionados / complementarios: seccion con regla y titulo macro al ras */
.section-products-related {
    margin: 0 !important;
    padding-block: clamp(2.5rem, 6vw, 4.5rem);
    border-top: 1px solid var(--lu-linea);
}

.section-products-related .h3 {
    margin: 0 0 clamp(1.25rem, 3vw, 2rem);
    font-family: var(--lu-macro);
    font-weight: 400;
    font-size: clamp(2.25rem, 5vw, 3.5rem);
    line-height: 1.1;
    text-align: left !important;
    text-transform: none;
    letter-spacing: 0;
}

.section-products-related .swiper-button-prev,
.section-products-related .swiper-button-next {
    width: 2.5rem;
    height: 2.5rem;
    margin-top: 0;
    border: 1px solid var(--lu-tinta);
    border-radius: 0;
    background-color: var(--lu-papel);
    color: var(--lu-tinta);
    display: flex;
    align-items: center;
    justify-content: center;
}

.section-products-related .swiper-button-prev::after,
.section-products-related .swiper-button-next::after {
    display: none;
}

.section-products-related .swiper-button-prev svg,
.section-products-related .swiper-button-next svg {
    width: 0.55rem;
    height: 1rem;
    fill: currentColor;
}

.section-products-related .swiper-button-prev:hover,
.section-products-related .swiper-button-next:hover {
    background-color: var(--lu-acento);
    border-color: var(--lu-acento);
}

.section-products-related .swiper-button-disabled {
    opacity: 0.3;
}

.section-products-related .swiper-pagination-bullet {
    width: 0.45rem;
    height: 0.45rem;
    margin: 0 0.2rem;
    border-radius: 0;
    background-color: var(--lu-tinta);
    opacity: 0.25;
}

.section-products-related .swiper-pagination-bullet-active {
    background-color: var(--lu-acento);
    opacity: 1;
}

/* Ultima unidad: rotulo en turquesa con tinta, no una linea de texto suelta */
.lu-ultimo {
    display: inline-block;
    margin: 0.5rem 0 1rem !important;
    padding: 0.4rem 0.65rem;
    background-color: var(--lu-acento);
    color: var(--lu-tinta) !important;
    font-family: var(--lu-micro);
    font-size: 0.66rem !important;
    font-weight: 700;
    letter-spacing: var(--lu-track);
    text-transform: uppercase;
    line-height: 1.3;
}

/* Guia de talles: link en la voz del texto con la regla en tinta */
a[data-toggle="#size-guide-modal"] {
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    font-family: var(--lu-texto);
    font-size: 0.85rem;
    color: var(--lu-tinta);
    text-decoration: underline;
    text-underline-offset: 3px;
    cursor: pointer;
}

a[data-toggle="#size-guide-modal"] svg {
    fill: currentColor;
    margin-right: 0 !important;
}

/* Ventanas centradas (guia de talles, pais de entrega, popup): papel, 1px,
   sin sombra ni redondeo, con el mismo encabezado que los paneles */
#size-guide-modal,
#home-modal,
.modal-centered-small {
    border: 1px solid var(--lu-tinta);
    border-radius: 0;
    box-shadow: none;
    background-color: var(--lu-papel);
}

#size-guide-modal .modal-body {
    padding: clamp(1rem, 3vw, 1.75rem);
}

#size-guide-modal .user-content table {
    width: 100%;
}

/* Calculador de envio en la ficha: rotulo, campo y resultados en renglones */
.product-shipping-calculator {
    margin-top: 1.5rem;
    padding-top: 1.25rem;
    border-top: 1px solid var(--lu-linea);
}

.product-shipping-calculator .shipping-calculator-form .col-12.mb-2 {
    display: flex;
    align-items: center;
    font-family: var(--lu-micro);
    font-size: 0.66rem;
    letter-spacing: var(--lu-track);
    text-transform: uppercase;
    color: var(--lu-tinta);
}

.product-shipping-calculator .shipping-calculator-form svg {
    fill: currentColor;
}

/* El base reparte col-5 (campo) / col-6 (boton): en 390 el campo cortaba
   "Tu código postal". Mitad y mitad, y en computadora vuelve al reparto base. */
.product-shipping-calculator .shipping-calculator-form .col-5 {
    flex: 0 0 58%;
    max-width: 58%;
}

.product-shipping-calculator .shipping-calculator-form .col-6 {
    flex: 0 0 42%;
    max-width: 42%;
}

.product-shipping-calculator .js-calculate-shipping {
    padding: 0.7rem 0.5rem;
    font-family: var(--lu-texto);
    font-size: 0.85rem;
    text-transform: none;
    letter-spacing: 0;
}

.product-shipping-calculator .font-small.text-primary,
.shipping-calculator-form a.font-small {
    font-family: var(--lu-texto);
    font-size: 0.8rem;
    color: var(--lu-tinta) !important;
    text-decoration: underline;
    text-underline-offset: 3px;
}

.product-shipping-calculator .list-readonly .list-item {
    padding-block: 0.75rem;
    border-bottom: 1px solid var(--lu-linea);
    font-family: var(--lu-texto);
    font-size: 0.85rem;
}

.shipping-spinner-container .spinner-ellipsis .point {
    border-radius: 0;
    background-color: var(--lu-acento);
}

/* Popup del home: imagen a sangre, frase macro, suscripcion como el pie */
#home-modal {
    max-width: min(26rem, calc(100vw - 2rem));
}

#home-modal .modal-body {
    padding: 0 0 1.25rem;
}

#home-modal .modal-img-full {
    display: block;
    width: 100%;
    height: auto;
}

#home-modal h3 {
    padding-inline: 1.25rem;
    font-family: var(--lu-macro);
    font-weight: 400;
    font-size: clamp(1.9rem, 6vw, 2.5rem);
    line-height: 1.15;
    text-transform: none;
    letter-spacing: 0;
    color: var(--lu-tinta);
}

#home-modal .newsletter {
    padding-inline: 1.25rem;
}

#home-modal .modal-header {
    position: absolute;
    top: 0;
    right: 0;
    z-index: 3;
    border: 0;
    background-color: var(--lu-papel);
    padding: 0.6rem;
}

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
    font-weight: 400;
    text-transform: none;
    letter-spacing: 0;
    font-size: clamp(2rem, 4vw, 2.75rem);
    line-height: 1.15;
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
    background-color: var(--lu-acento);
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
    background-color: var(--lu-acento);
    border-color: var(--lu-acento);
    color: var(--lu-tinta);
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
    background-color: var(--lu-acento);
    color: var(--lu-tinta);
    transition-duration: 0s;
}

.social-icon:active svg,
.cart-item-btn.btn:active svg {
    fill: var(--lu-tinta);
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

    .section-banners-home .textbanner-image::after {
        transition: none;
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

/*============================================================================
  #404
  La cifra es el cartel: Italiana a escala de hero, al ras de la izquierda.
  El decrypt (lupita-motion) cambia el texto, nunca el tamaño: tabular-nums
  para que los caracteres al azar no muevan la caja.
==============================================================================*/

.lu-404 {
    padding-top: clamp(2rem, 6vw, 5rem);
    padding-bottom: clamp(3rem, 6vw, 5rem);
}

.lu-404-cifra {
    font-family: var(--lu-macro);
    font-weight: 400;
    font-size: clamp(7rem, 42vw, 26rem);
    line-height: 0.85;
    letter-spacing: -0.02em;
    font-variant-numeric: tabular-nums;
    white-space: nowrap;
    margin: 0.5rem 0 1.5rem;
}

.lu-404-texto {
    font-size: 0.9rem;
    max-width: 32rem;
    margin: 0 0 2rem;
}

.lu-404-buscar {
    position: relative;
    max-width: 32rem;
}

/* El .btn del sistema trae borde y padding: la lupa del buscador es un icono
   sobre la regla, no un boton con caja */
.lu-404-buscar .search-input-submit {
    border: 0;
    background: none;
    padding: 0.25rem;
}

.lu-404-sugeridos {
    border-top: 1px solid var(--lu-linea);
    margin-top: clamp(3rem, 6vw, 5rem);
    padding-top: 1.5rem;
    padding-bottom: 1rem;
}

/*============================================================================
  #Busqueda
  El termino buscado es el titulo. Sin resultados se tacha en tinta (no en
  turquesa: es texto) y abajo queda el riel de secciones para seguir.
==============================================================================*/

.lu-busqueda-header .lu-rotulo {
    display: block;
    margin-bottom: 0.75rem;
}

.lu-busqueda-termino {
    overflow-wrap: anywhere;
}

.lu-tachado {
    text-decoration: line-through;
    text-decoration-thickness: 0.06em;
}

.lu-busqueda-vacia {
    font-size: 0.9rem;
    margin: 0 0 2.5rem;
}

.lu-busqueda-seguir {
    display: block;
    margin-bottom: 0.75rem;
}

/*============================================================================
  #Contacto
  Dos columnas desde 768: lo que carga el panel a la izquierda, el formulario
  a la derecha, separados por la linea de 1px. Nada escrito a mano.
==============================================================================*/

.lu-contacto {
    row-gap: 2rem;
}

.lu-contacto-datos .contact-info {
    text-align: left !important; /* .text-center del base en contact-links.tpl */
    margin: 0;
}

.lu-contacto-datos .contact-item {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    padding: 0.9rem 0;
    margin: 0;
    border-top: 1px solid var(--lu-linea);
    font-size: 0.8rem;
}

.lu-contacto-datos .contact-item:last-child {
    border-bottom: 1px solid var(--lu-linea);
}

.lu-contacto-datos .contact-item svg {
    margin: 0 !important;
    flex: 0 0 auto;
}

.lu-contacto-datos .contact-link {
    color: var(--lu-tinta);
    overflow-wrap: anywhere;
}

.lu-contacto-intro {
    font-size: 0.9rem;
    line-height: 1.7;
    margin: 0 0 1.5rem;
}

.lu-contacto-producto {
    display: flex;
    gap: 1rem;
    align-items: center;
    border: 1px solid var(--lu-linea);
    padding: 0.75rem;
    margin-bottom: 1.5rem;
    font-size: 0.8rem;
}

.lu-contacto-producto img {
    width: 4rem;
    height: auto;
}

.lu-contacto-producto p {
    margin: 0;
}

.lu-contacto-form .alert {
    margin-bottom: 1.5rem;
}

@media (min-width: 768px) {
    .lu-contacto-form {
        border-left: 1px solid var(--lu-linea);
        padding-left: clamp(1.5rem, 4vw, 3rem);
    }
}

/*============================================================================
  #Tienda cerrada (password.tpl)
  El unico lugar donde el turquesa es el fondo de toda la pantalla: tinta
  encima da 8.27:1. El campo es una caja de papel; el foco es el borde de
  tinta de 2px de #Formularios (sobre turquesa, turquesa no se veria).
==============================================================================*/

.template-password {
    background-color: var(--lu-acento);
    color: var(--lu-tinta);
}

.lu-cerrado {
    min-height: 100vh;
    min-height: 100svh;
    display: flex;
    align-items: center;
    padding-block: clamp(3rem, 8vw, 6rem);
}

.lu-cerrado .container {
    width: 100%;
}

.lu-cerrado-logo .logo-text {
    font-family: var(--lu-marca);
    font-size: clamp(2.5rem, 12vw, 7rem);
    line-height: 0.9;
    text-transform: uppercase;
    color: var(--lu-tinta);
}

.lu-cerrado-mensaje {
    font-family: var(--lu-sub);
    font-weight: 500;
    font-size: clamp(2rem, 5vw, 3.5rem);
    line-height: 1.1;
    max-width: 18ch;
    margin: 1.5rem 0 2.5rem;
}

.lu-cerrado-form {
    max-width: 26rem;
}

.lu-cerrado .form-label,
.lu-cerrado .btn-link {
    color: var(--lu-tinta);
}

.lu-cerrado .form-group .text-center,
.lu-cerrado-logo,
.lu-cerrado-logo .logo-text-container {
    text-align: left !important; /* el logo y el link de ayuda del base vienen centrados */
}

.lu-cerrado .form-group .mt-4 {
    margin-top: 1rem !important;
}

.lu-cerrado .alert {
    margin-top: 1rem;
}

/*============================================================================
  #Blog
  Lista editorial en vez de la grilla de 3. Todo apunta a las clases lu-post*
  que pasa blog.tpl: el HTML interno del componente no es nuestro.
  La primera nota va grande con su foto; las demas son filas de 1px. Con
  mouse (lupita-motion agrega .lu-preview-on) la foto de las filas se oculta
  y aparece flotando junto al cursor; sin JS o en tactil queda chica y fija.
==============================================================================*/

/* Sin regla propia arriba: la pone el encabezado de pagina (#Encabezado de
   pagina). Una .template-blog .page-header {border:0} pierde contra el
   body:not():not() de alla — 0,2,0 contra 0,3,1 — y quedaban dos lineas. */
.lu-blog {
    margin-bottom: clamp(2rem, 5vw, 4rem);
}

.lu-post {
    position: relative;
    display: grid;
    grid-template-columns: 5.5rem 1fr;
    column-gap: 1rem;
    align-items: start;
    padding: 1.25rem 0;
    border-bottom: 1px solid var(--lu-linea);
}

.lu-post > * {
    grid-column: 2;
}

.lu-post .lu-post-imagen {
    grid-column: 1;
    grid-row: 1 / span 3;
    position: relative;
    aspect-ratio: 3 / 4;
    height: auto; /* el base le fija 200px a la caja */
    overflow: hidden;
    margin: 0;
}

.lu-post .lu-post-img {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.lu-post-titulo,
.lu-post-titulo a {
    font-family: var(--lu-macro);
    font-weight: 400;
    font-size: clamp(1.4rem, 3.5vw, 2.5rem);
    line-height: 1.05;
    color: var(--lu-tinta);
    -webkit-line-clamp: 2;
    margin: 0 0 0.5rem;
}

.lu-post-resumen {
    font-size: 0.78rem;
    line-height: 1.6;
    color: var(--lu-gris);
    max-width: 60ch;
    margin: 0 0 0.75rem;
}

.lu-post-leer {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.66rem;
    color: var(--lu-tinta);
    text-decoration: underline;
}

.lu-post:first-child {
    grid-template-columns: 1fr;
    padding-top: clamp(1.25rem, 3vw, 2rem);
}

.lu-post:first-child > * {
    grid-column: 1;
}

.lu-post:first-child .lu-post-imagen {
    grid-row: auto;
    aspect-ratio: 16 / 9;
    margin-bottom: 1.25rem;
}

.lu-post:first-child .lu-post-titulo,
.lu-post:first-child .lu-post-titulo a {
    font-size: clamp(2rem, 4.5vw, 3.5rem);
}

@media (min-width: 768px) {
    .lu-post {
        grid-template-columns: 9rem 1fr;
        column-gap: 2rem;
        padding: 1.75rem 0;
    }

    .lu-post:first-child {
        grid-template-columns: 1.4fr 1fr;
        column-gap: 2.5rem;
        align-items: end;
    }

    .lu-post:first-child .lu-post-imagen {
        grid-column: 1;
        grid-row: 1 / span 3;
        margin-bottom: 0;
    }

    .lu-post:first-child > :not(.lu-post-imagen) {
        grid-column: 2;
    }
}

@media (hover: hover) and (pointer: fine) {
    .lu-preview-on .lu-post:not(:first-child) {
        grid-template-columns: 1fr;
    }

    .lu-preview-on .lu-post:not(:first-child) > * {
        grid-column: 1;
    }

    .lu-preview-on .lu-post:not(:first-child) .lu-post-imagen {
        display: none;
    }

    .lu-preview-on .lu-post:not(:first-child):hover .lu-post-titulo a {
        text-decoration: underline;
        text-decoration-thickness: 1px;
    }
}

/* La primera nota es el cartel: hasta 3 renglones de titulo (el base clampa
   a 3 y la fila a 2), y en desktop el texto se apila al pie de la foto en vez
   de repartirse a lo alto de ella */
.lu-post:first-child .lu-post-titulo {
    -webkit-line-clamp: 3;
}

@media (min-width: 768px) {
    .lu-post:first-child {
        grid-template-rows: 1fr auto auto;
    }

    .lu-post:first-child .lu-post-titulo {
        align-self: end;
    }
}

/* blog.tpl y blog-post.tpl meten page-header.tpl adentro de otro .container:
   sin esto las migas y el titulo quedan 15px mas adentro que el contenido */
.template-blog .page-header .container,
.template-blog-post .page-header .container {
    padding-left: 0;
    padding-right: 0;
}

.lu-preview {
    position: fixed;
    top: 0;
    left: 0;
    width: 16rem;
    aspect-ratio: 3 / 4;
    object-fit: cover;
    opacity: 0;
    pointer-events: none;
    z-index: 20;
    border: 1px solid var(--lu-tinta);
}

/*============================================================================
  #Nota del blog
  Columna de 680px (container-narrow del base). El cuerpo hereda
  .user-content (#Texto institucional). lupita-motion corta el titulo en
  palabras dentro de .lu-mascara y las sube desde abajo.
==============================================================================*/

.template-blog-post .page-header h1 {
    font-size: clamp(2.25rem, 7vw, 4.5rem);
    line-height: 1.02;
}

/* La mascara recorta la subida; el padding de abajo evita cortar los
   descendentes de la Italiana y el margen negativo lo devuelve */
.lu-mascara {
    display: inline-block;
    overflow: hidden;
    vertical-align: top;
    /* Great Vibes tira colas y adornos lejos de la caja: la mascara se abre
       arriba, abajo y a los costados y los margenes negativos lo devuelven */
    padding: 0.2em 0.15em 0.35em;
    margin: -0.2em -0.15em -0.35em;
}

.lu-mascara > span {
    display: inline-block;
}

.lu-nota-fecha {
    display: block;
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.66rem;
    color: var(--lu-gris);
    margin: 0 0 1.5rem;
}

.lu-nota-img {
    display: block;
    width: 100%;
    margin: 0 0 2rem;
}

.lu-nota-cuerpo {
    margin-bottom: clamp(3rem, 6vw, 5rem);
}

/*============================================================================
  #Carrito y menu en la voz del texto (2026-09-15)
  Pedido de Santiago: el panel y la pagina del carrito, y el menu
  hamburguesa, pasan a Instrument Sans (--lu-texto) en minuscula normal,
  TOTAL incluido. Antes eran rotulos (Roboto Mono en versales) y marca
  (Archivo Black). "body" delante de cada selector suma 0,0,1 de
  especificidad: le gana a las reglas de mas arriba sin !important.
==============================================================================*/

body #modal-cart .modal-header,
body .modal-nav-hamburger .modal-header,
body .nav-primary .nav-list .nav-list-link,
body .nav-primary .nav-list .list-subitems .nav-list-link,
body .nav-accounts-link,
body .cart-item h6,
body .cart-item .cart-item-name,
body .cart-item .cart-item-name small,
body .cart-item-subtotal,
body .cart-row .h6,
body .js-total-promotions,
body .ship-free-rest-message,
body .js-cart-total-container .h2,
body #modal-cart .js-cart-total-container .h2 > span:first-child,
body .js-cart-total-container .installments,
body #modal-cart .btn,
body .template-cart .cart-row .btn {
    font-family: var(--lu-texto);
    text-transform: none;
    letter-spacing: 0;
}

/* El buscador tambien (Santiago, 2026-09-15: "no cambiaste la tipografia del
   buscar"): el campo era Archivo Black en versales y las sugerencias rotulo.
   Mismo tamaño, voz del texto, minuscula. Cubre el panel y el de la 404. */
body .search-input,
body .search-input.form-control,
body #nav-search .modal-header,
body .search-suggest :is(a, span, div, li, p, strong) {
    font-family: var(--lu-texto);
    text-transform: none;
    letter-spacing: 0;
}

body .search-input,
body .search-input.form-control {
    font-weight: 500;
}

/* La lupa llegaba con el marco de .btn, un cuadrado mas alto que el renglon */
body .search-input-submit.btn {
    border: 0;
    background-color: transparent;
}

/* Los rubros del menu eran Archivo Black en versales: en Instrument Sans
   necesitan algo de peso para seguir leyendose como la entrada principal */
body .nav-primary .nav-list .nav-list-link {
    font-weight: 500;
    line-height: 1.15;
}

body .modal-nav-hamburger .modal-header,
body #modal-cart .modal-header {
    font-size: 0.9rem;
    font-weight: 600;
}

body .cart-item h6,
body .cart-item .cart-item-name {
    font-size: 0.88rem;
    line-height: 1.35;
}

body .cart-item .cart-item-name small {
    font-size: 0.75rem;
}

body #modal-cart .btn,
body .template-cart .cart-row .btn {
    font-weight: 600;
    font-size: 0.9rem;
}

/* "Todo el carrito": la lista de arriba se quedaba corta (subtotal,
   promociones, calculador de envio, Iniciar compra, Ver mas productos y el
   aviso de "agregamos tu producto" seguian en Roboto Mono versal). Esto
   cubre todo lo que vive adentro del panel, de la pagina (#shoppingCartPage,
   el titulo en Great Vibes queda afuera) y del aviso flotante. :is() de
   elementos + un id = 1,0,2: le gana a las reglas de rotulo de clase
   (.template-cart .cart-row .btn-link, 0,3,0) y a #go-to-checkout (1,0,0)
   sin !important. No toca color ni iconos. */
body #modal-cart :is(h1, h2, h3, h4, h5, h6, p, span, strong, small, a, div, label, input, button, li),
body #shoppingCartPage :is(h1, h2, h3, h4, h5, h6, p, span, strong, small, a, div, label, input, button, li),
body .notification-floating .notification :is(h1, h2, h3, h4, h5, h6, p, span, strong, small, a, div, label, input, button, li) {
    font-family: var(--lu-texto);
    text-transform: none;
    letter-spacing: 0;
}

/* El rotulo de "Total con tarjeta" venia a 0.62rem, pensado para versal */
body #modal-cart .js-cart-total-container .h2.lu-tarjeta > span:first-child,
body .template-cart .js-cart-total-container .h2.lu-tarjeta > span:first-child {
    font-size: 0.85rem;
    color: inherit;
}

/* En Instrument Sans minuscula, los subrubros y la cuenta a 0.66–0.7rem
   quedaban diminutos al lado de los rubros */
body .nav-primary .nav-list .list-subitems .nav-list-link {
    font-size: 0.95rem;
}

body .nav-accounts-link {
    font-size: 0.85rem;
}

/* Mismo problema en el carrito: subtotal, promociones, calculador de envio,
   avisos y "Ver mas productos" venian a 0.62–0.66rem para versal mono. En
   minuscula se leian como letra chica de contrato. */
/* El tamaño lo fijan los hijos (span/strong del renglon), no el .h5, y hay
   reglas de clase encima: se ancla en el id del panel y de la pagina. */
body #modal-cart .cart-row .h5 :is(span, strong),
body #modal-cart .js-total-promotions,
body #modal-cart .ship-free-rest-message,
body #shoppingCartPage .h5 :is(span, strong),
body #shoppingCartPage .js-total-promotions :is(span, div),
body #shoppingCartPage .form-label,
body #shoppingCartPage .alert,
body #shoppingCartPage .btn-link,
body #modal-cart .js-cart-total-container .h2.lu-tarjeta > span:first-child,
body #shoppingCartPage .js-cart-total-container .h2.lu-tarjeta > span:first-child {
    font-size: 0.85rem;
}

body #modal-cart .cart-row .h5 small,
body #shoppingCartPage .h5 small {
    font-size: 0.75rem;
}

/* #go-to-checkout fija 0.72rem con un id: se le gana con dos */
body #shoppingCartPage .btn:not(.btn-link),
body #shoppingCartPage #go-to-checkout {
    font-size: 0.9rem;
    font-weight: 600;
}

/*============================================================================
  #Tarjeta y efectivo (2026-09-15)
  Con "Descuento por medio de pago" prendido en el panel, el carrito muestra
  dos precios: el TOTAL (tarjeta) chico y apagado, y el precio en efectivo
  (component payment-discount-price, 20% off) grande y en el color de marca.
  ⚠️ Pedido explicito de Santiago, avisado: #6BB3B9 sobre papel da 2,17:1 y
  no llega ni al 3:1 de texto grande. Si hay quejas de lectura, pasar el
  numero a tinta sobre una franja turquesa (8,27:1).
==============================================================================*/

body .js-cart-total-container .h2.lu-tarjeta,
body #modal-cart .js-cart-total-container .h2.lu-tarjeta {
    font-size: 1rem;
    font-weight: 400;
    opacity: 0.6;
}

.lu-efectivo {
    margin-top: 0.5rem;
}

.lu-efectivo .lu-efectivo-precio {
    display: block;
    font-family: var(--lu-texto);
    font-weight: 700;
    font-size: clamp(1.9rem, 5vw, 2.6rem);
    line-height: 1.05;
    letter-spacing: -0.01em;
    color: var(--lu-acento);
}

.lu-efectivo .lu-efectivo-medio {
    font-family: var(--lu-texto);
    font-size: 0.85rem;
    color: var(--lu-tinta);
}

/* Lo mismo en la tarjeta de producto de la grilla (2026-09-16), a escala de
   una columna angosta: tarjeta chica y apagada, efectivo grande en turquesa,
   y abajo las 6 cuotas con el valor de cada una. */
.item-price-container.lu-tarjeta {
    opacity: 0.6;
}

.item-price-container.lu-tarjeta .lu-tarjeta-rotulo,
.item-price-container.lu-tarjeta .item-price,
.item-price-container.lu-tarjeta .price-compare,
.item-price-container.lu-tarjeta .item-price-compare {
    font-family: var(--lu-texto);
    font-size: 0.8rem;
    font-weight: 400;
    text-transform: none;
    letter-spacing: 0;
    /* esta adentro del <a> de la tarjeta: sin esto toma el azul del link */
    color: var(--lu-tinta);
}

.lu-efectivo.lu-efectivo-item {
    margin: 0.15rem 0 0;
}

.lu-efectivo.lu-efectivo-item .lu-efectivo-precio {
    font-size: clamp(1.15rem, 2.4vw, 1.5rem);
    white-space: nowrap;
}

.lu-efectivo.lu-efectivo-item .lu-efectivo-medio {
    font-size: 0.8rem;
}

.item-installments.lu-cuotas {
    font-family: var(--lu-texto);
    font-size: 0.78rem;
    letter-spacing: 0;
    text-transform: none;
    color: var(--lu-tinta);
    min-height: 0;
}

/*============================================================================
  #Subtitulos
  Bodoni Moda en su peso fino y con las ligaduras discrecionales, las
  historicas y el primer juego estilistico: sin eso es una didona correcta,
  con eso aparece algo del caracter raro que Santiago buscaba en Bigilla.
  Va al final para ganarle en orden a los pesos 500 que dejo Caveat.
==============================================================================*/

h3,
h4,
h5,
.user-content h3,
.user-content h4,
.nube-slider-home .swiper-description,
.section-cover-home .swiper-description,
.section-capsule-home .swiper-description,
.category-header .page-header-text,
.textbanner-paragraph,
.lu-cerrado-mensaje {
    font-weight: 400;
    font-feature-settings: "liga" 1, "dlig" 1, "hlig" 1, "ss01" 1;
}

/*============================================================================
  #Favoritos (2026-09-15)
  Wishlist propia para venir a probarse las prendas al local
  (lupita-favoritos.js.tpl). Corazon sin guardar: contorno en tinta sobre
  papel. Guardado: relleno en tinta sobre turquesa (8,27:1) — el turquesa
  nunca como color de un icono sobre papel. Todo nace hidden: si el
  navegador no deja guardar, no aparece nada.
==============================================================================*/

.lu-fav[hidden],
.js-favs-acceso[hidden],
.lu-fav-aviso[hidden],
.js-favs-whatsapp[hidden],
.js-favs-vacio[hidden] {
    display: none !important;
}

.lu-fav {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    flex: none;
    width: 2.5rem;
    height: 2.5rem;
    padding: 0;
    border: 1px solid var(--lu-tinta);
    background-color: var(--lu-papel);
    color: var(--lu-tinta);
    cursor: pointer;
    transition-property: background-color, transform;
    transition-duration: 150ms;
}

.lu-fav svg {
    width: 1.05rem;
    height: 1.05rem;
    fill: currentColor;
}

.lu-fav .lu-fav-lleno,
.lu-fav[aria-pressed="true"] .lu-fav-vacio {
    display: none;
}

.lu-fav[aria-pressed="true"] .lu-fav-lleno {
    display: block;
}

/* Guardado: corazon relleno BLANCO sobre turquesa (pedido de Santiago,
   2026-09-15; antes relleno en tinta). Blanco sobre turquesa queda por
   debajo del 3:1 de un icono, pero guardado/no guardado no depende solo del
   color: tambien cambia de contorno a relleno (y aria-pressed). */
.lu-fav[aria-pressed="true"] {
    background-color: var(--lu-acento);
    color: #FFFFFF;
}

.lu-fav:active {
    transform: scale(0.94);
}

.lu-fav:focus-visible {
    outline: 2px solid var(--lu-tinta);
    outline-offset: 2px;
}

/* Tarjeta: arriba a la derecha de la foto, la etiqueta queda a la izquierda */
.lu-fav-tarjeta {
    position: absolute;
    top: 0.6rem;
    right: 0.6rem;
    z-index: 2;
    width: 2.25rem;
    height: 2.25rem;
}

/* Ficha: el corazon pegado al boton de comprar, mismo alto */
.lu-comprar {
    display: flex;
    align-items: stretch;
    gap: 0.5rem;
    margin-bottom: 1.5rem;
}

.lu-comprar .btn-block {
    flex: 1 1 auto;
    width: auto;
    margin-bottom: 0 !important;
}

.lu-fav-ficha {
    width: 3.25rem;
    height: auto;
}

.lu-fav-ficha svg {
    width: 1.25rem;
    height: 1.25rem;
}

.lu-fav-rapida {
    margin: 0.5rem auto 1rem;
}

/* Cabecera: el mismo lenguaje que la bolsa, con el contador entre corchetes */
.lu-favs-link {
    color: var(--lu-tinta);
}

/* Alineacion de la cabecera: el corazon venia en inline-flex centrado y la
   bolsa del base en linea, con el icono corrido -0.2em y el contador como
   inline-block: uno se alineaba al centro y el otro a la linea de base, y
   quedaban a distinta altura. Todos los items y links de utilidades pasan a
   la misma caja flex centrada, con el icono sin corrimiento. */
.utilities-container,
.utilities-item,
.cart-summary {
    display: inline-flex;
    align-items: center;
}

.utilities-item[hidden] {
    display: none !important;
}

.utilities-link,
.cart-summary a {
    display: inline-flex;
    align-items: center;
    line-height: 1;
}

.utilities-link .icon-inline,
.cart-summary .icon-inline {
    display: block;
    vertical-align: 0;
    flex: none;
}

.cart-widget-amount,
.lu-favs-cantidad {
    display: inline-block;
    line-height: 1;
}

/* Con el corazon son tres utilidades: abajo de 768 la columna derecha (un
   tercio del ancho, 130px a 390) ya no entraba y empujaba el logotipo contra
   la lupa. Menos aire entre iconos y el contador sin corchetes, solo el
   numero pegado al icono. */
@media (max-width: 767px) {
    .utilities-container > .utilities-item + .utilities-item {
        margin-left: 0.55rem;
    }

}

.lu-favs-cantidad {
    font-family: var(--lu-micro);
    font-size: 0.62rem;
}

/* Panel */
#modal-favoritos,
#modal-favoritos .modal-body {
    background-color: var(--lu-papel);
}

#modal-favoritos .modal-header {
    font-family: var(--lu-texto);
    text-transform: none;
    letter-spacing: 0;
    font-size: 0.9rem;
    font-weight: 600;
}

.lu-favs-local {
    background-color: var(--lu-acento);
    color: var(--lu-tinta);
    padding: 1.25rem;
    margin: 0 0 0.5rem;
}

.lu-favs-titulo {
    font-family: var(--lu-sub);
    font-feature-settings: "liga" 1, "dlig" 1, "hlig" 1, "ss01" 1;
    font-size: 1.75rem;
    line-height: 1.1;
    margin: 0 0 0.35rem;
}

.lu-favs-direcciones {
    margin: 0;
    padding: 0;
}

.lu-favs-direccion {
    font-family: var(--lu-texto);
    font-size: 0.9rem;
    line-height: 1.5;
    margin: 0;
}

/* El horario cierra la lista de tiendas: un renglon aparte, en rotulo */
.lu-favs-direccion.lu-tienda-horario {
    margin-top: 0.35rem;
    font-family: var(--lu-micro);
    font-size: 0.72rem;
    letter-spacing: var(--lu-track);
    text-transform: uppercase;
}

/* La franja turquesa va a sangre; la lista y el vacio llevan el aire lateral
   del resto del panel (sin esto las fotos quedaban contra el borde) */
.lu-favs-lista {
    padding: 0 1.25rem;
    margin: 0;
}

.lu-favs-item {
    display: grid;
    grid-template-columns: 56px 1fr auto;
    align-items: start;
    gap: 0.85rem;
    padding: 1rem 0;
    border-bottom: 1px solid var(--lu-linea);
}

.lu-favs-foto img {
    display: block;
    width: 100%;
    aspect-ratio: 2 / 3;
    object-fit: cover;
}

.lu-favs-info {
    display: flex;
    flex-direction: column;
    gap: 0.2rem;
    font-family: var(--lu-texto);
}

.lu-favs-nombre {
    color: var(--lu-tinta);
    font-size: 0.9rem;
    line-height: 1.35;
}

.lu-favs-variante {
    color: var(--lu-gris);
    font-size: 0.8rem;
}

.lu-favs-precio {
    font-size: 0.85rem;
}

.lu-favs-quitar {
    border: 0;
    background: none;
    padding: 0.25rem 0.5rem;
    font-size: 1.3rem;
    line-height: 1;
    color: var(--lu-gris);
    cursor: pointer;
}

.lu-favs-quitar:hover {
    color: var(--lu-tinta);
}

.lu-favs-vacio {
    font-family: var(--lu-texto);
    font-size: 0.9rem;
    line-height: 1.6;
    color: var(--lu-gris);
    padding: 1rem 1.25rem;
    margin: 0;
}

#modal-favoritos .modal-footer {
    padding: 1rem 1.25rem;
}

.lu-favs-whatsapp {
    font-family: var(--lu-texto);
    text-transform: none;
    letter-spacing: 0;
    font-weight: 600;
    font-size: 0.9rem;
}

/* Aviso al guardar: tinta, abajo al centro, con el link en turquesa
   (turquesa sobre tinta = 8,27:1) */
.lu-fav-aviso {
    position: fixed;
    left: 50%;
    bottom: calc(1rem + env(safe-area-inset-bottom, 0px));
    z-index: 30;
    display: flex;
    align-items: center;
    gap: 1rem;
    max-width: calc(100vw - 2rem);
    padding: 0.85rem 1.1rem;
    background-color: var(--lu-tinta);
    color: var(--lu-papel);
    font-family: var(--lu-texto);
    font-size: 0.88rem;
    line-height: 1.35;
    opacity: 0;
    transform: translate(-50%, 0.75rem);
    transition-property: opacity, transform;
    transition-duration: 250ms;
    transition-timing-function: var(--lu-entrada);
}

.lu-fav-aviso-visible {
    opacity: 1;
    transform: translate(-50%, 0);
}

.lu-fav-aviso-link {
    color: var(--lu-acento);
    text-decoration: underline;
    white-space: nowrap;
}

@media (prefers-reduced-motion: reduce) {
    .lu-fav-aviso {
        transform: translate(-50%, 0);
        transition-property: opacity;
    }

    .lu-fav:active {
        transform: none;
    }
}

/*============================================================================
  #Medios de pago (2026-09-15)
  snipplets/medios-de-pago.tpl. Grande (seccion del home): tres celdas de
  1px con la cifra en la voz de subtitulo. Compacto (ficha y carrito): una
  lista de renglones. American Express siempre aparte, en franja turquesa
  con tinta encima (8,27:1). Los textos los maneja la clienta desde el panel.
==============================================================================*/

.lu-pagos-lista {
    margin: 0;
    padding: 0;
}

.lu-pagos-grande {
    border-top: 1px solid var(--lu-linea);
    padding-block: clamp(2.5rem, 6vw, 4.5rem);
}

.lu-pagos-rotulo {
    display: block;
    margin-bottom: 1.5rem;
}

.lu-pagos-grande .lu-pagos-lista {
    display: grid;
    grid-template-columns: 1fr;
    gap: 1px;
    background-color: var(--lu-linea);
    border-top: 1px solid var(--lu-linea);
    border-bottom: 1px solid var(--lu-linea);
}

@media (min-width: 768px) {
    .lu-pagos-grande .lu-pagos-lista {
        grid-template-columns: repeat(3, 1fr);
    }
}

.lu-pagos-grande .lu-pagos-item {
    display: flex;
    flex-direction: column;
    gap: 0.6rem;
    padding: clamp(1.25rem, 3vw, 2rem) clamp(1rem, 2.5vw, 1.75rem);
    background-color: var(--lu-papel);
}

.lu-pagos-grande .lu-pagos-cifra {
    font-family: var(--lu-sub);
    font-feature-settings: "liga" 1, "dlig" 1, "hlig" 1, "ss01" 1;
    font-size: clamp(2.25rem, 5vw, 3.5rem);
    line-height: 1;
}

.lu-pagos-grande .lu-pagos-texto {
    font-family: var(--lu-texto);
    font-size: 0.95rem;
    line-height: 1.5;
    max-width: 30ch;
}

.lu-pagos-amex {
    display: flex;
    flex-wrap: wrap;
    align-items: baseline;
    gap: 0.35rem 1rem;
    margin-top: 1px;
    padding: 1rem 1.25rem;
    background-color: var(--lu-acento);
    color: var(--lu-tinta);
    font-family: var(--lu-texto);
}

.lu-pagos-amex-rotulo {
    font-family: var(--lu-micro);
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.7rem;
}

.lu-pagos-amex-texto {
    font-size: 0.95rem;
    line-height: 1.45;
}

.lu-pagos-compacto {
    margin: 0 0 1.5rem;
    border-top: 1px solid var(--lu-linea);
    text-align: left;
}

.lu-pagos-compacto .lu-pagos-item {
    display: flex;
    align-items: baseline;
    gap: 0.6rem;
    padding: 0.6rem 0;
    border-bottom: 1px solid var(--lu-linea);
    font-family: var(--lu-texto);
    font-size: 0.85rem;
    line-height: 1.4;
}

.lu-pagos-compacto .lu-pagos-cifra {
    flex: none;
    font-weight: 700;
    white-space: nowrap;
}

.lu-pagos-compacto .lu-pagos-texto {
    color: var(--lu-gris);
}

.lu-pagos-compacto .lu-pagos-amex {
    margin-top: 0.6rem;
    padding: 0.7rem 0.85rem;
}

.lu-pagos-compacto .lu-pagos-amex-texto {
    font-size: 0.82rem;
}

/*============================================================================
  #Volver arriba (2026-09-15)
  Encima del boton de WhatsApp (3rem + 1rem de margen), mismo tamaño, en
  papel con borde de tinta para no confundirse con el. Invisible (y fuera
  del orden de tabulacion) hasta que se baja mas de una pantalla.
==============================================================================*/

.lu-arriba[hidden] {
    display: none !important;
}

.lu-arriba {
    position: fixed;
    right: 1rem;
    bottom: calc(4.5rem + env(safe-area-inset-bottom, 0px));
    z-index: 25;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 0.15rem;
    width: 3rem;
    height: 3rem;
    padding: 0;
    /* Solo la flecha, sin contorno ni caja (pedido de Santiago 2026-09-15) */
    border: 0;
    background-color: transparent;
    color: var(--lu-tinta);
    cursor: pointer;
    opacity: 0;
    visibility: hidden;
    transform: translateY(0.5rem);
    transition: opacity 200ms, transform 200ms, visibility 0s linear 200ms;
}

.lu-arriba-visible {
    opacity: 1;
    visibility: visible;
    transform: none;
    transition: opacity 200ms, transform 200ms, visibility 0s;
}

.lu-arriba svg {
    width: 1.35rem;
    height: 1.35rem;
    fill: currentColor;
}

/* La palabra queda para el lector de pantalla (aria-label del boton): a la
   vista, solo la flecha */
.lu-arriba-texto {
    display: none;
}

.lu-arriba:hover {
    color: var(--lu-acento);
}

.lu-arriba:focus-visible {
    outline: 2px solid var(--lu-tinta);
    outline-offset: 2px;
}

@media (prefers-reduced-motion: reduce) {
    .lu-arriba,
    .lu-arriba-visible {
        transform: none;
    }
}

/*============================================================================
  #Formas redondeadas (2026-09-16)
  Santiago: "no quiero tantos cuadrados, se busca una estetica romantica".
  El reset brutalista de arriba (90 grados en todo) queda como base y esta
  seccion, al final para ganar por orden, redondea con tres medidas:
    --lu-radio         fotos, tarjetas, paneles y ventanas
    --lu-radio-chico   campos de formulario, avisos, cajas de texto
    --lu-radio-pildora botones, chips, talles, etiquetas: capsula entera
  Lo que va de borde a borde (hero, portada, capsula en video, barras) sigue
  recto: redondear algo que toca los bordes de la pantalla no se ve.
==============================================================================*/

:root {
    --lu-radio: 18px;
    --lu-radio-chico: 10px;
    --lu-radio-pildora: 999px;
}

/* Botones y todo lo que se toca: capsula */
body .btn,
body .btn-primary,
body .btn-secondary,
body .swiper-btn,
body .btn-variant,
body .chip,
body .js-remove-filter.chip,
body .badge,
body .pill,
body .label,
body .item-label,
body .lu-canal .lu-canal-btn,
body .lu-canal-popup .lu-canal-popup-btn,
body .lu-favs-whatsapp,
body .lu-arriba,
body .bar-progress,
body .bar-progress-active,
body #shoppingCartPage .btn:not(.btn-link),
body #shoppingCartPage #go-to-checkout {
    border-radius: var(--lu-radio-pildora);
}

/* Los links con forma de boton subrayado no llevan caja: no se tocan */
body .btn-link {
    border-radius: 0;
}

/* Circulos: favoritos, flechas de los carruseles, puntos y muestras */
body .lu-fav,
body .lu-fav-tarjeta,
body .lu-fav-ficha,
body .lu-fav-rapida,
body .item-slider-controls-container,
body .section-products-related .swiper-button-prev,
body .section-products-related .swiper-button-next,
body .nube-slider-home .swiper-pagination-bullet,
body .service-pagination .swiper-pagination-bullet,
body .section-products-related .swiper-pagination-bullet,
body .item-colors .item-colors-bullet,
body .checkbox-container .checkbox-color,
body .shipping-spinner-container .spinner-ellipsis .point {
    border-radius: 50%;
}

/* "3 colores" en mobile es texto: capsula, no circulo */
body .item-colors .item-colors-bullet-text {
    border-radius: var(--lu-radio-pildora);
}

/* Campos */
body input:not([type="checkbox"]):not([type="radio"]),
body select,
body textarea,
body .form-control,
body .newsletter .form-control,
body .cart-item-input.form-control,
body .category-controls select,
body .category-controls .form-control {
    border-radius: var(--lu-radio-chico);
}

body input[type="checkbox"] {
    border-radius: 5px;
}

/* Fotos y tarjetas: overflow hidden para que la foto, el velo y el zoom
   del hover respeten la curva */
body .item-image,
body .textbanner-image,
body .section-home-modules .textbanner-image,
body .lu-campana,
body .lu-sobre-foto,
body .lu-nota-img,
body .lu-favs-foto,
body .instafeed-link,
body .card {
    border-radius: var(--lu-radio);
    overflow: hidden;
}

body .lu-faq-caja,
body .lu-pagos-compacto,
body .lu-pagos-grande,
body .lu-pagos-amex,
body .alert,
body .notification {
    border-radius: var(--lu-radio-chico);
}

/* Ventanas centradas: todas las esquinas. Hojas desde abajo: solo arriba.
   Paneles laterales (carrito, menu) tocan el borde: solo el lado de adentro. */
body .modal-content,
body #size-guide-modal,
body #home-modal,
body .modal-centered-small {
    border-radius: var(--lu-radio);
}

body .modal-bottom-sheet {
    border-radius: var(--lu-radio) var(--lu-radio) 0 0;
}

body .modal-right {
    border-radius: var(--lu-radio) 0 0 var(--lu-radio);
}

body .modal-left {
    border-radius: 0 var(--lu-radio) var(--lu-radio) 0;
}

body .modal-header,
body .modal-footer {
    border-radius: 0;
}

/* #Contadores (2026-09-16): la bolsa y favoritos ya no dicen [2] entre
   corchetes. El numero va en un circulito turquesa con tinta (8,27:1),
   pegado al icono. Si esta en cero se ve igual: el base lo imprime siempre. */
body .utilities-item .cart-widget-amount,
body .utilities-item .lu-favs-cantidad,
body .cart-widget-amount,
body .lu-favs-cantidad {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 1.15rem;
    height: 1.15rem;
    margin-left: 0.2rem;
    padding: 0 0.3rem;
    border-radius: var(--lu-radio-pildora);
    background-color: var(--lu-acento);
    color: var(--lu-tinta);
    font-family: var(--lu-texto);
    font-size: 0.62rem;
    font-weight: 600;
    letter-spacing: 0;
    line-height: 1;
}

/* Ficha: reglas con id o dos clases que le ganaban a las de arriba */
body #single-product .js-addtocart,
body .lu-comprar .btn-block,
body .lu-ultimo {
    border-radius: var(--lu-radio-pildora);
}

body .btn-variant.btn-variant-color .btn-variant-content {
    border-radius: 50%;
}

/* Fotos de la ficha y miniaturas del carrito, cada una con su curva.
   .tiras solo existe en el harness (la tienda usa el slider) */
body .product-slider-image,
body.template-product .tiras img {
    border-radius: var(--lu-radio);
}

body .cart-item img {
    border-radius: var(--lu-radio-chico);
}

/*============================================================================
  #Cinta de video (2026-09-16)
  snipplets/home/cinta-video.tpl: seis copias del video en fila, corriendo
  sin fin. La pista mide dos tandas iguales y se corre -50%: el final cae
  sobre una imagen identica al principio. Lineal, como toda cinta continua.
  La pausa fuera de pantalla la pone lupita-motion (.lu-cinta-quieta).
==============================================================================*/

/* Sin cortes a la vista (Santiago, 2026-09-16: "se ve el fondo blanco"):
   las copias van pegadas, sin curva ni aire. El espejo en una de cada dos
   se probo y Santiago lo saco: la union entre copias es un corte directo. */
.cover-image .lu-cinta,
.capsule-media .lu-cinta {
    position: absolute;
    inset: 0;
    overflow: hidden;
    background-color: var(--lu-tinta);
}

.lu-cinta-pista {
    display: flex;
    width: max-content;
    height: 100%;
    animation: lu-cinta 18s linear infinite;
    will-change: transform;
}

.lu-cinta-quieta .lu-cinta-pista {
    animation-play-state: paused;
}

/* Dos copias por tanda de 55vw cubren 110vw: nunca asoma el final de la
   pista. Tope alto (90rem) para que alcance tambien en pantallas de 2560. */
.lu-cinta-panel {
    flex: none;
    width: clamp(17rem, 55vw, 90rem);
    height: 100%;
}

body .lu-cinta-video {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: cover;
    border-radius: 0;
}

/* Velo sobre toda la cinta: el titulo en papel se lee sobre cualquier cuadro */
.lu-cinta::after {
    content: "";
    position: absolute;
    inset: 0;
    background-color: color-mix(in srgb, var(--lu-tinta) 18%, transparent);
    pointer-events: none;
}

@keyframes lu-cinta {
    to {
        transform: translate3d(-50%, 0, 0);
    }
}

@media (prefers-reduced-motion: reduce) {
    .lu-cinta-pista {
        animation: none;
    }
}

/*============================================================================
  #Hover y respuesta (2026-09-16)
  Mas vida al pasar el mouse, sin tocar colores (sigue la regla de Santiago:
  nada se oscurece, el estado es turquesa con tinta). Solo transform, solo
  con mouse, y sin movimiento con prefers-reduced-motion.
==============================================================================*/

/* Presionar: todo boton se hunde apenas. Tambien en celular: es respuesta
   al toque, no un hover. El de WhatsApp tiene su propio crecimiento. */
body .btn:not(.btn-link):not(.btn-whatsapp),
body .lu-fav,
body .btn-variant {
    transition-property: transform, background-color, border-color, color;
    transition-duration: 140ms;
    transition-timing-function: cubic-bezier(0.23, 1, 0.32, 1);
}

body .btn:not(.btn-link):not(.btn-whatsapp):active,
body .lu-fav:active,
body .btn-variant:active {
    transform: scale(0.96);
}

@media (hover: hover) and (pointer: fine) {
    /* Tarjeta de producto: la foto sube un poco, ademas del zoom de adentro */
    .item-product .item-image {
        transition: transform 280ms var(--lu-entrada);
    }

    .item-product:hover .item-image {
        transform: translate3d(0, -6px, 0);
    }

    /* Botones con relleno: suben 2px */
    body .btn-primary:hover,
    body .swiper-btn:hover,
    body .btn-variant:hover {
        transform: translate3d(0, -2px, 0);
    }

    /* Corazon y flechas de las fotos */
    body .lu-fav:hover,
    body .item-slider-controls-container:hover {
        transform: scale(1.1);
    }

    body .item-slider-controls-container {
        transition: transform 180ms cubic-bezier(0.23, 1, 0.32, 1);
    }

    /* Categorias con foto: el nombre sube cuando se va el velo */
    .section-banners-home .textbanner-title {
        transition: transform 420ms var(--lu-entrada);
    }

    .section-banners-home .textbanner-link:hover .textbanner-title {
        transform: translate3d(0, -8px, 0);
    }

    /* Campanas e Instagram: la foto respira como las de producto */
    .lu-campana img,
    .instafeed-link img {
        transition: transform 420ms var(--lu-entrada);
    }

    .lu-campana:hover img,
    .instafeed-link:hover img {
        transform: scale(1.04);
    }
}

@media (prefers-reduced-motion: reduce) {
    body .btn:not(.btn-link):not(.btn-whatsapp):active,
    body .lu-fav:active,
    body .btn-variant:active,
    .item-product:hover .item-image,
    body .btn-primary:hover,
    body .swiper-btn:hover,
    body .btn-variant:hover,
    body .lu-fav:hover,
    body .item-slider-controls-container:hover,
    .section-banners-home .textbanner-link:hover .textbanner-title,
    .lu-campana:hover img,
    .instafeed-link:hover img {
        transform: none;
    }
}

/* Las tres categorias con foto iban pegadas por 1px de linea: con curvas
   esa linea asoma en las esquinas. Pasan a fotos sueltas con aire. */
body .section-banners-home .row {
    background-color: transparent;
    gap: 0.5rem;
}

/* El +/- y la cantidad son una sola pieza: la capsula es el contenedor, y
   el campo y los signos de adentro quedan sin curva propia */
body .cart-item-quantity .row {
    border-radius: var(--lu-radio-pildora);
    overflow: hidden;
}

body .cart-item-btn.btn,
body .cart-item-input.form-control {
    border-radius: 0;
}
