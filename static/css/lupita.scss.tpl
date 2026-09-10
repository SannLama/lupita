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

.btn {
    border: 1px solid var(--lu-tinta);
    padding: 0.85rem 1.5rem;
    font-weight: 400;
    transition: background-color 0.12s linear, color 0.12s linear;
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

/* El texto NO se apoya sobre la foto: va dentro de un bloque macizo de tinta.
   Sobre la foto dependeria de que justo ahi haya una zona oscura, y las fotos
   todavia no existen. Ademas el bloque solido es brutalismo suizo puro, y la
   skill prohibe los degradados con los que se suele tapar este problema. */
.nube-slider-home .swiper-text {
    position: absolute;
    left: 50%;
    bottom: clamp(2rem, 6vh, 5rem);
    transform: translateX(-50%);
    z-index: 2;
    max-width: min(88vw, 38rem);
    padding: clamp(1.1rem, 2.2vw, 1.75rem) clamp(1.25rem, 2.5vw, 2rem);
    background-color: var(--lu-tinta);
    color: var(--lu-papel);
    text-align: center;
}

.nube-slider-home .swiper-title {
    font-family: var(--lu-macro);
    text-transform: uppercase;
    letter-spacing: -0.03em;
    line-height: 0.92;
    font-size: clamp(1.75rem, 5vw, 4rem);
    color: var(--lu-papel);
    margin: 0;
}

.nube-slider-home .swiper-description {
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.7rem;
    line-height: 1.5;
    color: var(--lu-papel);
    margin-top: 0.9rem;
}

/* El unico turquesa del hero, para que el ojo sepa donde tocar */
.nube-slider-home .swiper-btn {
    display: inline-block;
    margin-top: 1.25rem;
    background-color: var(--lu-acento);
    border-color: var(--lu-acento);
    color: var(--lu-papel);
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
  #Barra de aviso
  La franja de tinta que corona la pagina. Es el unico lugar donde el mejor
  dato de la marca — 20% en efectivo, 3 y 6 cuotas — esta antes que cualquier
  foto. Va en negativo: papel sobre tinta.
==============================================================================*/

.section-advertising {
    background-color: var(--lu-tinta);
    color: var(--lu-papel);
    padding: 0.55rem 0;
    font-family: var(--lu-micro);
    text-transform: uppercase;
    letter-spacing: var(--lu-track);
    font-size: 0.6rem;
    line-height: 1.3;
}

.section-advertising a,
.section-advertising .link-contrast {
    color: var(--lu-papel);
    text-decoration: none;
}

.section-advertising a:hover {
    color: var(--lu-acento);
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

.modal-header {
    border-bottom: 1px solid var(--lu-linea);
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
