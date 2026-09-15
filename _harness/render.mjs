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
  <link href="https://fonts.googleapis.com/css2?family=Archivo+Black&family=Bodoni+Moda:opsz,wght@6..96,400..700&family=Great+Vibes&family=Instrument+Sans:wght@400;600;700&family=Roboto+Mono:wght@300;400;700&display=swap" rel="stylesheet">
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
    /* style-critical + style-async: el aire entre campos de forms/form-input.tpl
       (%element-margin de style-async es 35px). Sin esto el harness pegaba
       cada rotulo a la caja de arriba, y en la tienda no pasa. */
    .form-group { position: relative; width: 100%; margin-bottom: 35px; }
    .form-group .form-label { float: left; width: 100%; margin-bottom: 10px; }
    /* style-critical #Blog: el base le fija 200px de alto a la caja de la foto
       y line-clamp de 3 al titulo y resumen */
    .post-item-image-container { position: relative; height: 200px; overflow: hidden; }
    .post-item-image { width: 100%; height: 100%; object-fit: cover; }
    .post-item-title, .post-item-summary { display: -webkit-box; -webkit-box-orient: vertical; -webkit-line-clamp: 3; overflow: hidden; text-overflow: ellipsis; line-height: 1.5em; }
    /* style-critical: lista de contact-links.tpl */
    .contact-info { margin-top: 0; padding-left: 0; }
    .contact-item { list-style: none; }
    /* style-critical: la columna angosta de la nota del blog */
    @media (min-width: 768px) { .container-narrow { max-width: 680px; } }
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
    .text-center { text-align: center !important; }
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

    /* Theme base: titulos por clase (style-critical). Importan porque varias
       piezas llegan con class="h1"/"h5"/"h6" y no con el elemento: el nombre
       en compra rapida, el total de la notificacion, los subtotales. */
    h1, .h1 { font-size: 28px; font-weight: 700; }
    h2, .h2 { font-size: 24px; font-weight: 700; }
    h3, .h3 { font-size: 20px; font-weight: 700; }
    h4, .h4 { font-size: 18px; font-weight: 700; }
    h5, .h5 { font-size: 16px; font-weight: 700; }
    h6, .h6 { font-size: 14px; font-weight: 700; }
    p { margin-top: 0; line-height: 22px; }
    @media (min-width: 768px) { .h4-md { font-size: 18px; font-weight: 700; } }

    /* Theme base: WhatsApp flotante y notificacion del carrito
       (style-critical + style-async), tal cual, para ver lo que la hoja
       les cambia encima. */
    .btn-whatsapp { position: fixed; bottom: 10px; right: 10px; z-index: 100; color: #fff;
                    background-color: #4dc247; box-shadow: 2px 2px 6px rgba(0,0,0,.4); border-radius: 50%; }
    .btn-whatsapp svg { width: 45px; height: 45px; padding: 10px; fill: #fff; vertical-align: middle; }
    .notification { padding: 10px; text-align: center; }
    .notification-floating { position: absolute; top: 100%; right: 15px; z-index: 2000;
                             width: calc(100% - 30px); margin-top: -20px; }
    .notification-floating .notification { box-shadow: 0 0 5px 0 rgba(0,0,0,.1), 0 2px 3px 0 rgba(0,0,0,.06); }
    @media (min-width: 768px) { .notification-floating .notification { width: 350px; } }
    .notification-hidden { transition: all .1s cubic-bezier(.16,.68,.43,.99); transform: rotatex(90deg); pointer-events: none; }
    .notification-visible { transition: all .5s cubic-bezier(.16,.68,.43,.99); transform: rotatex(0deg); }
    .notification-close { position: absolute; top: 5px; right: 10px; z-index: 1; font-size: 20px; cursor: pointer; }
    .notification-fixed-bottom { position: fixed; bottom: 0; left: 0; z-index: 999; width: 100%; }
    .notification-secondary { padding: 12px 0; background: #e8e8e4; color: rgba(10,10,10,.8); border-bottom: 1px solid rgba(10,10,10,.1); }
    .mb-md-0 { }
    .float-right { float: right; }
    .col-3 { flex: 0 0 25%; max-width: 25%; }
    .col-9 { flex: 0 0 75%; max-width: 75%; }
    .col-auto { flex: 0 0 auto; width: auto; max-width: 100%; }
    .pr-0 { padding-right: 0; }
    .mr-3 { margin-right: 1rem !important; }
    .mb-3 { margin-bottom: 1rem !important; }
    .mt-2 { margin-top: .5rem; }

    /* Theme base: banners y modulos (style-critical). Ojo con el padding-top
       100%: el base arma el alto de la foto asi, y la hoja lo tiene que
       apagar para que el aspect-ratio mande. */
    .textbanner { position: relative; margin-bottom: 20px; overflow: hidden; }
    .textbanner-image { position: relative; padding-top: 100%; background-size: cover; }
    .textbanner-image-background { position: absolute; top: 0; width: 100%; height: 100%; object-fit: cover; }
    .textbanner-text { position: relative; padding: 0 5% 45px 5%; text-align: center; }
    .textbanner-text.over-image { position: absolute; top: 50%; left: 50%; z-index: 9; width: 100%;
                                  color: #fff; transform: translate(-50%, -50%); }
    .textbanner-title { margin-bottom: 15px; line-height: 34px; }
    .textbanner-paragraph { display: -webkit-box; margin-bottom: 15px; line-height: 18px; overflow: hidden;
                            text-overflow: ellipsis; -webkit-line-clamp: 3; -webkit-box-orient: vertical; }
    @media (min-width: 768px) { .order-md-2 { order: 2; } }

    /* Theme base: bienvenida, servicios e Instagram (style-critical + async) */
    .section-welcome-home { padding: 70px 0; text-align: center; }
    .welcome-title { margin-bottom: 15px; text-transform: uppercase; }
    .welcome-text { line-height: 18px; }
    @media (min-width: 768px) { .offset-md-2 { margin-left: 16.666667%; }
                                .col-md-8 { flex: 0 0 66.666667%; max-width: 66.666667%; } }
    .section-informative-banners { padding: 50px 0; text-align: center; }
    .service-icon { margin: 10px 0; }
    .service-title { margin: 0 0 5px 0; }
    .service-pagination { position: relative; margin-top: 5px; }
    .swiper-wrapper { display: flex; }
    .service-item-container { flex: 0 0 100%; max-width: 100%; }
    @media (min-width: 768px) { .service-item-container.col-md { flex: 1 0 0%; max-width: 100%; } }
    .swiper-pagination-bullet { display: inline-block; width: 8px; height: 8px; border-radius: 50%; background: #000; opacity: .2; margin: 0 4px; }
    .swiper-pagination-bullet-active { opacity: 1; }
    .col-md-auto { flex: 0 0 100%; max-width: 100%; }
    @media (min-width: 768px) { .col-md-auto { flex: 0 0 auto; width: auto; max-width: 100%; } }
    .instafeed-user { display: inline-block; margin: 0 0 0 5px; line-height: 24px; vertical-align: top; }
    .instafeed-link { position: relative; display: block; padding-top: 100%; overflow: hidden; }
    .instafeed-link .instafeed-img { position: absolute; top: 0; width: 100%; height: 100%; object-fit: cover;
                                     transition: all .8s ease; }
    .col-4 { flex: 0 0 33.333333%; max-width: 33.333333%; }
    .icon-3x { width: 3em; height: 3em; }

    /* Theme base: paginas institucionales y migas */
    .user-content ul { padding-left: 20px; }
    .user-content ul li { margin-bottom: 10px; line-height: 22px; }
    .page-header-text { margin: .5rem 0 0 0; font-size: 12px; text-align: center; }
    @media (min-width: 768px) { .justify-content-md-center { justify-content: center; } }

    /* Theme base: pagina del carrito (Bootstrap + style-critical). Las
       utilidades llevan !important como en Bootstrap 4, porque justamente
       eso es lo que la hoja tiene que pelear. */
    .col-1 { flex: 0 0 8.333333%; max-width: 8.333333%; }
    .col-5 { flex: 0 0 41.666667%; max-width: 41.666667%; }
    .col-7 { flex: 0 0 58.333333%; max-width: 58.333333%; }
    .col-10 { flex: 0 0 83.333333%; max-width: 83.333333%; }
    @media (min-width: 768px) {
      .col-md-1 { flex: 0 0 8.333333%; max-width: 8.333333%; }
      .col-md-11 { flex: 0 0 91.666667%; max-width: 91.666667%; }
      .col-md-3 { flex: 0 0 25%; max-width: 25%; }
      .col-md-5 { flex: 0 0 41.666667%; max-width: 41.666667%; }
      .col-md-6 { flex: 0 0 50%; max-width: 50%; }
      .col-md-7 { flex: 0 0 58.333333%; max-width: 58.333333%; }
      .position-sticky-md { position: sticky !important; }
      .text-md-center { text-align: center !important; }
      .text-md-left { text-align: left !important; }
      .justify-content-md-end { justify-content: flex-end !important; }
      .justify-content-md-center { justify-content: center !important; }
      .float-md-none { float: none !important; }
      .mt-md-0 { margin-top: 0 !important; }
      .mb-md-0 { margin-bottom: 0 !important; }
    }
    .justify-content-end { justify-content: flex-end !important; }
    .align-items-md-center { align-items: center; }
    .m-auto { margin: auto !important; }
    .mx-0 { margin-left: 0 !important; margin-right: 0 !important; }
    .mb-5 { margin-bottom: 3rem !important; }
    .mb-2 { margin-bottom: .5rem !important; }
    .mt-4 { margin-top: 1.5rem !important; }
    .text-right { text-align: right !important; }
    .btn-block { display: block; width: 100%; }
  </style>
  <link rel="stylesheet" href="lupita.css">
</head>`

/** Replica el split por "—" de header-advertising.tpl: con mas de un
 * mensaje, arma el ticker de steps(N); con uno solo, lo deja estatico. */
/* Replica snipplets/header/header-advertising.tpl: marquesina con dos grupos */
function adBar(texto) {
  const partes = texto.split('—').map((p) => p.trim()).filter(Boolean)
  const grupo = (oculto) => `<div class="ad-marquee-grupo"${oculto ? ' aria-hidden="true"' : ''}>${partes.map((p) => `<span class="ad-msg">${p}</span>`).join('')}</div>`
  return `<div class="ad-marquee"><div class="ad-marquee-track" style="animation-duration: ${partes.length * 7}s;">${grupo(false)}${grupo(true)}</div></div>`
}

/* Cabecera real del theme: snipplets/header/header.tpl mas la barra de aviso.
   Las tres columnas (hamburguesa / logo / utilidades) son las del base. */
const CABECERA = (settings, extra = '') => `
    ${settings.ad_bar === '1' && settings.ad_text_es ? `
    <section class="section-advertising">${adBar(settings.ad_text_es)}</section>` : ''}
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
              <!-- snipplets/header/header.tpl con lupita_logo_marca: el "A!" del .ai en turquesa -->
              <a href="home.html" class="lu-logo-marca" title="Ahí! Lupita">${readFileSync(join(RAIZ, 'snipplets', 'svg', 'logo-lupita.tpl'), 'utf8').replace(/\{#[\s\S]*?#\}/g, '').replace('{{ svg_custom_class }}', '').replace('{{ store.name }}', 'Ahí! Lupita').trim()}</a>
            </div>
          </div>
          <div class="col text-right">
            <div class="utilities-container">
              <div class="utilities-item">
                <a href="#" class="js-panel utilities-link" data-toggle="#nav-search" aria-label="Buscador">${ICONO.lupa}</a>
              </div>
              <div class="utilities-item js-favs-acceso" hidden>
                <a href="#" class="js-panel utilities-link lu-favs-link" data-toggle="#modal-favoritos" aria-label="Favoritos">${ICONO.corazon}<span class="js-favs-cantidad lu-favs-cantidad">0</span></a>
              </div>
              <div class="utilities-item">
                <div id="ajax-cart" class="cart-summary">
                  <a href="#" class="js-panel" data-toggle="#modal-cart">${ICONO.bolsa}<span class="cart-widget-amount">2</span></a>
                </div>
              </div>
            </div>
          </div>
        </div>${extra}
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
  whatsapp: '<svg class="icon-inline icon-2x" viewBox="0 0 448 512" aria-hidden="true"><path d="M380 105A221 221 0 0 0 32 371L0 486l118-31a221 221 0 0 0 106 27c122 0 224-99 224-221 0-59-25-114-68-156zm-156 340c-33 0-65-9-94-26l-7-4-70 18 19-68-4-7a184 184 0 1 1 156 87zm101-138c-6-3-33-16-38-18s-9-3-12 3-14 18-17 21-6 4-12 1-23-9-44-27c-16-15-27-33-30-38s0-9 2-11l8-10c3-3 4-6 6-9s1-7 0-10-12-30-17-41c-4-11-9-9-12-9h-11a21 21 0 0 0-15 7c-5 6-20 20-20 48s21 56 23 60 41 62 99 87c38 16 51 18 68 15 11-2 33-13 38-26s5-24 3-26-5-4-11-7z"/></svg>',
  instagram: '<svg class="icon-inline icon-3x align-top svg-icon-text" viewBox="0 0 448 512" aria-hidden="true"><path d="M224 141a115 115 0 1 0 0 230 115 115 0 0 0 0-230zm0 190a75 75 0 1 1 0-150 75 75 0 0 1 0 150zm146-195a27 27 0 1 1-54 0 27 27 0 0 1 54 0zm76 27c-2-36-10-68-36-94s-58-34-94-36c-37-2-148-2-185 0-36 2-68 10-94 36S3 127 1 163c-2 37-2 148 0 185 2 36 10 68 36 94s58 34 94 36c37 2 148 2 185 0 36-2 68-10 94-36s34-58 36-94c2-37 2-148 0-185zm-48 225a76 76 0 0 1-43 43c-30 12-100 9-133 9s-103 3-133-9a76 76 0 0 1-43-43c-12-30-9-100-9-133s-3-103 9-133a76 76 0 0 1 43-43c30-12 100-9 133-9s103-3 133 9a76 76 0 0 1 43 43c12 30 9 100 9 133s3 103-9 133z"/></svg>',
  corazon: '<svg class="icon-inline" viewBox="0 0 512 512" aria-hidden="true"><path d="M458.4 64.3C400.6 15.7 311.3 23 256 79.3 200.7 23 111.4 15.6 53.6 64.3-21.6 127.6-10.6 230.8 43 285.5l175.4 178.7c10 10.2 23.4 15.9 37.6 15.9 14.3 0 27.6-5.6 37.6-15.8L469 285.6c53.5-54.7 64.7-157.9-10.6-221.3zm-23.6 187.5L259.4 430.5c-2.4 2.4-4.4 2.4-6.8 0L77.2 251.8c-36.5-37.2-43.9-107.6 7.3-150.7 38.9-32.7 98.9-27.8 136.5 10.5l35 35.7 35-35.7c37.8-38.5 97.8-43.2 136.5-10.6 51.1 43.1 43.5 113.9 7.3 150.8z"/></svg>',
  corazonVacio: '<svg class="lu-fav-vacio" aria-hidden="true" viewBox="0 0 512 512"><path d="M458.4 64.3C400.6 15.7 311.3 23 256 79.3 200.7 23 111.4 15.6 53.6 64.3-21.6 127.6-10.6 230.8 43 285.5l175.4 178.7c10 10.2 23.4 15.9 37.6 15.9 14.3 0 27.6-5.6 37.6-15.8L469 285.6c53.5-54.7 64.7-157.9-10.6-221.3zm-23.6 187.5L259.4 430.5c-2.4 2.4-4.4 2.4-6.8 0L77.2 251.8c-36.5-37.2-43.9-107.6 7.3-150.7 38.9-32.7 98.9-27.8 136.5 10.5l35 35.7 35-35.7c37.8-38.5 97.8-43.2 136.5-10.6 51.1 43.1 43.5 113.9 7.3 150.8z"/></svg>',
  corazonLleno: '<svg class="lu-fav-lleno" aria-hidden="true" viewBox="0 0 512 512"><path d="M462.3 62.6C407.5 15.9 326 24.3 275.7 76.2L256 96.5l-19.7-20.3C186.1 24.3 104.5 15.9 49.7 62.6c-62.8 53.6-66.1 149.8-9.9 207.9l193.5 199.8c12.5 12.9 32.8 12.9 45.3 0l193.5-199.8c56.3-58.1 53-154.3-9.8-207.9z"/></svg>',
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
            <button type="button" class="btn h6 m-0 lu-quitar" aria-label="Quitar ${p.nombre}">${ICONO.tacho}<span class="lu-quitar-texto" aria-hidden="true">Quitar</span></button>
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
            <div class="h2 row no-gutters text-primary mb-0 lu-tarjeta">
              <span class="col mr-1">Total con tarjeta:</span>
              <span class="js-cart-total col text-right">${pesos(TOTAL_CARRITO)}</span>
            </div>
            <div class="total-price hidden">Total: ${pesos(TOTAL_CARRITO)}</div>
            <!-- DEDUCIDO: component('payment-discount-price') no esta publicado; clases que le pasa cart-totals.tpl -->
            <div class="js-payment-discount-price-cart-container lu-efectivo mt-1 text-right"><span class="lu-efectivo-precio">${pesos(Math.round(TOTAL_CARRITO * 0.8))}</span> <span class="lu-efectivo-medio">con Efectivo</span></div>
          </div>

          <div class="js-visible-on-cart-filled container-fluid">
            ${pagosHtml('compacto')}
            <div class="js-ajax-cart-submit row mb-3">
              <input class="btn btn-primary btn-block" type="submit" name="go_to_checkout" value="Iniciar Compra">
            </div>
          </div>
        </div>
      </div>
    </form>
  </div>`

/* whatsapp-chat.tpl: el boton flotante, en todas las paginas. El numero es
   un pendiente de la clienta, asi que el href no va a ningun lado. */
const WHATSAPP = `
  <a href="https://wa.me/5491128622903" target="_blank" rel="noopener" class="js-btn-fixed-bottom btn-whatsapp" aria-label="Comunicate por WhatsApp">${ICONO.whatsapp}</a>`

const PANELES = `
${WHATSAPP}
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
              <li><a class="nav-list-link" href="sobre-nosotros.html">Sobre nosotros</a></li>
              <li><a class="nav-list-link" href="preguntas-frecuentes.html">Preguntas frecuentes</a></li>
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

  <!-- Favoritos: header.tpl + snipplets/favoritos/panel.tpl. Direccion y numero de demo. -->
  <div id="modal-favoritos" class="js-modal modal modal-favoritos modal-right transition-slide modal-docked-md" style="display:none">
    <div class="modal-with-fixed-footer">
      <div class="modal-scrollable-area">
        <div class="js-modal-close modal-header"><span class="modal-close">${ICONO.cerrar}</span>Guardá y probate</div>
        <div class="modal-body">
          <div class="lu-favs">
            <div class="lu-favs-local">
              <p class="lu-favs-titulo">Vení a probártelas</p>
              <ul class="lu-favs-direcciones list-unstyled">${tiendasItems('lu-favs-direccion')}</ul>
              <a href="${leerDefaults().lupita_tiendas_url_es}" target="_blank" rel="noopener" class="lu-tiendas-link lu-tiendas-favs">Conocer las tiendas</a>
            </div>
            <ul class="js-favs-lista lu-favs-lista list-unstyled"></ul>
            <p class="js-favs-vacio lu-favs-vacio">Todavía no guardaste nada. Tocá el corazón en las prendas que quieras probarte.</p>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <a href="https://wa.me/5491128622903" data-base="https://wa.me/5491128622903" target="_blank" rel="noopener" class="js-favs-whatsapp btn btn-primary btn-block lu-favs-whatsapp" hidden>Reservar para probármelas</a>
      </div>
    </div>
  </div>

  <div class="js-fav-aviso lu-fav-aviso" role="status" aria-live="polite" hidden>
    <span>Guardada. Probátela en cualquiera de nuestras tiendas</span>
    <a href="#" class="js-panel lu-fav-aviso-link" data-toggle="#modal-favoritos">Ver favoritos</a>
  </div>

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
  </script>
  <script src="lupita-favoritos.js"></script>
${(() => {
  /* snipplets/volver-arriba.tpl tal cual, sin el comentario Twig */
  const p = join(RAIZ, 'snipplets', 'volver-arriba.tpl')
  return existsSync(p) ? readFileSync(p, 'utf8').replace(/\{#[\s\S]*?#\}/g, '').replace(/\{\{\s*'([^']*)'\s*\|\s*translate\s*\}\}/g, '$1') : ''
})()}`

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
          <!-- snipplets/canal-difusion.tpl. En la tienda no sale hasta cargar el
               link; aca se muestra con "#" para ver el bloque. -->
          <div class="newsletter section-footer lu-canal">
            <h3>${leerDefaults().lupita_canal_titulo_es}</h3>
            <p>${leerDefaults().lupita_canal_texto_es}</p>
            <a href="#" target="_blank" rel="noopener" class="btn lu-canal-btn">${leerDefaults().lupita_canal_boton_es}</a>
          </div>
        </div>
      </div>

      <div class="row element-footer">
        <div class="col text-center">
          <!-- snipplets/social/social-links.tpl con los svg reales del theme -->
          ${['instagram', 'tiktok'].map((sn) => `<a class="social-icon" href="${{ instagram: 'https://www.instagram.com/ahilupitaok', tiktok: 'https://www.tiktok.com/@ahilupitaok' }[sn]}" target="_blank" rel="noopener" aria-label="${sn} Ahí! Lupita">${readFileSync(join(RAIZ, 'snipplets', 'svg', sn + '.tpl'), 'utf8').replace('{{ svg_custom_class }}', 'icon-inline').trim()}</a>`).join('\n          ')}
        </div>
      </div>

      <div class="row element-footer">
        <div class="col text-center">
          <ul class="footer-menu m-0 p-0">
            <li class="footer-menu-item"><a class="footer-menu-link" href="como-comprar.html">Cómo comprar</a></li>
            <li class="footer-menu-item"><a class="footer-menu-link" href="medios-de-pago.html">Medios de pago</a></li>
            <li class="footer-menu-item"><a class="footer-menu-link" href="sobre-nosotros.html">Sobre nosotros</a></li>
            <li class="footer-menu-item"><a class="footer-menu-link" href="preguntas-frecuentes.html">Preguntas frecuentes</a></li>
            <li class="footer-menu-item"><a class="footer-menu-link" href="#">Envíos</a></li>
            <li class="footer-menu-item"><a class="footer-menu-link" href="#">Cambios y devoluciones</a></li>
          </ul>
        </div>
      </div>

      <div class="row element-footer">
        <div class="col text-center">
          <ul class="contact-info text-center">
            <li class="contact-item"><a href="https://wa.me/5491128622903" class="contact-link">+54 9 11 2862-2903</a></li>
            ${tiendasItems('contact-item')}
          </ul>
          <a href="${leerDefaults().lupita_tiendas_url_es}" target="_blank" rel="noopener" class="lu-tiendas-link lu-tiendas-pie">Conocer las tiendas</a>
        </div>
      </div>

      <div class="row element-footer footer-payments-shipping-logos">
        <div class="col text-center">
          ${['VISA', 'MASTER', 'AMEX', 'MERCADO PAGO'].map((m) => `<img src="${foto('#8A8A84', m, 120, 48)}" alt="${m}">`).join('')}
        </div>
        <div class="w-100 my-2"></div>
        <div class="col text-center">
          ${['ANDREANI', 'OCA', 'RETIRO EN TIENDA'].map((m) => `<img src="${foto('#8A8A84', m, 140, 48)}" alt="${m}">`).join('')}
        </div>
      </div>

      <div class="row element-footer">
        <div class="col-md-3 text-center text-md-left">
          <span class="powered-by">Tienda creada con Tiendanube</span>
        </div>
        <div class="col-md-9 copyright text-center text-md-right">
          Copyright Ahí! Lupita 2026. Todos los derechos reservados.
          <!-- Replica aproximada de component('claim-info'): el HTML real no esta publicado -->
          <div class="mt-2">
            <span class="d-inline-block mb-1">Defensa de las y los consumidores. Para reclamos</span>
            <a href="#" class="lu-reclamo-link">ingresá acá</a>
            <span class="mx-1 d-none d-md-inline-block">/</span>
            <a href="contacto.html" class="lu-arrepentimiento-link">Botón de arrepentimiento</a>
          </div>
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
// Espeja snipplets/tiendas-datos.tpl con los valores de defaults.txt.
function tiendasItems(clase) {
  const d = leerDefaults()
  return ['lupita_tienda_1_es', 'lupita_tienda_2_es', 'lupita_tienda_3_es']
    .filter((k) => d[k])
    .map((k) => `<li class="${clase} lu-tienda-direccion">${d[k]}</li>`)
    .concat(d.lupita_horarios_es ? [`<li class="${clase} lu-tienda-horario">${d.lupita_horarios_es}</li>`] : [])
    .join('\n            ')
}

function imagenSrc(valor, texto, w, h) {
  return valor.startsWith('img/') ? valor : foto(valor, texto, w, h)
}

/** Replica snipplets/medios-de-pago.tpl con los textos iniciales de config/defaults.txt.
    Declaracion (no const): CARRITO la usa mas arriba, al cargar el modulo. */
function pagosHtml(tamano) {
  const s = leerDefaults()
  const filas = ['efectivo', 'tarjetas', 'transferencia']
    .map((k) => [s[`lupita_pago_${k}_cifra_es`], s[`lupita_pago_${k}_es`]])
    .filter(([c, t]) => c || t)
  const amex = s.lupita_pago_amex_show === '1' && s.lupita_pago_amex_es
  const cuerpo = `
      <ul class="lu-pagos-lista list-unstyled">${filas.map(([c, t]) => `
        <li class="lu-pagos-item">${c ? `<span class="lu-pagos-cifra">${c}</span>` : ''}${t ? `<span class="lu-pagos-texto">${t}</span>` : ''}</li>`).join('')}
      </ul>${amex ? `
      <div class="lu-pagos-amex"><span class="lu-pagos-amex-rotulo">American Express</span><span class="lu-pagos-amex-texto">${amex}</span></div>` : ''}`
  return tamano === 'grande'
    ? `<section class="lu-pagos lu-pagos-grande" data-store="lupita-medios-de-pago" aria-label="Medios de pago"><div class="container"><span class="lu-rotulo lu-micro lu-pagos-rotulo">Medios de pago</span>${cuerpo}<a href="${s.lupita_tiendas_url_es}" target="_blank" rel="noopener" class="lu-tiendas-link lu-tiendas-pagos">Conocer las tiendas</a></div></section>`
    : `<section class="lu-pagos lu-pagos-compacto" data-store="lupita-medios-de-pago" aria-label="Medios de pago">${cuerpo}</section>`
}

/** Replica snipplets/favoritos/boton.tpl. Nace hidden como en la tienda. */
function corazon(p, i, clase) {
  return `<button type="button" class="js-fav lu-fav ${clase}" hidden aria-pressed="false" aria-label="Guardar en favoritos" data-fav-id="demo-${i}" data-fav-nombre="${p.nombre}" data-fav-url="producto.html?p=${i}" data-fav-imagen="${foto(p.foto, 'FOTO ' + String(i + 1).padStart(2, '0'), 120, 180)}" data-fav-precio="${pesos(p.precio)}">${ICONO.corazonVacio}${ICONO.corazonLleno}</button>`
}

/** Replica el DOM de snipplets/grid/item.tpl (clases reales, verificadas). */
function tarjeta(p, i) {
  const cuota = Math.round(p.precio / 3)
  return `
        <div class="js-item-product col-6 col-md-3 item item-product" data-product-type="list"
             onclick="location.href='producto.html?p=${i}'">
          <div class="item-image mb-2">
            ${corazon(p, i, 'lu-fav-tarjeta')}
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
                  <p class="page-header-text font-md-normal">Lo ultimo que entro a las tres tiendas. Todo con 20% off pagando en efectivo.</p>
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
          ${pagosHtml('compacto')}

          <div class="lu-variantes">
            <span class="lu-rotulo">Talle</span>
            <div class="lu-talles">
              ${['1', '2', '3', '4'].map((t, j) => `<button class="lu-talle${j === 1 ? ' activo' : ''}">${t}</button>`).join('')}
            </div>
          </div>

          <div class="lu-comprar">
            <input type="submit" class="js-addtocart btn btn-primary btn-block" value="Agregar al carrito">
            ${corazon(PRODUCTOS[0], 0, 'lu-fav-ficha')}
          </div>

          <div class="product-description user-content">
            <p>Prenda de la nueva temporada, disponible en las tres tiendas de Lomas de Zamora y Banfield. Asesoramiento personalizado para encontrar tu talle.</p>
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
/* Las piezas de campana con titulo impreso pasaron por aca el 2026-09-15 y
   Santiago prefirio volver a estas: ahora van en la galeria de campanas,
   debajo de los videos (home-campanas.tpl). */
const SLIDES = [
  { titulo: 'Nueva temporada', desc: 'Primavera 26 · Ya en las tres tiendas', boton: 'Ver lo nuevo', foto: 'img/hero-01.jpg', color: 'black' },
  { titulo: '20% off', desc: 'Abonando en efectivo', boton: 'Ver la tienda', foto: 'img/hero-02.jpg', color: 'white' },
  { titulo: 'Ahi! Lupita', desc: 'Ropa de mujer en tres tiendas', boton: 'Ver la tienda', foto: 'img/hero-03.jpg', color: 'white' },
  { titulo: '3 y 6 cuotas', desc: 'Sin interes con todas las tarjetas', boton: 'Comprar ahora', foto: 'img/hero-04.jpg', color: 'white' },
]

/* banner-services.tpl: tres renglones de demo. Los iconos son los del base
   (truck, credit-card, lock) en trazo equivalente. */
const SERVICIOS = [
  { titulo: 'Envíos a todo el país', texto: 'Por Andreani o Correo Argentino. Retiro gratis en las tres tiendas.',
    icono: '<svg class="icon-inline icon-w-20 icon-2x service-icon" viewBox="0 0 640 512" aria-hidden="true"><path d="M624 352h-16V243c0-13-5-25-14-34l-77-77c-9-9-21-14-34-14h-51V64c0-18-14-32-32-32H32C14 32 0 46 0 64v288c0 18 14 32 32 32h16a96 96 0 0 0 192 0h160a96 96 0 0 0 192 0h32c9 0 16-7 16-16v-16c0-9-7-16-16-16zM144 464a48 48 0 1 1 0-96 48 48 0 0 1 0 96zm288-160H272v-32h160v32zm0-64H272v-32h160v32zm64 224a48 48 0 1 1 0-96 48 48 0 0 1 0 96zm64-96h-8a96 96 0 0 0-112-46V160h51l77 77v131z"/></svg>' },
  { titulo: '3 y 6 cuotas sin interés', texto: 'Con todas las tarjetas. Y 20% off pagando en efectivo en la tienda.',
    icono: '<svg class="icon-inline icon-w-18 icon-2x service-icon" viewBox="0 0 576 512" aria-hidden="true"><path d="M528 32H48C22 32 0 54 0 80v352c0 26 22 48 48 48h480c26 0 48-22 48-48V80c0-26-22-48-48-48zm-480 48h480c9 0 16 7 16 16v48H32V96c0-9 7-16 16-16zm480 352H48c-9 0-16-7-16-16V256h512v160c0 9-7 16-16 16zM128 336v32h96v-32h-96zm160 0v32h160v-32H288z"/></svg>' },
  { titulo: 'Compra protegida', texto: 'Pagás con Mercado Pago y tu compra queda cubierta hasta que la tenés en la mano.',
    icono: '<svg class="icon-inline icon-w-14 icon-2x service-icon" viewBox="0 0 448 512" aria-hidden="true"><path d="M400 224h-24v-72a152 152 0 0 0-304 0v72H48c-26 0-48 22-48 48v192c0 26 22 48 48 48h352c26 0 48-22 48-48V272c0-26-22-48-48-48zm-104 0H152v-72a72 72 0 0 1 144 0v72zm104 240H48V272h352v192z"/></svg>' },
]

function paginaHome(settings) {
  const slides = SLIDES.map(
    (s, i) => `
          <div class="swiper-slide slide-container${i === 0 ? ' activo' : ''}">
            <div class="slider-slide">
              <img class="slider-image" src="${imagenSrc(s.foto, 'CAMPANA ' + (i + 1), 1600, 900)}" alt="">${s.titulo || s.desc || s.boton ? `
              <div class="swiper-text swiper-${s.color}">
                ${s.titulo ? `<div class="swiper-title h1">${s.titulo}</div>` : ''}
                ${s.desc ? `<div class="swiper-description h5 font-weight-normal mt-3">${s.desc}</div>` : ''}
                ${s.boton ? `<a href="categoria.html" class="btn btn-small swiper-btn mt-4">${s.boton}</a>` : ''}
              </div>` : ''}
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
    { titulo: 'Accesorios', foto: 'img/hero-02.jpg', url: 'categoria.html' },
    { titulo: 'Denim', foto: 'img/hero-04.jpg', url: 'categoria.html' },
    { titulo: 'Night Out', foto: 'img/hero-03.jpg', url: 'categoria.html' },
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
    .nube-slider-home .swiper-wrapper { position: relative; height: 100%; }
    .nube-slider-home .swiper-slide { position: absolute; inset: 0; opacity: 0; z-index: 0; }
    .nube-slider-home .swiper-slide.activo { opacity: 1; z-index: 1; }
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

  <!-- home_order_position_2 = informatives -> banner-services.tpl, entre los
       destacados y los banners de categorias (pedido de Santiago, 2026-09-15).
       Los tres textos son de demo: la clienta los escribe desde el panel. -->
  <section class="section-informative-banners" data-store="banner-services">
    <div class="container">
      <div class="row">
        <div class="js-informative-banners swiper-container">
          <div class="swiper-wrapper">${SERVICIOS.map((s) => `
            <div class="service-item-container col-md swiper-slide p-0 px-md-3">
              <div class="service-item row justify-content-md-center text-md-left">
                <div class="col-md-auto">${s.icono}</div>
                <div class="col">
                  <h3 class="service-title">${s.titulo}</h3>
                  <p>${s.texto}</p>
                </div>
              </div>
            </div>`).join('')}
          </div>
          <div class="js-informative-banners-pagination service-pagination swiper-pagination swiper-pagination-black">
            <span class="swiper-pagination-bullet swiper-pagination-bullet-active"></span><span class="swiper-pagination-bullet"></span><span class="swiper-pagination-bullet"></span>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- home_order_position_3 = categories -> home-banners.tpl -->
  <section class="section-banners-home">
    <div class="container-fluid p-0">
      <div class="row no-gutters align-items-center">${categorias}
      </div>
    </div>
  </section>

  <section class="section-cover-home">
    <div class="cover-image">
      <!-- El video de Santiago convertido con ffmpeg (1920, 30 fps, H.264, sin
           audio, faststart): de 36 MB .mov a ~3 MB. En la tienda va por
           cover_video_url, alojado afuera. Titulo: Sea of Dreams. -->
      <video class="cover-image-background" autoplay muted loop playsinline preload="auto" poster="video/portada-poster.jpg">
        <source src="video/portada.mp4" type="video/mp4">
      </video>
      <div class="swiper-text swiper-white">
        <div class="swiper-title h1">Sea of Dreams</div>
      </div>
    </div>
  </section>

  <!-- Capsula "City Moves" (antes "The Trip"): segundo video de Santiago,
       convertido igual que el de la Portada. En la tienda va por
       capsule_video_url, alojado afuera. -->
  <section class="section-capsule-home">
    <div class="capsule-media">
      <video class="capsule-video" autoplay muted loop playsinline preload="auto" poster="video/capsula-poster.jpg">
        <source src="video/capsula.mp4" type="video/mp4">
      </video>
      <div class="swiper-text swiper-white">
        <div class="swiper-title h1">City Moves</div>
      </div>
    </div>
  </section>

  <!-- home-campanas.tpl: las piezas con titulo impreso, debajo de los videos -->
  <section class="lu-campanas" data-store="home-campanas">
    <div class="container"><span class="lu-rotulo lu-micro lu-campanas-rotulo">${settings.lupita_campanas_titulo_es}</span></div>
    <div class="lu-campanas-grilla">
      ${['slider-sea-of-dreams.jpg', 'slider-sea-and-a-dream.jpg', 'slider-city-moves.jpg'].map((f) => `<figure class="lu-campana"><img src="img/${f}" alt="Campaña de Ahí! Lupita" loading="lazy"></figure>`).join('\n      ')}
    </div>
  </section>


  <!-- home_order_position_4 = modules -> home-modules.tpl, con modules_full.
       Un modulo con la foto a la derecha (module_align = right). -->
  <section class="section-home-modules" data-store="home-image-text-module">
    <div class="container-fluid p-0">
      <!-- Sin link envolvente (2026-09-15): solo el boton lleva al mapa -->
        <div class="row no-gutters align-items-center">
          <div class="col-md order-md-2">
            <div class="textbanner">
              <div class="textbanner-image">
                <img src="${imagenSrc('img/hero-03.jpg', 'MODULO', 800, 1000)}" class="textbanner-image-background" alt="Elegilo online, probátelo en la tienda">
              </div>
            </div>
          </div>
          <div class="col-md">
            <div class="textbanner-text">
              <div class="h1 textbanner-title">Elegilo online, probátelo en la tienda</div>
              <div class="textbanner-paragraph">${settings.module_01_description_es}</div>
              <a href="${settings.module_01_url_es}" target="_blank" rel="noopener" class="btn btn-primary btn-small">${settings.module_01_button_es}</a>
            </div>
          </div>
        </div>
    </div>
  </section>

  <!-- home_order_position_10 = payments -> medios-de-pago.tpl (aca antes de la bienvenida para verlo) -->
  ${pagosHtml('grande')}

  <!-- home_order_position_6 = welcome -> home-welcome-message.tpl -->
  <section class="section-welcome-home" data-store="home-welcome-message">
    <div class="container">
      <div class="row">
        <div class="col-md-8 offset-md-2">
          <h2 class="welcome-title">${settings.welcome_message_es}</h2>
          <p class="welcome-text">${settings.welcome_text_es}</p>
        </div>
      </div>
    </div>
  </section>

  <!-- home_order_position_4 = instafeed -> home-instafeed.tpl. Las nueve
       fotos las trae la plataforma cuando la clienta conecta Instagram en el
       panel (store.hasInstagramToken). Sin conexion el theme no pinta fotos:
       solo el aviso "Seguinos en Instagram". Aca se muestra ese estado, sin
       fotos inventadas (Santiago, 2026-09-15). -->
  <section class="section-instafeed-home" data-store="home-instagram-feed">
    <div class="container">
      <div class="row">
        <div class="col-12 text-center">
          <div class="lu-redes-fila">
            <a target="_blank" rel="noopener" href="https://www.instagram.com/ahilupitaok" class="instafeed-title" aria-label="Instagram de Ahi! Lupita">
              ${ICONO.instagram}
              <span class="instafeed-user-fila">
                <h2 class="h2 h1-md mt-2 instafeed-user">ahilupitaok</h2>
                <svg class="instafeed-verificada" viewBox="0 0 40 40" role="img" aria-label="Cuenta verificada"><path fill="#0095F6" fill-rule="evenodd" d="M19.998 3.094 14.638 0l-2.972 5.15H5.432v6.354L0 14.64 3.094 20 0 25.359l5.432 3.137v5.905h5.975L14.638 40l5.36-3.094L25.358 40l3.232-5.6h6.162v-6.01L40 25.359 36.905 20 40 14.641l-5.248-3.03v-6.46h-6.419L25.358 0l-5.36 3.094Zm7.415 11.225 2.254 2.287-11.43 11.5-6.835-6.93 2.244-2.258 4.587 4.581 9.18-9.18Z"/></svg>
              </span>
            </a>
            <a target="_blank" rel="noopener" href="https://www.tiktok.com/@ahilupitaok" class="instafeed-title lu-tiktok-title" aria-label="TikTok de Ahi! Lupita">
              ${readFileSync(join(RAIZ, 'snipplets', 'svg', 'tiktok.tpl'), 'utf8').replace('{{ svg_custom_class }}', 'icon-inline icon-3x align-top svg-icon-text').trim()}
              <span class="instafeed-user-fila">
                <span class="h2 h1-md mt-2 instafeed-user">ahilupitaok</span>
              </span>
            </a>
          </div>
          <div class="js-ig-fallback text-center mt-3">
            <div class="mb-3">Seguinos en nuestras redes</div>
            <a target="_blank" rel="noopener" href="https://www.instagram.com/ahilupitaok" class="btn btn-link">Ver perfil</a>
          </div>
        </div>
      </div>
    </div>
  </section>

${PIE}
${PANELES}

  <script>
    const slides = [...document.querySelectorAll('.nube-slider-home .swiper-slide')]
    const bullets = [...document.querySelectorAll('.nube-slider-home .swiper-pagination-bullet')]
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
   7b. Pagina del carrito
   Replica templates/cart.tpl + cart-item-ajax.tpl (cart_page = true) +
   cart-totals.tpl (cart_page = true), con las clases y las utilidades de
   Bootstrap que traen — incluidos los mb-5 con !important que la hoja
   tiene que pisar.
   --------------------------------------------------------------------------- */

const renglonCarritoPagina = (p, i, arr) => `
        <div class="js-cart-item cart-item js-cart-item-shippable row align-items-md-center mx-0 ${i === arr.length - 1 ? 'mb-2' : 'mb-5'}" data-item-id="${p.i}" data-component="cart.line-item">
          <div class="col-2 col-md-1 px-0">
            <a href="producto.html?p=${p.i}"><img src="${foto(p.foto, '', 200, 300)}" class="img-fluid" alt=""></a>
          </div>
          <div class="col-10 col-md-11">
            <div class="row align-items-center">
              <h6 class="font-weight-normal col-12 col-md-6 h4-md mb-2 mb-md-0" data-component="line-item.name">
                <a href="producto.html?p=${p.i}">${p.nombre}</a>
                <small>${p.variante}</small>
              </h6>
              <div class="cart-item-quantity col-7 col-md-3" data-component="line-item.subtotal">
                <div class="form-group float-md-none m-auto form-quantity w-auto mb-2">
                  <div class="row m-0 justify-content-md-center align-items-center">
                    <span class="js-cart-quantity-btn cart-item-btn btn">&#8722;</span>
                    <input class="js-cart-quantity-input cart-item-input form-control" type="number" value="${p.cant}" aria-label="Cantidad">
                    <span class="js-cart-quantity-btn cart-item-btn btn">+</span>
                  </div>
                </div>
              </div>
              <h6 class="js-cart-item-subtotal cart-item-subtotal col-5 col-md-3 text-right text-md-center h4-md font-weight-bold">${pesos(p.sub)}</h6>
            </div>
          </div>
          <div class="col-1 cart-item-delete text-right">
            <button type="button" class="btn h6 h5-md m-0 lu-quitar" aria-label="Quitar ${p.nombre}">${ICONO.tacho}<span class="lu-quitar-texto" aria-hidden="true">Quitar</span></button>
          </div>
        </div>`

function paginaCarrito(settings) {
  return `${CABEZA('Carrito')}
<body class="template-cart">
${CABECERA(settings)}

  <section class="page-header mt-3" data-store="page-title">
    <div class="container">
      <div class="row">
        <div class="col text-center">
          <div class="breadcrumbs">
            <a class="crumb" href="home.html" title="Ahi! Lupita">Inicio</a>
            <span class="divider">></span>
            <span class="crumb active">Carrito de compras</span>
          </div>
          <h1>Carrito de Compras</h1>
        </div>
      </div>
    </div>
  </section>

  <div id="shoppingCartPage" class="container" data-store="cart-page">
    <form action="#" method="post" class="cart-body" data-store="cart-form" data-component="cart">
      <div class="cart-body">
        <div class="js-ajax-cart-list cart-row">${EN_CARRITO.map(renglonCarritoPagina).join('')}
        </div>
        <div class="cart-row">
          <div class="js-subtotal-price subtotal-price hidden"></div>
          <div class="divider d-none d-md-block"></div>
          <div class="container p-0">
            <div class="row">
              <div class="col-12 col-md-5">
                <div class="js-fulfillment-info js-allows-non-shippable">
                  <div class="js-visible-on-cart-filled js-has-new-shipping js-shipping-calculator-container container-fluid">
                    <div id="cart-shipping-container" class="row">
                      <div class="col-12 px-0">
                        <div class="form-group">
                          <label class="form-label" for="cp">Calculá el envío</label>
                          <div style="display:flex;gap:1px">
                            <input id="cp" class="form-control" type="text" placeholder="Tu código postal" aria-label="Código postal">
                            <input type="submit" class="btn btn-default" value="Calcular" style="flex:none">
                          </div>
                        </div>
                        <div class="alert alert-info">Retiro gratis en las tres tiendas.</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-12 col-md-7">
                <div id="cart-sticky-summary" class="position-sticky-md container-fluid">
                  <div class="row justify-content-md-end mt-4 mt-md-0">
                    <div class="col-12 col-md-auto">
                      <div class="js-visible-on-cart-filled h5 row no-gutters justify-content-end justify-content-md-center mb-1" data-store="cart-subtotal">
                        <span class="col col-md-auto">Subtotal <small>(sin envío)</small>:</span>
                        <strong class="js-cart-subtotal col col-md-auto text-right">${pesos(TOTAL_CARRITO)}</strong>
                      </div>
                      <div class="js-total-promotions">
                        <span class="js-total-promotions-detail-row row" id="all">
                          <span class="col">20% OFF en todos los productos:</span>
                          <span class="col text-right">-${pesos(Math.round(TOTAL_CARRITO * 0.2))}</span>
                        </span>
                      </div>
                      <div class="js-cart-total-container js-visible-on-cart-filled mb-3 clear-both" data-store="cart-total">
                        <div class="h2 row no-gutters text-primary mb-0 lu-tarjeta justify-content-end justify-content-md-center">
                          <span class="col col-md-auto mr-1">Total con tarjeta:</span>
                          <span class="js-cart-total col col-md-auto text-right">${pesos(Math.round(TOTAL_CARRITO * 0.8))}</span>
                        </div>
                        <div class="total-price hidden">Total: ${pesos(TOTAL_CARRITO)}</div>
                        <!-- DEDUCIDO: component('payment-discount-price') no esta publicado -->
                        <div class="js-payment-discount-price-cart-container lu-efectivo mt-1 text-right text-md-center"><span class="lu-efectivo-precio">${pesos(Math.round(TOTAL_CARRITO * 0.8 * 0.8))}</span> <span class="lu-efectivo-medio">con Efectivo</span></div>
                      </div>
                      <div class="js-visible-on-cart-filled">
                        ${pagosHtml('compacto')}
                        <input id="go-to-checkout" class="btn btn-primary btn-block mb-3" type="submit" name="go_to_checkout" value="Iniciar Compra">
                        <div class="row mb-2">
                          <div class="text-center w-100">
                            <a href="categoria.html" class="btn btn-link">Ver más productos</a>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </form>
  </div>
${PIE}
${PANELES}
</body>
</html>
`
}

/* ---------------------------------------------------------------------------
   7c. Pagina institucional y muestrario de piezas sueltas
   page.tpl (page-header con migas + .user-content) tal como lo arma el
   base, y debajo las piezas que no tienen pagina propia donde verse: la
   notificacion de "agregado al carrito" (fija a la vista, en la tienda se
   despliega bajo la cabecera), la busqueda sin resultados y los avisos.
   --------------------------------------------------------------------------- */

const NOTIFICACION = `
        <div class="js-alert-added-to-cart notification-floating notification-visible" style="display:block">
          <div class="notification notification-primary position-relative col-12 float-right">
            <div class="h6 text-center mb-3 mr-3"><strong>¡Ya agregamos tu producto al carrito!</strong></div>
            <div class="js-cart-notification-close notification-close">${ICONO.cerrar}</div>
            <div class="js-cart-notification-item row" data-store="cart-notification-item">
              <div class="col-3 pr-0 notification-img">
                <img src="${foto('#8C9AA3', '', 200, 300)}" class="js-cart-notification-item-img img-fluid" alt="">
              </div>
              <div class="col-9 text-left">
                <div class="mb-1">
                  <span class="js-cart-notification-item-name">Vestido midi satinado con tajo</span>
                  <span class="js-cart-notification-item-variant-container">(<span class="js-cart-notification-item-variant">M / Negro</span>)</span>
                </div>
                <div class="mb-1">
                  <span class="js-cart-notification-item-quantity">1</span><span> x </span><span class="js-cart-notification-item-price">${pesos(74500)}</span>
                </div>
              </div>
            </div>
            <div class="row text-primary h5 font-weight-normal mt-2 mb-3">
              <span class="col-auto text-left"><strong>Total</strong> (<span class="js-cart-widget-amount">2</span> <span class="js-cart-counts-plural">productos):</span></span>
              <strong class="js-cart-total col text-right">${pesos(TOTAL_CARRITO)}</strong>
            </div>
            <a href="#" class="js-panel btn btn-primary btn-medium w-100 d-inline-block" data-toggle="#modal-cart">Ver carrito</a>
          </div>
        </div>`

function paginaPagina(settings) {
  return `${CABEZA('Cambios y devoluciones')}
<body class="template-page">
${CABECERA(settings, NOTIFICACION)}

  <section class="page-header mt-3" data-store="page-title">
    <div class="container">
      <div class="row">
        <div class="col text-center">
          <div class="breadcrumbs">
            <a class="crumb" href="home.html" title="Ahi! Lupita">Inicio</a>
            <span class="divider">></span>
            <span class="crumb active">Cambios y devoluciones</span>
          </div>
          <h1>Cambios y devoluciones</h1>
        </div>
      </div>
    </div>
  </section>

  <section class="user-content">
    <div class="container">
      <div class="row justify-content-md-center">
        <div class="col-md-8">
          <p>Texto de demo: el real lo escribe la clienta desde el panel. Tenés 30 días desde que recibís tu compra para cambiarla en cualquiera de las tres tiendas, con la prenda sin uso y con la etiqueta puesta. Si comprás online y el talle no te queda, lo cambiás en la tienda o lo coordinamos por WhatsApp.</p>
          <h2>Cómo hacer un cambio</h2>
          <ul>
            <li>Escribinos por WhatsApp con el número de pedido.</li>
            <li>Acercate a la tienda que te quede más cómoda, o pedí el retiro a domicilio.</li>
            <li>Elegís otra prenda o te queda un crédito para usar cuando quieras.</li>
          </ul>
          <h3>Tabla de talles</h3>
          <table>
            <thead><tr><th>Talle</th><th>Busto</th><th>Cintura</th><th>Cadera</th></tr></thead>
            <tbody>
              <tr><td>1</td><td>84 cm</td><td>64 cm</td><td>90 cm</td></tr>
              <tr><td>2</td><td>88 cm</td><td>68 cm</td><td>94 cm</td></tr>
              <tr><td>3</td><td>92 cm</td><td>72 cm</td><td>98 cm</td></tr>
              <tr><td>4</td><td>96 cm</td><td>76 cm</td><td>102 cm</td></tr>
            </tbody>
          </table>
          <p>Las devoluciones con reintegro de dinero se hacen únicamente sobre compras online y dentro de los 10 días de recibida la compra, según la <a href="#">Ley de Defensa del Consumidor</a>.</p>
        </div>
      </div>
    </div>
  </section>

  <!-- Muestrario: banner de cookies (notification.tpl, fijo al pie) -->
  <div class="js-notification js-notification-cookie-banner notification notification-fixed-bottom notification-above notification-secondary" style="display:block">
    <div class="container text-center text-md-left">
      <div class="row align-items-md-center">
        <div class="col-12 col-md-7 offset-md-2 mb-3 mb-md-0 text-foreground">
          Al navegar por este sitio <strong>aceptás el uso de cookies</strong> para agilizar tu experiencia de compra.
        </div>
        <div class="col-md-auto">
          <a href="#" class="js-notification-close js-acknowledge-cookies btn btn-primary btn-medium px-4 py-2 d-inline-block">Entendido</a>
        </div>
      </div>
    </div>
  </div>

  <!-- Muestrario: los cuatro avisos -->
  <div class="container" style="padding-top:2rem">
    <div class="alert alert-info">El carrito de compras está vacío.</div>
    <div class="alert alert-success" style="margin-top:1rem">¡Listo! Aplicamos el cupón de descuento.</div>
    <div class="alert alert-warning" style="margin-top:1rem">¡Uy! No tenemos más stock de este producto para agregarlo al carrito.</div>
    <div style="margin-top:1rem"><span class="label label-secondary">Envío gratis</span> <span class="label label-accent">20% OFF</span> <span class="label">Nuevo</span> <span class="label label-sale">Oferta</span></div>
  </div>
${PIE}
${PANELES}
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
<nav><a href="home.html">Home</a><a href="categoria.html">Categoria</a><a href="producto.html">Producto</a><a href="carrito.html">Carrito</a><a href="pagina.html">Pagina</a><a href="busqueda.html">Busqueda</a><a href="busqueda-vacia.html">Sin resultados</a><a href="404.html">404</a><a href="contacto.html">Contacto</a><a href="contrasena.html">Contrasena</a><a href="blog.html">Blog</a><a href="nota.html">Nota</a></nav>
${fila('Home', 'home.html')}
${fila('Categoria', 'categoria.html')}
${fila('Producto', 'producto.html')}
${fila('Carrito', 'carrito.html')}
${fila('Pagina', 'pagina.html')}
${fila('Busqueda', 'busqueda.html')}
${fila('Sin resultados', 'busqueda-vacia.html')}
${fila('404', '404.html')}
${fila('Contacto', 'contacto.html')}
${fila('Contrasena', 'contrasena.html')}
${fila('Blog', 'blog.html')}
${fila('Nota', 'nota.html')}
${fila('Sobre nosotros', 'sobre-nosotros.html')}
${fila('Preguntas frecuentes', 'preguntas-frecuentes.html')}
</body></html>
`
}

/* ---------------------------------------------------------------------------
   Pantallas restantes (2026-09-15): 404
   --------------------------------------------------------------------------- */

function pagina404(settings) {
  return `${CABEZA('Error 404')}
<body class="template-404">
${CABECERA(settings)}
  <section class="lu-404" id="404">
    <div class="container">
      <span class="lu-rotulo lu-micro">Error</span>
      <h1 class="lu-404-cifra" aria-label="404"><span data-motion="decrypt" aria-hidden="true">404</span></h1>
      <p class="lu-404-texto">La página que estás buscando no existe.</p>
      <div class="lu-404-buscar">
        <form class="js-search-container js-search-form" action="categoria.html" method="get">
          <div class="form-group m-0">
            <input class="js-search-input form-control search-input" autocomplete="off" type="search" name="q" placeholder="Buscar" aria-label="Buscador">
            <button type="submit" class="btn search-input-submit" aria-label="Buscar">${ICONO.lupa}</button>
          </div>
        </form>
      </div>
    </div>
    <div class="container lu-404-sugeridos">
      <span class="lu-rotulo lu-micro">Quizás te interesen los siguientes productos.</span>
    </div>
    <div class="container" style="padding:0">
      <div class="js-product-table row">${PRODUCTOS.slice(0, 4).map(tarjeta).join('')}</div>
    </div>
  </section>
${PIE}
${PANELES}
${MOTION}
</body>
</html>
`
}

/* Busqueda con y sin resultados (templates/search.tpl) */
function paginaBusqueda(settings, vacia) {
  const termino = vacia ? 'campera de corderoy' : 'vestido'
  return `${CABEZA('Búsqueda')}
<body class="template-search">
${CABECERA(settings)}
  <section class="page-header mt-3 lu-busqueda-header" data-store="page-title">
    <div class="container"><div class="row"><div class="col">
      <span class="lu-rotulo lu-micro">Búsqueda</span>
      <h1><span class="lu-busqueda-termino${vacia ? ' lu-tachado' : ''}">“${termino}”</span></h1>
    </div></div></div>
  </section>
  <section class="category-body">
    <div class="container">
${vacia
    ? `      <p class="lu-busqueda-vacia">No hubo resultados para tu búsqueda</p>
      <span class="lu-rotulo lu-micro lu-busqueda-seguir">Seguí mirando</span>
${RIEL}`
    : `      <div class="js-product-table row" data-motion="stagger">${PRODUCTOS.map(tarjeta).join('')}</div>`}
    </div>
  </section>
${PIE}
${PANELES}
${MOTION}
</body>
</html>
`
}

/* Contacto (templates/contact.tpl) con el aviso de exito visible. El DOM del
   formulario es el de snipplets/forms/form.tpl + form-input.tpl. Los datos de
   la columna izquierda son de relleno: en la tienda los carga el panel. */
function paginaContacto(settings) {
  const campo = (id, rotulo, tipo) => `
            <div class="form-group ">
              <label class="form-label " for="${id}">${rotulo}</label>
              <input type="${tipo}" id="${id}" class=" form-control  " autocorrect="off" autocapitalize="off" name="${id}">
            </div>`
  return `${CABEZA('Contacto')}
<body class="template-contact">
${CABECERA(settings)}
  <section class="page-header mt-3" data-store="page-title">
    <div class="container"><div class="row"><div class="col text-center">
      <h1>Contacto</h1>
    </div></div></div>
  </section>
  <section class="contact-page">
    <div class="container">
      <div class="row lu-contacto">
        <div class="col-md-5 lu-contacto-datos">
          <p class="lu-contacto-intro">[ Demo: el texto de contacto lo escribe la clienta en el panel ]</p>
          <ul class="contact-info text-center">
            <li class="contact-item">${ICONO.whatsapp}<a href="https://wa.me/5491128622903" class="contact-link">5491128622903</a></li>
            ${tiendasItems('contact-item')}
          </ul>
        </div>
        <div class="col-md-7 lu-contacto-form">
          <div class="alert alert-success" data-component="contact-success-message" data-motion="spring">¡Gracias por contactarnos! Vamos a responderte apenas veamos tu mensaje.</div>
          <form id="contact-form" action="#" method="post" class="form js-winnie-pooh-form" data-store="contact-form">
${campo('name', 'Nombre', 'text')}${campo('email', 'Email', 'email')}${campo('phone', 'Teléfono', 'tel')}
            <div class="form-group ">
              <label class="form-label " for="message">Mensaje</label>
              <textarea id="message" class="form-control form-control-area  " autocorrect="off" autocapitalize="off" name="message" rows="7"></textarea>
            </div>
            <input class="btn btn-primary " type="submit" value="Enviar" name="contact">
          </form>
        </div>
      </div>
    </div>
  </section>
${PIE}
${PANELES}
${MOTION}
</body>
</html>
`
}

/* Tienda cerrada (templates/password.tpl) con la contraseña incorrecta, para
   ver el aviso y el temblor. No usa CABECERA: la plantilla no pasa por el layout. */
function paginaContrasena() {
  return `${CABEZA('Tienda cerrada')}
<body class="template-password">
  <section class="section-password lu-cerrado">
    <div class="container">
      <div class="lu-cerrado-logo">
        <div class="logo-text-container"><span class="logo-text h1 m-0">AHI ! LUPITA</span></div>
      </div>
      <h2 class="lu-cerrado-mensaje">[ Mensaje del panel: ej. Volvemos pronto ]</h2>
      <div class="lu-cerrado-form" data-motion="shake">
        <form id="password-form" action="#" method="post" class="form ">
          <div class="form-group ">
            <label class="form-label " for="password">Contraseña de acceso</label>
            <input type="password" id="password" class="js-password-input form-control  " autocorrect="off" autocapitalize="off" autocomplete="off" name="password">
            <div class="mt-4 text-center"><a href="#" class="btn-link ">¿Olvidaste la contraseña?</a></div>
            <div class="alert alert-danger">La contraseña es incorrecta.</div>
          </div>
          <input class="btn btn-primary " type="submit" value="Desbloquear" name="">
        </form>
      </div>
    </div>
  </section>
${PIE}
${MOTION}
</body>
</html>
`
}

/* Blog y nota (templates/blog.tpl y blog-post.tpl). Titulos y resumenes de
   relleno, marcados como [ Demo ]. */
const NOTAS = [
  { titulo: 'Cómo combinar un blazer estructurado para todos los días', resumen: '[ Demo ] Tres formas de llevarlo del trabajo a la noche sin cambiarte entera.', foto: '#A8A093' },
  { titulo: 'Guía de talles: medirte en casa', resumen: '[ Demo ] Busto, cintura y cadera con un centímetro y dos minutos.', foto: '#8C9AA3' },
  { titulo: 'Lo nuevo de la temporada', resumen: '[ Demo ] Las prendas que entraron esta semana a las tiendas.', foto: '#6E6A63' },
  { titulo: 'Cuidar el satén', resumen: '[ Demo ] Lavado, planchado y guardado para que dure.', foto: '#CFC7B8' },
]

/* DEDUCIDO: el componente blog-post-item no esta publicado. Clases del base
   (post-item-*, las que estila style-critical) + las que pasa blog.tpl
   (lu-post*). Verificar contra la tienda. */
function notaItem(n, i) {
  return `
      <div class="post-item lu-post">
        <div class="post-item-image-container lu-post-imagen"><a href="nota.html"><img class="post-item-image lu-post-img" src="${foto(n.foto, 'NOTA ' + (i + 1), 600, 800)}" alt="${n.titulo}"></a></div>
        <div class="post-item-title lu-post-titulo"><a href="nota.html">${n.titulo}</a></div>
        <p class="post-item-summary lu-post-resumen">${n.resumen}</p>
        <a href="nota.html" class="lu-post-leer">Leer más</a>
      </div>`
}

function paginaBlog(settings) {
  return `${CABEZA('Blog')}
<body class="template-blog">
${CABECERA(settings)}
<div class="container">
  <section class="page-header mt-3" data-store="page-title"><div class="container"><div class="row"><div class="col text-center">
    <div class="breadcrumbs"><a class="crumb" href="home.html">Inicio</a><span class="divider">></span><span class="crumb active">Blog</span></div>
    <h1>Blog</h1>
  </div></div></div></section>
  <section class="blog-page lu-blog" data-motion="hover-preview">${NOTAS.map(notaItem).join('')}
  </section>
</div>
${PIE}
${PANELES}
${MOTION}
</body>
</html>
`
}

function paginaNota(settings) {
  const n = NOTAS[0]
  return `${CABEZA('Nota')}
<body class="template-blog-post">
${CABECERA(settings)}
<div class="container container-narrow">
  <section class="page-header mt-3" data-store="page-title"><div class="container"><div class="row"><div class="col text-center">
    <div class="breadcrumbs"><a class="crumb" href="home.html">Inicio</a><span class="divider">></span><a class="crumb" href="blog.html">Blog</a><span class="divider">></span><span class="crumb active">${n.titulo}</span></div>
    <h1 data-motion="split-lines">${n.titulo}</h1>
  </div></div></div></section>
  <div class="blog-post-page lu-nota">
    <span class="lu-nota-fecha">15 de septiembre de 2026</span>
    <img class="img-fluid lu-nota-img" src="${foto(n.foto, 'FOTO DE LA NOTA', 1200, 800)}" alt="">
    <div class="user-content lu-nota-cuerpo">
      <p>[ Demo: el texto lo escribe la clienta desde el panel. ] Un blazer con hombros marcados ordena cualquier look: arriba de una remera básica, con un jean wide leg, o cerrado como si fuera un vestido.</p>
      <h2>Para el trabajo</h2>
      <p>Pantalón sastrero del mismo tono y una camisa oversize a rayas. Zapato bajo.</p>
      <ul><li>Mismo color arriba y abajo alarga la figura.</li><li>Las mangas arremangadas lo hacen menos formal.</li></ul>
      <h3>Para la noche</h3>
      <p>Sin nada abajo, cerrado con un cinto, y una <a href="#">falda de cuero ecológico</a>.</p>
    </div>
  </div>
</div>
${PIE}
${PANELES}
${MOTION}
</body>
</html>
`
}

/* Sobre nosotros (templates/page.tpl con handle sobre-nosotros ->
   snipplets/sobre-nosotros.tpl). Textos de defaults.txt; fotos de campaña. */
function paginaSobre(settings) {
  return `${CABEZA('Sobre nosotros')}
<body class="template-page">
${CABECERA(settings)}
  <section class="lu-sobre" data-store="page-about">
    <div class="container">
      <div class="lu-sobre-grilla">
        <div class="lu-sobre-texto">
          <h1 class="lu-sobre-titulo">${settings.lupita_about_title_es}</h1>
          <p class="lu-sobre-parrafo">${settings.lupita_about_text_es}</p>
          <p class="lu-sobre-asesoramiento">${settings.lupita_about_advice_es}</p>
          <p class="lu-sobre-cierre">${settings.lupita_about_closing_es}</p>
          <a href="${settings.lupita_tiendas_url_es}" target="_blank" rel="noopener" class="lu-tiendas-link lu-tiendas-sobre">Conocer las tiendas</a>
        </div>
        <div class="lu-sobre-fotos">
          <figure class="lu-sobre-foto"><img src="img/hero-01.jpg" alt="Tienda de Ahi! Lupita"></figure>
          <figure class="lu-sobre-foto"><img src="img/hero-03.jpg" alt="Tienda de Ahi! Lupita"></figure>
          <figure class="lu-sobre-foto"><img src="img/hero-04.jpg" alt="Tienda de Ahi! Lupita"></figure>
        </div>
      </div>
    </div>
  </section>
${PIE}
${PANELES}
</body>
</html>
`
}

/* Preguntas frecuentes (templates/page.tpl con handle preguntas-frecuentes ->
   snipplets/preguntas-frecuentes.tpl). Textos de defaults.txt; la primera abierta
   en el harness para que la captura muestre una respuesta. */
function paginaFaq(settings) {
  const items = [1, 2, 3, 4, 5, 6]
    .map((n) => [settings[`lupita_faq_${n}_pregunta_es`], settings[`lupita_faq_${n}_respuesta_es`], settings[`lupita_faq_${n}_respuesta_2_es`], settings[`lupita_faq_${n}_tiendas`] === '1'])
    .filter(([p, r]) => p && r)
    .map(([p, r, r2, tiendas], i) => `
          <details class="lu-faq-item"${i === 0 || tiendas ? ' open' : ''}>
            <summary class="lu-faq-pregunta">${p}</summary>
            <div class="lu-faq-respuesta">
              <p>${r}</p>${tiendas ? `\n              <ul class="lu-faq-tiendas list-unstyled">${tiendasItems('lu-faq-tienda')}</ul>` : ''}${r2 ? `\n              <p>${r2}</p>` : ''}
            </div>
          </details>`)
    .join('')
  return `${CABEZA('Preguntas frecuentes')}
<body class="template-page">
${CABECERA(settings)}
  <section class="lu-faq" data-store="page-faq">
    <div class="container">
      <div class="lu-faq-caja">
        <h1 class="lu-faq-titulo">Preguntas frecuentes</h1>
        <div class="lu-faq-lista">${items}
        </div>
        <p class="lu-faq-arrepentimiento">
          <a href="contacto.html" class="lu-arrepentimiento-link">Botón de arrepentimiento</a>
        </p>
      </div>
    </div>
  </section>
${PIE}
${PANELES}
</body>
</html>
`
}

/* Medios de pago y Como comprar (templates/page.tpl -> snipplets/pagina-lupita.tpl) */
function paginaLupita(settings, tipo) {
  const titulo = tipo === 'pagos' ? 'Medios de pago' : 'Cómo comprar'
  const pasos = [1, 2, 3, 4, 5]
    .map((n) => [settings[`lupita_comprar_${n}_titulo_es`], settings[`lupita_comprar_${n}_texto_es`]])
    .filter(([t]) => t)
    .map(([t, x], i) => `
          <li class="lu-paso">
            <span class="lu-paso-numero">${i + 1}</span>
            <div class="lu-paso-cuerpo">
              <h2 class="lu-paso-titulo">${t}</h2>${x ? `\n              <p class="lu-paso-texto">${x}</p>` : ''}
            </div>
          </li>`)
    .join('')
  return `${CABEZA(titulo)}
<body class="template-page">
${CABECERA(settings)}
  <section class="lu-pagina lu-pagina-${tipo}" data-store="page-${tipo}">
    <div class="container">
      <h1 class="lu-pagina-titulo">${titulo}</h1>
    </div>
    ${tipo === 'pagos' ? pagosHtml('grande') : `<div class="container"><ol class="lu-pasos list-unstyled">${pasos}
      </ol></div>`}
  </section>
${PIE}
${PANELES}
</body>
</html>
`
}

/* El JS de movimiento se sirve crudo, como lo incluye layout.tpl */
const MOTION = `<script src="lupita-motion.js"></script>`

function motionJs() {
  const p = join(RAIZ, 'static', 'js', 'lupita-motion.js.tpl')
  return existsSync(p) ? readFileSync(p, 'utf8').replace(/\{#[\s\S]*?#\}/g, '') : ''
}

/* Edge headless no baja de ~500 px: esta pagina mete la que se pida en un iframe de 390 */
const MOVIL = `<!DOCTYPE html><html lang="es"><head><meta charset="utf-8"><title>390</title>
<style>body{margin:0;background:#cfccc5}iframe{border:0;display:block;background:#F4F4F0}</style></head>
<body><iframe id="f" width="390" height="1800"></iframe>
<script>document.getElementById('f').src = new URLSearchParams(location.search).get('p') || 'home.html'</script>
</body></html>`

/* ---------------------------------------------------------------------------
   9. Escribir
   --------------------------------------------------------------------------- */

const settings = leerDefaults()
mkdirSync(SALIDA, { recursive: true })
writeFileSync(join(SALIDA, 'lupita.css'), compilarCss(settings))
writeFileSync(join(SALIDA, 'categoria.html'), paginaCategoria(settings))
writeFileSync(join(SALIDA, 'producto.html'), paginaProducto(settings))
writeFileSync(join(SALIDA, 'home.html'), paginaHome(settings))
writeFileSync(join(SALIDA, 'carrito.html'), paginaCarrito(settings))
writeFileSync(join(SALIDA, 'pagina.html'), paginaPagina(settings))
writeFileSync(join(SALIDA, 'dispositivos.html'), paginaDispositivos())
writeFileSync(join(SALIDA, '404.html'), pagina404(settings))
writeFileSync(join(SALIDA, 'busqueda.html'), paginaBusqueda(settings, false))
writeFileSync(join(SALIDA, 'busqueda-vacia.html'), paginaBusqueda(settings, true))
writeFileSync(join(SALIDA, 'contacto.html'), paginaContacto(settings))
writeFileSync(join(SALIDA, 'contrasena.html'), paginaContrasena())
writeFileSync(join(SALIDA, 'blog.html'), paginaBlog(settings))
writeFileSync(join(SALIDA, 'nota.html'), paginaNota(settings))
writeFileSync(join(SALIDA, 'sobre-nosotros.html'), paginaSobre(settings))
writeFileSync(join(SALIDA, 'preguntas-frecuentes.html'), paginaFaq(settings))
writeFileSync(join(SALIDA, 'medios-de-pago.html'), paginaLupita(settings, 'pagos'))
writeFileSync(join(SALIDA, 'como-comprar.html'), paginaLupita(settings, 'comprar'))
writeFileSync(join(SALIDA, 'lupita-motion.js'), motionJs())
{
  const p = join(RAIZ, 'static', 'js', 'lupita-favoritos.js.tpl')
  writeFileSync(join(SALIDA, 'lupita-favoritos.js'), existsSync(p) ? readFileSync(p, 'utf8').replace(/\{#[\s\S]*?#\}/g, '') : '')
}
writeFileSync(join(SALIDA, 'movil.html'), MOVIL)

/* Fotos reales del hero (ver imagenSrc): se copian tal cual a out/img. */
const IMG_ORIGEN = join(AQUI, 'img')
if (existsSync(IMG_ORIGEN)) {
  cpSync(IMG_ORIGEN, join(SALIDA, 'img'), { recursive: true })
}

console.log('OK ->', SALIDA)
console.log('   papel', settings.background_color, '| tinta', settings.text_color, '| acento', settings.accent_color)
console.log('   titulos', settings.font_headings, '| texto', settings.font_rest, '| subtitulos Bodoni Moda, rotulos Roboto Mono, marca Archivo Black (fijas)')
