{# Portada: una sola foto a pantalla completa con un titulo grande, sin
   carrusel — idea de Santiago (referencia Lara Casa), 2026-09-11.

   Reusa las clases del hero (swiper-text/swiper-title/swiper-description/
   swiper-btn, swiper-white/swiper-black) para heredar gratis el sistema de
   contraste por foto que ya se arreglo ahi: ver la nota en lupita.scss.tpl
   sobre el selector de color de texto. #}

{% if has_cover %}
	<section class="section-cover-home" data-store="home-cover">
		<div class="cover-image">
			<img
				src="{{ 'cover.jpg' | static_url | settings_image_url('xlarge') }}"
				srcset="{{ 'cover.jpg' | static_url | settings_image_url('xlarge') }} 1400w, {{ 'cover.jpg' | static_url | settings_image_url('1080p') }} 1920w"
				class="cover-image-background lazyload fade-in"
				alt="{{ settings.cover_title }}"
			/>
			<div class="swiper-text swiper-{{ settings.cover_color }}">
				<div class="swiper-title h1">{{ settings.cover_title }}</div>
				{% if settings.cover_description %}
					<div class="swiper-description h5 font-weight-normal mt-3">{{ settings.cover_description }}</div>
				{% endif %}
				{% if settings.cover_button and settings.cover_url %}
					<a href="{{ settings.cover_url | setting_url }}" class="btn btn-small swiper-btn mt-4">{{ settings.cover_button }}</a>
				{% endif %}
			</div>
		</div>
	</section>
{% endif %}
