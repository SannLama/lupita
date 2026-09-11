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

/* Macro: bloques arquitectonicos. Tracking negativo y leading comprimido para
   que las letras formen una masa solida, no una linea de texto. */
h1,
h2,
.lu-macro {
    font-family: var(--lu-macro);
    text-transform: uppercase;
    letter-spacing: -0.04em;
    line-height: 0.9;
    margin: 0;
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
    letter-spacing: -0.02em;
    line-height: 1;
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
  Un solo color de acento en todo el theme, y es el de la marca.
==============================================================================*/

.text-accent,
.item-installments strong,
a:hover {
    color: var(--lu-acento);
}

/* El logotipo es un bloque solido y no se parte nunca: en 390px se cortaba en
   dos lineas y se montaba sobre la navegacion. */
.lu-marca {
    background-color: var(--lu-acento);
    color: var(--lu-papel);
    white-space: nowrap;
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

.item-label-sale,
.label-sale {
    background-color: var(--lu-acento);
    color: var(--lu-papel);
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
    color: var(--lu-papel);
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
    letter-spacing: -0.02em;
    margin-bottom: 1rem;
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

/* Comprar: el bloque mas macizo de la pagina */
#single-product .js-addtocart {
    width: 100%;
    padding: 1.15rem 1.5rem;
    font-size: 0.78rem;
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
/* .section-cover-home comparte estas cinco reglas con el hero a proposito
   (ver #Portada mas abajo): mismo riesgo de contraste, mismo arreglo. */
.nube-slider-home .swiper-text,
.section-cover-home .swiper-text {
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
.section-cover-home .swiper-text.swiper-white {
    color: var(--lu-papel);
}

.nube-slider-home .swiper-text.swiper-black,
.section-cover-home .swiper-text.swiper-black {
    color: var(--lu-tinta);
}

.nube-slider-home .swiper-title,
.section-cover-home .swiper-title {
    font-family: var(--lu-macro);
    text-transform: uppercase;
    letter-spacing: -0.03em;
    line-height: 0.92;
    font-size: clamp(1.75rem, 5vw, 4rem);
    color: inherit;
    margin: 0;
}

.nube-slider-home .swiper-description,
.section-cover-home .swiper-description {
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
.section-cover-home .swiper-btn {
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

.cover-image {
    position: relative;
    height: 56vh;
    max-height: 680px;
    overflow: hidden;
}

@media (min-width: 768px) {
    .cover-image {
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
    color: var(--lu-acento);
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
    font-family: var(--lu-macro);
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
    color: var(--lu-acento);
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
    font-family: var(--lu-macro);
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
    font-family: var(--lu-macro);
    text-transform: uppercase;
    letter-spacing: -0.02em;
    font-size: clamp(1.25rem, 4.5vw, 1.75rem);
    color: var(--lu-tinta);
}

.search-input:focus {
    outline: none;
    border-bottom-color: var(--lu-acento);
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

.newsletter .form-control:focus {
    outline: none;
    border-bottom-color: var(--lu-acento);
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

footer a:hover {
    color: var(--lu-acento);
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

.textbanner-image {
    position: relative;
    aspect-ratio: 3 / 4;
    overflow: hidden;
}

.textbanner-image-background {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
    transition-property: transform;
    transition-duration: 420ms;
}

/* La foto respira, igual que en la grilla de productos */
.textbanner-link:hover .textbanner-image-background {
    transform: scale(1.04);
}

.textbanner-text.over-image {
    position: absolute;
    left: 0.75rem;
    bottom: 0.75rem;
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
    color: var(--lu-acento);
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

.category-controls select:focus {
    outline: none;
    color: var(--lu-acento);
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
    color: var(--lu-acento);
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
    color: var(--lu-acento);
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

.alert-success {
    border-color: var(--lu-acento);
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

.cart-item .cart-item-name a {
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

.cart-item-input.form-control:focus {
    outline: none;
    color: var(--lu-acento);
}

/* El tacho tampoco es un boton macizo. */
.cart-item-delete .btn {
    border: 0;
    padding: 0.2rem;
    background-color: transparent;
    color: var(--lu-gris);
}

.cart-item-delete .btn:hover {
    color: var(--lu-acento);
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
   h2, asi que la escala macro del sistema no lo agarraba sola. */
.js-cart-total-container .h2 {
    font-family: var(--lu-macro);
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

#modal-cart .js-cart-total-container .h2 > span {
    display: block;
    max-width: none;
    flex: none;
    text-align: left;
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

/* Mismo motivo: "envio gratis" en turquesa a 0.66rem sobre papel no se lee. */
.ship-free-rest-message .text-accent {
    color: var(--lu-tinta);
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

.item-image img {
    transition: transform 420ms var(--lu-entrada);
}

.item-product:hover .item-image img {
    transform: scale(1.04);
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
    .item-product:hover .item-image img {
        transition: none;
        transform: none;
    }

    .transition-soft,
    .transition-soft-slow,
    .bar-progress-active {
        transition-duration: 0.01ms;
    }
}
