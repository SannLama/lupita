# Pantallas restantes — Plan de implementación

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Diseñar búsqueda, 404, contacto, contraseña, blog y nota con el sistema de Lupita y un gesto de anime.js por pantalla.

**Architecture:** Un bundle recortado de anime.js (`static/js/lupita-motion.js.tpl`) que se activa por atributo `data-motion` y parte siempre del estado final del HTML. Cada pantalla = plantilla Twig + bloque en `lupita.scss.tpl` + página en el harness.

**Tech Stack:** Twig de Tiendanube, CSS plano, anime.js 4.5 (animate, stagger, createSpring, createAnimatable, splitText), esbuild 0.28, harness Node + Edge headless.

**Spec:** `docs/superpowers/specs/2026-09-15-pantallas-restantes-design.md`

## Global Constraints

- Papel `var(--lu-papel)`, tinta `var(--lu-tinta)`, turquesa `var(--lu-acento)` solo como fondo con tinta encima; ningún foco pasa a turquesa.
- Macro `var(--lu-macro)` (Italiana), micro `var(--lu-micro)` (Roboto Mono), marca `var(--lu-marca)` (Archivo Black).
- CSS plano en `lupita.scss.tpl`: sin anidado ni `$vars`, sin `border-radius`, sin sombras visibles.
- `lupita-motion.js.tpl` ≤ 30 KB y sin las secuencias `{{`, `{%`, `{#` (Twig lo incluye crudo).
- Con `prefers-reduced-motion: reduce` no corre ningún gesto; sin JS toda pantalla está completa.
- Solo `transform` y `opacity` (el decrypt cambia texto).
- No escribir a mano horarios, WhatsApp ni direcciones de la clienta.
- Antes de estilar una pieza del base, copiar al andamio (`CABEZA` en `render.mjs`) el CSS del base que la toca.
- Los commits los pide Santiago: cada tarea termina con el commit **solo si él ya lo pidió para esta tanda**.

## Mapa de archivos

| Archivo | Responsabilidad |
|---|---|
| `_harness/motion/entrada.mjs` (nuevo) | Los seis gestos y el arranque por `data-motion` |
| `_harness/motion/build.mjs` (nuevo) | esbuild → `static/js/lupita-motion.js.tpl`, control de tamaño y de Twig |
| `static/js/lupita-motion.js.tpl` (generado) | Lo que se sube; no se edita a mano |
| `package.json` | `build:motion`, animejs y esbuild como devDependencies |
| `layouts/layout.tpl` | `<script>` propio para el movimiento |
| `templates/404.tpl`, `search.tpl`, `contact.tpl`, `password.tpl`, `blog.tpl`, `blog-post.tpl` | Marcado de cada pantalla |
| `snipplets/page-header.tpl` | `data-motion="split-lines"` en el h1 de la nota |
| `static/css/lupita.scss.tpl` | Un bloque `#` por pantalla, al final |
| `_harness/render.mjs` | Páginas nuevas, copia del JS, `movil.html` |
| `LUPITA.md` | Documentación y "Sin verificar" |

## Verificación (se repite en cada tarea)

```powershell
cd C:\xampp\htdocs\ahilupita-theme; node _harness/render.mjs
$edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$sp = "C:\Users\lamat\AppData\Local\Temp\claude\C--Users-lamat\53bd86a2-928a-475f-bec9-c16d3eea0ec2\scratchpad"
& $edge --headless=new --disable-gpu --hide-scrollbars --virtual-time-budget=8000 --window-size=1440,1800 "--screenshot=$sp\PAGINA-1440.png" http://localhost:5200/PAGINA.html
& $edge --headless=new --disable-gpu --hide-scrollbars --virtual-time-budget=8000 --window-size=900,1800 "--screenshot=$sp\PAGINA-390.png" "http://localhost:5200/movil.html?p=PAGINA.html"
```

Mirar los PNG con Read. `movil.html` es un iframe de 390 px (Edge no baja de ~500). Después, abrir la página en el navegador de Santiago con `Start-Process`.

---

### Task 1: Bundle de movimiento

**Files:**
- Create: `_harness/motion/entrada.mjs`, `_harness/motion/build.mjs`
- Generate: `static/js/lupita-motion.js.tpl`
- Modify: `package.json`, `layouts/layout.tpl:165`, `_harness/render.mjs` (sección 9 y `CABEZA`)

**Interfaces:**
- Produces: atributos `data-motion="decrypt|stagger|spring|shake|split-lines|hover-preview"`; clase `lu-preview-on` en la lista del blog y `<img class="lu-preview">` en `body`; en el harness la constante `MOTION` (tag `<script>`) y la página `movil.html?p=`.

