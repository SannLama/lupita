/**
 * Harness local de Ahi! Lupita — NO SE SUBE POR FTP.
 *
 * Tiendanube compila los .tpl en su servidor y no hay forma de correr eso
 * localmente. Esto no lo reemplaza: resuelve los {{ settings.x }} de la hoja
 * de estilos leyendo config/defaults.txt de verdad, y arma paginas que
 * replican el DOM que producen las plantillas del theme.
 *
 * O sea: verifica EL CSS, que es lo que escribimos nosotros. No verifica las
 * plantillas ni las funciones propias de la plataforma. Para eso hace falta
 * la tienda con FTP.
 *
 * Se puede recorrer: la cabecera, el boton del hero y las tarjetas navegan
 * entre home, categoria y producto, y las flechas del slider funcionan.
 *
 * Uso:  node _harness/render.mjs   ->  _harness/out/
 */

import { readFileSync, writeFileSync, mkdirSync, cpSync, existsSync } from 'node:fs'
import { dirname, join } from 'node:path'
import { fileURLToPath } from 'node:url'

const AQUI = dirname(fileURLToPath(import.meta.url))
const RAIZ = join(AQUI, '..')
const SALIDA = join(AQUI, 'out')

/* ---------------------------------------------------------------------------
   1. Leer los settings reales desde config/defaults.txt
   --------------------------------------------------------------------------- */

function leerDefaults() {
  const txt = readFileSync(join(RAIZ, 'config', 'defaults.txt'), 'utf8')
  const settings = {}
  for (const linea of txt.split(/\r?\n/)) {
    const m = linea.match(/^([a-z0-9_]+)\s*=\s*(.*)$/i)
    if (m) settings[m[1]] = m[2].trim()
  }
  return settings
}

/* ---------------------------------------------------------------------------
   2. Resolver la hoja de estilos
   --------------------------------------------------------------------------- */

