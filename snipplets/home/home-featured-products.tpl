{# /*============================================================================
  #Productos destacados en abanico (Santiago, 2026-09-28)
  Referencia: un componente React "card fan carousel" (GSAP). Aca es el mismo
  comportamiento en CSS + JS propio, sin React ni GSAP:
  - Las cartas se abren en abanico (hasta 7 visibles, la del centro al frente).
  - Al entrar en pantalla aparecen desde abajo, de a una, con rebote.
  - Al pasar el mouse la carta sube y las vecinas se corren.
  - Con mas de 7 productos: flechas, puntos y deslizar con el dedo.
  Los productos son los marcados como destacados en el panel
  (sections.primary.products); cada carta lleva foto y link a la ficha, y la
  del frente (o la que tiene el mouse) muestra nombre y precio. Sin productos
  destacados la seccion no sale.

  Antes era el carrusel swiper del base (.js-swiper-featured); store.js lo
  sigue buscando y no encuentra nada, no pasa nada.
==============================================================================*/#}

{% if sections.primary.products %}
    <section class="section-featured-home lu-abanico-seccion" data-store="home-products-featured">
        <div class="container">
            {% if settings.featured_products_title %}
                <h3 class="lu-abanico-titulo">{{ settings.featured_products_title }}</h3>
            {% endif %}
            <div class="js-lu-abanico lu-abanico">
                {% for product in sections.primary.products %}
                    <a class="js-lu-abanico-carta lu-abanico-carta" href="{{ product.url }}" title="{{ product.name }}">
                        <span class="lu-abanico-foto">
                            {% if product.featured_image %}
                                <img src="{{ product.featured_image | product_image_url('large') }}" alt="{{ product.featured_image.alt ?: product.name }}" loading="lazy" draggable="false"/>
                            {% endif %}
                        </span>
                        <span class="lu-abanico-dato">
                            <span class="lu-abanico-nombre">{{ product.name }}</span>
                            {% if product.display_price %}
                                <span class="lu-abanico-precio">{{ product.price | money }}</span>
                            {% endif %}
                        </span>
                    </a>
                {% endfor %}
            </div>
            <div class="js-lu-abanico-nav lu-abanico-nav" hidden>
                <button type="button" class="js-lu-abanico-prev lu-abanico-flecha" aria-label="{{ 'Anterior' | translate }}">
                    {% include "snipplets/svg/chevron-left.tpl" with {svg_custom_class: "icon-inline"} %}
                </button>
                <span class="js-lu-abanico-puntos lu-abanico-puntos" aria-hidden="true"></span>
                <button type="button" class="js-lu-abanico-next lu-abanico-flecha" aria-label="{{ 'Siguiente' | translate }}">
                    {% include "snipplets/svg/chevron-right.tpl" with {svg_custom_class: "icon-inline"} %}
                </button>
            </div>
        </div>
        <script>
            (function () {
                var cont = document.querySelector('.js-lu-abanico');
                if (!cont) return;
                var cartas = Array.prototype.slice.call(cont.querySelectorAll('.js-lu-abanico-carta'));
                var total = cartas.length, MAX = 7, MITAD = 3;
                if (!total) return;
                var paginar = total > MAX;
                var huecos = paginar ? MAX : total;
                var medio = huecos >> 1;
                var centro = paginar ? MITAD : medio;
                var POS = [
                    { rot: -21, scale: 0.7756, x: -30, y: 7.3, z: 1 },
                    { rot: -14, scale: 0.8498, x: -22, y: 4.0, z: 2 },
                    { rot: -7, scale: 0.9346, x: -11, y: 1.3, z: 3 },
                    { rot: 0, scale: 1, x: 0, y: 0, z: 10 },
                    { rot: 7, scale: 0.9346, x: 11, y: 1.3, z: 3 },
                    { rot: 14, scale: 0.8498, x: 22, y: 4.0, z: 2 },
                    { rot: 21, scale: 0.7756, x: 30, y: 7.3, z: 1 }
                ];
                var slot = function (s) {
                    if (huecos >= MAX) return POS[s];
                    var d = huecos > 1 ? (s - medio) / medio : 0, a = Math.abs(d);
                    return { rot: d * 21, scale: 1 - 0.2244 * a * a, x: d * 30, y: a * a * 7.3, z: 10 - Math.abs(s - medio) };
                };
                var mult = function () {
                    var w = window.innerWidth;
                    return w < 480 ? 0.28 : w < 640 ? 0.38 : w < 768 ? 0.5 : w < 1024 ? 0.75 : 1;
                };
                var visibles = function () {
                    var mapa = {};
                    if (!paginar) { cartas.forEach(function (_, i) { mapa[i] = i; }); return mapa; }
                    for (var s = 0; s < MAX; s++) mapa[((centro + s - MITAD) % total + total) % total] = s;
                    return mapa;
                };
                var poner = function (el, t, demora) {
                    el.style.transitionDelay = (demora || 0) + 'ms';
                    el.style.transform = 'translateX(-50%) translate(' + t.x + 'rem, ' + t.y + 'rem) rotate(' + t.rot + 'deg) scale(' + t.scale + ')';
                    el.style.opacity = t.op == null ? 1 : t.op;
                    el.style.zIndex = t.z;
                };
                var activo = null;
                {# entrada: true la primera vez, cada carta sale con 60 ms de diferencia #}
                var dibujar = function (entrada) {
                    var mapa = visibles(), m = mult();
                    cartas.forEach(function (el, i) {
                        var s = mapa[i];
                        if (s === undefined) {
                            el.classList.add('lu-abanico-fuera');
                            el.classList.remove('lu-abanico-frente');
                            el.tabIndex = -1;
                            poner(el, { x: 0, y: 4, rot: 0, scale: 0.5, z: 0, op: 0 });
                            return;
                        }
                        el.classList.remove('lu-abanico-fuera');
                        el.tabIndex = 0;
                        el.dataset.slot = s;
                        var b = slot(s), x = b.x * m, y = b.y, rot = b.rot, sc = b.scale;
                        var demora = entrada ? 200 + s * 60 : 0;
                        if (activo !== null && !entrada) {
                            var dist = Math.abs(s - activo);
                            demora = dist * 20;
                            if (s === activo) { y -= 2.5; sc *= 1.08; }
                            else {
                                var n = medio > 0 ? (s - medio) / medio : 0;
                                var empuje = 8 * (1 - Math.abs(n)) * (1 + 0.2 * Math.max(0, 3 - dist));
                                if (s < activo) { x -= empuje * m; rot -= 3 / (dist + 1); }
                                else { x += empuje * m; rot += 3 / (dist + 1); }
                            }
                        }
                        var alFrente = activo === null ? s === medio : s === activo;
                        el.classList.toggle('lu-abanico-frente', alFrente);
                        poner(el, { x: x, y: y, rot: rot, scale: sc, z: s === activo ? 20 : b.z }, demora);
                    });
                    var puntos = cont.parentNode.querySelectorAll('.js-lu-abanico-puntos span');
                    for (var p = 0; p < puntos.length; p++) puntos[p].classList.toggle('activo', p === centro);
                };
                var listo = false;
                cartas.forEach(function (el) {
                    var enfocar = function () {
                        if (!listo || el.classList.contains('lu-abanico-fuera')) return;
                        var s = Number(el.dataset.slot);
                        if (activo !== s) { activo = s; dibujar(); }
                    };
                    el.addEventListener('mouseenter', enfocar);
                    el.addEventListener('focus', enfocar);
                });
                cont.addEventListener('mouseleave', function () { if (listo && activo !== null) { activo = null; dibujar(); } });
                window.addEventListener('resize', function () { if (listo) dibujar(); });

                if (paginar) {
                    var nav = cont.parentNode.querySelector('.js-lu-abanico-nav');
                    var cajaPuntos = nav.querySelector('.js-lu-abanico-puntos');
                    for (var k = 0; k < total; k++) cajaPuntos.appendChild(document.createElement('span'));
                    nav.hidden = false;
                    var mover = function (dir) {
                        if (!listo) return;
                        activo = null;
                        centro = (centro + dir + total) % total;
                        dibujar();
                    };
                    nav.querySelector('.js-lu-abanico-prev').addEventListener('click', function () { mover(-1); });
                    nav.querySelector('.js-lu-abanico-next').addEventListener('click', function () { mover(1); });
                    var x0 = null;
                    cont.addEventListener('touchstart', function (e) { x0 = e.touches[0].clientX; }, { passive: true });
                    cont.addEventListener('touchend', function (e) {
                        if (x0 === null) return;
                        var dx = e.changedTouches[0].clientX - x0; x0 = null;
                        if (Math.abs(dx) > 40) mover(dx < 0 ? 1 : -1);
                    });
                }

                var entrar = function () {
                    cont.classList.add('lu-abanico-entrando');
                    dibujar(true);
                    setTimeout(function () {
                        cont.classList.remove('lu-abanico-entrando');
                        cartas.forEach(function (el) { el.style.transitionDelay = '0ms'; });
                        listo = true;
                    }, 1300 + huecos * 60);
                };
                var reducido = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
                if (reducido || !('IntersectionObserver' in window)) { dibujar(); listo = true; return; }
                {# Punto de partida de la entrada: todas juntas, abajo, chicas e invisibles #}
                cartas.forEach(function (el) { poner(el, { x: 0, y: 12, rot: 0, scale: 0.5, z: 0, op: 0 }); });
                var io = new IntersectionObserver(function (ents) {
                    if (!ents[0].isIntersecting) return;
                    io.disconnect();
                    requestAnimationFrame(function () { requestAnimationFrame(entrar); });
                }, { threshold: 0.25 });
                io.observe(cont);
            })();
        </script>
    </section>
    {% set section_name = 'primary' %}
{% endif %}
