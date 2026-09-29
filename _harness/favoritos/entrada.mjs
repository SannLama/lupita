/* Favoritos de Ahi! Lupita — la interfaz. La logica vive en logica.mjs.
   Todo el marcado nace en el HTML (Twig) con hidden: si el navegador no deja
   guardar, esto sale sin mostrar nada y la tienda queda como antes. */
import { disponible, leer, guardar, contiene, alternar, quitar, urlWhatsApp } from './logica.mjs'

const almacen = (() => {
  try { return window.localStorage } catch (e) { return undefined }
})()

let temporizador = 0

function datosDe(boton) {
  const d = boton.dataset
  return {
    id: d.favId, nombre: d.favNombre || '', url: d.favUrl || '', imagen: d.favImagen || '', precio: d.favPrecio || '', variante: '',
    num: parseFloat(d.favPrecioNum) || 0, desc: parseFloat(d.favDesc) || 0,
  }
}

/* En la ficha el precio puede cambiar con la variante: se toma el que se ve */
function precioDeLaFicha() {
  const el = document.querySelector('#single-product #price_display')
  return el ? parseFloat(el.textContent.replace(/[^\d,]/g, '').replace(',', '.')) || 0 : 0
}

const pesos = (n) => '$' + Math.round(n).toLocaleString('es-AR')

/* Los precios como en el carrito: tarjeta en gris, efectivo en turquesa y
   las 6 cuotas. Las prendas guardadas antes de esto solo traen el texto. */
function precios(p) {
  const caja = elemento('div', 'lu-favs-precios')
  if (!p.num) {
    if (p.precio) caja.appendChild(elemento('span', 'lu-favs-precio', p.precio))
    return caja
  }
  caja.appendChild(elemento('span', 'lu-favs-tarjeta', `${pesos(p.num)} con tarjeta`))
  if (p.desc) caja.appendChild(elemento('span', 'lu-favs-efectivo', `${pesos(p.num * (100 - p.desc) / 100)} con Efectivo`))
  caja.appendChild(elemento('span', 'lu-favs-cuotas', `6 cuotas sin interés de ${pesos(p.num / 6)}`))
  return caja
}

/* Ficha: "Talle M / Negro" con lo elegido en el formulario al momento de guardar */
function varianteElegida(boton) {
  const form = boton.closest('form')
  if (!form) return ''
  const partes = []
  form.querySelectorAll('.js-product-variants-group').forEach((grupo) => {
    const activo = grupo.querySelector('.js-insta-variant.selected .btn-variant-content')
    const select = grupo.querySelector('select.js-variation-option')
    const valor = activo ? activo.getAttribute('data-name') : (select && select.selectedIndex >= 0 ? select.options[select.selectedIndex].text : '')
    if (!valor) return
    const rotulo = grupo.querySelector('.form-label')
    const nombre = rotulo ? rotulo.textContent.trim() : ''
    partes.push(nombre && !/^(color|cor)$/i.test(nombre) ? `${nombre} ${valor.trim()}` : valor.trim())
  })
  return partes.join(' / ')
}

function marcar(boton, guardada) {
  boton.setAttribute('aria-pressed', guardada ? 'true' : 'false')
  boton.setAttribute('aria-label', guardada ? 'Quitar de favoritos' : 'Guardar en favoritos')
}

function elemento(tag, clase, texto) {
  const el = document.createElement(tag)
  if (clase) el.className = clase
  if (texto) el.textContent = texto
  return el
}

function pintar(lista) {
  document.querySelectorAll('.js-fav').forEach((b) => marcar(b, contiene(lista, b.dataset.favId)))
  document.querySelectorAll('.js-favs-cantidad').forEach((c) => { c.textContent = String(lista.length) })

  const ul = document.querySelector('.js-favs-lista')
  if (ul) {
    ul.textContent = ''
    lista.slice().reverse().forEach((p) => {
      const li = elemento('li', 'lu-favs-item')
      const enlace = elemento('a', 'lu-favs-foto')
      enlace.href = p.url
      if (p.imagen) {
        const img = elemento('img')
        img.src = p.imagen
        img.alt = ''
        img.loading = 'lazy'
        enlace.appendChild(img)
      }
      const info = elemento('div', 'lu-favs-info')
      const nombre = elemento('a', 'lu-favs-nombre', p.nombre)
      nombre.href = p.url
      info.appendChild(nombre)
      if (p.variante) info.appendChild(elemento('span', 'lu-favs-variante', p.variante))
      info.appendChild(precios(p))
      const sacar = elemento('button', 'js-favs-quitar lu-favs-quitar', '×')
      sacar.type = 'button'
      sacar.dataset.favId = p.id
      sacar.setAttribute('aria-label', `Quitar ${p.nombre} de favoritos`)
      li.append(enlace, info, sacar)
      ul.appendChild(li)
    })
  }

  const vacio = document.querySelector('.js-favs-vacio')
  if (vacio) vacio.hidden = lista.length > 0

  const wa = document.querySelector('.js-favs-whatsapp')
  if (wa) {
    wa.hidden = lista.length === 0
    wa.href = urlWhatsApp(wa.dataset.base, lista) || wa.dataset.base
  }
}

