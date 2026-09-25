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
	{% set lu_pr_texto = settings.lupita_promo_texto ?: settings.lupita_pago_efectivo %}
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
				<p class="lu-promo-bajada">{{ lu_pr_texto }}</p>
			{% endif %}
			{% if lu_pr_url and lu_pr_boton %}
				<a href="{% if lu_pr_externo %}{{ lu_pr_url }}{% else %}{{ lu_pr_url | setting_url }}{% endif %}" class="btn btn-line btn-small lu-promo-boton"{% if lu_pr_externo %} target="_blank" rel="noopener"{% endif %}>{{ lu_pr_boton }}</a>
			{% endif %}
			{% if settings.lupita_promo_legal %}
				<p class="lu-promo-legal">{{ settings.lupita_promo_legal }}</p>
			{% endif %}
		</div>
	</section>
{% endif %}
