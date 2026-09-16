{# Capsula: video en loop, sin sonido, de fondo — idea de Santiago (la
   capsula actual de la marca es "The Trip"), 2026-09-11.

   Tiendanube no aloja archivos de video sueltos: `capsule_video_url` tiene
   que ser un link directo a un .mp4 alojado en otro lado (no una pagina de
   YouTube/Vimeo — eso es lo que ya hace video_embed, un video con boton de
   play, seccion distinta). La imagen de reemplazo cubre dos casos: mientras
   carga, y los navegadores que no dejan autoplay.

   ⚠️ Sin `muted` el autoplay no arranca en ningun navegador, asi que no hay
   sonido: no es una decision de diseño, es el unico autoplay que los
   navegadores permiten.

   Reusa las clases de texto del hero, igual que la Portada — ver la nota en
   lupita.scss.tpl. #}

{% if has_capsule %}
	<section class="section-capsule-home" data-store="home-capsule">
		<div class="capsule-media">
			{# Desde el 2026-09-16 el video va repetido en una cinta que corre.
			   Con movimiento reducido la cinta queda quieta y en pausa (ver el
			   snipplet): un fondo en loop continuo es el caso que la guia marca. #}
			{% set lu_poster = '' %}
			{% if 'capsule-poster.jpg' | has_custom_image %}
				{% set lu_poster = 'capsule-poster.jpg' | static_url | settings_image_url('large') %}
			{% endif %}
			{% include 'snipplets/home/cinta-video.tpl' with {video_url: settings.capsule_video_url, poster_url: lu_poster, clase_video: 'capsule-video'} %}
			{% if settings.capsule_title or settings.capsule_description or settings.capsule_button %}
				<div class="swiper-text swiper-{{ settings.capsule_color }}">
					{% if settings.capsule_title %}
						<div class="swiper-title h1">{{ settings.capsule_title }}</div>
					{% endif %}
					{% if settings.capsule_description %}
						<div class="swiper-description h5 font-weight-normal mt-3">{{ settings.capsule_description }}</div>
					{% endif %}
					{% if settings.capsule_button and settings.capsule_url %}
						<a href="{{ settings.capsule_url | setting_url }}" class="btn btn-small swiper-btn mt-4">{{ settings.capsule_button }}</a>
					{% endif %}
				</div>
			{% endif %}
		</div>
	</section>
{% endif %}
