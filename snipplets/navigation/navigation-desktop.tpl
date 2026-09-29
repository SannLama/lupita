{# /*============================================================================
  #Menu de escritorio (2026-09-25)
  Como el de Tienda Napoli (pedido de Santiago): en computadora el menu
  principal va en una fila debajo del logo, en versal chica, y los rubros
  con subcategorias despliegan al pasar el mouse un panel a todo el ancho
  con las subcategorias en columnas. Los items son los del "Menu principal"
  de Tiendanube (el mismo del panel hamburguesa). En celular no se muestra:
  sigue la hamburguesa.
==============================================================================*/#}

{% if navigation %}
{# "New collection" (Santiago, 2026-09-29: "tendrian que estar todas las
   partes de arriba como remeras y remerones y asi con todos"): una columna
   por categoria del menu elegido en Diseno -> Menues -> "Desplegable de New
   collection" (si no se elige, el Menu principal), con TODAS sus
   subcategorias, que salen del arbol de categorias (category.subcategories)
   y no de lo cargado a mano en el menu. Asi, cuando suben categorias nuevas,
   aparecen solas. Orden alfabetico, sin repetidos y columnas con el mismo
   nombre fusionadas: ordenar-subcategorias.tpl. #}
{% set lu_nc_fuente = settings.lupita_newcol_menu ? menus[settings.lupita_newcol_menu] : navigation %}
{% set lu_nc_fuente = lu_nc_fuente ?: navigation %}
    <nav class="lu-nav-desk" aria-label="{{ 'Menú principal' | translate }}">
        <ul class="lu-nav-desk-lista list-unstyled">
            {# Sin "Envíos" (Santiago, 2026-09-28: "sacá lo de envíos") #}
            {% for item in navigation if item.name | lower not in ['envíos', 'envios'] %}
                {% set lu_nd_url = item.url ? (item.url | setting_url) : '#' %}
                {# "New collection" despliega todas las categorias del menu
                   (Santiago, 2026-09-27): se arman solas con los items de
                   categoria del Menu principal, sin cargar nada en el panel #}
                {% set lu_nd_newcol = 'new collection' in item.name | lower %}
                {% set lu_nd_desplegable = item.subitems or lu_nd_newcol %}
                <li class="lu-nav-desk-item{% if lu_nd_desplegable %} lu-nav-desk-con-sub{% endif %}">
                    <a class="lu-nav-desk-link{% if item.current %} is-actual{% endif %}" href="{{ lu_nd_url }}"{% if lu_nd_desplegable %} aria-haspopup="true"{% endif %}>
                        {{ item.name }}
                        {% if lu_nd_desplegable %}
                            {% include "snipplets/svg/chevron-down.tpl" with {svg_custom_class: "icon-inline lu-nav-desk-flecha"} %}
                        {% endif %}
                    </a>
                    {% if lu_nd_newcol %}
                        <div class="lu-nav-desk-panel lu-nc-panel">
                            <a class="lu-nav-desk-sublink lu-nav-desk-todo lu-nc-todo" href="{{ lu_nd_url }}">{{ 'Ver todo' | translate }}</a>
                            <ul class="js-lu-grupos lu-nc-grupos list-unstyled">
                                {% for lu_g in lu_nc_fuente if lu_g.name != item.name and lu_g.name | lower not in ['envíos', 'envios'] %}
                                    {% if lu_g.isCategory and lu_g.category and lu_g.category.subcategories is not empty %}
                                        <li class="js-lu-grupo lu-nc-grupo">
                                            <a class="js-lu-grupo-titulo lu-nav-desk-sublink lu-nc-titulo" href="{{ lu_g.category.url }}">{{ lu_g.name }}</a>
                                                <ul class="js-lu-grupo-items lu-nc-items list-unstyled">
                                                    {% for lu_s in lu_g.category.subcategories %}
                                                        <li><a class="lu-nav-desk-sublink lu-nc-item" href="{{ lu_s.url }}">{{ lu_s.name }}</a></li>
                                                    {% endfor %}
                                                </ul>
                                        </li>
                                    {% elseif lu_g.subitems %}
                                        <li class="js-lu-grupo lu-nc-grupo">
                                            <a class="js-lu-grupo-titulo lu-nav-desk-sublink lu-nc-titulo" href="{% if lu_g.url %}{{ lu_g.url | setting_url }}{% else %}#{% endif %}">{{ lu_g.name }}</a>
                                            <ul class="js-lu-grupo-items lu-nc-items list-unstyled">
                                                {% for lu_s in lu_g.subitems %}
                                                    <li><a class="lu-nav-desk-sublink lu-nc-item" href="{% if lu_s.url %}{{ lu_s.url | setting_url }}{% else %}#{% endif %}">{{ lu_s.name }}</a></li>
                                                {% endfor %}
                                            </ul>
                                        </li>
                                    {% endif %}
                                {% endfor %}
                            </ul>
                        </div>
                    {% elseif item.subitems %}
                        <div class="lu-nav-desk-panel">
                            <ul class="lu-nav-desk-sub list-unstyled">
                                {% if item.isCategory and item.url %}
                                    <li><a class="lu-nav-desk-sublink lu-nav-desk-todo" href="{{ item.url }}">{{ 'Ver todo' | translate }}</a></li>
                                {% endif %}
                                {% for lu_nd_sub in item.subitems %}
                                    <li><a class="lu-nav-desk-sublink{% if lu_nd_sub.current %} is-actual{% endif %}" href="{% if lu_nd_sub.url %}{{ lu_nd_sub.url | setting_url }}{% else %}#{% endif %}">{{ lu_nd_sub.name }}</a></li>
                                {% endfor %}
                            </ul>
                        </div>
                    {% endif %}
                </li>
            {% endfor %}
        </ul>
    </nav>
    {% include "snipplets/navigation/ordenar-subcategorias.tpl" %}
    <script type="text/javascript">
        {# El contenido del panel se alinea con la fila del menu: arranca donde
           arranca el primer item y termina donde termina el ultimo, asi las
           subcategorias quedan en la misma grilla que las categorias #}
        (function () {
            var links = document.querySelectorAll('.lu-nav-desk-lista > .lu-nav-desk-item > .lu-nav-desk-link');
            if (!links.length) return;
            function ajustar() {
                var ancho = document.documentElement.clientWidth;
                var izq = links[0].getBoundingClientRect().left;
                var der = links[links.length - 1].getBoundingClientRect().right;
                document.querySelectorAll('.lu-nav-desk-panel').forEach(function (p) {
                    p.style.setProperty('--lu-nd-inicio', Math.round(izq) + 'px');
                    p.style.setProperty('--lu-nd-fin', Math.max(16, Math.round(ancho - der)) + 'px');
                });
            }
            document.querySelectorAll('.lu-nav-desk-con-sub').forEach(function (li) {
                li.addEventListener('mouseenter', ajustar);
                li.addEventListener('focusin', ajustar);
            });
        })();
    </script>
{% endif %}
