/* Movimiento de Ahi! Lupita — un gesto por pantalla, activado por data-motion.
   El HTML ya trae el estado final: todo anima DESDE otro valor hacia el que
   esta en la pagina. Si esto no carga, la pantalla se ve completa y quieta.

   waapi.animate y no animate: el motor completo de anime.js pesaba 41,7 KB y
   este 19,8 KB (2026-09-15). waapi solo anima propiedades CSS, asi que el
   decrypt (texto) y el seguimiento del cursor (valores sueltos) van a mano
   con requestAnimationFrame. */
import { waapi, stagger, createSpring } from 'animejs'

/* Solo digitos: en Italiana # y % son mucho mas anchos y la cifra saltaba */
const CARACTERES = '0123456789'

function avisar(e) {
  if (window.console) console.warn('[lupita-motion]', e)
}

/* 404: los digitos pasan por caracteres al azar y se asientan de izquierda a derecha */
function decrypt(el) {
  const final = el.textContent
  const n = final.length
  const duracion = 900
  let inicio = 0
  const paso = (t) => {
    if (!inicio) inicio = t
    const fijos = Math.min(n, Math.floor(((t - inicio) / duracion) * n))
    let s = final.slice(0, fijos)
    for (let i = fijos; i < n; i++) {
      s += CARACTERES[Math.floor(Math.random() * CARACTERES.length)]
    }
    el.textContent = s
    if (fijos < n && !listo) requestAnimationFrame(paso)
    else el.textContent = final
  }
  let listo = false
  requestAnimationFrame(paso)
  /* Respaldo: en una pestaña en segundo plano rAF se frena, y la cifra no puede
     quedar desordenada. Pase lo que pase, a los 1,1 s dice lo que tiene que decir. */
  setTimeout(() => { listo = true; el.textContent = final }, duracion + 200)
}

/* Busqueda: las tarjetas de la primera pagina entran escalonadas (tope 12) */
function escalonar(el) {
  const items = Array.prototype.slice.call(el.querySelectorAll('.js-item-product'), 0, 12)
  if (!items.length) return
  waapi.animate(items, {
    opacity: { from: 0 },
    y: { from: 12 },
    duration: 500,
    delay: stagger(40),
    ease: 'outQuad',
  })
}

/* Contacto: el aviso de exito entra con un resorte corto */
function resorte(el) {
  waapi.animate(el, {
    opacity: { from: 0 },
    y: { from: 16 },
    ease: createSpring({ stiffness: 220, damping: 14 }),
  })
}

/* Contrasena incorrecta: el campo tiembla una vez */
function temblar(el) {
  waapi.animate(el, {
    x: [0, -6, 6, -6, 6, 0],
    duration: 400,
    ease: 'inOutSine',
  })
}

/* Nota: el titulo sube palabra por palabra desde abajo de su mascara.
   Corte a mano y no splitText: splitText sumaba 6 KB sin necesidad.
   El lector de pantalla lee el aria-label; las mascaras van aria-hidden. */
function lineas(el) {
  const texto = el.textContent.trim()
  if (!texto) return
  el.setAttribute('aria-label', texto)
  el.textContent = ''
  const palabras = texto.split(/\s+/).map((palabra, i, todas) => {
    const mascara = document.createElement('span')
    mascara.className = 'lu-mascara'
    mascara.setAttribute('aria-hidden', 'true')
    const interior = document.createElement('span')
    interior.textContent = palabra
    mascara.appendChild(interior)
    el.appendChild(mascara)
    if (i < todas.length - 1) el.appendChild(document.createTextNode(' '))
    return interior
  })
  waapi.animate(palabras, { y: { from: '110%' }, duration: 700, delay: stagger(35), ease: 'outExpo' })
}

/* Blog: la foto de la fila sigue al cursor. Solo con mouse; en tactil no pasa
   nada y cada fila muestra su foto fija (lu-preview-on la pone este codigo). */
function vistaPrevia(lista) {
  if (!window.matchMedia('(hover: hover) and (pointer: fine)').matches) return
  const posts = lista.querySelectorAll('.lu-post:not(:first-child)')
  if (!posts.length) return

  const flotante = document.createElement('img')
  flotante.className = 'lu-preview'
  flotante.alt = ''
  flotante.setAttribute('aria-hidden', 'true')
  document.body.appendChild(flotante)
  lista.classList.add('lu-preview-on')

  /* Seguimiento con retraso: cada cuadro recorre el 18% de lo que falta */
  const pos = { x: 0, y: 0, ax: 0, ay: 0 }
  let cuadro = 0
  const seguir = () => {
    pos.x += (pos.ax - pos.x) * 0.18
    pos.y += (pos.ay - pos.y) * 0.18
    flotante.style.transform = `translate3d(${pos.x}px, ${pos.y}px, 0)`
    cuadro = Math.abs(pos.ax - pos.x) + Math.abs(pos.ay - pos.y) > 0.5 ? requestAnimationFrame(seguir) : 0
  }
  const apuntar = (e, saltar) => {
    pos.ax = e.clientX + 24
    pos.ay = e.clientY - 120
    if (saltar) { pos.x = pos.ax; pos.y = pos.ay }
    if (!cuadro) cuadro = requestAnimationFrame(seguir)
  }

  posts.forEach((post) => {
    const img = post.querySelector('img')
    if (!img) return
    post.addEventListener('pointerenter', (e) => {
      flotante.src = img.currentSrc || img.getAttribute('data-src') || img.src
      apuntar(e, true)
      waapi.animate(flotante, { opacity: 1, duration: 200, ease: 'outQuad' })
    })
    post.addEventListener('pointermove', (e) => apuntar(e, false))
    post.addEventListener('pointerleave', () => {
      waapi.animate(flotante, { opacity: 0, duration: 160, ease: 'outQuad' })
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
