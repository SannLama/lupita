{# /*============================================================================
  #Banner de promocion (2026-09-25)
  Del PDF "Paginas Web implementar" (lam. 6-7: Zadig & Voltaire, Napoli): un
  solo mensaje de pago en grande, a todo el ancho ("20% OFF", "6 cuotas").
  Con foto va sobre la foto oscurecida; sin foto, sobre tinta.

  Textos desde "Personalizar diseno > Banner de promocion". Si se deja la
  cifra vacia, toma la de "Medios de pago de Lupita" (20% off en efectivo),
  para que el banner diga lo mismo que el resto de la tienda.
==============================================================================*/#}

{% set lu_pr_cifra = settings.lupita_promo_cifra ?: settings.lupita_pago_efectivo_cifra %}

{% if not settings.lupita_promo_ocultar and lu_pr_cifra %}
	{% set lu_pr_img = 'promo.jpg' | has_custom_image %}
	{# "|" parte la bajada en renglones (Santiago, 2026-09-25: dos lineas) #}
	{% set lu_pr_texto = settings.lupita_promo_texto ?: 'Abonando en efectivo' %}
	{% set lu_pr_url = settings.lupita_promo_url ?: settings.lupita_tiendas_url %}
	{% set lu_pr_boton = settings.lupita_promo_boton ?: 'Conocer las tiendas' %}
	{% set lu_pr_externo = lu_pr_url and 'http' in lu_pr_url and 'ahilupita' not in lu_pr_url %}
	<section class="lu-promo{% if not lu_pr_img %} lu-promo-liso{% endif %}" data-store="home-promo">
		{% if lu_pr_img %}
			<img class="lu-promo-media lazyload" src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ 'promo.jpg' | static_url | settings_image_url('1080p') }}" alt="" aria-hidden="true">
		{% endif %}
		<div class="lu-promo-texto">
			{% if settings.lupita_promo_rotulo %}
				<span class="lu-promo-rotulo">{{ settings.lupita_promo_rotulo }}</span>
			{% endif %}
			<h2 class="lu-promo-cifra">{{ lu_pr_cifra }}</h2>
			{% if lu_pr_texto %}
				<p class="lu-promo-bajada">{% for lu_pr_linea in lu_pr_texto | split('|') %}<span class="lu-promo-linea">{{ lu_pr_linea | trim }}</span>{% endfor %}</p>
			{% endif %}
			{% if lu_pr_url and lu_pr_boton %}
				<a href="{% if lu_pr_externo %}{{ lu_pr_url }}{% else %}{{ lu_pr_url | setting_url }}{% endif %}" class="btn btn-line btn-small lu-promo-boton"{% if lu_pr_externo %} target="_blank" rel="noopener"{% endif %}>{{ lu_pr_boton }}</a>
			{% endif %}
			{% if settings.lupita_promo_legal %}
				<p class="lu-promo-legal">{{ settings.lupita_promo_legal }}</p>
			{% endif %}
		</div>
	</section>
	<script type="text/javascript">
		{# La bajada y el boton centrados bajo la mitad del primer caracter de la
		   cifra (el "2" de "20% off"; Santiago, 2026-09-25), sin salirse de la
		   pantalla en celular #}
		(function () {
			var sec = document.querySelector('[data-store="home-promo"]');
			if (!sec) return;
			var cifra = sec.querySelector('.lu-promo-cifra');
			var mover = sec.querySelectorAll('.lu-promo-bajada, .lu-promo-boton');
			if (!cifra || !mover.length) return;
			function alinear() {
				var nodo = cifra.firstChild;
				while (nodo && (nodo.nodeType !== 3 || !nodo.textContent.trim())) nodo = nodo.nextSibling;
				if (!nodo) return;
				var ini = nodo.textContent.search(/\S/);
				var r = document.createRange();
				r.setStart(nodo, ini);
				r.setEnd(nodo, ini + 1);
				var c = r.getBoundingClientRect();
				{# + 0.6em de la cifra: un poco mas a la derecha que la mitad del 2
				   (Santiago: "tampoco tanto para la izquierda") #}
				var centro = c.left + c.width / 2 + 0.6 * parseFloat(getComputedStyle(cifra).fontSize);
				var margen = 16;
				var ancho = document.documentElement.clientWidth;
				{# Con `translate` y no `transform`: el boton anima transform al
				   pasar el mouse. La posicion natural se saca restando el
				   corrimiento anterior (medir justo despues de sacarlo daria
				   un valor a mitad de la transicion). #}
				mover.forEach(function (el) {
					var antes = parseFloat(el.getAttribute('data-lu-dx')) || 0;
					var b = el.getBoundingClientRect();
					var izq = b.left - antes;
					var der = b.right - antes;
					var dx = centro - (izq + der) / 2;
					dx = Math.max(dx, margen - izq);
					dx = Math.min(dx, ancho - margen - der);
					dx = Math.round(dx);
					el.setAttribute('data-lu-dx', dx);
					el.style.translate = dx + 'px 0';
				});
			}
			alinear();
			if (document.fonts && document.fonts.ready) document.fonts.ready.then(alinear);
			window.addEventListener('load', alinear);
			window.addEventListener('resize', alinear);
		})();
	</script>
{% endif %}
