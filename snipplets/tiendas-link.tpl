{# /*============================================================================
  #Link "Conocer las tiendas"
  Lleva a la lista de Google Maps que carga la clienta en "Personalizar diseño
  > Tiendas e Instagram de Lupita". Si el campo esta vacio, no aparece.
  tiendas_clase: clase de ubicacion (lu-tiendas-favs, lu-tiendas-pie,
  lu-tiendas-pagos).
==============================================================================*/#}

{% if settings.lupita_tiendas_url %}
    <a href="{{ settings.lupita_tiendas_url }}" target="_blank" rel="noopener" class="lu-tiendas-link {{ tiendas_clase }}">{{ 'Conocer las tiendas' | translate }}</a>
{% endif %}
