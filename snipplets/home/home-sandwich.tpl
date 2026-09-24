{# Franja de video/foto a todo el ancho, arriba o abajo de los banners de
   categorias (Santiago, 2026-09-24: "sandwich"). Misma dinamica que los tres
   banners de categorias: toda la franja es un link, con titulo y boton encima.
   Sale sola si hay video o foto cargados en el panel (Banners de categorias).
   Parametros: lu_sw_video, lu_sw_img, lu_sw_title, lu_sw_button, lu_sw_url. #}
{% set lu_sw_has_img = lu_sw_img | has_custom_image %}
{% if lu_sw_video or lu_sw_has_img %}
	<section class="lu-sandwich">
		{% if lu_sw_url %}<a class="lu-sandwich-link" href="{{ lu_sw_url | setting_url }}"{% if lu_sw_title %} aria-label="{{ lu_sw_title }}"{% endif %}>{% endif %}
			{% if lu_sw_video %}
				<video class="lu-sandwich-media" autoplay muted loop playsinline preload="metadata"{% if lu_sw_has_img %} poster="{{ lu_sw_img | static_url | settings_image_url('1080p') }}"{% endif %}>
					<source src="{{ lu_sw_video }}" type="video/mp4">
				</video>
			{% else %}
				<img class="lu-sandwich-media lazyload" src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ lu_sw_img | static_url | settings_image_url('1080p') }}" alt="{{ lu_sw_title }}">
			{% endif %}
			{% if lu_sw_title or lu_sw_button %}
				<div class="lu-sandwich-text">
					{% if lu_sw_title %}<div class="lu-sandwich-title">{{ lu_sw_title }}</div>{% endif %}
					{% if lu_sw_button %}<span class="btn btn-line btn-small">{{ lu_sw_button }}</span>{% endif %}
				</div>
			{% endif %}
		{% if lu_sw_url %}</a>{% endif %}
	</section>
{% endif %}
