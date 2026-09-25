{# /*============================================================================
  #Shop the look (2026-09-25)
  Del PDF "Paginas Web implementar" (lam. 28: Millie, "Espectacular!!!!"):
  fotos de looks con puntos sobre cada prenda. Al tocar un punto aparece una
  tarjetita con la foto, el nombre y el precio del producto, y el link.

  Hasta tres looks (look-N.jpg) con hasta tres puntos cada uno. De cada punto
  se carga solo la posicion (% desde la izquierda y desde arriba) y el link
  al producto: nombre, foto y precio los lee el script de la ficha del
  producto (los datos estructurados que publica Tiendanube), asi no hay que
  cargarlos dos veces ni se desactualizan.
==============================================================================*/#}

{% set lu_looks = [] %}
{% for lu_i in 1..3 %}
	{% set lu_img = 'look-' ~ lu_i ~ '.jpg' %}
	{% if lu_img | has_custom_image %}
		{% set lu_pts = [] %}
		{% for lu_j in 1..3 %}
			{% set lu_url = attribute(settings, 'lupita_look_' ~ lu_i ~ '_p' ~ lu_j ~ '_url') %}
			{% if lu_url %}
				{% set lu_pts = lu_pts | merge([[attribute(settings, 'lupita_look_' ~ lu_i ~ '_p' ~ lu_j ~ '_x') ?: 50, attribute(settings, 'lupita_look_' ~ lu_i ~ '_p' ~ lu_j ~ '_y') ?: 50, lu_url]]) %}
			{% endif %}
		{% endfor %}
		{% set lu_looks = lu_looks | merge([[lu_img, lu_pts]]) %}
	{% endif %}
{% endfor %}

{% if lu_looks and not settings.lupita_look_ocultar %}
	<section class="lu-look js-lu-look" data-store="home-shop-the-look">
		<h3 class="lu-look-titulo">{{ settings.lupita_look_titulo ?: 'Shop the look' }}</h3>
		<ul class="lu-look-lista list-unstyled">
			{% for lu_l in lu_looks %}
				<li class="lu-look-item">
					<img class="lu-look-foto lazyload" src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ lu_l[0] | static_url | settings_image_url('large') }}" alt="">
					{% for lu_p in lu_l[1] %}
						<button type="button" class="lu-look-punto js-lu-look-punto" style="left: {{ lu_p[0] }}%; top: {{ lu_p[1] }}%;" data-url="{{ lu_p[2] | setting_url }}" aria-expanded="false" aria-label="{{ 'Ver la prenda' | translate }}"><span></span></button>
					{% endfor %}
				</li>
			{% endfor %}
		</ul>
	</section>

	<script type="text/javascript">
		(function () {
			var raiz = document.querySelector('.js-lu-look');
			if (!raiz) return;
			var cache = {};
			var abierta = null;
			var formato = new Intl.NumberFormat('es-AR', { style: 'currency', currency: 'ARS', maximumFractionDigits: 0 });

			{# Nombre, foto y precio desde la ficha: primero el JSON-LD de
			   Tiendanube (component structured-data), si no las etiquetas og #}
			function leer(url) {
				if (cache[url]) return cache[url];
				cache[url] = fetch(url, { credentials: 'same-origin' }).then(function (r) { return r.text(); }).then(function (html) {
					var doc = new DOMParser().parseFromString(html, 'text/html');
					var datos = { nombre: '', foto: '', precio: '' };
					doc.querySelectorAll('script[type="application/ld+json"]').forEach(function (s) {
						try {
							var j = JSON.parse(s.textContent);
							[].concat(j['@graph'] || j).forEach(function (n) {
								if (!n || !/Product/.test(n['@type'])) return;
								datos.nombre = datos.nombre || n.name || '';
								datos.foto = datos.foto || [].concat(n.image || [])[0] || '';
								var o = [].concat(n.offers || [])[0];
								if (o && !datos.precio && o.price) datos.precio = formato.format(parseFloat(o.price));
							});
						} catch (e) {}
					});
					function meta(p) { var m = doc.querySelector('meta[property="' + p + '"]'); return m ? m.getAttribute('content') : ''; }
					datos.nombre = datos.nombre || meta('og:title');
					datos.foto = datos.foto || meta('og:image');
					if (!datos.precio && (meta('og:price:amount') || meta('product:price:amount'))) {
						datos.precio = formato.format(parseFloat(meta('og:price:amount') || meta('product:price:amount')));
					}
					return datos;
				}).catch(function () { return { nombre: '', foto: '', precio: '' }; });
				return cache[url];
			}

			function cerrar() {
				if (!abierta) return;
				abierta.punto.setAttribute('aria-expanded', 'false');
				abierta.tarjeta.remove();
				abierta = null;
			}

			raiz.addEventListener('click', function (e) {
				var punto = e.target.closest('.js-lu-look-punto');
				if (!punto) return;
				var era = abierta && abierta.punto === punto;
				cerrar();
				if (era) return;
				var tarjeta = document.createElement('a');
				tarjeta.className = 'lu-look-tarjeta';
				tarjeta.href = punto.dataset.url;
				tarjeta.innerHTML = '<span class="lu-look-tarjeta-cargando">...</span>';
				var x = parseFloat(punto.style.left), y = parseFloat(punto.style.top);
				tarjeta.classList.toggle('lu-look-tarjeta-izq', x > 55);
				tarjeta.classList.toggle('lu-look-tarjeta-arriba', y > 60);
				tarjeta.style.left = punto.style.left;
				tarjeta.style.top = punto.style.top;
				punto.parentNode.appendChild(tarjeta);
				punto.setAttribute('aria-expanded', 'true');
				abierta = { punto: punto, tarjeta: tarjeta };
				leer(punto.dataset.url).then(function (d) {
					if (!abierta || abierta.tarjeta !== tarjeta) return;
					tarjeta.innerHTML = '';
					if (d.foto) { var im = document.createElement('img'); im.src = d.foto; im.alt = ''; tarjeta.appendChild(im); }
					var t = document.createElement('span'); t.className = 'lu-look-tarjeta-texto';
					var n = document.createElement('span'); n.className = 'lu-look-tarjeta-nombre'; n.textContent = d.nombre || 'Ver producto'; t.appendChild(n);
					if (d.precio) { var p = document.createElement('span'); p.className = 'lu-look-tarjeta-precio'; p.textContent = d.precio; t.appendChild(p); }
					var v = document.createElement('span'); v.className = 'lu-look-tarjeta-ver'; v.textContent = 'Ver producto'; t.appendChild(v);
					tarjeta.appendChild(t);
				});
			});

			document.addEventListener('click', function (e) {
				if (abierta && !e.target.closest('.js-lu-look-punto') && !e.target.closest('.lu-look-tarjeta')) cerrar();
			});
			document.addEventListener('keydown', function (e) { if (e.key === 'Escape') cerrar(); });
		})();
	</script>
{% endif %}
