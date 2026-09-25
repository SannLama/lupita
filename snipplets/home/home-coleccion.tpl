{# /*============================================================================
  #Coleccion (2026-09-25)
  Banner de la coleccion de temporada, del PDF "Paginas Web implementar"
  (lam. 3-5: Millie, Ylovers, Kosiuko): una foto o video de campana a todo el
  ancho, con un rotulo chico ("New in"), el nombre de la coleccion en grande
  y la temporada debajo ("// SS27"). Toda la franja es un link.

  Sale sola cuando hay foto o video en "Personalizar diseno > Coleccion".
==============================================================================*/#}

{% set lu_col_img = 'coleccion.jpg' | has_custom_image %}
{% set lu_col_video = settings.lupita_coleccion_video %}

{% if not settings.lupita_coleccion_ocultar and (lu_col_img or lu_col_video) %}
	{% set lu_col_titulo = settings.lupita_coleccion_titulo %}
	{% set lu_col_url = settings.lupita_coleccion_url %}
	<section class="lu-coleccion" data-store="home-coleccion">
		{% if lu_col_url %}<a class="lu-coleccion-link" href="{{ lu_col_url | setting_url }}"{% if lu_col_titulo %} aria-label="{{ lu_col_titulo }}"{% endif %}>{% else %}<div class="lu-coleccion-link">{% endif %}
			{% if lu_col_video %}
				<video class="lu-coleccion-media" autoplay muted loop playsinline preload="metadata"{% if lu_col_img %} poster="{{ 'coleccion.jpg' | static_url | settings_image_url('1080p') }}"{% endif %}>
					<source src="{{ lu_col_video }}" type="video/mp4">
				</video>
			{% else %}
				<img class="lu-coleccion-media lazyload" src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ 'coleccion.jpg' | static_url | settings_image_url('1080p') }}" alt="{{ lu_col_titulo }}">
			{% endif %}
			<div class="lu-coleccion-texto">
				{% if settings.lupita_coleccion_rotulo %}
					<span class="lu-coleccion-rotulo">{{ settings.lupita_coleccion_rotulo }}</span>
				{% endif %}
				{% if lu_col_titulo %}
					<h2 class="lu-coleccion-titulo">{{ lu_col_titulo }}</h2>
				{% endif %}
				{% if settings.lupita_coleccion_temporada %}
					<span class="lu-coleccion-temporada">{{ settings.lupita_coleccion_temporada }}</span>
				{% endif %}
				{% if settings.lupita_coleccion_boton and lu_col_url %}
					<span class="btn btn-line btn-small lu-coleccion-boton">{{ settings.lupita_coleccion_boton }}</span>
				{% endif %}
			</div>
		{% if lu_col_url %}</a>{% else %}</div>{% endif %}
	</section>
{% endif %}
