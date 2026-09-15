{# Portada: una sola foto o un video en loop a pantalla completa, con un titulo
   opcional encima, sin carrusel — idea de Santiago (referencia Lara Casa),
   2026-09-11. El video lo pidio el 2026-09-15.

   Reusa las clases del hero (swiper-text/swiper-title/swiper-description/
   swiper-btn, swiper-white/swiper-black) para heredar gratis el sistema de
   contraste por foto que ya se arreglo ahi: ver la nota en lupita.scss.tpl
   sobre el selector de color de texto.

   Video: igual que la Capsula, Tiendanube no aloja el archivo, asi que
   `cover_video_url` es un link directo a un .mp4. Mudo porque sin `muted` no
   hay autoplay; cover.jpg queda de poster mientras carga. #}

{% if has_cover %}
	<section class="section-cover-home" data-store="home-cover">
		<div class="cover-image">
			{% if settings.cover_video_url %}
				<video
					class="cover-image-background"
					id="cover-video"
					autoplay
					muted
					loop
					playsinline
					preload="auto"
					{% if 'cover.jpg' | has_custom_image %}poster="{{ 'cover.jpg' | static_url | settings_image_url('1080p') }}"{% endif %}
				>
					<source src="{{ settings.cover_video_url }}" type="video/mp4">
				</video>
				<script>
					(function () {
						var v = document.getElementById('cover-video');
						if (v && window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
							v.removeAttribute('autoplay');
							v.pause();
							v.currentTime = 0;
						}
					})();
				</script>
			{% else %}
				<img
					src="{{ 'cover.jpg' | static_url | settings_image_url('xlarge') }}"
					srcset="{{ 'cover.jpg' | static_url | settings_image_url('xlarge') }} 1400w, {{ 'cover.jpg' | static_url | settings_image_url('1080p') }} 1920w"
					class="cover-image-background lazyload fade-in"
					alt="{{ settings.cover_title }}"
				/>
			{% endif %}
			{% if settings.cover_title or settings.cover_description or (settings.cover_button and settings.cover_url) %}
				<div class="swiper-text swiper-{{ settings.cover_color }}">
					{% if settings.cover_title %}
						<div class="swiper-title h1">{{ settings.cover_title }}</div>
					{% endif %}
					{% if settings.cover_description %}
						<div class="swiper-description h5 font-weight-normal mt-3">{{ settings.cover_description }}</div>
					{% endif %}
					{% if settings.cover_button and settings.cover_url %}
						<a href="{{ settings.cover_url | setting_url }}" class="btn btn-small swiper-btn mt-4">{{ settings.cover_button }}</a>
					{% endif %}
				</div>
			{% endif %}
		</div>
	</section>
{% endif %}
