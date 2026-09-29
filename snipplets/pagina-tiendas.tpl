{# /*============================================================================
  #Pagina de tiendas (2026-09-25)
  Del PDF "Paginas Web implementar" (lam. 23-24: Naima): las tres tiendas
  con foto, direccion, horario, WhatsApp y "Como llegar" a Google Maps.
  page.tpl la usa para la pagina "Locales" (ya existia en la tienda) o una
  que se llame "Tiendas" / "Nuestras tiendas".

  Direcciones y horario salen de "Tiendas e Instagram de Lupita" (los mismos
  del pie). Fotos, nombres, horarios propios y links de Maps son opcionales:
  sin link de Maps, el boton busca la direccion en Google Maps.

  El contenido de la pagina NO se muestra (ver abajo).
==============================================================================*/#}

{% set lu_ts = [
	['tienda-1.jpg', settings.lupita_tienda_1_nombre, settings.lupita_tienda_1, settings.lupita_tienda_1_horario, settings.lupita_tienda_1_maps, 'local-espana-2.jpg'],
	['tienda-2.jpg', settings.lupita_tienda_2_nombre, settings.lupita_tienda_2, settings.lupita_tienda_2_horario, settings.lupita_tienda_2_maps, 'local-esquina-2.jpg'],
	['tienda-3.jpg', settings.lupita_tienda_3_nombre, settings.lupita_tienda_3, settings.lupita_tienda_3_horario, settings.lupita_tienda_3_maps, 'local-banfield-2.jpg']
] %}
{# Fotos de las tiendas fijas en el theme (Santiago, 2026-09-29): las mismas
   de Probatelo (static/images/local-*-2.jpg). Van por codigo y no por el
   panel para no depender de "Publicar cambios"; si algun dia se quiere volver
   a las del panel, usar lu_t[0] | has_custom_image como antes. #}
{% set lu_ts_wa = store.whatsapp %}

<section class="lu-tiendas-pag" data-store="page-tiendas">
	<div class="container">
		<header class="lu-tiendas-cabecera">
			<h1 class="lu-pagina-titulo">{{ settings.lupita_tiendas_titulo ?: 'Nuestras tiendas' }}</h1>
			<p class="lu-tiendas-bajada">{{ settings.lupita_tiendas_bajada ?: 'Vení a nuestras tiendas a probártelo con el asesoramiento personalizado de nuestro equipo.' }}</p>
		</header>

		<ul class="lu-tiendas-grilla list-unstyled">
			{% for lu_t in lu_ts if lu_t[2] %}
				{% set lu_t_foto = true %}
				<li class="lu-tienda-card">
					<figure class="lu-tienda-foto{% if not lu_t_foto %} lu-tienda-foto-vacia{% endif %}">
						{% if lu_t_foto %}
							<img src="{{ ('images/' ~ lu_t[5]) | static_url }}" width="810" height="1080" loading="lazy" alt="{{ 'Tienda de' | translate }} {{ lu_t[1] ?: lu_t[2] }}">
						{% else %}
							{% include "snipplets/svg/logo-lupita.tpl" with {svg_custom_class: 'lu-tienda-logo'} %}
						{% endif %}
					</figure>
					<div class="lu-tienda-datos">
						{% if lu_t[1] %}<h2 class="lu-tienda-nombre">{{ lu_t[1] }}</h2>{% endif %}
						<p class="lu-tienda-dato lu-tienda-dir">{% include "snipplets/svg/map-marker-alt.tpl" with {svg_custom_class: "icon-inline"} %}<span>{{ lu_t[2] }}</span></p>
						{% if lu_t[3] or settings.lupita_horarios %}
							<p class="lu-tienda-dato">{% include "snipplets/svg/calendar-alt.tpl" with {svg_custom_class: "icon-inline"} %}<span>{{ lu_t[3] ?: settings.lupita_horarios }}</span></p>
						{% endif %}
						<div class="lu-tienda-acciones">
							<a class="btn btn-primary btn-small js-lu-maps" href="{{ lu_t[4] ?: 'https://www.google.com/maps/search/' }}" data-direccion="{% if not lu_t[4] %}{{ lu_t[2] }}{% endif %}" target="_blank" rel="noopener">{{ 'Cómo llegar' | translate }}</a>
							{% if lu_ts_wa %}
								<a class="lu-tienda-wa" href="{{ lu_ts_wa }}" target="_blank" rel="noopener">{% include "snipplets/svg/whatsapp.tpl" with {svg_custom_class: "icon-inline"} %}{{ 'Escribinos' | translate }}</a>
							{% endif %}
						</div>
					</div>
				</li>
			{% endfor %}
		</ul>

		{# 2026-09-25: el contenido de la pagina era una imagen vieja de 2020
		   ("Nuestros locales - Las Lomitas"); Santiago pidio borrarlo y el panel
		   exige algo de texto, asi que aca no se muestra. #}
	</div>
</section>

<script type="text/javascript">
	{# Sin link de Maps cargado, el boton busca la direccion #}
	document.querySelectorAll('.js-lu-maps[data-direccion]').forEach(function (a) {
		var dir = a.getAttribute('data-direccion');
		if (dir) a.href = 'https://www.google.com/maps/search/?api=1&query=' + encodeURIComponent(dir + ', Buenos Aires, Argentina');
	});
</script>
