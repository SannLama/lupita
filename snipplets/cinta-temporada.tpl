{# /*============================================================================
  #Cinta de temporada (2026-09-25)
  Del PDF "Paginas Web implementar" (lam. 19: Napoli): el nombre de la
  temporada repetido, corriendo de costado sin fin. La usa el Backstage del
  home y, si se tilda en el panel, tambien va arriba del pie en todas las
  paginas (layout.tpl).

  Misma mecanica que la cinta de video: la pista son dos tandas iguales y el
  CSS la corre -50%, asi el salto cae sobre un texto identico. Decorativa
  (aria-hidden). Con movimiento reducido queda quieta.
==============================================================================*/#}

{% if settings.lupita_temporada %}
	<div class="lu-temporada" aria-hidden="true">
		<div class="lu-temporada-pista">
			{% for lu_tanda in 1..2 %}
				{% for lu_rep in 1..6 %}
					<span class="lu-temporada-item">{{ settings.lupita_temporada }}</span>
				{% endfor %}
			{% endfor %}
		</div>
	</div>
{% endif %}
