{# /*============================================================================
  #Tiendas: direcciones y horario
  Salen del grupo "Tiendas e Instagram de Lupita" del panel (lupita_tienda_1/2/3
  y lupita_horarios): store.address es un solo campo y las tiendas son tres.
  Si no hay ninguna cargada, vuelve a store.address. Devuelve <li>: el que lo
  incluye pone el <ul> y la clase de cada item (tiendas_item_clase).
==============================================================================*/#}

{% set lu_tiendas = [settings.lupita_tienda_1, settings.lupita_tienda_2, settings.lupita_tienda_3] %}
{% set lu_hay_tiendas = settings.lupita_tienda_1 or settings.lupita_tienda_2 or settings.lupita_tienda_3 %}

{% if lu_hay_tiendas %}
	{% for lu_tienda in lu_tiendas %}
		{% if lu_tienda %}
			<li class="{{ tiendas_item_clase }} lu-tienda-direccion">
				{% if tiendas_iconos %}{% include "snipplets/svg/map-marker-alt.tpl" with {svg_custom_class: "icon-inline icon-lg icon-w mx-2 svg-icon-text"} %}{% endif %}
				{{ lu_tienda }}
			</li>
		{% endif %}
	{% endfor %}
{% elseif store.address %}
	<li class="{{ tiendas_item_clase }} lu-tienda-direccion">
		{% if tiendas_iconos %}{% include "snipplets/svg/map-marker-alt.tpl" with {svg_custom_class: "icon-inline icon-lg icon-w mx-2 svg-icon-text"} %}{% endif %}
		{{ store.address }}
	</li>
{% endif %}
{% if settings.lupita_horarios %}
	<li class="{{ tiendas_item_clase }} lu-tienda-horario">{{ settings.lupita_horarios }}</li>
{% endif %}
