{# Barra de aviso: fondo turquesa y los mensajes corren hacia la izquierda sin
   cortes (Santiago, 2026-09-15; antes rotaban de a uno y desaparecian).
   Los mensajes salen del mismo campo del panel, separados por "—".

   Marquesina sin JS: el track lleva DOS grupos identicos y se desplaza -50%,
   que es exactamente el ancho de un grupo, asi el segundo toma el lugar del
   primero y el loop no salta. Cada grupo mide por lo menos el ancho de la
   pantalla (ver lupita.scss.tpl), para que no quede un hueco con pocos
   mensajes. El segundo grupo es aria-hidden: el lector de pantalla lee cada
   mensaje una vez. #}
{% if settings.ad_bar and settings.ad_text %}
	{% set ad_parts = settings.ad_text | split('—') %}
	<section class="section-advertising">
		{% if settings.ad_url %}
			<a class="link-contrast ad-marquee-link" href="{{ settings.ad_url | setting_url }}">
		{% endif %}
		<div class="ad-marquee">
			<div class="ad-marquee-track" style="animation-duration: {{ ad_parts | length * 7 }}s;">
				{% for vuelta in 1..2 %}
					<div class="ad-marquee-grupo"{% if vuelta == 2 %} aria-hidden="true"{% endif %}>
						{% for part in ad_parts %}
							<span class="ad-msg">{{ part | trim }}</span>
						{% endfor %}
					</div>
				{% endfor %}
			</div>
		</div>
		{% if settings.ad_url %}
			</a>
		{% endif %}
	</section>
{% endif %}