- [ ] **Step 1: package.json**

```json
{
  "private": true,
  "scripts": {
    "build:motion": "node _harness/motion/build.mjs"
  },
  "devDependencies": {
    "animejs": "^4.5.0",
    "esbuild": "^0.28.2"
  }
}
```

Run: `npm install` → termina sin errores y `node_modules/.bin/esbuild.cmd` existe.

- [ ] **Step 2: entrada.mjs**

```js
/* Movimiento de Ahi! Lupita — un gesto por pantalla, activado por data-motion.
   El HTML ya trae el estado final: todo anima DESDE otro valor hacia el que
   esta en la pagina. Si esto no carga, la pantalla se ve completa y quieta. */
import { animate, stagger, createSpring, createAnimatable, splitText } from 'animejs'

const CARACTERES = '0123456789#%&'

/* 404: los digitos pasan por caracteres al azar y se asientan de izquierda a derecha */
function decrypt(el) {
  const final = el.textContent
  const n = final.length
  const estado = { p: 0 }
  animate(estado, {
    p: n,
    duration: 900,
    ease: 'linear',
    onUpdate: () => {
      const fijos = Math.floor(estado.p)
      let s = final.slice(0, fijos)
      for (let i = fijos; i < n; i++) {
        s += CARACTERES[Math.floor(Math.random() * CARACTERES.length)]
      }
      el.textContent = s
    },
    onComplete: () => { el.textContent = final },
  })
}

/* Busqueda: las tarjetas de la primera pagina entran escalonadas (tope 12) */
function escalonar(el) {
  const items = Array.prototype.slice.call(el.querySelectorAll('.js-item-product'), 0, 12)
  if (!items.length) return
  animate(items, {
    opacity: { from: 0 },
    y: { from: 12 },
    duration: 500,
    delay: stagger(40),
    ease: 'outQuad',
  })
}

/* Contacto: el aviso de exito entra con un resorte corto */
function resorte(el) {
  animate(el, {
    opacity: { from: 0 },
    y: { from: 16 },
    ease: createSpring({ stiffness: 220, damping: 14 }),
  })
}

/* Contrasena incorrecta: el campo tiembla una vez */
function temblar(el) {
  animate(el, {
    x: [{ to: -6 }, { to: 6 }, { to: -6 }, { to: 6 }, { to: 0 }],
    duration: 400,
    ease: 'inOutSine',
  })
}

/* Nota: el titulo sube linea por linea desde abajo de su mascara.
   Espera a las fuentes: cortar lineas con la fuente de reemplazo las corta mal. */
function lineas(el) {
  const listas = document.fonts ? document.fonts.ready : Promise.resolve()
  listas.then(() => {
    try {
      const { lines } = splitText(el, { lines: { wrap: 'clip' } })
      animate(lines, { y: { from: '100%' }, duration: 700, delay: stagger(80), ease: 'outExpo' })
    } catch (e) {
      avisar(e)
    }
  })
}

/* Blog: la foto de la fila sigue al cursor. Solo con mouse; en tactil no pasa nada
   y cada fila muestra su foto fija (la clase lu-preview-on la pone este codigo). */
function vistaPrevia(lista) {
  if (!window.matchMedia('(hover: hover) and (pointer: fine)').matches) return
  const posts = lista.querySelectorAll('.lu-post:not(:first-child)')
  if (!posts.length) return
  const flotante = document.createElement('img')
  flotante.className = 'lu-preview'
  flotante.alt = ''
  flotante.setAttribute('aria-hidden', 'true')
  document.body.appendChild(flotante)
  const seguir = createAnimatable(flotante, { x: 350, y: 350, ease: 'outQuad' })
  lista.classList.add('lu-preview-on')
  posts.forEach((post) => {
    const img = post.querySelector('img')
    if (!img) return
    post.addEventListener('pointerenter', (e) => {
      flotante.src = img.currentSrc || img.getAttribute('data-src') || img.src
      seguir.x(e.clientX + 24, 0)
      seguir.y(e.clientY - 120, 0)
      animate(flotante, { opacity: 1, scale: { from: 0.96, to: 1 }, duration: 250, ease: 'outQuad' })
    })
    post.addEventListener('pointermove', (e) => {
      seguir.x(e.clientX + 24)
      seguir.y(e.clientY - 120)
    })
    post.addEventListener('pointerleave', () => {
      animate(flotante, { opacity: 0, duration: 180, ease: 'outQuad' })
    })
  })
}

const GESTOS = {
  decrypt,
  stagger: escalonar,
  spring: resorte,
  shake: temblar,
  'split-lines': lineas,
  'hover-preview': vistaPrevia,
}

function avisar(e) {
  if (window.console) console.warn('[lupita-motion]', e)
}

function iniciar() {
  if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) return
  document.querySelectorAll('[data-motion]').forEach((el) => {
    const gesto = GESTOS[el.getAttribute('data-motion')]
    if (!gesto) return
    try { gesto(el) } catch (e) { avisar(e) }
  })
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', iniciar)
} else {
  iniciar()
}
```

