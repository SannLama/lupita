{# Franja de video/foto a todo el ancho, arriba o abajo de los banners de
   categorias (Santiago, 2026-09-24: "sandwich"). Sale sola si hay video o
   foto cargados en el panel (Banners de categorias). Parametros:
   lu_sw_video (url .mp4), lu_sw_img (nombre del archivo de imagen). #}
{% set lu_sw_has_img = lu_sw_img | has_custom_image %}
{% if lu_sw_video or lu_sw_has_img %}
	<section class="lu-sandwich" aria-hidden="true">
		{% if lu_sw_video %}
			<video class="lu-sandwich-media" autoplay muted loop playsinline preload="metadata"{% if lu_sw_has_img %} poster="{{ lu_sw_img | static_url | settings_image_url('1080p') }}"{% endif %}>
				<source src="{{ lu_sw_video }}" type="video/mp4">
			</video>
		{% else %}
			<img class="lu-sandwich-media lazyload" src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ lu_sw_img | static_url | settings_image_url('1080p') }}" alt="">
		{% endif %}
	</section>
{% endif %}
