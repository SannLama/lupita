{# /*============================================================================
  #Riel de categorias (2026-09-25)
  Del PDF "Paginas Web implementar" (lam. 8-12: Matiere, Supre, Napoli,
  Millie): hasta seis categorias puntuales con foto y nombre encima. En
  computadora van todas en una fila; en celular se deslizan de costado
  (scroll-snap, sin librerias).

  Cada una sale solo si tiene foto y nombre ("Personalizar diseno > Riel de
  categorias"). Sin ninguna cargada, no se muestra.
==============================================================================*/#}

{% set lu_riel = [
	['riel-1.jpg', settings.lupita_riel_1_nombre, settings.lupita_riel_1_url],
	['riel-2.jpg', settings.lupita_riel_2_nombre, settings.lupita_riel_2_url],
	['riel-3.jpg', settings.lupita_riel_3_nombre, settings.lupita_riel_3_url],
	['riel-4.jpg', settings.lupita_riel_4_nombre, settings.lupita_riel_4_url],
	['riel-5.jpg', settings.lupita_riel_5_nombre, settings.lupita_riel_5_url],
	['riel-6.jpg', settings.lupita_riel_6_nombre, settings.lupita_riel_6_url]
] %}
{% set lu_riel_hay = false %}
{% for lu_r in lu_riel %}
	{% if lu_r[1] and (lu_r[0] | has_custom_image) %}
		{% set lu_riel_hay = true %}
	{% endif %}
{% endfor %}

{% if lu_riel_hay and not settings.lupita_riel_ocultar %}
	<section class="lu-riel" data-store="home-riel">
		{% if settings.lupita_riel_titulo %}
			<h3 class="lu-riel-titulo">{{ settings.lupita_riel_titulo }}</h3>
		{% endif %}
		<ul class="lu-riel-lista list-unstyled">
			{% for lu_r in lu_riel %}
				{% if lu_r[1] and (lu_r[0] | has_custom_image) %}
					<li class="lu-riel-item">
						<a class="lu-riel-link" href="{{ lu_r[2] ? (lu_r[2] | setting_url) : '#' }}">
							<img class="lu-riel-foto lazyload" src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ lu_r[0] | static_url | settings_image_url('large') }}" alt="">
							<span class="lu-riel-nombre">{{ lu_r[1] }}</span>
						</a>
					</li>
				{% endif %}
			{% endfor %}
		</ul>
	</section>
{% endif %}
