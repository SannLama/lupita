{# /*============================================================================
  #Backstage (2026-09-25)
  Del PDF "Paginas Web implementar" (lam. 19: Napoli): videos de backstage de
  la campana, verticales como un reel, con la cinta del nombre de la
  temporada corriendo arriba (snipplets/cinta-temporada.tpl).

  Hasta tres links directos a .mp4 (Tiendanube no aloja videos). En celular
  se deslizan de costado. Fuera de pantalla se pausan (lupita-motion, gesto
  "cinta"). Sale si hay al menos un video o el nombre de la temporada.
==============================================================================*/#}

{% set lu_bs_videos = [settings.lupita_backstage_video_1, settings.lupita_backstage_video_2, settings.lupita_backstage_video_3] %}
{% set lu_bs_hay = settings.lupita_backstage_video_1 or settings.lupita_backstage_video_2 or settings.lupita_backstage_video_3 %}

{% if not settings.lupita_backstage_ocultar and (lu_bs_hay or settings.lupita_temporada) %}
	<section class="lu-backstage" data-store="home-backstage" data-motion="cinta">
		{% include 'snipplets/cinta-temporada.tpl' %}
		{% if lu_bs_hay %}
			<div class="lu-backstage-cuerpo">
				{% if settings.lupita_backstage_titulo or settings.lupita_backstage_texto %}
					<div class="lu-backstage-cabecera">
						{% if settings.lupita_backstage_titulo %}<h3 class="lu-backstage-titulo">{{ settings.lupita_backstage_titulo }}</h3>{% endif %}
						{% if settings.lupita_backstage_texto %}<p class="lu-backstage-texto">{{ settings.lupita_backstage_texto }}</p>{% endif %}
					</div>
				{% endif %}
				<ul class="lu-backstage-lista list-unstyled">
					{% for lu_v in lu_bs_videos if lu_v %}
						<li class="lu-backstage-item">
							<video class="lu-backstage-video" autoplay muted loop playsinline preload="metadata" tabindex="-1">
								<source src="{{ lu_v }}" type="video/mp4">
							</video>
						</li>
					{% endfor %}
				</ul>
			</div>
		{% endif %}
	</section>
{% endif %}