function cerrarAviso() {
  const aviso = document.querySelector('.js-fav-aviso')
  if (!aviso) return
  clearTimeout(temporizador)
  aviso.classList.remove('lu-fav-aviso-visible')
  setTimeout(() => { aviso.hidden = true }, 250)
}

function avisar(prenda) {
  const aviso = document.querySelector('.js-fav-aviso')
  if (!aviso) return
  const img = aviso.querySelector('.js-fav-aviso-img')
  if (img) { img.hidden = !prenda.imagen; if (prenda.imagen) img.src = prenda.imagen }
  const nombre = aviso.querySelector('.js-fav-aviso-nombre')
  if (nombre) nombre.textContent = prenda.nombre
  const variante = aviso.querySelector('.js-fav-aviso-variante')
  if (variante) variante.textContent = prenda.variante || ''
  const caja = aviso.querySelector('.js-fav-aviso-precios')
  if (caja) { caja.textContent = ''; caja.appendChild(precios(prenda)) }
  aviso.hidden = false
  void aviso.offsetWidth /* reflow: sin esto la entrada no anima */
  aviso.classList.add('lu-fav-aviso-visible')
  clearTimeout(temporizador)
  temporizador = setTimeout(cerrarAviso, 5000)
}

function alTocarCorazon(boton) {
  if (!boton.dataset.favId) return
  const prenda = datosDe(boton)
  if (boton.classList.contains('lu-fav-ficha')) {
    prenda.variante = varianteElegida(boton)
    prenda.num = precioDeLaFicha() || prenda.num
  }
  const r = alternar(leer(almacen), prenda)
  guardar(almacen, r.lista)
  pintar(r.lista)
  if (r.guardada) avisar(prenda)
}

/* Compra rapida: el modal nace vacio; se le copian los datos de la tarjeta */
function alAbrirCompraRapida(disparador) {
  const tarjeta = disparador.closest('.js-item-product')
  const origen = tarjeta && tarjeta.querySelector('.js-fav')
  const destino = document.querySelector('.lu-fav-rapida')
  if (!origen || !destino) return
  ;['favId', 'favNombre', 'favUrl', 'favImagen', 'favPrecio', 'favPrecioNum', 'favDesc'].forEach((k) => { destino.dataset[k] = origen.dataset[k] || '' })
  marcar(destino, contiene(leer(almacen), destino.dataset.favId))
}

function iniciar() {
  if (!disponible(almacen)) return
  document.querySelectorAll('.js-fav, .js-favs-acceso').forEach((el) => { el.hidden = false })
  pintar(leer(almacen))

  document.addEventListener('click', (e) => {
    const corazon = e.target.closest('.js-fav')
    if (corazon) {
      /* la tarjeta entera es un link: el corazon no tiene que navegar */
      e.preventDefault()
      e.stopPropagation()
      alTocarCorazon(corazon)
      return
    }
    if (e.target.closest('.js-fav-aviso-cerrar')) { cerrarAviso(); return }
    if (e.target.closest('.js-fav-aviso .js-modal-open')) cerrarAviso()
    const sacar = e.target.closest('.js-favs-quitar')
    if (sacar) {
      const lista = quitar(leer(almacen), sacar.dataset.favId)
      guardar(almacen, lista)
      pintar(lista)
      return
    }
    const rapida = e.target.closest('.js-quickshop-modal-open')
    if (rapida) alAbrirCompraRapida(rapida)
  }, true)

  /* otra pestaña cambio la lista */
  window.addEventListener('storage', () => pintar(leer(almacen)))
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', iniciar)
} else {
  iniciar()
}
