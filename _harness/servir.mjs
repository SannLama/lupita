/**
 * Servidor estatico minimo para mirar el harness. NO SE SUBE POR FTP.
 * Uso: node _harness/servir.mjs  ->  http://localhost:5200/categoria.html
 */

import { createServer } from 'node:http'
import { readFile } from 'node:fs/promises'
import { dirname, join, extname, normalize } from 'node:path'
import { fileURLToPath } from 'node:url'

const RAIZ = join(dirname(fileURLToPath(import.meta.url)), 'out')
const PUERTO = 5200

const TIPOS = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.svg': 'image/svg+xml',
}

createServer(async (req, res) => {
  const pedido = decodeURIComponent(req.url.split('?')[0])
  const ruta = join(RAIZ, normalize(pedido === '/' ? '/categoria.html' : pedido))

  if (!ruta.startsWith(RAIZ)) {
    res.writeHead(403).end('no')
    return
  }

  try {
    const cuerpo = await readFile(ruta)
    res.writeHead(200, {
      'Content-Type': TIPOS[extname(ruta)] ?? 'application/octet-stream',
      'Cache-Control': 'no-store',
    })
    res.end(cuerpo)
  } catch {
    res.writeHead(404).end('404')
  }
}).listen(PUERTO, () => console.log(`harness en http://localhost:${PUERTO}/categoria.html`))
