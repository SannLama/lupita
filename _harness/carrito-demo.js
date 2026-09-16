/* Harness: carrito y compra de mentira. NO SE SUBE POR FTP.

   En la tienda todo esto lo hacen store.js (agregar, cantidades, quitar,
   avisos) y el checkout de Tiendanube (una pantalla de la plataforma). El
   harness solo tenia el marcado, asi que "no dejaba seguir la compra":
   "Agregar al carrito" era un submit sin formulario, "Iniciar compra" mandaba
   a "#" y no habia checkout. Esto replica el recorrido para poder probarlo:
   ficha / compra rapida -> aviso -> carrito (panel y pagina) -> checkout ->
   confirmacion. El estado vive en localStorage ('harness-carrito').

   ?auto=compra en producto.html recorre todo solo (prueba de punta a punta). */
(function () {
  // v2: con fotos de producto reales (la v1 guardaba los rectangulos grises)
  var CLAVE = 'harness-carrito-v2'
  var params = new URLSearchParams(location.search)
  var TACHO = window.__ICONO_TACHO || ''
  var pesos = function (n) { return '$ ' + Math.round(n).toLocaleString('es-AR') }

  function leer() {
    try { var v = JSON.parse(localStorage.getItem(CLAVE)); if (Array.isArray(v)) return v } catch (e) {}
    return null
  }
  function guardar(l) { try { localStorage.setItem(CLAVE, JSON.stringify(l)) } catch (e) {} }

  var lista = leer()
  if (!lista) { lista = (window.__CARRITO_SEMILLA || []).slice(); guardar(lista) }

  function cantidad() { return lista.reduce(function (a, x) { return a + x.cant }, 0) }
  function subtotal() { return lista.reduce(function (a, x) { return a + x.cant * x.precio }, 0) }
  function escapar(s) { return String(s).replace(/[&<>"]/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c] }) }

  function cantidadHtml(x) {
    return '<div class="row m-0 justify-content-md-center align-items-center">' +
      '<span class="js-cart-quantity-btn cart-item-btn btn" data-accion="menos" role="button" aria-label="Restar uno">&#8722;</span>' +
      '<input class="js-cart-quantity-input cart-item-input form-control" type="number" min="1" value="' + x.cant + '" aria-label="Cantidad">' +
      '<span class="js-cart-quantity-btn cart-item-btn btn" data-accion="mas" role="button" aria-label="Sumar uno">+</span></div>'
  }
  function quitarHtml(x) {
    return '<button type="button" class="btn h6 m-0 lu-quitar" aria-label="Quitar ' + escapar(x.nombre) + '">' + TACHO + '<span class="lu-quitar-texto" aria-hidden="true">Quitar</span></button>'
  }
  function renglonPanel(x, i) {
    return '<div class="js-cart-item cart-item form-row" data-indice="' + i + '">' +
      '<div class="col-2"><img src="' + x.foto + '" class="img-fluid" alt=""></div>' +
      '<div class="col-10"><div class="w-100">' +
      '<h6 class="font-weight-normal cart-item-name mb-0"><a href="producto.html">' + escapar(x.nombre) + '</a> <small>' + escapar(x.variante) + '</small></h6>' +
      '<div class="cart-item-quantity"><div class="form-group float-left form-quantity w-auto mb-2">' + cantidadHtml(x) + '</div></div>' +
      '<h6 class="js-cart-item-subtotal cart-item-subtotal">' + pesos(x.precio * x.cant) + '</h6>' +
      '</div></div>' +
      '<div class="col-1 cart-item-delete text-right">' + quitarHtml(x) + '</div></div>'
  }
  function renglonPagina(x, i) {
    return '<div class="js-cart-item cart-item row align-items-md-center mx-0 mb-2" data-indice="' + i + '">' +
      '<div class="col-2 col-md-1 px-0"><img src="' + x.foto + '" class="img-fluid" alt=""></div>' +
      '<div class="col-10 col-md-11"><div class="row align-items-center">' +
      '<h6 class="font-weight-normal col-12 col-md-6 h4-md mb-2 mb-md-0"><a href="producto.html">' + escapar(x.nombre) + '</a> <small>' + escapar(x.variante) + '</small></h6>' +
      '<div class="cart-item-quantity col-7 col-md-3"><div class="form-group float-md-none m-auto form-quantity w-auto mb-2">' + cantidadHtml(x) + '</div></div>' +
      '<h6 class="js-cart-item-subtotal cart-item-subtotal col-5 col-md-3 text-right text-md-center h4-md font-weight-bold">' + pesos(x.precio * x.cant) + '</h6>' +
      '</div></div>' +
      '<div class="col-1 cart-item-delete text-right">' + quitarHtml(x) + '</div></div>'
  }

  function pintar() {
    var n = cantidad(), s = subtotal(), vacio = lista.length === 0
    document.querySelectorAll('.cart-summary .cart-widget-amount').forEach(function (el) { el.textContent = n })
    var panel = document.querySelector('#modal-cart .js-ajax-cart-list')
    if (panel) panel.innerHTML = lista.map(renglonPanel).join('')
    var pagina = document.querySelector('#shoppingCartPage .js-ajax-cart-list')
    if (pagina) pagina.innerHTML = vacio ? '<div class="alert alert-info">El carrito de compras está vacío. <a href="categoria.html" class="btn-link">Ver productos</a></div>' : lista.map(renglonPagina).join('')
    document.querySelectorAll('.js-empty-ajax-cart').forEach(function (el) { el.style.display = vacio ? '' : 'none' })
    document.querySelectorAll('#modal-cart .js-visible-on-cart-filled, #shoppingCartPage .js-visible-on-cart-filled, #modal-cart .js-fulfillment-info').forEach(function (el) { el.style.display = vacio ? 'none' : '' })
    document.querySelectorAll('#modal-cart .js-cart-subtotal, #modal-cart .js-ajax-cart-total, #shoppingCartPage .js-cart-subtotal').forEach(function (el) { el.textContent = pesos(s) })
    document.querySelectorAll('#modal-cart .js-cart-total, #shoppingCartPage .js-cart-total').forEach(function (el) { el.textContent = pesos(s) })
    document.querySelectorAll('#modal-cart .lu-efectivo-precio, #shoppingCartPage .lu-efectivo-precio').forEach(function (el) { el.textContent = pesos(s * 0.8) })
    // La fila de promocion de la pagina era demo fija: con cantidades reales confunde
    document.querySelectorAll('#shoppingCartPage .js-total-promotions').forEach(function (el) { el.style.display = 'none' })
    pintarCheckout()
  }

  function mostrarAviso(item) {
    document.querySelectorAll('.js-alert-added-to-cart.js-demo').forEach(function (n) { n.remove() })
    var host = document.querySelector('.head-main .container') || document.body
    var d = document.createElement('div')
    d.className = 'js-alert-added-to-cart js-demo notification-floating notification-visible'
    d.setAttribute('role', 'status')
    d.innerHTML = '<div class="notification notification-primary position-relative col-12 float-right">' +
      '<div class="h6 text-center mb-3 mr-3"><strong>¡Ya agregamos tu producto al carrito!</strong></div>' +
      '<div class="js-cart-notification-close notification-close" role="button" aria-label="Cerrar">&times;</div>' +
      '<div class="js-cart-notification-item row"><div class="col-3 pr-0 notification-img"><img src="' + item.foto + '" class="img-fluid" alt=""></div>' +
      '<div class="col-9 text-left"><div class="mb-1"><span>' + escapar(item.nombre) + '</span>' + (item.variante ? ' <span>(' + escapar(item.variante) + ')</span>' : '') + '</div>' +
      '<div class="mb-1"><span>1</span><span> x </span><span>' + pesos(item.precio) + '</span></div></div></div>' +
      '<div class="row text-primary h5 font-weight-normal mt-2 mb-3"><span class="col-auto text-left"><strong>Total</strong> (' + cantidad() + ' productos):</span><strong class="col text-right">' + pesos(subtotal()) + '</strong></div>' +
      '<a href="#" class="js-ver-carrito-demo btn btn-primary btn-medium w-100 d-inline-block">Ver carrito</a></div>'
    host.appendChild(d)
    setTimeout(function () { d.remove() }, 6000)
  }

  function agregarDesde(boton) {
    var cont = boton.closest('#quickshop-modal, .js-product-detail, .js-product-container') || document
    var nombreEl = cont.querySelector('h1, .js-item-name')
    var precioEl = cont.querySelector('.js-price-display')
    var nombre = nombreEl ? nombreEl.textContent.trim() : 'Producto'
    var precio = precioEl ? Number(precioEl.textContent.replace(/[^0-9]/g, '')) : 0
    var talleSel = cont.querySelector('.js-insta-variant.selected:not(.btn-variant-color)')
    var colorSel = cont.querySelector('.btn-variant-color.selected')
    // Talle sin stock elegido: en la tienda store.js deshabilita el boton ("Sin stock")
    if (talleSel && talleSel.classList.contains('btn-variant-no-stock')) {
      var aviso = cont.querySelector('.js-demo-sin-stock')
      if (!aviso) {
        aviso = document.createElement('div')
        aviso.className = 'js-demo-sin-stock alert alert-warning'
        aviso.setAttribute('role', 'alert')
        boton.parentNode.insertBefore(aviso, boton.parentNode.firstChild)
      }
      aviso.textContent = 'Ese talle está sin stock. Elegí otro para agregarlo al carrito.'
      return
    }
    var viejo = cont.querySelector('.js-demo-sin-stock'); if (viejo) viejo.remove()
    var talle = talleSel ? talleSel.querySelector('.btn-variant-content') : null
    var variante = [talle ? 'Talle ' + talle.getAttribute('data-name') : '', colorSel ? colorSel.getAttribute('title') : ''].filter(Boolean).join(' / ')
    var img = cont.querySelector('.product-slider-image')
    var foto = img ? img.src : (window.__FOTO_GENERICA || '')
    var existente = null
    lista.forEach(function (x) { if (x.nombre === nombre && x.variante === variante) existente = x })
    if (existente) existente.cant++
    else { existente = { nombre: nombre, variante: variante, precio: precio, cant: 1, foto: foto }; lista.push(existente) }
    guardar(lista)
    pintar()
    if (boton.closest('#quickshop-modal') && window.cerrar) window.cerrar()
    mostrarAviso(existente)
  }

  /* ---- Checkout de simulacion (checkout.html) ---- */
  function valor(nombre) { var el = document.querySelector('input[name="' + nombre + '"]:checked'); return el ? el.value : '' }
  function pintarCheckout() {
    var res = document.getElementById('lu-checkout-resumen')
    if (!res) return
    res.innerHTML = lista.length
      ? lista.map(function (x) { return '<li class="lu-checkout-item"><span>' + x.cant + ' × ' + escapar(x.nombre) + (x.variante ? ' <small>(' + escapar(x.variante) + ')</small>' : '') + '</span><strong>' + pesos(x.precio * x.cant) + '</strong></li>' }).join('')
      : '<li class="lu-checkout-item">El carrito está vacío. <a href="categoria.html" class="btn-link">Ver productos</a></li>'
    var s = subtotal(), pago = valor('pago'), entrega = valor('entrega')
    var tasa = pago === 'efectivo' ? 0.2 : pago === 'transferencia' ? 0.1 : 0
    var envio = entrega === 'domicilio' ? 6500 : 0
    var set = function (id, t) { var el = document.getElementById(id); if (el) el.textContent = t }
    set('lu-checkout-subtotal', pesos(s))
    var filaDesc = document.getElementById('lu-checkout-fila-descuento')
    if (filaDesc) filaDesc.hidden = !tasa
    set('lu-checkout-descuento', '-' + pesos(s * tasa) + (pago === 'efectivo' ? ' (20% efectivo)' : pago === 'transferencia' ? ' (10% transferencia)' : ''))
    set('lu-checkout-envio', entrega === 'domicilio' ? pesos(envio) : 'Gratis')
    set('lu-checkout-total', pesos(s * (1 - tasa) + envio))
    var cp = document.getElementById('lu-checkout-cp'); if (cp) cp.hidden = entrega !== 'domicilio'
    var tiendas = document.getElementById('lu-checkout-tiendas'); if (tiendas) tiendas.hidden = entrega !== 'retiro'
    var boton = document.querySelector('#lu-checkout-form [type="submit"]'); if (boton) boton.disabled = !lista.length
  }
  function finalizar() {
    if (!lista.length) return
    var form = document.getElementById('lu-checkout-form')
    var listo = document.getElementById('lu-checkout-listo')
    if (!form || !listo) return
    listo.querySelector('.js-numero').textContent = '#' + (1000 + Math.floor(Math.random() * 9000))
    listo.querySelector('.js-resumen-final').innerHTML = document.getElementById('lu-checkout-resumen').innerHTML
    listo.querySelector('.js-total-final').textContent = document.getElementById('lu-checkout-total').textContent
    var entrega = valor('entrega')
    var tienda = document.querySelector('#lu-checkout-tiendas select')
    listo.querySelector('.js-entrega-final').textContent = entrega === 'retiro' ? 'Retiro en ' + (tienda ? tienda.value : 'la tienda') : 'Envío a domicilio'
    form.hidden = true
    listo.hidden = false
    lista = []
    guardar(lista)
    pintar()
    window.scrollTo(0, 0)
  }

  /* ---- Eventos ---- */
  document.addEventListener('click', function (e) {
    var menos = e.target.closest('.js-cart-quantity-btn')
    if (menos) {
      var r = menos.closest('[data-indice]'); if (!r) return
      e.preventDefault()
      var x = lista[Number(r.getAttribute('data-indice'))]
      x.cant = Math.max(1, x.cant + (menos.getAttribute('data-accion') === 'menos' ? -1 : 1))
      guardar(lista); pintar(); return
    }
    var quitar = e.target.closest('.lu-quitar')
    if (quitar) {
      var r2 = quitar.closest('[data-indice]'); if (!r2) return
      e.preventDefault()
      lista.splice(Number(r2.getAttribute('data-indice')), 1)
      guardar(lista); pintar(); return
    }
    var agregar = e.target.closest('.js-addtocart')
    if (agregar) { e.preventDefault(); agregarDesde(agregar); return }
    var cookies = e.target.closest('.js-acknowledge-cookies')
    if (cookies) { e.preventDefault(); var b = cookies.closest('.js-notification'); if (b) b.style.display = 'none'; return }
    var cerrarAviso = e.target.closest('.js-cart-notification-close')
    if (cerrarAviso) { var n = cerrarAviso.closest('.js-alert-added-to-cart'); if (n) n.remove(); return }
    var ver = e.target.closest('.js-ver-carrito-demo')
    if (ver) { e.preventDefault(); var n2 = ver.closest('.js-alert-added-to-cart'); if (n2) n2.remove(); if (window.abrir) window.abrir('#modal-cart'); else location.href = 'carrito.html'; return }
  })

  document.addEventListener('change', function (e) {
    var inp = e.target.closest('.js-cart-quantity-input')
    if (inp) {
      var r = inp.closest('[data-indice]'); if (!r) return
      lista[Number(r.getAttribute('data-indice'))].cant = Math.max(1, parseInt(inp.value, 10) || 1)
      guardar(lista); pintar(); return
    }
    if (e.target.name === 'entrega' || e.target.name === 'pago') pintarCheckout()
  })

  document.addEventListener('submit', function (e) {
    var f = e.target
    if (f.matches('.js-ajax-cart-panel, #shoppingCartPage form')) {
      e.preventDefault()
      var quien = e.submitter
      if (quien && quien.name !== 'go_to_checkout') {
        // "Calcular" del carrito: resultado de demo
        var info = f.querySelector('#cart-shipping-container .alert-info')
        var cp = f.querySelector('#cp')
        if (info) info.textContent = cp && cp.value ? 'CP ' + cp.value + ': envío a domicilio ' + pesos(6500) + ' · retiro gratis en las tres tiendas (demo)' : 'Ingresá tu código postal para calcular el envío.'
        return
      }
      if (!lista.length) return
      location.href = 'checkout.html' + (params.get('auto') === 'checkout' ? '?auto=finalizar' : '')
      return
    }
    if (f.id === 'lu-checkout-form') { e.preventDefault(); finalizar(); return }
    if (f.id === 'contact-form') {
      e.preventDefault()
      var ok = document.querySelector('[data-component="contact-success-message"]')
      if (ok) { ok.scrollIntoView({ block: 'center' }); ok.style.outline = '2px solid var(--lu-acento)' }
      f.reset(); return
    }
    if (f.id === 'lu-login-form') { e.preventDefault(); location.href = 'home.html'; return }
  })

  pintar()

  /* ---- Recorrido automatico (prueba de punta a punta) ---- */
  var auto = params.get('auto')
  if (auto === 'compra') {
    setTimeout(function () {
      lista = []; guardar(lista); pintar()
      var ficha = document.querySelector('.ficha:not([hidden])') || document
      var talles = ficha.querySelectorAll('.js-insta-variant:not(.btn-variant-color)')
      if (talles[3]) { talles[3].click(); ficha.querySelector('.js-addtocart').click() }   // sin stock: no tiene que agregar
      if (talles[2]) talles[2].click()
      var colores = ficha.querySelectorAll('.btn-variant-color'); if (colores[1]) colores[1].click()
      ficha.querySelector('.js-addtocart').click()
      ficha.querySelector('.js-addtocart').click()   // la misma variante: suma cantidad, no renglon
      setTimeout(function () { location.href = 'carrito.html?auto=checkout' }, 1500)
    }, 800)
  } else if (auto === 'agregar') {
    // Agrega una prenda y se queda: para ver el aviso y el contador en una captura
    setTimeout(function () {
      lista = []; guardar(lista); pintar()
      var ficha = document.querySelector('.ficha:not([hidden])') || document
      var talles = ficha.querySelectorAll('.js-insta-variant:not(.btn-variant-color)')
      if (talles[3]) { talles[3].click(); ficha.querySelector('.js-addtocart').click() }   // sin stock: aviso, no agrega
      if (talles[0]) talles[0].click()
      ficha.querySelector('.js-addtocart').click()
      window.scrollTo(0, 0)
    }, 800)
  } else if (auto === 'checkout') {
    setTimeout(function () { var b = document.getElementById('go-to-checkout'); if (b) b.click() }, 1200)
  } else if (auto === 'finalizar') {
    setTimeout(function () {
      var email = document.querySelector('#lu-checkout-form input[name="email"]'); if (email) email.value = 'prueba@ejemplo.com'
      var retiro = document.querySelector('input[name="entrega"][value="retiro"]'); if (retiro) { retiro.checked = true; retiro.dispatchEvent(new Event('change', { bubbles: true })) }
      var efectivo = document.querySelector('input[name="pago"][value="efectivo"]'); if (efectivo) { efectivo.checked = true; efectivo.dispatchEvent(new Event('change', { bubbles: true })) }
      setTimeout(function () { var b = document.querySelector('#lu-checkout-form [type="submit"]'); if (b) b.click() }, 600)
    }, 1200)
  }
})()
