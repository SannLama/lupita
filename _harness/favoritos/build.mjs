/* Arma static/js/lupita-favoritos.js.tpl — este archivo NO se sube, su salida si.
   Uso: npm run build:favoritos */
import { build } from 'esbuild'
import { writeFileSync } from 'node:fs'
import { Script } from 'node:vm'
import { dirname, join } from 'node:path'
import { fileURLToPath } from 'node:url'

const AQUI = dirname(fileURLToPath(import.meta.url))
const DESTINO = join(AQUI, '..', '..', 'static', 'js', 'lupita-favoritos.js.tpl')
const TOPE_KB = 8

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

/* Twig incluye el .js.tpl crudo: {{, {% o {# lo romperian */
const twig = js.match(/\{[{%#]/g) || []
js = js.replace(/\{([{%#])/g, '{ $1')
new Script(js) // solo compila: tira si el JS quedo invalido

const kb = Buffer.byteLength(js) / 1024
writeFileSync(DESTINO, `{# Generado por _harness/favoritos/build.mjs — no editar a mano #}\n${js}\n`)
console.log(`lupita-favoritos: ${kb.toFixed(1)} KB (tope ${TOPE_KB}) · secuencias Twig neutralizadas: ${twig.length}`)
if (kb > TOPE_KB) process.exit(1)
