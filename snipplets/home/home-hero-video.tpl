{# /*============================================================================
  #Hero con video (2026-09-25)
  Del PDF "Paginas Web implementar" (lam. 2: Supre): la portada del home con
  un video en loop, mudo, y un titulo grande encima. home-section-switch.tpl
  lo usa EN LUGAR del carrusel cuando hay un link en "Carrusel de imagenes >
  Video de portada". Sin link, el carrusel de fotos sigue como siempre.

  Tiendanube no aloja videos: va un link directo a un .mp4 (como Portada y
  Capsula). hero-video.jpg es la imagen mientras carga.
==============================================================================*/#}

{% set lu_hv_poster = 'hero-video.jpg' | has_custom_image %}
{% set lu_hv_url = settings.lupita_hero_url %}
<section class="lu-hero-video" data-store="home-hero-video">
	<video class="lu-hero-video-media" autoplay muted loop playsinline preload="auto"{% if lu_hv_poster %} poster="{{ 'hero-video.jpg' | static_url | settings_image_url('1080p') }}"{% endif %}>
		<source src="{{ settings.lupita_hero_video }}" type="video/mp4">
	</video>
	{% if settings.lupita_hero_titulo or settings.lupita_hero_bajada or (settings.lupita_hero_boton and lu_hv_url) %}
		<div class="lu-hero-video-texto">
			{% if settings.lupita_hero_titulo %}
				<h2 class="lu-hero-video-titulo">{{ settings.lupita_hero_titulo }}</h2>
			{% endif %}
			{% if settings.lupita_hero_bajada %}
				<p class="lu-hero-video-bajada">{{ settings.lupita_hero_bajada }}</p>
			{% endif %}
			{% if settings.lupita_hero_boton and lu_hv_url %}
				<a href="{{ lu_hv_url | setting_url }}" class="btn btn-small lu-hero-video-boton">{{ settings.lupita_hero_boton }}</a>
			{% endif %}
		</div>
	{% endif %}
</section>