function compilarCss(settings) {
  let css = readFileSync(join(RAIZ, 'static', 'css', 'lupita.scss.tpl'), 'utf8')

  // Comentarios Twig {# ... #}
  css = css.replace(/\{#[\s\S]*?#\}/g, '')

  // Los bloques logicos de la hoja: cantidad de columnas por breakpoint
  css = css.replace(
    /\{%\s*if settings\.grid_columns == 2\s*%\}(.*?)\{%\s*else\s*%\}(.*?)\{%\s*endif\s*%\}/g,
    (_, siDos, siNo) => (settings.grid_columns === '2' ? siDos : siNo)
  )

  // {{ 'Texto' | translate }} — la hoja inyecta rotulos con content: en vez de
  // hardcodearlos, para que sigan el idioma de la tienda. Aca alcanza con
  // devolver el original, que ya viene en castellano.
  css = css.replace(/\{\{\s*'([^']*)'\s*\|\s*translate\s*\}\}/g, (_, texto) => texto)

  // {{ settings.x }}
  const faltantes = new Set()
  css = css.replace(/\{\{\s*settings\.([a-z0-9_]+)\s*\}\}/gi, (_, clave) => {
    if (settings[clave] === undefined) {
      faltantes.add(clave)
      return 'magenta' // chillon a proposito: si aparece magenta, falta un default
    }
    return settings[clave]
  })

  if (faltantes.size) {
    console.warn('OJO, sin valor en defaults.txt:', [...faltantes].join(', '))
  }

  const resto = css.match(/\{[{%]/g)
  if (resto) console.warn('Quedo Twig sin resolver:', resto.length, 'ocurrencias')

  return css
}

/* ---------------------------------------------------------------------------
   3. Andamio comun
   Nada de esto es el sistema visual: es lo minimo del theme base y del
   navegador que las muestras necesitan para no verse rotas.
   --------------------------------------------------------------------------- */

const CABEZA = (titulo) => `<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${titulo} — Ahi! Lupita (harness)</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Archivo+Black&family=Roboto+Mono:wght@300;400;700&display=swap" rel="stylesheet">
  <style>
    /* ANDAMIO — representa al theme base, asi que va ANTES de lupita.css, que
       es como se cargan en la tienda (layout.tpl mete la nuestra despues de
       style-async). Si fuera al reves, este bloque le ganaria los empates de
       especificidad a nuestra hoja y el harness mentiria. */
    * { box-sizing: border-box; }
    body { margin: 0; }
    /* El padding es el de Bootstrap, que viene embebido en style-critical:
       15px, no 1.5rem. En 320 esos 18px de diferencia deciden si la cabecera
       entra en un renglon o se parte. */
    .container { max-width: 1600px; margin: 0 auto; padding: 0 15px; }
    /* El overflow:hidden es del base (style-critical) y no es un detalle: es
       lo que hace que la foto crezca DENTRO de su division de 1px al pasar por
       encima, en vez de pisar la celda de al lado. */
    .item-image { position: relative; margin-bottom: .5rem; overflow: hidden; }
    .item-image img { display: block; width: 100%; height: auto; }
    .item-label { position: absolute; top: .6rem; left: .6rem; z-index: 1; }
    /* El base resetea esto para todo el sitio (style-critical: a{...}) */
    a { text-decoration: none; }
    /* La tarjeta entera es clickeable, no solo el nombre */
    .item-product .item-image { cursor: pointer; }
    .item-product:hover .item-name { color: var(--lu-acento); }

    /* Bootstrap 4, solo lo que la cabecera y el pie del base usan de verdad */
    .row { display: flex; flex-wrap: wrap; margin: 0 -.75rem; }
    .row.no-gutters { margin: 0; }
    .col, [class^="col-"] { padding: 0 .75rem; }
    .col { flex: 1 0 0%; }
    .row.no-gutters > .col, .row.no-gutters > .col-md { padding: 0; }
    .col-md-3, .col-md { flex: 0 0 100%; max-width: 100%; }
    .col-md-9 { flex: 0 0 100%; max-width: 100%; }
    @media (min-width: 768px) {
      .col-md-3 { flex: 0 0 25%; max-width: 25%; }
      .col-md-9 { flex: 0 0 75%; max-width: 75%; }
      .col-md { flex: 1 0 0%; max-width: 100%; }
    }
    .align-items-center { align-items: center; }
    .justify-content-md-center { justify-content: center; }
    .col-md-8 { flex: 0 0 100%; max-width: 100%; padding: 0 .75rem; }
    .text-center { text-align: center; }
    .text-right { text-align: right; }
    .position-relative { position: relative; }
    .m-0 { margin: 0; }
    .p-0 { padding: 0; }
    .my-2 { margin: .5rem 0; }
    .w-100 { width: 100%; }

    /* Theme base: cabecera */
    .head-fix { position: sticky; top: 0; z-index: 1040; }
    .utilities-container { display: inline-block; }
    .utilities-item { display: inline-block; }
    .logo-text-container { max-width: 450px; margin: auto; padding: 5px; text-align: center; }
    .icon-inline { display: inline-block; vertical-align: -.2em; fill: currentColor;
                   width: 1em; height: 1em; }
    /* El base les pone icon-w-14 / icon-w-16, o sea un tamano fijo que NO
       depende del cuerpo del texto de al lado. */
    .utilities-link .icon-inline, .cart-summary .icon-inline { width: 15px; height: 15px; }

    /* Theme base: buscador, newsletter y pie */
    .js-search-container { position: relative; }
    .form-control { width: 100%; display: block; }
    .search-input-submit { position: absolute; top: 5px; right: 0; background: none; border: 0; }
    .newsletter form { position: relative; }
    .newsletter-btn { position: absolute; top: 0; right: 0; }
    .item-with-subitems { position: relative; }
    .nav-list-arrow { position: absolute; }
    .footer-payments-shipping-logos img { max-height: 35px; width: auto; margin: 2px; }

    /* Los modales del base son off-canvas. Esto no replica su CSS entero, pero
       si lo que importa para mirar el movimiento: el panel vive FUERA de la
       pantalla y entra al ganar .modal-show, y el base lo hace moviendo
       left/right — propiedades de layout — con transition:all. Nuestra hoja lo
       pasa a transform; para verlo como un cambio de verdad, aca esta el
       original. */
    .modal { position: fixed; top: 0; bottom: 0; z-index: 1050; overflow-y: auto;
             width: 100%; max-width: 380px;
             transition: all .2s cubic-bezier(.16,.68,.43,.99); }
    .modal-left { left: -100%; }
    .modal-right { right: -100%; }
    .modal-left.modal-show { left: 0; }
    .modal-right.modal-show { right: 0; }
    .modal-overlay { position: fixed; inset: 0; background: rgba(10,10,10,.45); z-index: 1045;
                     opacity: 0; transition: opacity .34s ease; }
    .modal-overlay.visible { opacity: 1; }
    .modal-header { display: flex; align-items: center; gap: .75rem; padding: 1rem 1.25rem; }
    .modal-close { cursor: pointer; }
    .modal-body { padding: 0; }
    #nav-search .modal-body { padding: 1.25rem; }
    .modal-with-fixed-footer { display: flex; flex-direction: column; min-height: 100%; }
    .modal-scrollable-area { flex: 1; }

    /* Theme base: controles y filtros de la categoria.
       El base declara sticky SIN top, o sea que no se pega a nada; y arriba de
       768 lo vuelve relative. Se copia tal cual, con defecto y todo. */
    .category-controls { position: sticky; z-index: 100; padding: 15px 0; }
    @media (min-width: 768px) { .category-controls { position: relative; padding: 0; } }
    .category-controls-sticky-detector { height: 1px; }
    .filter-link { display: inline-block; width: 100%; padding: 10px 0; }
    .list-unstyled { padding-left: 0; list-style: none; }
    .col-12 { flex: 0 0 100%; max-width: 100%; }
    .col-6 { flex: 0 0 50%; max-width: 50%; }
    @media (min-width: 768px) {
      .col-md-9 { flex: 0 0 75%; max-width: 75%; }
      .col-md-3 { flex: 0 0 25%; max-width: 25%; }
      .col-lg-6 { flex: 0 0 100%; max-width: 100%; }
    }
    @media (min-width: 992px) {
      .col-lg-6 { flex: 0 0 50%; max-width: 50%; }
      .offset-lg-3 { margin-left: 25%; }
    }
    .col-2 { flex: 0 0 16.666667%; max-width: 16.666667%; }
    .offset-5 { margin-left: 41.666667%; }
    .background-primary { background-color: var(--lu-tinta); }
    .divider { height: 2px; }
    .font-weight-bold { font-weight: 700; }
    .mt-3 { margin-top: 1rem; } .mt-4 { margin-top: 1.5rem; }
    .mb-2 { margin-bottom: .5rem; } .mb-3 { margin-bottom: 1rem; }
    .d-md-inline-block { display: inline-block; }
    .mr-md-2 { margin-right: .5rem; }
    .d-inline-block { display: inline-block; }
    .px-0 { padding-left: 0; padding-right: 0; }

    /* La casilla del base ya es un cuadrado con borde de 1px y un tilde
       dibujado con dos bordes rotados. Se copia tal cual (style-async +
       style-colors) para poder ver arriba lo que nuestra hoja le cambia. */
    .checkbox-container .checkbox { position: relative; display: block; margin-bottom: 15px;
                                    padding-left: 30px; line-height: 20px; cursor: pointer; }
    .checkbox-container .checkbox input { display: none; }
    .checkbox-container .checkbox input:checked ~ .checkbox-icon:after { display: block; }
    .checkbox-icon { position: absolute; top: -1px; left: 0; width: 20px; height: 20px;
                     background: var(--lu-papel); border: 1px solid var(--lu-tinta); }
    .checkbox-icon:after { position: absolute; top: 1px; left: 6px; display: none;
                           width: 7px; height: 12px; content: ''; transform: rotate(45deg);
                           border: solid var(--lu-tinta); border-width: 0 2px 2px 0; }
    .checkbox-color { display: inline-block; width: 10px; height: 10px; margin: 0 0 2px 5px;
                      vertical-align: middle; border-radius: 100%; }

    /* Theme base: carrito. Los floats y los tamaños son los de style-async,
       copiados tal cual — incluido el col-2 + col-10 + col-1 del marcado, que
       son TRECE columnas de doce y por eso el tacho se caia a otra linea. */
    .form-row { display: flex; flex-wrap: wrap; margin: 0 -5px; }
    .cart-item { position: relative; margin-bottom: 25px; }
    .cart-item-name { float: left; width: 100%; padding: 0 40px 10px 0; }
    .cart-item-subtotal { float: right; margin: 10px 0; text-align: right; font-weight: normal; }
    .cart-item-btn { padding: 6px; display: inline-block; background: transparent;
                     font-size: 16px; opacity: .8; }
    .cart-item-input { display: inline-block; width: 40px; height: 30px; font-size: 16px;
                       text-align: center; }
    .alert { clear: both; padding: 8px; border: 1px solid; text-align: center; }
    .bar-progress { height: 6px; border-radius: 3px; }
    .bar-progress-active { height: 6px; border-radius: 3px; }
    .float-left { float: left; }
    .clear-both { clear: both; }
    .w-auto { width: auto; }
    .mb-0 { margin-bottom: 0; }
    .mb-1 { margin-bottom: .25rem; }
    .mb-5 { margin-bottom: 3rem; }
    .mt-1 { margin-top: .25rem; }
    .mr-1 { margin-right: .25rem; }
    .no-gutters { margin: 0; }
    .no-gutters > .col { padding: 0; }
    .container-fluid { width: 100%; padding: 0 15px; }
    .img-fluid { max-width: 100%; height: auto; }
  </style>
  <link rel="stylesheet" href="lupita.css">
</head>`

/** Replica el split por "—" de header-advertising.tpl: con mas de un
 * mensaje, arma el ticker de steps(N); con uno solo, lo deja estatico. */
function adBar(texto) {
  const partes = texto.split('—').map((p) => p.trim()).filter(Boolean)
  if (partes.length <= 1) return texto
  return `<span class="ad-rotator"><span class="ad-track" style="animation-duration: ${partes.length * 4}s; animation-timing-function: steps(${partes.length});">${partes.map((p) => `<span class="ad-msg">${p}</span>`).join('')}</span></span>`
}

/* Cabecera real del theme: snipplets/header/header.tpl mas la barra de aviso.
   Las tres columnas (hamburguesa / logo / utilidades) son las del base. */
const CABECERA = (settings) => `
    ${settings.ad_bar === '1' && settings.ad_text_es ? `
    <section class="section-advertising">
      <div class="container">
        <div class="row-fluid"><div class="col text-center">${adBar(settings.ad_text_es)}</div></div>
      </div>
    </section>` : ''}
    <header class="head-main head-${settings.head_background} head-fix">
      <div class="container position-relative">
        <div class="row no-gutters align-items-center">
          <div class="col">
            <div class="utilities-container">
              <div class="utilities-item">
                <a href="#" class="js-panel utilities-link" data-toggle="#nav-hamburger" aria-label="Menú">${ICONO.barras}</a>
              </div>
            </div>
          </div>
          <div class="col text-center">
            <div class="logo-text-container">
              <a href="home.html" class="logo-text h1 m-0" style="text-decoration:none;color:inherit">AHI ! LUPITA</a>
            </div>
          </div>
          <div class="col text-right">
            <div class="utilities-container">
              <div class="utilities-item">
                <a href="#" class="js-panel utilities-link" data-toggle="#nav-search" aria-label="Buscador">${ICONO.lupa}</a>
              </div>
              <div class="utilities-item">
                <div id="ajax-cart" class="cart-summary">
                  <a href="#" class="js-panel" data-toggle="#modal-cart">${ICONO.bolsa}<span class="cart-widget-amount">2</span></a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </header>`

/* Los iconos del base son snipplets SVG. Estos son equivalentes en trazo y
   tamano: lo que importa para el CSS es que sean un SVG inline de 1em. */
const ICONO = {
  barras: '<svg class="icon-inline" viewBox="0 0 448 512" aria-hidden="true"><path d="M16 132h416a16 16 0 000-32H16a16 16 0 000 32zm0 124h416a16 16 0 000-32H16a16 16 0 000 32zm0 124h416a16 16 0 000-32H16a16 16 0 000 32z"/></svg>',
  lupa: '<svg class="icon-inline" viewBox="0 0 512 512" aria-hidden="true"><path d="M208 48a160 160 0 10.1 320.1A160 160 0 00208 48zm0 288a128 128 0 110-256 128 128 0 010 256zm291 137L387 361a16 16 0 00-23 0l-3 3a16 16 0 000 23l112 112a16 16 0 0023 0l3-3a16 16 0 000-23z"/></svg>',
  bolsa: '<svg class="icon-inline" viewBox="0 0 448 512" aria-hidden="true"><path d="M352 128h-32V96a96 96 0 00-192 0v32H96a32 32 0 00-32 32v288a32 32 0 0032 32h256a32 32 0 0032-32V160a32 32 0 00-32-32zM160 96a64 64 0 01128 0v32H160V96zm192 352H96V160h320v288z"/></svg>',
  cerrar: '<svg class="icon-inline" viewBox="0 0 352 512" aria-hidden="true"><path d="M242 256l100-100a16 16 0 000-23l-23-23a16 16 0 00-23 0L196 210 96 110a16 16 0 00-23 0l-23 23a16 16 0 000 23l100 100-100 100a16 16 0 000 23l23 23a16 16 0 0023 0l100-100 100 100a16 16 0 0023 0l23-23a16 16 0 000-23L242 256z"/></svg>',
  filtro: '<svg class="icon-inline" viewBox="0 0 512 512" aria-hidden="true"><path d="M487 24H25a24 24 0 00-17 41l180 180v163a24 24 0 0010 20l80 55a24 24 0 0038-20V245L496 65a24 24 0 00-9-41zM288 224v240l-64-44V224L32 56h448L288 224z"/></svg>',
  tacho: '<svg class="icon-inline" viewBox="0 0 448 512" aria-hidden="true"><path d="M432 80h-98l-16-33a32 32 0 00-29-18H159a32 32 0 00-29 18l-16 33H16a16 16 0 000 32h16l21 359a48 48 0 0048 45h246a48 48 0 0048-45l21-359h16a16 16 0 000-32zM159 64h130l8 16H151l8-16zm188 416H101a16 16 0 01-16-15L64 112h320l-21 353a16 16 0 01-16 15z"/></svg>',
}

/* ---------------------------------------------------------------------------
   3a. Las secciones
   Ahi! Lupita vende SOLO ropa de mujer, asi que no hay un nivel de genero que
   separar: las secciones son directamente las prendas. Estos nombres son de
   mentira, igual que las prendas — sirven para ver el bloque, no para decidir
   el menu, que sale del catalogo real.
   --------------------------------------------------------------------------- */

const SECCIONES = [
  'Nuevos ingresos', 'Vestidos', 'Remeras y tops', 'Pantalones', 'Faldas',
  'Abrigos', 'Sastreria', 'Lenceria', 'Accesorios', 'Sale',
]

/** Replica el DOM de snipplets/grid/categories.tpl con horizontal: true. */
const RIEL = `
    <nav class="lu-secciones" aria-label="Categorías" data-store="category-sections">
      <ul class="lu-secciones-lista list-unstyled">
${SECCIONES.map((s, i) => `        <li data-item="${i + 1}"><a href="categoria.html" title="${s}" class="lu-seccion-link">${s}</a></li>`).join('\n')}
      </ul>
    </nav>`

/** Replica el DOM de snipplets/grid/filters.tpl dentro del modal de category.tpl. */
const grupoFiltro = (titulo, valores, color) => `
        <div class="filters-container mb-5" data-store="filters-group">
          <h6 class="mb-3">${titulo}</h6>
${valores.map(([v, n, hex], i) => `          <label class="js-filter-checkbox js-apply-filter checkbox-container font-weight-bold mb-2" data-filter-name="${titulo.toLowerCase()}" data-filter-value="${v}">
            <span class="checkbox">
              <input type="checkbox" autocomplete="off"${i === 1 ? ' checked' : ''}>
              <span class="checkbox-icon"></span>
              <span class="checkbox-text">${v} (${n})</span>
              ${color ? `<span class="checkbox-color" style="background-color: ${hex};"></span>` : ''}
            </span>
          </label>`).join('\n')}
        </div>`

const FILTROS = `
  <div id="nav-filters" class="js-modal modal modal-filters modal-docked-small modal-left transition-slide modal-full" style="display:none">
    <div class="js-modal-close modal-header">
      <span class="modal-close">${ICONO.cerrar}</span>
      Filtros
    </div>
    <div class="modal-body">
      <div id="filters" data-store="filters-nav">
${grupoFiltro('Talle', [['XS', 4], ['S', 11], ['M', 12], ['L', 9], ['XL', 5]])}
${grupoFiltro('Color', [['Negro', 14, '#0A0A0A'], ['Crudo', 8, '#E8E2D6'], ['Turquesa', 3, '#6BB3B9'], ['Jean', 6, '#7E8A96']], true)}
        <div class="filters-container mb-5">
          <h6 class="mb-3">Precio</h6>
          <label class="js-filter-checkbox checkbox-container font-weight-bold mb-2">
            <span class="checkbox">
              <input type="checkbox" autocomplete="off">
              <span class="checkbox-icon"></span>
              <span class="checkbox-text">Hasta $ 50.000 (5)</span>
            </span>
          </label>
          <label class="js-filter-checkbox checkbox-container font-weight-bold mb-2">
            <span class="checkbox">
              <input type="checkbox" autocomplete="off">
              <span class="checkbox-icon"></span>
              <span class="checkbox-text">$ 50.000 a $ 100.000 (5)</span>
            </span>
          </label>
        </div>
      </div>
    </div>
  </div>`

/* ---------------------------------------------------------------------------
   3b. Panel de navegacion y buscador
   Replican el DOM de snipplets/navigation/navigation-panel.tpl y
   header/header-search.tpl, dentro del andamio de snipplets/modal.tpl.
   Los rubros son de mentira, como las prendas: sirven para ver el bloque, no
   para decidir el menu.
   --------------------------------------------------------------------------- */

/* Las mismas secciones del riel, para que el menu y la categoria no cuenten
   dos historias distintas. Solo Pantalones se despliega, para ver el acordeon. */
const RUBROS = SECCIONES.map((nombre) =>
  nombre === 'Pantalones'
    ? { nombre, subitems: ['Jeans', 'Sastreros', 'Calzas'] }
    : { nombre }
)

/* ---------------------------------------------------------------------------
   3d. Panel del carrito
   Replica el DOM de snipplets/cart-panel.tpl + cart-item-ajax.tpl +
   cart-totals.tpl, en su version de panel (cart_page = false), dentro del
   modal que arma header.tpl.
   --------------------------------------------------------------------------- */

const EN_CARRITO = [
  { i: 1, nombre: 'Vestido midi satinado con tajo', variante: 'Talle M / Negro', cant: 1, sub: 74500, foto: '#8C9AA3' },
  { i: 4, nombre: 'Blazer estructurado', variante: 'Talle S / Crudo', cant: 1, sub: 145000, foto: '#A8A093' },
]

const TOTAL_CARRITO = EN_CARRITO.reduce((a, p) => a + p.sub, 0)

const rengloncarrito = (p) => `
        <div class="js-cart-item cart-item js-cart-item-shippable form-row" data-item-id="${p.i}" data-component="cart.line-item">
          <div class="col-2">
            <a href="producto.html?p=${p.i}"><img src="${foto(p.foto, '', 200, 300)}" class="img-fluid" alt=""></a>
          </div>
          <div class="col-10">
            <div class="w-100">
              <h6 class="font-weight-normal cart-item-name mb-0" data-component="line-item.name">
                <a href="producto.html?p=${p.i}">${p.nombre}</a>
                <small>${p.variante}</small>
              </h6>
              <div class="cart-item-quantity" data-component="line-item.subtotal">
                <div class="form-group float-left form-quantity w-auto mb-2">
                  <div class="row m-0 justify-content-md-center">
                    <span class="js-cart-quantity-btn cart-item-btn btn">&#8722;</span>
                    <input class="js-cart-quantity-input cart-item-input form-control" type="number" value="${p.cant}" aria-label="Cantidad">
                    <span class="js-cart-quantity-btn cart-item-btn btn">+</span>
                  </div>
                </div>
              </div>
              <h6 class="js-cart-item-subtotal cart-item-subtotal">${pesos(p.sub)}</h6>
            </div>
          </div>
          <div class="col-1 cart-item-delete text-right">
            <button type="button" class="btn h6 m-0" aria-label="Quitar">${ICONO.tacho}</button>
          </div>
        </div>`

const CARRITO = `
  <div id="modal-cart" class="js-modal js-fullscreen-modal modal modal-right transition-slide modal-docked-md" style="display:none">
    <form action="#" method="post" class="js-ajax-cart-panel">
      <div class="js-modal-close modal-header">
        <span class="modal-close">${ICONO.cerrar}</span>
        Carrito de Compras
      </div>
      <div class="modal-body">
        <div class="js-ajax-cart-list cart-row">
${EN_CARRITO.map(rengloncarrito).join('')}
        </div>
        <div class="js-empty-ajax-cart cart-row" style="display:none">
          <div class="alert alert-info">El carrito de compras está vacío.</div>
        </div>

        <div class="js-fulfillment-info js-allows-non-shippable">
          <div class="js-ship-free-rest">
            <div class="js-bar-progress bar-progress">
              <div class="js-bar-progress-active bar-progress-active" style="width:73%"></div>
            </div>
            <div class="js-ship-free-rest-message ship-free-rest-message">
              <div class="ship-free-rest-text bar-progress-amount h6">¡Estás a <strong class="js-ship-free-dif h5">${pesos(80500)}</strong> de tener <strong class="text-accent">envío gratis</strong>!</div>
            </div>
          </div>
        </div>

        <div class="cart-row">
          <div class="js-visible-on-cart-filled h5 row no-gutters mb-1" data-store="cart-subtotal">
            <span class="col">Subtotal<small class="js-subtotal-shipping-wording"> (sin envío)</small>:</span>
            <strong class="js-ajax-cart-total js-cart-subtotal col text-right">${pesos(TOTAL_CARRITO)}</strong>
          </div>

          <div class="js-cart-total-container js-visible-on-cart-filled mb-3 clear-both" data-store="cart-total">
            <div class="h2 row no-gutters text-primary mb-0">
              <span class="col mr-1">Total:</span>
              <span class="js-cart-total col text-right">${pesos(TOTAL_CARRITO)}</span>
            </div>
            <div class="total-price hidden">Total: ${pesos(TOTAL_CARRITO)}</div>
            <div class="installments mt-1 font-weight-bold text-right">3 cuotas sin interes de ${pesos(Math.round(TOTAL_CARRITO / 3))}</div>
          </div>

          <div class="js-visible-on-cart-filled container-fluid">
            <div class="js-ajax-cart-submit row mb-3">
              <input class="btn btn-primary btn-block" type="submit" name="go_to_checkout" value="Iniciar Compra">
            </div>
          </div>
        </div>
      </div>
    </form>
  </div>`

const PANELES = `
  <div id="nav-hamburger" class="js-modal modal modal-nav-hamburger modal-docked-small modal-left transition-fade" style="display:none">
    <div class="modal-with-fixed-footer">
      <div class="modal-scrollable-area">
        <div class="js-modal-close modal-header">
          <span class="modal-close">${ICONO.cerrar}</span>
        </div>
        <div class="modal-body">
          <div class="nav-primary">
            <ul class="nav-list">
${RUBROS.map((r) => (r.subitems
  ? `              <li class="item-with-subitems">
                <div><a class="nav-list-link" href="categoria.html">${r.nombre}<span class="nav-list-arrow">&#9662;</span></a></div>
                <ul class="list-subitems nav-list-accordion">
${r.subitems.map((s) => `                  <li><a class="nav-list-link" href="categoria.html">${s}</a></li>`).join('\n')}
                </ul>
              </li>`
  : `              <li><a class="nav-list-link" href="categoria.html">${r.nombre}</a></li>`)).join('\n')}
            </ul>
          </div>
        </div>
      </div>
      <div class="modal-footer p-0">
        <div class="nav-secondary">
          <ul class="nav-account">
            <li class="nav-accounts-item"><a href="#" class="nav-accounts-link">Crear cuenta</a></li>
            <li class="nav-accounts-item"><a href="#" class="nav-accounts-link">Iniciar sesión</a></li>
          </ul>
        </div>
      </div>
    </div>
  </div>

  <div id="nav-search" class="js-modal modal modal-right transition-slide modal-docked-md" style="display:none">
    <div class="js-modal-close modal-header">
      <span class="modal-close">${ICONO.cerrar}</span>
    </div>
    <div class="modal-body">
      <form class="js-search-container js-search-form" action="#" method="get">
        <div class="form-group m-0">
          <input class="js-search-input form-control search-input" autocomplete="off" type="search" name="q" placeholder="Buscar" aria-label="Buscador">
          <button type="submit" class="btn search-input-submit" aria-label="Buscar">${ICONO.lupa}</button>
        </div>
      </form>
      <div class="js-search-suggest search-suggest"></div>
    </div>
  </div>

${CARRITO}

  <div class="js-modal-overlay modal-overlay" style="display:none"></div>

  <script>
    // En la tienda esto lo maneja store.js. Se replica su secuencia, que es la
    // que decide si la transicion se ve o no: mostrar, FORZAR UN REFLOW, y
    // recien ahi poner la clase. Sin ese reflow el navegador junta los dos
    // cambios en un solo frame y el panel aparece de golpe, sin animar.
    // Al cerrar, store.js espera 500ms antes de esconderlo; lo mismo aca.
    const velo = document.querySelector('.modal-overlay')
    function abrir(sel) {
      const m = document.querySelector(sel)
      m.style.display = 'block'
      velo.style.display = 'block'
      void m.offsetWidth
      m.classList.add('modal-show')
      velo.classList.add('visible')
    }
    function cerrar() {
      velo.classList.remove('visible')
      document.querySelectorAll('.js-modal.modal-show').forEach(m => {
        m.classList.remove('modal-show')
        setTimeout(() => { m.style.display = 'none' }, 500)
      })
      setTimeout(() => { velo.style.display = 'none' }, 500)
    }
    document.querySelectorAll('.js-panel').forEach(b => b.addEventListener('click', (e) => {
      e.preventDefault()
      abrir(b.dataset.toggle)
    }))
    document.querySelectorAll('.js-modal-close').forEach(b => b.addEventListener('click', cerrar))
    velo.addEventListener('click', cerrar)
  </script>`

/* ---------------------------------------------------------------------------
   3c. Pie
   Replica snipplets/footer.tpl con sus filas .element-footer. Los datos que la
   clienta todavia no confirmo van marcados como tales A PROPOSITO: si aparecen
   inventados en una captura, terminan en la tienda.
   --------------------------------------------------------------------------- */

const PIE = `
  <footer class="js-footer">
    <div class="container">

      <div class="row justify-content-md-center">
        <div class="col-md-8 text-center">
          <div class="js-newsletter newsletter section-footer">
            <h3>Recibí todas las ofertas</h3>
            <p>¿Querés recibir nuestras ofertas? ¡Registrate ya mismo y comenzá a disfrutarlas!</p>
            <form method="post" action="#">
              <div class="input-append">
                <input class="form-control" type="email" name="email" placeholder="Email" aria-label="Email">
                <input type="submit" class="btn newsletter-btn" value="Enviar">
              </div>
            </form>
          </div>
        </div>
      </div>

      <div class="row element-footer">
        <div class="col text-center">
          <a class="social-icon" href="#" aria-label="instagram">IG</a>
          <a class="social-icon" href="#" aria-label="tiktok">TT</a>
        </div>
      </div>

      <div class="row element-footer">
        <div class="col text-center">
          <ul class="footer-menu m-0 p-0">
            <li class="footer-menu-item"><a class="footer-menu-link" href="#">Cómo comprar</a></li>
            <li class="footer-menu-item"><a class="footer-menu-link" href="#">Medios de pago</a></li>
            <li class="footer-menu-item"><a class="footer-menu-link" href="#">Envíos</a></li>
            <li class="footer-menu-item"><a class="footer-menu-link" href="#">Cambios y devoluciones</a></li>
          </ul>
        </div>
      </div>

      <div class="row element-footer">
        <div class="col text-center">
          <ul class="contact-info text-center">
            <li class="contact-item"><a href="#" class="contact-link">[ WhatsApp a confirmar ]</a></li>
            <li class="contact-item"><a href="#" class="contact-link">[ Mail a confirmar ]</a></li>
            <li class="contact-item">España 137, Lomas de Zamora</li>
            <li class="contact-item">Loria 198, Lomas de Zamora</li>
            <li class="contact-item">[ Tercera dirección a confirmar ]</li>
            <li class="contact-item">[ Horarios a confirmar ]</li>
          </ul>
        </div>
      </div>

      <div class="row element-footer footer-payments-shipping-logos">
        <div class="col text-center">
          ${['VISA', 'MASTER', 'AMEX', 'MERCADO PAGO'].map((m) => `<img src="${foto('#8A8A84', m, 120, 48)}" alt="${m}">`).join('')}
        </div>
        <div class="w-100 my-2"></div>
        <div class="col text-center">
          ${['ANDREANI', 'OCA', 'RETIRO EN LOCAL'].map((m) => `<img src="${foto('#8A8A84', m, 140, 48)}" alt="${m}">`).join('')}
        </div>
      </div>

      <div class="row element-footer">
        <div class="col-md-3 text-center text-md-left">
          <span class="powered-by">Tienda creada con Tiendanube</span>
        </div>
        <div class="col-md-9 copyright text-center text-md-right">
          Copyright Ahí! Lupita 2026. Todos los derechos reservados.
        </div>
      </div>

    </div>
  </footer>`

/* ---------------------------------------------------------------------------
   4. Productos falsos
   Fotos de distinto tono y encuadre a proposito: el punto de la grilla con
   lineas es justamente sostener fotos que no comparten fondo.
   --------------------------------------------------------------------------- */

const PRODUCTOS = [
  { nombre: 'Campera de jean oversize', precio: 89900, foto: '#B9B2A6' },
  { nombre: 'Vestido midi satinado con tajo', precio: 74500, antes: 98000, foto: '#8C9AA3', etiqueta: 'OFERTA' },
  { nombre: 'Top halter plisado', precio: 42900, foto: '#D8D2C6' },
  { nombre: 'Pantalon sastrero tiro alto', precio: 96000, foto: '#6E6A63' },
  { nombre: 'Blazer estructurado', precio: 145000, foto: '#A8A093', etiqueta: 'NUEVO' },
  { nombre: 'Remera basica algodon peinado', precio: 28900, foto: '#C9C3B7' },
  { nombre: 'Falda de cuero ecologico', precio: 87400, antes: 112000, foto: '#4A4742', etiqueta: 'OFERTA' },
  { nombre: 'Camisa oversize a rayas', precio: 65900, foto: '#B4BCC2' },
  { nombre: 'Jean wide leg con tiro alto y bolsillos utilitarios', precio: 92000, foto: '#7E8A96' },
  { nombre: 'Sweater de lana trenzado', precio: 78500, foto: '#CFC7B8' },
  { nombre: 'Body de encaje', precio: 39900, foto: '#9C9188' },
  { nombre: 'Trench largo', precio: 168000, foto: '#BDB4A4', etiqueta: 'NUEVO' },
]

/* Declaracion y no const: el panel del carrito se arma mas arriba en el
   archivo y necesita esta funcion ya disponible. */
function pesos(n) {
  return '$ ' + n.toLocaleString('es-AR')
}

/** SVG plano como data URI: sin red, y proporcion 2:3 como una foto de catalogo. */
function foto(color, texto, w = 400, h = 600) {
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${w} ${h}"><rect width="${w}" height="${h}" fill="${color}"/><text x="${w / 2}" y="${h / 2}" font-family="monospace" font-size="${Math.round(w / 26)}" fill="rgba(255,255,255,.55)" text-anchor="middle">${texto}</text></svg>`
  return 'data:image/svg+xml;utf8,' + encodeURIComponent(svg)
}

/* Fotos reales de campana, en _harness/img/ (NO se suben por FTP, son solo
   para mirar el hero con contenido real en vez del gris de foto()). Si el
   campo `foto` de un slide empieza con 'img/', se usa tal cual; si no, cae al
   placeholder SVG de siempre. */
function imagenSrc(valor, texto, w, h) {
  return valor.startsWith('img/') ? valor : foto(valor, texto, w, h)
}

/** Replica el DOM de snipplets/grid/item.tpl (clases reales, verificadas). */
function tarjeta(p, i) {
  const cuota = Math.round(p.precio / 3)
  return `
        <div class="js-item-product col-6 col-md-3 item item-product" data-product-type="list"
             onclick="location.href='producto.html?p=${i}'">
          <div class="item-image mb-2">
            ${p.etiqueta ? `<span class="item-label${p.etiqueta === 'OFERTA' ? ' item-label-sale' : ''}">${p.etiqueta}</span>` : ''}
            <img class="js-item-image" src="${foto(p.foto, 'FOTO ' + String(i + 1).padStart(2, '0'))}" alt="${p.nombre}">
          </div>
          <div class="item-description">
            <a href="producto.html?p=${i}" class="item-link">
              <div class="js-item-name item-name mb-1">${p.nombre}</div>
              <div class="item-price-container mb-1">
                ${p.antes ? `<span class="item-price-compare">${pesos(p.antes)}</span> ` : ''}
                <span class="js-price-display item-price">${pesos(p.precio)}</span>
              </div>
            </a>
            <span class="item-installments">3 cuotas sin interes de ${pesos(cuota)}</span>
          </div>
        </div>`
}

/* ---------------------------------------------------------------------------
   5. Categoria
   --------------------------------------------------------------------------- */

function paginaCategoria(settings) {
  return `${CABEZA('Nuevos ingresos')}
<body class="template-category">
${CABECERA(settings)}

  <section class="category-header mt-4 section-margin">
    <div class="container">
      <div class="row">
        <div class="col text-center">
          <section class="page-header mt-3">
            <div class="container">
              <div class="row">
                <div class="col text-center col-lg-6 offset-lg-3">
                  <h1>Nuevos ingresos</h1>
                  <p class="page-header-text font-md-normal">Lo ultimo que entro a los tres locales. Todo con 20% off pagando en efectivo.</p>
                  <div class="divider col-2 offset-5 background-primary"></div>
                </div>
              </div>
            </div>
          </section>
        </div>
      </div>
    </div>
  </section>

  <section class="category-body">
  <div class="container">
${RIEL}
    <div class="js-category-controls-prev category-controls-sticky-detector"></div>
    <div class="js-category-controls row align-items-center mb-md-3 category-controls">
      <div class="col-6 col-md-9">
        <a href="#" class="js-panel filter-link" data-toggle="#nav-filters">Filtrar ${ICONO.filtro}</a>
      </div>
      <div class="col-6 col-md-3 text-right">
        <div class="form-group mb-0" style="position:relative;display:inline-block">
          <select class="js-sort-by form-control" aria-label="Ordenar por:">
            <option>Destacado</option>
            <option>Precio: Menor a Mayor</option>
            <option>Precio: Mayor a Menor</option>
            <option>Mas Nuevo al mas Viejo</option>
          </select>
          <span style="position:absolute;right:0;top:50%;transform:translateY(-50%);pointer-events:none">&#9662;</span>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-12 mb-3 lu-aplicados">
        <div class="d-md-inline-block mr-md-2 mb-3">Filtrado por:</div>
        <button class="js-remove-filter chip">Talle M ${ICONO.cerrar}</button>
        <button class="js-remove-filter chip">Negro ${ICONO.cerrar}</button>
        <a href="#" class="js-remove-all-filters d-inline-block px-0">Borrar filtros</a>
      </div>
    </div>
  </div>
  </section>

  <div class="container" style="padding:0">
    <div class="js-product-table row">${PRODUCTOS.map(tarjeta).join('')}
    </div>
  </div>

  <div class="container">
    <section class="lu-seccion">
      <span class="lu-rotulo lu-micro">Harness local · papel ${settings.background_color} · tinta ${settings.text_color} · acento ${settings.accent_color}</span>
    </section>
  </div>
${PIE}
${FILTROS}
${PANELES}
</body>
</html>
`
}

/* ---------------------------------------------------------------------------
   6. Ficha de producto
   Replica el DOM de templates/product.tpl + snipplets/product/*.
   --------------------------------------------------------------------------- */

function paginaProducto(settings) {
  const galeria = PRODUCTOS.map(
    (p, i) => `
    <div class="ficha" data-p="${i}" hidden>
      <div class="detalle js-product-detail js-product-container">
      <div class="row section-single-product">
        <div class="col-12 col-md-7 px-0 px-md-3">
          <div class="product-image-container col-12 p-0">
            <img class="product-slider-image" src="${foto(p.foto, 'FOTO PRINCIPAL', 800, 1000)}" alt="${p.nombre}">
          </div>
          <div class="tiras">
            <img src="${foto(p.foto, 'DETALLE', 400, 500)}" alt="">
            <img src="${foto('#C9C3B7', 'ESPALDA', 400, 500)}" alt="">
          </div>
        </div>
        <div class="col">
          <h1>${p.nombre}</h1>
          <div class="js-price-container price-container">
            ${p.antes ? `<p class="js-compare-price-display price-compare mb-0">${pesos(p.antes)}</p>` : ''}
            <p class="js-price-display mb-0">${pesos(p.precio)}</p>
          </div>
          <span class="item-installments">3 cuotas sin interes de ${pesos(Math.round(p.precio / 3))}</span>

          <div class="lu-variantes">
            <span class="lu-rotulo">Talle</span>
            <div class="lu-talles">
              ${['1', '2', '3', '4'].map((t, j) => `<button class="lu-talle${j === 1 ? ' activo' : ''}">${t}</button>`).join('')}
            </div>
          </div>

          <input type="submit" class="js-addtocart btn btn-primary btn-block" value="Agregar al carrito">

          <div class="product-description user-content">
            <p>Prenda de la nueva temporada, disponible en los tres locales de Lomas de Zamora y Banfield. Asesoramiento personalizado para encontrar tu talle.</p>
            <p>Este texto es de relleno: la descripcion real la carga la clienta desde el panel de Tiendanube.</p>
          </div>

          <hr class="lu-regla" style="margin:1.5rem 0">
          <span class="lu-rotulo">20% off abonando en efectivo</span>
        </div>
      </div>
      </div>
    </div>`
  ).join('')

  return `${CABEZA('Producto')}
<body class="template-product">
  <style>
    .tiras { display: grid; grid-template-columns: 1fr 1fr; gap: 1px; margin-top: 1px; }
    .tiras img { display: block; width: 100%; height: auto; }
    .product-slider-image { display: block; width: 100%; height: auto; }
    .section-single-product { display: grid; grid-template-columns: 1fr; gap: 2rem; }
    @media (min-width: 768px) {
      .section-single-product { grid-template-columns: 7fr 5fr; gap: clamp(2rem, 4vw, 4rem); }
    }
    .lu-variantes { margin: 1.5rem 0; }
    .lu-talles { display: flex; gap: 1px; margin-top: .6rem; }
    .lu-talle { font: 400 .72rem 'Roboto Mono', monospace; letter-spacing: .08em;
                background: var(--lu-papel); color: var(--lu-tinta);
                border: 1px solid var(--lu-tinta); padding: .7rem 1.1rem; cursor: pointer; }
    .lu-talle.activo, .lu-talle:hover { background: var(--lu-tinta); color: var(--lu-papel); }
    .volver { display: inline-block; margin: 1.25rem 0; }
  </style>

${CABECERA(settings)}
  <div class="container">
    <a href="categoria.html" class="lu-rotulo lu-micro volver" style="color:var(--lu-tinta);text-decoration:none">&#8592; Volver a nuevos ingresos</a>
    ${galeria}
  </div>

  <script>
    // Muestra la prenda que se clickeo en la grilla (?p=N)
    const n = Number(new URLSearchParams(location.search).get('p') || 0)
    const fichas = [...document.querySelectorAll('.ficha')]
    const elegida = fichas.find(f => Number(f.dataset.p) === n) || fichas[0]
    elegida.hidden = false

    // En la tienda hay una sola ficha por pagina y lleva id="single-product".
    // Aca estan las doce en el mismo archivo, asi que el id — del que cuelga el
    // CSS que acota el h1 — se le pone solo a la visible: repetirlo doce veces
    // seria HTML invalido.
    elegida.querySelector('.detalle').id = 'single-product'

    // Selector de talle
    elegida.querySelectorAll('.lu-talle').forEach(b => b.addEventListener('click', () => {
      elegida.querySelectorAll('.lu-talle').forEach(o => o.classList.remove('activo'))
      b.classList.add('activo')
    }))
  </script>
${PIE}
${PANELES}
</body>
</html>
`
}

/* ---------------------------------------------------------------------------
   7. Home: el hero con las fotos que se pasan solas.
   Replica el DOM de snipplets/home/home-slider.tpl con sus clases reales. En la
   tienda esto lo mueve Swiper; aca lo mueve un puñado de lineas, que alcanza
   para ver el ritmo, el contraste y el contador.
   --------------------------------------------------------------------------- */

/* `color` replica el selector de color de texto que la clienta tiene en el
   panel por slide (blanco/negro, ver home-slider.tpl -> slide.color). La foto
   de playa (hero-01) es clara justo donde cae el titulo: con blanco se pierde
   (probado en pantalla el 2026-09-11), asi que va en negro. */
const SLIDES = [
  { titulo: 'Nueva temporada', desc: 'Primavera 26 · Ya en los tres locales', boton: 'Ver lo nuevo', foto: 'img/hero-01.jpg', color: 'black' },
  { titulo: '20% off', desc: 'Abonando en efectivo', boton: 'Ver la tienda', foto: 'img/hero-02.jpg', color: 'white' },
  { titulo: 'Ahi! Lupita', desc: 'Ropa de mujer en tres locales', boton: 'Ver la tienda', foto: 'img/hero-03.jpg', color: 'white' },
  { titulo: '3 y 6 cuotas', desc: 'Sin interes con todas las tarjetas', boton: 'Comprar ahora', foto: 'img/hero-04.jpg', color: 'white' },
]

function paginaHome(settings) {
  const slides = SLIDES.map(
    (s, i) => `
          <div class="swiper-slide slide-container${i === 0 ? ' activo' : ''}">
            <div class="slider-slide">
              <img class="slider-image" src="${imagenSrc(s.foto, 'CAMPANA ' + (i + 1), 1600, 900)}" alt="">
              <div class="swiper-text swiper-${s.color}">
                <div class="swiper-title h1">${s.titulo}</div>
                <div class="swiper-description h5 font-weight-normal mt-3">${s.desc}</div>
                <a href="categoria.html" class="btn btn-small swiper-btn mt-4">${s.boton}</a>
              </div>
            </div>
          </div>`
  ).join('')

  const bullets = SLIDES.map((_, i) =>
    `<span class="swiper-pagination-bullet${i === 0 ? ' swiper-pagination-bullet-active' : ''}"></span>`
  ).join('')

  const destacados = PRODUCTOS.slice(0, 4).map(tarjeta).join('')

  /* home_order_position_2 = categories -> home-banners.tpl del base, 3
     banners con foto que la clienta carga desde el panel (Diseño -> Banners
     de categorias). Nombres de demo = las secciones reales del riel, no
     "denim/blusas/accesorios" de la referencia que trajo Santiago. */
  const CATEGORIAS = [
    { titulo: 'Vestidos', foto: 'img/hero-02.jpg', url: 'categoria.html' },
    { titulo: 'Pantalones', foto: 'img/hero-04.jpg', url: 'categoria.html' },
    { titulo: 'Abrigos', foto: 'img/hero-03.jpg', url: 'categoria.html' },
  ]
  const categorias = CATEGORIAS.map(
    (c) => `
      <div class="col-md">
        <div class="textbanner">
          <a class="textbanner-link" href="${c.url}" title="${c.titulo}" aria-label="${c.titulo}">
            <div class="textbanner-image overlay">
              <img src="${imagenSrc(c.foto, c.titulo, 600, 800)}" class="textbanner-image-background" alt="${c.titulo}">
            </div>
            <div class="textbanner-text over-image">
              <div class="h1 textbanner-title">${c.titulo}</div>
            </div>
          </a>
        </div>
      </div>`
  ).join('')

  return `${CABEZA('Home')}
<body class="template-home">
  <style>
    /* Andamio: en la tienda esto lo hace Swiper. */
    .swiper-wrapper { position: relative; height: 100%; }
    .swiper-slide { position: absolute; inset: 0; opacity: 0; z-index: 0; }
    .swiper-slide.activo { opacity: 1; z-index: 1; }
    .swiper-button-prev, .swiper-button-next { position: absolute; top: 50%; transform: translateY(-50%);
      color: #F4F4F0; font: 400 1.5rem 'Roboto Mono', monospace; mix-blend-mode: difference;
      cursor: pointer; user-select: none; padding: 1rem; }
    .swiper-button-prev { left: .5rem; } .swiper-button-next { right: .5rem; }
    .swiper-btn { text-decoration: none; }
    .swiper-pagination-bullet { cursor: pointer; }
  </style>

${CABECERA(settings)}

  <div class="js-home-main-slider-container">
    <div class="js-home-main-slider-visibility section-slider">
      <div class="js-home-slider nube-slider-home swiper-container swiper-container-horizontal">
        <div class="swiper-wrapper">${slides}
        </div>
        <div class="js-swiper-home-control swiper-pagination swiper-pagination-bullets">${bullets}</div>
        <div class="swiper-button-prev">&#8592;</div>
        <div class="swiper-button-next">&#8594;</div>
      </div>
    </div>
  </div>

  <div class="container">
    <section class="lu-seccion">
      <div class="lu-seccion-titulo">
        <span class="lu-rotulo">Destacados</span>
        <hr class="lu-regla" style="flex:1">
        <a href="categoria.html" class="lu-rotulo" style="color:var(--lu-tinta);text-decoration:none">Ver todo &#8594;</a>
      </div>
    </section>
  </div>

  <div class="container" style="padding:0">
    <div class="js-product-table row">${destacados}
    </div>
  </div>

  <section class="section-banners-home">
    <div class="container-fluid p-0">
      <div class="row no-gutters align-items-center">${categorias}
      </div>
    </div>
  </section>

${PIE}
${PANELES}

  <script>
    const slides = [...document.querySelectorAll('.swiper-slide')]
    const bullets = [...document.querySelectorAll('.swiper-pagination-bullet')]
    let i = 0

    function mostrar(n) {
      slides[i].classList.remove('activo')
      bullets[i].classList.remove('swiper-pagination-bullet-active')
      i = (n + slides.length) % slides.length
      slides[i].classList.add('activo')
      bullets[i].classList.add('swiper-pagination-bullet-active')
    }

    let reloj = setInterval(() => mostrar(i + 1), 5000)

    // Al tocar una flecha se reinicia el reloj, como hace Swiper
    function manual(n) { clearInterval(reloj); mostrar(n); reloj = setInterval(() => mostrar(i + 1), 5000) }

    document.querySelector('.swiper-button-next').addEventListener('click', () => manual(i + 1))
    document.querySelector('.swiper-button-prev').addEventListener('click', () => manual(i - 1))
    bullets.forEach((b, n) => b.addEventListener('click', () => manual(n)))
  </script>
</body>
</html>
`
}

/* ---------------------------------------------------------------------------
   8. Banco de dispositivos
   Cada iframe tiene su propio viewport, asi que las media queries responden al
   ancho REAL declarado; el scale es solo para que entren todos en la pantalla.
   Un 1920 escalado a 0.32 sigue siendo un 1920 para el CSS de adentro.
   --------------------------------------------------------------------------- */

const DISPOSITIVOS = [
  { ancho: 320, alto: 800, escala: 1, rotulo: '320 · iPhone SE (el piso real)' },
  { ancho: 390, alto: 800, escala: 1, rotulo: '390 · iPhone' },
  { ancho: 430, alto: 800, escala: 1, rotulo: '430 · iPhone Pro Max' },
  { ancho: 768, alto: 900, escala: 0.62, rotulo: '768 · iPad vertical' },
  { ancho: 1024, alto: 900, escala: 0.52, rotulo: '1024 · iPad horizontal' },
  { ancho: 1280, alto: 900, escala: 0.44, rotulo: '1280 · notebook' },
  { ancho: 1920, alto: 1000, escala: 0.32, rotulo: '1920 · monitor grande' },
]

function paginaDispositivos() {
  const marco = (pagina, d) => `
      <figure style="margin:0">
        <figcaption>${d.rotulo}</figcaption>
        <div class="visor" style="width:${Math.round(d.ancho * d.escala)}px;
                                  height:${Math.round(d.alto * d.escala)}px">
          <iframe src="${pagina}" width="${d.ancho}" height="${d.alto}"
                  style="transform:scale(${d.escala})"></iframe>
        </div>
      </figure>`

  const fila = (titulo, pagina) => `
    <h2>${titulo}</h2>
    <div class="banco">${DISPOSITIVOS.map((d) => marco(pagina, d)).join('')}</div>`

  return `<!DOCTYPE html>
<html lang="es"><head><meta charset="utf-8">
<title>Dispositivos — harness Ahi! Lupita</title>
<link href="https://fonts.googleapis.com/css2?family=Roboto+Mono:wght@400;700&display=swap" rel="stylesheet">
<style>
  body { margin:0; padding:1.5rem; background:#cfccc5;
         font:400 11px 'Roboto Mono', monospace; }
  h2 { font:700 12px 'Roboto Mono', monospace; letter-spacing:.12em;
       text-transform:uppercase; margin:1.5rem 0 .75rem; }
  h2::before { content:'[ '; } h2::after { content:' ]'; }
  .banco { display:flex; gap:1.25rem; align-items:flex-start; flex-wrap:wrap; }
  figcaption { letter-spacing:.06em; text-transform:uppercase;
               margin-bottom:.4rem; white-space:nowrap; }
  .visor { overflow:hidden; border:1px solid #0A0A0A; background:#F4F4F0; }
  .visor iframe { border:0; transform-origin:top left; display:block; }
  nav { margin-bottom:1rem; }
  nav a { color:#0A0A0A; letter-spacing:.06em; text-transform:uppercase; margin-right:1rem; }
</style>
</head><body>
<nav><a href="home.html">Home</a><a href="categoria.html">Categoria</a><a href="producto.html">Producto</a></nav>
${fila('Home', 'home.html')}
${fila('Categoria', 'categoria.html')}
${fila('Producto', 'producto.html')}
</body></html>
`
}

/* ---------------------------------------------------------------------------
   9. Escribir
   --------------------------------------------------------------------------- */

const settings = leerDefaults()
mkdirSync(SALIDA, { recursive: true })
writeFileSync(join(SALIDA, 'lupita.css'), compilarCss(settings))
writeFileSync(join(SALIDA, 'categoria.html'), paginaCategoria(settings))
writeFileSync(join(SALIDA, 'producto.html'), paginaProducto(settings))
writeFileSync(join(SALIDA, 'home.html'), paginaHome(settings))
writeFileSync(join(SALIDA, 'dispositivos.html'), paginaDispositivos())

/* Fotos reales del hero (ver imagenSrc): se copian tal cual a out/img. */
const IMG_ORIGEN = join(AQUI, 'img')
if (existsSync(IMG_ORIGEN)) {
  cpSync(IMG_ORIGEN, join(SALIDA, 'img'), { recursive: true })
}

console.log('OK ->', SALIDA)
console.log('   papel', settings.background_color, '| tinta', settings.text_color, '| acento', settings.accent_color)
console.log('   macro', settings.font_headings, '| micro', settings.font_rest)
