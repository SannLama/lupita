{# Pie (Santiago, 2026-09-24, con referencia): lista vertical con icono y
   nombre de la red, no una tira de cuadrados sueltos. #}
{% set lu_redes_nombre = {'instagram': 'Instagram', 'facebook': 'Facebook', 'youtube': 'YouTube', 'tiktok': 'TikTok', 'twitter': 'X', 'pinterest': 'Pinterest'} %}
<ul class="lu-pie-lista">
{% for sn in ['instagram', 'facebook', 'youtube', 'tiktok', 'twitter', 'pinterest'] %}
    {% set sn_url = attribute(store,sn) %}
    {% if sn_url %}
        <li class="lu-pie-item">
            <a class="lu-pie-red" href="{{ sn_url }}" target="_blank" rel="noopener" aria-label="{{ lu_redes_nombre[sn] }} {{ store.name }}">
                {% if sn == "facebook" %}
                    {% set social_network = sn ~ '-f' %}
                {% else %}
                    {% set social_network = sn %}
                {% endif %}
                {% include "snipplets/svg/" ~ social_network ~ ".tpl" with {svg_custom_class: "icon-inline"} %}
                <span>{{ lu_redes_nombre[sn] }}</span>
            </a>
        </li>
    {% endif %}
{% endfor %}
</ul>
