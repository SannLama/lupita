/**
 * Harness local de Ahi! Lupita — NO SE SUBE POR FTP.
 *
 * Tiendanube compila los .tpl en su servidor y no hay forma de correr eso
 * localmente. Esto no lo reemplaza: resuelve los {{ settings.x }} de la hoja
 * de estilos leyendo config/defaults.txt de verdad, y arma una pagina de
 * muestra que replica el DOM que produce snipplets/grid/item.tpl.
 *
 * O sea: verifica EL CSS, que es lo que escribimos nosotros. No verifica las
 * plantillas ni las funciones propias de la plataforma. Para eso hace falta
 * la tienda con FTP.
 *
 * Uso:  node _harness/render.mjs   ->  _harness/out/categoria.html
 */

import { readFileSync, writeFileSync, mkdirSync } from 'node:fs'
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

  // El unico bloque logico de la hoja: cantidad de columnas en desktop
  css = css.replace(
    /\{%\s*if settings\.grid_columns == 2\s*%\}(.*?)\{%\s*else\s*%\}(.*?)\{%\s*endif\s*%\}/g,
    (_, siDos, siNo) => (settings.grid_columns === '2' ? siDos : siNo)
  )

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

  // Nada de Twig deberia sobrevivir
  const resto = css.match(/\{[{%]/g)
  if (resto) console.warn('Quedo Twig sin resolver:', resto.length, 'ocurrencias')

  return css
}

/* ---------------------------------------------------------------------------
   3. Productos falsos
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

const pesos = (n) => '$ ' + n.toLocaleString('es-AR')

/** SVG plano como data URI: sin red, y proporcion 2:3 como la de una foto de catalogo. */
function foto(color, texto) {
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 600"><rect width="400" height="600" fill="${color}"/><text x="200" y="300" font-family="monospace" font-size="15" fill="rgba(255,255,255,.55)" text-anchor="middle">${texto}</text></svg>`
  return 'data:image/svg+xml;utf8,' + encodeURIComponent(svg)
}

/** Replica el DOM de snipplets/grid/item.tpl (clases reales, verificadas). */
function tarjeta(p, i) {
  const cuota = Math.round(p.precio / 3)
  return `
        <div class="js-item-product col-6 col-md-3 item item-product" data-product-type="list">
          <div class="item-image mb-2">
            ${p.etiqueta ? `<span class="item-label${p.etiqueta === 'OFERTA' ? ' item-label-sale' : ''}">${p.etiqueta}</span>` : ''}
            <img class="js-item-image" src="${foto(p.foto, 'FOTO ' + String(i + 1).padStart(2, '0'))}" alt="${p.nombre}">
          </div>
          <div class="item-description">
            <a href="#" class="item-link">
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
   4. Pagina de muestra
   --------------------------------------------------------------------------- */

function paginaCategoria(settings) {
  return `<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Nuevos ingresos — Ahi! Lupita (harness)</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Archivo+Black&family=Roboto+Mono:wght@300;400;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="lupita.css">
  <style>
    /* Lo minimo del theme base que la muestra necesita para no verse rota.
       No es parte del sistema visual: es andamio del harness. */
    * { box-sizing: border-box; }
    body { margin: 0; }
    .container { max-width: 1600px; margin: 0 auto; padding: 0 1.5rem; }
    .item-image { position: relative; margin-bottom: .5rem; }
    .item-image img { display: block; width: 100%; height: auto; }
    .item-label { position: absolute; top: .6rem; left: .6rem; }
    .item-link { text-decoration: none; }
    .lu-cabecera { display: flex; justify-content: space-between; align-items: center;
                   gap: .75rem; flex-wrap: wrap;
                   padding: 1.25rem 0; border-bottom: 1px solid var(--lu-linea); }
    .lu-nav { display: flex; gap: .9rem; }
    .lu-nav a { color: var(--lu-tinta); text-decoration: none; }
  </style>
</head>
<body class="template-category">

  <div class="container">
    <header class="lu-cabecera">
      <span class="lu-marca lu-micro" style="padding:.45rem .7rem">AHI ! LUPITA</span>
      <nav class="lu-nav lu-micro">
        <a href="#">Buscar</a>
        <a href="#">Carrito [0]</a>
        <a href="#">Ingresar</a>
      </nav>
    </header>

    <section class="lu-seccion" style="border-top:0">
      <div class="lu-seccion-titulo">
        <h1 class="lu-macro">Nuevos<br>ingresos</h1>
      </div>
      <div class="lu-seccion-titulo">
        <span class="lu-rotulo">${PRODUCTOS.length} prendas</span>
        <hr class="lu-regla" style="flex:1">
        <span class="lu-rotulo">20% off en efectivo</span>
      </div>
    </section>
  </div>

  <div class="container" style="padding:0">
    <div class="js-product-table row">${PRODUCTOS.map(tarjeta).join('')}
    </div>
  </div>

  <div class="container">
    <section class="lu-seccion">
      <span class="lu-rotulo lu-micro">Harness local · papel ${settings.background_color} · tinta ${settings.text_color} · acento ${settings.accent_color}</span>
    </section>
  </div>

</body>
</html>
`
}

/* ---------------------------------------------------------------------------
   5. Escribir
   --------------------------------------------------------------------------- */

/* ---------------------------------------------------------------------------
   Home: el hero con las fotos que se pasan solas.
   Replica el DOM de snipplets/home/home-slider.tpl con sus clases reales. En la
   tienda esto lo mueve Swiper; aca lo mueve un setInterval de doce lineas, que
   alcanza para ver el ritmo, el contraste y el contador.
   --------------------------------------------------------------------------- */

const SLIDES = [
  { titulo: 'Nueva temporada', desc: 'Primavera 26 · Ya en los tres locales', boton: 'Ver lo nuevo', foto: '#8E9A93' },
  { titulo: '20% off', desc: 'Abonando en efectivo', boton: 'Ver la tienda', foto: '#6E6A63' },
  { titulo: '3 y 6 cuotas', desc: 'Sin interes con todas las tarjetas', boton: 'Comprar ahora', foto: '#A79C8C' },
]

function fotoAncha(color, texto) {
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1600 900"><rect width="1600" height="900" fill="${color}"/><text x="800" y="450" font-family="monospace" font-size="26" fill="rgba(255,255,255,.5)" text-anchor="middle">${texto}</text></svg>`
  return 'data:image/svg+xml;utf8,' + encodeURIComponent(svg)
}

function paginaHome() {
  const slides = SLIDES.map(
    (s, i) => `
          <div class="swiper-slide slide-container${i === 0 ? ' activo' : ''}">
            <div class="slider-slide">
              <img class="slider-image" src="${fotoAncha(s.foto, 'CAMPANA ' + (i + 1))}" alt="">
              <div class="swiper-text swiper-white">
                <div class="swiper-title h1">${s.titulo}</div>
                <div class="swiper-description h5 font-weight-normal mt-3">${s.desc}</div>
                <div class="btn btn-small swiper-btn mt-4">${s.boton}</div>
              </div>
            </div>
          </div>`
  ).join('')

  const bullets = SLIDES.map((_, i) =>
    `<span class="swiper-pagination-bullet${i === 0 ? ' swiper-pagination-bullet-active' : ''}"></span>`
  ).join('')

  return `<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Home — Ahi! Lupita (harness)</title>
  <link href="https://fonts.googleapis.com/css2?family=Archivo+Black&family=Roboto+Mono:wght@300;400;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="lupita.css">
  <style>
    * { box-sizing: border-box; }
    body { margin: 0; }
    .container { max-width: 1600px; margin: 0 auto; padding: 0 1.5rem; }
    .lu-cabecera { display: flex; justify-content: space-between; align-items: center;
                   gap: .75rem; flex-wrap: wrap; padding: 1.25rem 0; }
    .lu-nav { display: flex; gap: .9rem; }
    .lu-nav a { color: var(--lu-tinta); text-decoration: none; }
    /* Andamio: en la tienda esto lo hace Swiper. */
    .swiper-wrapper { position: relative; height: 100%; }
    .swiper-slide { position: absolute; inset: 0; opacity: 0; z-index: 0; }
    .swiper-slide.activo { opacity: 1; z-index: 1; }
    .swiper-button-prev, .swiper-button-next { position: absolute; top: 50%; transform: translateY(-50%);
      color: #F4F4F0; font: 400 1.5rem 'Roboto Mono', monospace; mix-blend-mode: difference; }
    .swiper-button-prev { left: 1.5rem; } .swiper-button-next { right: 1.5rem; }
  </style>
</head>
<body class="template-home">

  <div class="container">
    <header class="lu-cabecera">
      <span class="lu-marca lu-micro" style="padding:.45rem .7rem">AHI ! LUPITA</span>
      <nav class="lu-nav lu-micro">
        <a href="#">Buscar</a><a href="#">Carrito [0]</a><a href="#">Ingresar</a>
      </nav>
    </header>
  </div>

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
      </div>
    </section>
  </div>

  <script>
    // Solo para el harness: rota los slides al mismo ritmo que el theme (5 s).
    const slides = [...document.querySelectorAll('.swiper-slide')]
    const bullets = [...document.querySelectorAll('.swiper-pagination-bullet')]
    let i = 0
    setInterval(() => {
      slides[i].classList.remove('activo')
      bullets[i].classList.remove('swiper-pagination-bullet-active')
      i = (i + 1) % slides.length
      slides[i].classList.add('activo')
      bullets[i].classList.add('swiper-pagination-bullet-active')
    }, 5000)
  </script>
</body>
</html>
`
}

/**
 * Vista mobile. Un iframe genera su propio viewport, asi que las media queries
 * responden a 390px de verdad — Chrome en Windows no deja achicar la ventana
 * lo suficiente como para probarlo de otra forma.
 */
/**
 * Banco de dispositivos. Cada iframe tiene su propio viewport, asi que las
 * media queries responden al ancho REAL declarado; el `scale` es solo para que
 * entren todos en la pantalla. Un 1920 escalado a 0.32 sigue siendo un 1920
 * para el CSS de adentro.
 */

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
</style>
</head><body>
${fila('Home', 'home.html')}
${fila('Categoria', 'categoria.html')}
</body></html>
`
}

const settings = leerDefaults()
mkdirSync(SALIDA, { recursive: true })
writeFileSync(join(SALIDA, 'lupita.css'), compilarCss(settings))
writeFileSync(join(SALIDA, 'categoria.html'), paginaCategoria(settings))
writeFileSync(join(SALIDA, 'home.html'), paginaHome())
writeFileSync(join(SALIDA, 'dispositivos.html'), paginaDispositivos())

console.log('OK ->', join(SALIDA, 'categoria.html'))
console.log('   papel', settings.background_color, '| tinta', settings.text_color, '| acento', settings.accent_color)
console.log('   macro', settings.font_headings, '| micro', settings.font_rest)
