{# /*============================================================================
  #Cinta de Instagram (2026-09-25)
  Del PDF "Paginas Web implementar" (lam. 27: Supre, "As seen on social"):
  posteos de Instagram en una sola fila, corriendo de costado, con el
  usuario debajo. Pensada para ir ultima en el home, pegada al pie.

  Las fotos se cargan a mano (ig-1.jpg ... ig-8.jpg en "Cinta de
  Instagram"): el feed automatico de Tiendanube necesita Instagram conectado
  en el panel, y hoy no lo esta. Todas llevan al perfil.
==============================================================================*/#}

{% set lu_ig_fotos = [] %}
{% for lu_i in 1..8 %}
	{% if ('ig-' ~ lu_i ~ '.jpg') | has_custom_image %}
		{% set lu_ig_fotos = lu_ig_fotos | merge(['ig-' ~ lu_i ~ '.jpg']) %}
	{% endif %}
{% endfor %}

{% if lu_ig_fotos and not settings.lupita_igc_ocultar %}
	{% set lu_ig_url = store.instagram %}
	<section class="lu-igc" data-store="home-ig-cinta" data-motion="cinta">
		{% if settings.lupita_igc_titulo %}
			<h3 class="lu-igc-titulo">{{ settings.lupita_igc_titulo }}</h3>
		{% endif %}
		<div class="lu-igc-marco">
			<div class="lu-igc-pista">
				{% for lu_tanda in 1..2 %}
					{% for lu_f in lu_ig_fotos %}
						<a class="lu-igc-post" href="{{ lu_ig_url }}" target="_blank" rel="noopener"{% if lu_tanda == 2 %} aria-hidden="true" tabindex="-1"{% endif %}>
							<img class="lazyload" src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ lu_f | static_url | settings_image_url('medium') }}" alt="{% if lu_tanda == 1 %}{{ 'Publicación de Instagram' | translate }}{% endif %}">
						</a>
					{% endfor %}
				{% endfor %}
			</div>
		</div>
		{% if lu_ig_url %}
			<a class="lu-igc-usuario" href="{{ lu_ig_url }}" target="_blank" rel="noopener">
				{% include "snipplets/svg/instagram.tpl" with {svg_custom_class: "icon-inline"} %}
				@{{ lu_ig_url | split('/') | last }}
			</a>
		{% endif %}
	</section>
{% endif %}
