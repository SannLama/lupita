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

/* ---------------------------------------------------------------------------
   Movimiento de todo el sitio (2026-09-16, pedido de Santiago: "mas
   animaciones"). Con Element.animate nativo y no con anime.js: son fundidos y
   transformaciones fijas, no suman peso al paquete.
   --------------------------------------------------------------------------- */

/* Las mismas curvas del theme (--lu-entrada en la hoja) */
const SALIDA_SUAVE = 'cubic-bezier(0.16, 0.84, 0.44, 1)'
const IDA_Y_VUELTA = 'cubic-bezier(0.77, 0, 0.175, 1)'
const RESPUESTA = 'cubic-bezier(0.23, 1, 0.32, 1)'

/* Cinta de video: fuera de pantalla se frena la pista y se pausan los videos */
function cinta(el) {
  if (!('IntersectionObserver' in window)) return
  const videos = el.querySelectorAll('video')
  new IntersectionObserver((entradas) => {
    entradas.forEach((e) => {
      el.classList.toggle('lu-cinta-quieta', !e.isIntersecting)
      videos.forEach((v) => {
        if (e.isIntersecting) { const p = v.play(); if (p && p.catch) p.catch(() => {}) } else v.pause()
      })
    })
  }, { rootMargin: '200px 0px' }).observe(el)
}

/* Lo que aparece al bajar: fundido y subida corta, escalonado cuando entran
   varios juntos (una fila de productos). Solo lo que arranca FUERA de la
   pantalla: lo que ya se ve al cargar no parpadea. */
const APARECEN = [
  '.lu-seccion-titulo',
  '.js-item-product',
  '.section-banners-home .textbanner',
  '.section-home-modules .textbanner',
  '.service-item-container',
  '.lu-campana',
  '.instafeed-link',
  '.lu-sobre-foto',
  '.lu-faq-item',
].join(',')

/* Titulos en la cursiva (Great Vibes): se descubren de izquierda a derecha,
   como si se escribieran. El recorte se agranda hacia arriba, abajo y a los
   costados para no cortar los rulos de las mayusculas. */
const TITULOS = [
  '.page-header h1:not([data-motion])',
  '.section-banners-home .textbanner-title',
  '.section-cover-home .swiper-title',
  '.section-capsule-home .swiper-title',
  '.lu-seccion-titulo h2',
].join(',')

const TAPADO = 'inset(-40% 100% -40% -10%)'
const DESTAPADO = 'inset(-40% -10% -40% -10%)'

function adentroDeOtroGesto(el) {
  return el.closest('[data-motion="stagger"], .modal, .js-modal')
}

function aparecer(lote) {
  lote.forEach((el, i) => {
    el.animate(
      [{ opacity: 0, transform: 'translate3d(0, 24px, 0)' }, { opacity: 1, transform: 'none' }],
      { duration: 700, delay: Math.min(i, 6) * 60, easing: SALIDA_SUAVE, fill: 'backwards' }
    )
    /* fill backwards sostiene el 0 durante la demora: el estilo en linea ya
       no hace falta */
    el.style.opacity = ''
  })
}

function escribir(el, demora) {
  el.style.clipPath = ''
  el.animate(
    [{ clipPath: TAPADO }, { clipPath: DESTAPADO }],
    { duration: 1300, delay: demora, easing: IDA_Y_VUELTA, fill: 'backwards' }
  )
}

function alBajar() {
  if (!Element.prototype.animate) return
  const alto = window.innerHeight
  const pendientes = new Set()

  document.querySelectorAll(APARECEN).forEach((el) => {
    if (adentroDeOtroGesto(el) || el.getBoundingClientRect().top < alto) return
    el.style.opacity = '0'
    pendientes.add(el)
  })

  const titulos = new Set()
  document.querySelectorAll(TITULOS).forEach((el) => {
    if (adentroDeOtroGesto(el)) return
    /* Los que ya estan a la vista se escriben apenas carga la pagina */
    if (el.getBoundingClientRect().top < alto) { escribir(el, 150); return }
    el.style.clipPath = TAPADO
    titulos.add(el)
  })

  /* Revision por scroll y no IntersectionObserver: en la prueba del
     2026-09-16 el observer no disparaba y todo quedaba invisible. Con el
     scroll se revisan las cajas en el cuadro siguiente; lo que ya quedo
     ARRIBA de la pantalla (un salto con Inicio o un ancla) tambien se
     muestra, nada puede quedar escondido. */
  /* Directo en el evento y no con requestAnimationFrame: son unas decenas de
     getBoundingClientRect, y asi no depende de que el navegador pinte cuadros
     (en una pestaña en segundo plano o en la prueba headless no los pinta) */
  const revisar = () => {
    const limite = window.innerHeight * 0.92
    const lote = []
    const toca = (el) => el.getBoundingClientRect().top < limite
    pendientes.forEach((el) => { if (toca(el)) { pendientes.delete(el); lote.push(el) } })
    titulos.forEach((el) => { if (toca(el)) { titulos.delete(el); escribir(el, 0) } })
    if (lote.length) aparecer(lote)
    if (!pendientes.size && !titulos.size) {
      window.removeEventListener('scroll', revisar)
      window.removeEventListener('resize', revisar)
    }
  }
  window.addEventListener('scroll', revisar, { passive: true })
  window.addEventListener('resize', revisar)
  revisar()
}

/* Contadores de la bolsa y favoritos: el circulito salta cuando cambia el
   numero. Se cancela el salto anterior si se agregan dos cosas seguidas. */
function saltar(el) {
  el.getAnimations().forEach((a) => a.cancel())
  el.animate(
    [{ transform: 'scale(1)' }, { transform: 'scale(1.4)', offset: 0.35 }, { transform: 'scale(1)' }],
    { duration: 420, easing: RESPUESTA }
  )
}

function contadores() {
  if (!('MutationObserver' in window)) return
  document.querySelectorAll('.cart-widget-amount, .lu-favs-cantidad').forEach((el) => {
    let antes = el.textContent.trim()
    new MutationObserver(() => {
      const ahora = el.textContent.trim()
      if (ahora !== antes) { antes = ahora; saltar(el) }
    }).observe(el, { childList: true, characterData: true, subtree: true })
  })
}

/* Corazon: late una vez al guardar (no al sacar) */
function corazones() {
  document.addEventListener('click', (e) => {
    const boton = e.target.closest && e.target.closest('.js-fav')
    if (!boton) return
    setTimeout(() => {
      if (boton.getAttribute('aria-pressed') !== 'true') return
      const icono = boton.querySelector('svg') || boton
      icono.getAnimations().forEach((a) => a.cancel())
      icono.animate(
        [
          { transform: 'scale(1)' },
          { transform: 'scale(1.3)', offset: 0.3 },
          { transform: 'scale(0.94)', offset: 0.6 },
          { transform: 'scale(1)' },
        ],
        { duration: 480, easing: RESPUESTA }
      )
    }, 0)
  })
}

const GESTOS = {
  decrypt,
  stagger: escalonar,
  spring: resorte,
  shake: temblar,
  'split-lines': lineas,
  'hover-preview': vistaPrevia,
  cinta,
}

function iniciar() {
  if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) return
  document.querySelectorAll('[data-motion]').forEach((el) => {
    const gesto = GESTOS[el.getAttribute('data-motion')]
    if (!gesto) return
    try { gesto(el) } catch (e) { avisar(e) }
  })
  ;[alBajar, contadores, corazones].forEach((f) => {
    try { f() } catch (e) { avisar(e) }
  })
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', iniciar)
} else {
  iniciar()
}
