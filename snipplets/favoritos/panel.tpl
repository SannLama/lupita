{# /*============================================================================
  #Favoritos: cuerpo del panel
  La lista la dibuja lupita-favoritos. Direcciones y horario salen del panel
  (snipplets/tiendas-datos.tpl): no se escribe ninguna a mano.
==============================================================================*/#}

<div class="lu-favs">
    <div class="lu-favs-local">
        <p class="lu-favs-titulo">{{ 'Vení a probártelas' | translate }}</p>
        <ul class="lu-favs-direcciones list-unstyled">
            {% include 'snipplets/tiendas-datos.tpl' with {tiendas_item_clase: 'lu-favs-direccion'} %}
        </ul>
        {% include 'snipplets/tiendas-link.tpl' with {tiendas_clase: 'lu-tiendas-favs'} %}
    </div>
    <ul class="js-favs-lista lu-favs-lista list-unstyled"></ul>
    <p class="js-favs-vacio lu-favs-vacio">{{ 'Todavía no guardaste nada. Tocá el corazón en las prendas que quieras probarte.' | translate }}</p>
</div>