- [ ] **Step 3: build.mjs**

```js
/* Arma static/js/lupita-motion.js.tpl — NO SE SUBE ESTE ARCHIVO, si su salida.
   Uso: npm run build:motion */
import { build } from 'esbuild'
import { writeFileSync } from 'node:fs'
import { dirname, join } from 'node:path'
import { fileURLToPath } from 'node:url'

const AQUI = dirname(fileURLToPath(import.meta.url))
const DESTINO = join(AQUI, '..', '..', 'static', 'js', 'lupita-motion.js.tpl')
const TOPE_KB = 30

const r = await build({
  entryPoints: [join(AQUI, 'entrada.mjs')],
  bundle: true,
  minify: true,
  format: 'iife',
  target: 'es2019',
  legalComments: 'none',
  write: false,
})

let js = r.outputFiles[0].text

/* Twig incluye el .js.tpl crudo: un {{, {% o {# del minificado lo romperia.
   Un espacio en el medio no cambia el JS fuera de strings; se cuentan para
   revisarlos si aparecen. */
const twig = js.match(/\{[{%#]/g) || []
js = js.replace(/\{([{%#])/g, '{ $1')
new Function(js) // tira si el JS quedo invalido

const kb = Buffer.byteLength(js) / 1024
writeFileSync(DESTINO, `{# Generado por _harness/motion/build.mjs — no editar a mano #}\n${js}\n`)
console.log(`lupita-motion: ${kb.toFixed(1)} KB (tope ${TOPE_KB}) · secuencias Twig neutralizadas: ${twig.length}`)
if (kb > TOPE_KB) {
  console.error('Se paso del tope: sacar splitText y cortar las lineas a mano (ver spec §2 Nota)')
  process.exit(1)
}
```

Run: `npm run build:motion`
Expected: `lupita-motion: NN.N KB (tope 30)` y exit 0. Si pasa de 30, aplicar el recorte del mensaje antes de seguir.

- [ ] **Step 4: layout.tpl** — después del `</script>` de la línea 165:

```twig
        {# Movimiento de Lupita (anime.js recortado): script aparte para que un
           error aca no apague el JS de la tienda #}

        <script type="text/javascript">
            {% include "static/js/lupita-motion.js.tpl" %}
        </script>
```

- [ ] **Step 5: harness** — en `render.mjs`, antes de la sección 9:

```js
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
```

y en la sección 9: `writeFileSync(join(SALIDA, 'lupita-motion.js'), motionJs())` y `writeFileSync(join(SALIDA, 'movil.html'), MOVIL)`.

Agregar al andamio de `CABEZA`, junto al resto de Bootstrap:

```css
    /* style-critical: la columna angosta de la nota del blog */
    @media (min-width: 768px) { .container-narrow { max-width: 680px; } }
```

- [ ] **Step 6: verificar**

Run: `node _harness/render.mjs` → `OK`; `Test-Path _harness/out/lupita-motion.js` → `True`; abrir `http://localhost:5200/movil.html?p=home.html` y ver la home a 390.

- [ ] **Step 7: commit** (si Santiago lo pidió): `package.json package-lock.json _harness/motion layouts/layout.tpl static/js/lupita-motion.js.tpl _harness/render.mjs` — "Movimiento: anime.js recortado por data-motion".

---

### Task 2: 404

**Files:** Modify `templates/404.tpl:10-36`, `static/css/lupita.scss.tpl` (final), `_harness/render.mjs`

**Interfaces:** Consumes `data-motion="decrypt"`, `MOTION`, `tarjeta()`, `PRODUCTOS`, `CABECERA`, `PIE`, `PANELES`.

- [ ] **Step 1: plantilla** — reemplazar la rama `{% else %}` (líneas 10–36):

```twig
{% else %}
	<section class="lu-404" id="404">
		<div class="container">
			<span class="lu-rotulo lu-micro">{{ "Error" | translate }}</span>
			<h1 class="lu-404-cifra" aria-label="404"><span data-motion="decrypt" aria-hidden="true">404</span></h1>
			<p class="lu-404-texto">{{ "La página que estás buscando no existe." | translate }}</p>
			<div class="lu-404-buscar">
				{% include "snipplets/header/header-search.tpl" %}
			</div>
		</div>
		{% set related_products = sections.primary.products | take(4) | shuffle %}
		{% if related_products | length > 1 %}
			<div class="container lu-404-sugeridos">
				<span class="lu-rotulo lu-micro">{{ "Quizás te interesen los siguientes productos." | translate }}</span>
			</div>
			<div class="container" style="padding:0">
				<div class="row">
					{% for related in related_products %}
						{% include 'snipplets/grid/item.tpl' with {product : related} %}
					{% endfor %}
				</div>
			</div>
		{% endif %}
	</section>
{% endif %}
```

- [ ] **Step 2: CSS** — al final de `lupita.scss.tpl`:

```css
/*============================================================================
  #404
  La cifra es el cartel: Italiana a escala de hero, al ras de la izquierda.
  El decrypt (lupita-motion) cambia el texto, nunca el tamaño: la caja se
  reserva con tabular-nums para que los caracteres al azar no la muevan.
==============================================================================*/

.lu-404 {
    padding-top: clamp(2rem, 6vw, 5rem);
    padding-bottom: clamp(3rem, 6vw, 5rem);
}

.lu-404-cifra {
    font-family: var(--lu-macro);
    font-weight: 400;
    font-size: clamp(6rem, 30vw, 22rem);
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

.lu-404-sugeridos {
    border-top: 1px solid var(--lu-linea);
    margin-top: clamp(3rem, 6vw, 5rem);
    padding-top: 1.5rem;
    padding-bottom: 1rem;
}
```

- [ ] **Step 3: harness** — función y escritura:

```js
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
        <form class="js-search-container js-search-form" action="busqueda.html" method="get">
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
      <div class="row">${PRODUCTOS.slice(0, 4).map(tarjeta).join('')}</div>
    </div>
  </section>
${PIE}
${PANELES}
${MOTION}
</body>
</html>
`
}
```

`writeFileSync(join(SALIDA, '404.html'), pagina404(settings))`

- [ ] **Step 4: verificar** con el bloque de Verificación (`PAGINA=404`): la cifra entra en una línea a 390 y a 1440; en el navegador el decrypt corre una vez y termina en "404"; con el DevTools en "reduce motion" no corre.
- [ ] **Step 5: commit** (si corresponde): "404: cifra en Italiana con decrypt".

---

### Task 3: Búsqueda

**Files:** Modify `templates/search.tpl` (entero), `static/css/lupita.scss.tpl`, `_harness/render.mjs`

**Interfaces:** Consumes `data-motion="stagger"`, `snipplets/grid/categories.tpl` con `horizontal: true`, `RIEL`, `tarjeta()`.

- [ ] **Step 1: plantilla**

```twig
{% paginate by 12 %}

{# Encabezado propio (no page-header.tpl): el rotulo va arriba del termino.
   query no esta confirmado en esta plantilla: sin el, vuelve al titulo del base. #}
<section class="page-header mt-3 lu-busqueda-header" data-store="page-title">
	<div class="container">
		<div class="row">
			<div class="col">
				<span class="lu-rotulo lu-micro">{{ "Búsqueda" | translate }}</span>
				<h1>
					{% if query %}
						<span class="lu-busqueda-termino{% if not products %} lu-tachado{% endif %}">“{{ query }}”</span>
					{% else %}
						{{ "Resultados de búsqueda" | translate }}
					{% endif %}
				</h1>
			</div>
		</div>
	</div>
</section>

<section class="category-body">
	<div class="container">
		{% if products %}
			<div class="js-product-table row" data-motion="stagger">
				{% include 'snipplets/product_grid.tpl' %}
			</div>
			{% include 'snipplets/grid/pagination.tpl' with { infinite_scroll: true } %}
		{% else %}
			<p class="lu-busqueda-vacia">{{ "No hubo resultados para tu búsqueda" | translate }}</p>
			{% if categories %}
				<span class="lu-rotulo lu-micro">{{ "Seguí mirando" | translate }}</span>
				{% include 'snipplets/grid/categories.tpl' with { horizontal: true, filter_categories: categories } %}
			{% endif %}
		{% endif %}
	</div>
</section>
```

- [ ] **Step 2: CSS**

```css
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

.template-search .lu-busqueda-vacia + .lu-rotulo {
    display: block;
    margin-bottom: 0.75rem;
}
```

- [ ] **Step 3: harness** — una función con dos variantes:

```js
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
      <span class="lu-rotulo lu-micro">Seguí mirando</span>
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
```

`writeFileSync(join(SALIDA, 'busqueda.html'), paginaBusqueda(settings, false))` y `writeFileSync(join(SALIDA, 'busqueda-vacia.html'), paginaBusqueda(settings, true))`. En `pagina.html` borrar el muestrario "busqueda sin resultados" (líneas 1497–1502): ya tiene página propia.

- [ ] **Step 4: verificar** `busqueda` y `busqueda-vacia` a 1440 y 390: término largo sin desbordar a 390, tachado legible, riel recorrible; en el navegador las tarjetas entran escalonadas y terminan con opacidad 1.
- [ ] **Step 5: commit** (si corresponde): "Busqueda: termino como titulo, tachado sin resultados".

---

### Task 4: Contacto

**Files:** Modify `templates/contact.tpl:12-104`, `static/css/lupita.scss.tpl`, `_harness/render.mjs`

**Interfaces:** Consumes `data-motion="spring"`.

- [ ] **Step 1: plantilla** — reemplazar desde `<section class="contact-page">` hasta el final. La lógica de cancelación, honeypot y producto no cambia; cambian la grilla y dos atributos:

```twig
<section class="contact-page">
	<div class="container">
		<div class="row lu-contacto">
			<div class="col-md-5 lu-contacto-datos">
				{% if is_order_cancellation %}
					<p data-component="order-cancellation-disclaimer">{{ "Si te arrepentiste, podés pedir la cancelación enviando este formulario. Tenés como máximo hasta 10 días corridos desde que recibiste el producto." | translate }} </p>
					<a class="btn-link" href="{{ status_page_url_regret }}">{{'Ver detalle de la compra >' | translate}}</a>
					{% if has_contact_info %}
						<p class="mt-4 mb-3">{{ 'Si tenés problemas con otra compra, contactanos:' | translate }}</p>
					{% endif %}
				{% endif %}
				{% if store.contact_intro %}
					<p class="lu-contacto-intro">{{ store.contact_intro }}</p>
				{% endif %}
				{% if has_contact_info %}
					{% include "snipplets/contact-links.tpl" %}
				{% endif %}
			</div>
			<div class="col-md-7 lu-contacto-form">
				{% if product %}
					<div class="lu-contacto-producto">
						<img src="{{ product.featured_image | product_image_url('thumb') }}" title="{{ product.name }}" alt="{{ product.name }}" />
						<p>{{ "Usted está consultando por el siguiente producto:" | translate }} </br> {{ product.name | a_tag(product.url) }}</p>
					</div>
				{% endif %}
				{% if contact %}
					{% if contact.success %}
						{% if is_order_cancellation %}
							<div class="alert alert-success" data-component="order-cancellation-success-message" data-motion="spring">
								{{ "¡Tu pedido de cancelación fue enviado!" | translate }}
								<br>
								{{ "Vamos a ponernos en contacto con vos apenas veamos tu mensaje." | translate }}
								<br>
								<strong>{{ "Tu código de trámite es" | translate }} #{{ last_order_id }}</strong>
							</div>
						{% else %}
							<div class="alert alert-success" data-component="contact-success-message" data-motion="spring">{{ "¡Gracias por contactarnos! Vamos a responderte apenas veamos tu mensaje." | translate }}</div>
						{% endif %}
					{% else %}
						<div class="alert alert-danger">{{ "Necesitamos tu nombre y un email para poder responderte." | translate }}</div>
					{% endif %}
				{% endif %}
```

…y a partir de `{% if is_order_cancellation_without_id %}` el bloque del formulario queda **idéntico** a las líneas 57–100 actuales, cerrando con:

```twig
			</div>
		</div>
	</div>
</section>
```

- [ ] **Step 2: CSS**

```css
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
```

- [ ] **Step 3: harness** — copiar al andamio lo del base que toca (style-critical `.contact-info`, `.contact-item`):

```css
    /* style-critical: lista de contact-links.tpl */
    .contact-info { margin-top: 0; padding-left: 0; }
    .contact-item { list-style: none; }
```

y la página, con el aviso de éxito visible y datos de relleno marcados:

```js
function paginaContacto(settings) {
  const campo = (id, rotulo, tipo = 'text') => `
          <div class="form-group">
            <label class="form-label" for="${id}">${rotulo}</label>
            <input type="${tipo}" class="form-control" id="${id}" name="${id}">
          </div>`
  return `${CABEZA('Contacto')}
<body class="template-contact">
${CABECERA(settings)}
  <section class="page-header mt-3" data-store="page-title">
    <div class="container"><div class="row"><div class="col text-center">
      <div class="breadcrumbs"><a class="crumb" href="home.html">Inicio</a><span class="divider">></span><span class="crumb active">Contacto</span></div>
      <h1>Contacto</h1>
    </div></div></div>
  </section>
  <section class="contact-page">
    <div class="container">
      <div class="row lu-contacto">
        <div class="col-md-5 lu-contacto-datos">
          <p class="lu-contacto-intro">[ Demo: el texto de contacto lo escribe la clienta en el panel ]</p>
          <ul class="contact-info text-center">
            <li class="contact-item">${ICONO.lupa}<a href="#" class="contact-link">[ mail del panel ]</a></li>
            <li class="contact-item">${ICONO.lupa}[ dirección del panel ]</li>
          </ul>
        </div>
        <div class="col-md-7 lu-contacto-form">
          <div class="alert alert-success" data-motion="spring">¡Gracias por contactarnos! Vamos a responderte apenas veamos tu mensaje.</div>
          <form class="form">
${campo('name', 'Nombre')}${campo('email', 'Email', 'email')}${campo('phone', 'Teléfono', 'tel')}
            <div class="form-group">
              <label class="form-label" for="message">Mensaje</label>
              <textarea class="form-control form-control-area" id="message" rows="7"></textarea>
            </div>
            <input type="submit" class="btn btn-primary btn-block" value="Enviar">
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
```

`writeFileSync(join(SALIDA, 'contacto.html'), paginaContacto(settings))`

- [ ] **Step 4: verificar** a 1440 (dos columnas con la línea en el medio) y a 390 (apilado); el aviso entra con resorte y queda quieto en su lugar.
- [ ] **Step 5: commit** (si corresponde): "Contacto: dos columnas y aviso con resorte".

---

### Task 5: Contraseña

**Files:** Modify `templates/password.tpl:49-50,94-135`, `static/css/lupita.scss.tpl`, `_harness/render.mjs`

**Interfaces:** Consumes `data-motion="shake"`.

- [ ] **Step 1: plantilla** — después de la línea 49 (style-async), la hoja del sistema (esta plantilla no usa `layout.tpl`):

```twig
        {# Sistema visual de Ahi! Lupita: password.tpl no pasa por layout.tpl #}
        <link rel="stylesheet" href="{{ 'css/lupita.scss.tpl' | static_url }}">
```

Reemplazar la sección (94–120):

```twig
        <section class="section-password lu-cerrado">
            <div class="container">
                <div class="lu-cerrado-logo">
                    {{ component('logos/logo', {logo_size: 'large', logo_img_classes: 'transition-soft-slow', logo_text_classes: 'h1 m-0'}) }}
                </div>
                <h2 class="lu-cerrado-mensaje">{{ message }}</h2>
                <div class="lu-cerrado-form" {% if invalid_password == true %}data-motion="shake"{% endif %}>
                    {% embed "snipplets/forms/form.tpl" with{form_id: 'password-form', submit_text: 'Desbloquear' | translate } %}
                        {% block form_body %}
                            {% embed "snipplets/forms/form-input.tpl" with{input_for: 'password', type_password: true, input_name: 'password', input_help: true, input_help_link: store.customer_reset_password_url, input_label_text: 'Contraseña de acceso' | translate } %}
                                {% block input_form_alert %}
                                    {% if invalid_password == true %}
                                        <div class="alert alert-danger">{{ 'La contraseña es incorrecta.' | translate }}</div>
                                    {% endif %}
                                {% endblock input_form_alert %}
                            {% endembed %}
                        {% endblock %}
                    {% endembed %}
                </div>
            </div>
        </section>
```

y en el `<script>` final, después del include de `external-no-dependencies`:

```twig
        </script>
        <script type="text/javascript">
            {% include "static/js/lupita-motion.js.tpl" %}
        </script>
```

- [ ] **Step 2: CSS**

```css
/*============================================================================
  #Tienda cerrada (password.tpl)
  El unico lugar donde el turquesa es el fondo de toda la pantalla: tinta
  encima da 8.27:1. El campo es una caja de papel; el foco es borde de tinta
  de 2px (sobre turquesa, turquesa no se veria).
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
    font-family: var(--lu-macro);
    font-weight: 400;
    font-size: clamp(1.75rem, 5vw, 3.5rem);
    line-height: 1.05;
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

.template-password .footer,
.template-password footer {
    background-color: transparent;
    border-top: 1px solid var(--lu-tinta);
}
```

- [ ] **Step 3: harness**

```js
function paginaContrasena() {
  return `${CABEZA('Tienda cerrada')}
<body class="template-password">
  <section class="section-password lu-cerrado">
    <div class="container">
      <div class="lu-cerrado-logo"><div class="logo-text-container"><span class="logo-text h1 m-0">AHI ! LUPITA</span></div></div>
      <h2 class="lu-cerrado-mensaje">[ Mensaje del panel: ej. Volvemos pronto ]</h2>
      <div class="lu-cerrado-form" data-motion="shake">
        <form class="form">
          <div class="form-group">
            <label class="form-label" for="password">Contraseña de acceso</label>
            <input type="password" class="form-control" id="password" name="password">
            <div class="alert alert-danger">La contraseña es incorrecta.</div>
          </div>
          <input type="submit" class="btn btn-primary btn-block" value="Desbloquear">
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
```

`writeFileSync(join(SALIDA, 'contrasena.html'), paginaContrasena())`

- [ ] **Step 4: verificar**: turquesa a sangre, logotipo que no se parte a 320/390, campo en papel; foco de teclado visible sobre turquesa; tiembla una vez al cargar.
- [ ] **Step 5: commit** (si corresponde): "Contrasena: tienda cerrada en turquesa, el campo tiembla si falla".

---

### Task 6: Blog y nota

**Files:** Modify `templates/blog.tpl`, `templates/blog-post.tpl`, `snipplets/page-header.tpl:19`, `static/css/lupita.scss.tpl`, `_harness/render.mjs`

**Interfaces:** Consumes `data-motion="hover-preview"` (clases `.lu-post`, `lu-preview-on`, `.lu-preview`) y `data-motion="split-lines"`.

**Riesgo:** el HTML interno de `component('blog/...')` no está publicado. Por eso **todo el CSS apunta a las clases que pasamos nosotros** en `post_item_classes`/`post_content_classes`, nunca a las internas del componente. El DOM del harness es una deducción y va a "Sin verificar".

- [ ] **Step 1: blog.tpl**

```twig
<div class="container">
    {% embed "snipplets/page-header.tpl" with { breadcrumbs: true } %}
        {% block page_header_text %}{{ "Blog" | translate }}{% endblock page_header_text %}
    {% endembed %}

    {# Lista editorial: una fila por nota. Las clases lu-* son las que controla
       el theme; el HTML de adentro lo arma la plataforma. #}
    <section class="blog-page lu-blog" data-motion="hover-preview">
        {% for post in blog.posts %}
            {{ component(
                'blog/blog-post-item', {
                    image_lazy: false,
                    post_item_classes: {
                        item: 'lu-post',
                        image_container: 'lu-post-imagen',
                        image: 'lu-post-img',
                        title: 'lu-post-titulo',
                        summary: 'lu-post-resumen',
                        read_more: 'lu-post-leer',
                    },
                })
            }}
        {% endfor %}
    </section>
    {% include 'snipplets/grid/pagination.tpl' with {'pages': blog.pages} %}
</div>
```

- [ ] **Step 2: blog-post.tpl**

```twig
<div class="container container-narrow">

    {% embed "snipplets/page-header.tpl" with { breadcrumbs: true} %}
        {% block page_header_text %}{{ post.title | translate }}{% endblock page_header_text %}
    {% endembed %}

    <div class="blog-post-page lu-nota">
        {{ component(
            'blog/blog-post-content', {
                image_lazy: true,
                image_lazy_js: true,
                post_content_classes: {
                    date: 'lu-nota-fecha',
                    image: 'img-fluid fade-in lu-nota-img',
                    content: 'user-content lu-nota-cuerpo',
                },
            })
        }}
    </div>
</div>
```

`user-content` le da al cuerpo las reglas de texto largo que ya existen (#Texto institucional).

- [ ] **Step 3: page-header.tpl:19** — el h1 queda:

```twig
                <h1 {% if template == 'product' %}class="js-product-name" data-store="product-name-{{ product.id }}"{% endif %}{% if template == 'blog-post' %} data-motion="split-lines"{% endif %}>{% block page_header_text %}{% endblock %}</h1>
```

- [ ] **Step 4: CSS**

```css
/*============================================================================
  #Blog
  Lista editorial en vez de la grilla de 3. Todo apunta a las clases lu-post*
  que pasa blog.tpl: el HTML interno del componente no es nuestro.
  La primera nota va grande con su foto; las demas son filas de 1px. Con
  mouse (lupita-motion agrega .lu-preview-on) la foto de las filas se oculta
  y aparece flotando junto al cursor; sin JS o en tactil queda chica y fija.
==============================================================================*/

.lu-blog {
    border-top: 1px solid var(--lu-tinta);
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

.lu-post-imagen {
    grid-column: 1;
    grid-row: 1 / span 3;
    position: relative;
    aspect-ratio: 3 / 4;
    height: auto;
    overflow: hidden;
    margin: 0;
}

.lu-post-img {
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
    padding-top: 0;
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
    font-size: clamp(2rem, 6vw, 4.5rem);
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
  .user-content (#Texto institucional). El titulo lo corta lupita-motion
  en lineas; la mascara la pone splitText (wrap: clip).
==============================================================================*/

.template-blog-post .page-header h1 {
    font-size: clamp(2.25rem, 7vw, 4.5rem);
    line-height: 1.02;
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
```

- [ ] **Step 5: harness** — andamio del base (style-critical #Blog) y dos páginas:

```css
    /* style-critical #Blog: el base le fija 200px de alto a la caja de la foto
       y line-clamp de 3 al titulo y resumen */
    .post-item-image-container { position: relative; height: 200px; overflow: hidden; }
    .post-item-image { width: 100%; height: 100%; object-fit: cover; }
    .post-item-title, .post-item-summary { display: -webkit-box; -webkit-box-orient: vertical; -webkit-line-clamp: 3; overflow: hidden; text-overflow: ellipsis; line-height: 1.5em; }
```

```js
const NOTAS = [
  { titulo: 'Cómo combinar un blazer estructurado para todos los días', resumen: '[ Demo ] Tres formas de llevarlo del trabajo a la noche sin cambiarte entera.', foto: '#A8A093' },
  { titulo: 'Guía de talles: medirte en casa', resumen: '[ Demo ] Busto, cintura y cadera con un centímetro y dos minutos.', foto: '#8C9AA3' },
  { titulo: 'Lo nuevo de la temporada', resumen: '[ Demo ] Las prendas que entraron esta semana a los locales.', foto: '#6E6A63' },
  { titulo: 'Cuidar el satén', resumen: '[ Demo ] Lavado, planchado y guardado para que dure.', foto: '#CFC7B8' },
]

/* DEDUCIDO: el componente blog-post-item no esta publicado. Clases del base
   (post-item-*) + las que pasa blog.tpl (lu-post*). Verificar en la tienda. */
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
```

`writeFileSync(join(SALIDA, 'blog.html'), paginaBlog(settings))`, `writeFileSync(join(SALIDA, 'nota.html'), paginaNota(settings))`

- [ ] **Step 6: verificar**: blog a 1440 (primera nota a dos columnas, filas sin foto), a 390 (filas con foto chica fija), la foto sigue al mouse en el navegador; nota a 1440 y 390 con el título entrando por líneas y sin quedar cortado al terminar.
- [ ] **Step 7: commit** (si corresponde): "Blog y nota: lista editorial con vista previa, titulo por lineas".

---

### Task 7: Dispositivos, verificación final y documentación

**Files:** Modify `_harness/render.mjs` (`paginaDispositivos`), `LUPITA.md`, vault (`Temas/Ahi-Lupita.md`, `Bitácora.md`, `Tareas.md`)

- [ ] **Step 1:** en `paginaDispositivos`, agregar al `<nav>` y como filas: `Busqueda` → `busqueda.html`, `Sin resultados` → `busqueda-vacia.html`, `404` → `404.html`, `Contacto` → `contacto.html`, `Contrasena` → `contrasena.html`, `Blog` → `blog.html`, `Nota` → `nota.html`.
- [ ] **Step 2:** sin JS: renombrar temporalmente `_harness/out/lupita-motion.js`, capturar las siete páginas a 1440, verificar que todo el contenido se ve, restaurar el archivo.
- [ ] **Step 3:** reduced-motion: en Edge con `--force-prefers-reduced-motion`, capturar `404.html` con `--virtual-time-budget=200` y verificar que la cifra dice "404".
- [ ] **Step 4:** `LUPITA.md`: sección "## Pantallas restantes (2026-09-15)" con lo hecho por pantalla, el bundle (tamaño medido, cómo regenerarlo: `npm run build:motion`, que `lupita-motion.js.tpl` SÍ se sube en `static/`), y sumar a "Sin verificar": `query` y `categories` en `search.tpl`; `lupita.scss.tpl` y el JS en `password.tpl`; el HTML real y las clases aceptadas por `blog-post-item` y `blog-post-content`; que el script de movimiento no choque con `store.js`; el scroll infinito con tarjetas animadas.
- [ ] **Step 5:** vault: entrada en Bitácora, sección en `Temas/Ahi-Lupita.md`, tareas `#ahilupita` para lo "Sin verificar".
- [ ] **Step 6: commit** (si corresponde): "Pantallas restantes: dispositivos y documentacion".
