{# Barra de aviso: fondo turquesa, UN mensaje por vez, quieto y centrado, que
   cambia al siguiente cada 4 segundos con un fundido corto (Santiago,
   2026-09-28, "como el de markova.com"; del 15/9 al 28/9 fue una marquesina
   que corria hacia la izquierda). Los mensajes salen del mismo campo del
   panel, separados por "—".

   Todos los mensajes ocupan la misma celda de una grilla: la franja mide lo
   que el mensaje mas largo (si en el celular alguno ocupa dos renglones, la
   franja no salta al cambiar). Se frena al pasar el mouse. Con un solo
   mensaje no rota. #}
{% if settings.ad_bar and settings.ad_text %}
	{% set ad_parts = settings.ad_text | split('—') %}
	<section class="section-advertising">
		{% if settings.ad_url %}
			<a class="link-contrast ad-rotador-link" href="{{ settings.ad_url | setting_url }}">
		{% endif %}
		<div class="ad-rotador js-ad-rotador">
			{% for part in ad_parts %}
				<span class="ad-msg{% if loop.first %} is-activo{% endif %}">{{ part | trim }}</span>
			{% endfor %}
		</div>
		{% if settings.ad_url %}
			</a>
		{% endif %}
	</section>
	<script>
		(function () {
			var rotador = document.querySelector('.js-ad-rotador');
			if (!rotador) return;
			var msgs = rotador.querySelectorAll('.ad-msg');
			if (msgs.length < 2) return;
			var actual = 0, quieto = false;
			rotador.addEventListener('mouseenter', function () { quieto = true; });
			rotador.addEventListener('mouseleave', function () { quieto = false; });
			setInterval(function () {
				if (quieto || document.hidden) return;
				msgs[actual].classList.remove('is-activo');
				actual = (actual + 1) % msgs.length;
				msgs[actual].classList.add('is-activo');
			}, 4000);
		})();
	</script>
{% endif %}
