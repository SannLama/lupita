{# /*============================================================================
  #Franja antes del pie (2026-09-25)
  Del PDF "Paginas Web implementar" (lam. 25: Millie): tres datos de compra
  en una fila, justo arriba del footer, en todas las paginas. layout.tpl la
  incluye antes de footer.tpl.

  Ahi! Lupita no vende online, asi que en vez de "compra protegida" los tres
  datos por defecto llevan a lo que ya existe: envios, cambios y WhatsApp.
  Todo se cambia en "Personalizar diseno > Franja antes del pie".
==============================================================================*/#}

{% set lu_wa = store.whatsapp %}
{% set lu_ap_items = [
	['truck', settings.lupita_pie_1_titulo ?: 'Envíos', settings.lupita_pie_1_texto ?: 'Mirá cómo y a dónde enviamos.', settings.lupita_pie_1_url ?: '/envios/'],
	['sync-alt', settings.lupita_pie_2_titulo ?: 'Cambios y devoluciones', settings.lupita_pie_2_texto ?: 'Todo lo que tenés que saber.', settings.lupita_pie_2_url ?: '/cambios-y-devoluciones/'],
	['whatsapp', settings.lupita_pie_3_titulo ?: 'Atención personalizada', settings.lupita_pie_3_texto ?: 'Escribinos por WhatsApp y te asesoramos.', settings.lupita_pie_3_url ?: lu_wa]
] %}

{% if not settings.lupita_pie_ocultar %}
	<section class="lu-antes-pie" data-store="antes-del-pie" aria-label="{{ 'Informacion de compra' | translate }}">
		<ul class="lu-antes-pie-lista list-unstyled">
			{% for lu_ap in lu_ap_items %}
				{% set lu_ap_externo = 'http' in lu_ap[3] and 'ahilupita' not in lu_ap[3] %}
				<li class="lu-antes-pie-item">
					{% if lu_ap[3] %}<a class="lu-antes-pie-link" href="{% if lu_ap_externo %}{{ lu_ap[3] }}{% else %}{{ lu_ap[3] | setting_url }}{% endif %}"{% if lu_ap_externo %} target="_blank" rel="noopener"{% endif %}>{% endif %}
						<span class="lu-antes-pie-icono" aria-hidden="true">
							{% if lu_ap[0] == 'truck' %}
								{% include "snipplets/svg/truck.tpl" with {svg_custom_class: "icon-inline"} %}
							{% elseif lu_ap[0] == 'sync-alt' %}
								{% include "snipplets/svg/sync-alt.tpl" with {svg_custom_class: "icon-inline"} %}
							{% else %}
								{% include "snipplets/svg/whatsapp.tpl" with {svg_custom_class: "icon-inline"} %}
							{% endif %}
						</span>
						<span class="lu-antes-pie-titulo">{{ lu_ap[1] }}</span>
						<span class="lu-antes-pie-texto">{{ lu_ap[2] }}</span>
					{% if lu_ap[3] %}</a>{% endif %}
				</li>
			{% endfor %}
		</ul>
	</section>
{% endif %}
