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
<body>

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

/**
 * Vista mobile. Un iframe genera su propio viewport, asi que las media queries
 * responden a 390px de verdad — Chrome en Windows no deja achicar la ventana
 * lo suficiente como para probarlo de otra forma.
 */
function paginaMobile() {
  const marco = (ancho, alto, rotulo) => `
    <figure style="margin:0">
      <figcaption style="font:400 11px 'Roboto Mono',monospace;letter-spacing:.08em;
                         text-transform:uppercase;margin-bottom:.5rem">${rotulo}</figcaption>
      <iframe src="categoria.html" width="${ancho}" height="${alto}"
              style="border:1px solid #0A0A0A"></iframe>
    </figure>`

  return `<!DOCTYPE html>
<html lang="es"><head><meta charset="utf-8">
<title>Mobile — harness Ahi! Lupita</title>
<link href="https://fonts.googleapis.com/css2?family=Roboto+Mono:wght@400&display=swap" rel="stylesheet">
<style>body{margin:0;padding:2rem;background:#dedbd4;display:flex;gap:2rem;flex-wrap:wrap}</style>
</head><body>
${marco(390, 844, '390 x 844 — iPhone')}
${marco(768, 844, '768 — tablet, limite del breakpoint')}
</body></html>
`
}

const settings = leerDefaults()
mkdirSync(SALIDA, { recursive: true })
writeFileSync(join(SALIDA, 'lupita.css'), compilarCss(settings))
writeFileSync(join(SALIDA, 'categoria.html'), paginaCategoria(settings))
writeFileSync(join(SALIDA, 'mobile.html'), paginaMobile())

console.log('OK ->', join(SALIDA, 'categoria.html'))
console.log('   papel', settings.background_color, '| tinta', settings.text_color, '| acento', settings.accent_color)
console.log('   macro', settings.font_headings, '| micro', settings.font_rest)
