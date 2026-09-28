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
{# Secciones de "New collection" (Santiago, 2026-09-28: "que te lleve a
   partes de arriba, partes de abajo, sweaters"): son las subcategorias de
   la categoria SS 27, que es a donde apunta el item del menu. El item del
   Menu principal no las trae (no tiene subitems cargados), por eso van aca.
   Si cambian las subcategorias en el panel, actualizar esta lista. #}
{% set lu_nc_secciones = [
    ['Partes de arriba', '/denim-wear-1ifcg/pantalon-denim/partes-de-arriba-xpdzu/'],
    ['Partes de abajo', '/denim-wear-1ifcg/pantalon-denim/partes-de-abajo-1yr44/'],
    ['Hoodies y sweaters', '/denim-wear-1ifcg/pantalon-denim/hoodies-y-sweaters-1lv3x/'],
    ['Bikinis', '/denim-wear-1ifcg/pantalon-denim/bikinis-1upjt/']
] %}
    <nav class="lu-nav-desk" aria-label="{{ 'Menú principal' | translate }}">
        <ul class="lu-nav-desk-lista list-unstyled">
            {# Sin "Envíos" (Santiago, 2026-09-28: "sacá lo de envíos") #}
            {% for item in navigation if item.name | lower not in ['envíos', 'envios'] %}
                {% set lu_nd_url = item.url ? (item.url | setting_url) : '#' %}
                {# "New collection" despliega todas las categorias del menu
                   (Santiago, 2026-09-27): se arman solas con los items de
                   categoria del Menu principal, sin cargar nada en el panel #}
                {% set lu_nd_newcol = 'new collection' in item.name | lower and not item.subitems %}
                {% set lu_nd_desplegable = item.subitems or lu_nd_newcol %}
                <li class="lu-nav-desk-item{% if lu_nd_desplegable %} lu-nav-desk-con-sub{% endif %}">
                    <a class="lu-nav-desk-link{% if item.current %} is-actual{% endif %}" href="{{ lu_nd_url }}"{% if lu_nd_desplegable %} aria-haspopup="true"{% endif %}>
                        {{ item.name }}
                        {% if lu_nd_desplegable %}
                            {% include "snipplets/svg/chevron-down.tpl" with {svg_custom_class: "icon-inline lu-nav-desk-flecha"} %}
                        {% endif %}
                    </a>
                    {% if item.subitems %}
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
                    {% elseif lu_nd_newcol %}
                        <div class="lu-nav-desk-panel">
                            <ul class="lu-nav-desk-sub list-unstyled">
                                {% if true %}
                                    <li><a class="lu-nav-desk-sublink lu-nav-desk-todo" href="{{ lu_nd_url }}">{{ 'Ver todo' | translate }}</a></li>
                                {% endif %}
                                {% for lu_nc in lu_nc_secciones %}
                                    <li><a class="lu-nav-desk-sublink" href="{{ store.url }}{{ lu_nc[1] }}">{{ lu_nc[0] }}</a></li>
                                {% endfor %}
                                {# Y todo lo de Accesorios (Santiago, 2026-09-28): sale de los
                                   subitems del item "Accesorios" del Menu principal #}
                                {% for lu_acc in navigation if 'accesorios' in lu_acc.name | lower %}
                                    {% for lu_acc_sub in lu_acc.subitems %}
                                        <li><a class="lu-nav-desk-sublink" href="{% if lu_acc_sub.url %}{{ lu_acc_sub.url | setting_url }}{% else %}#{% endif %}">{{ lu_acc_sub.name }}</a></li>
                                    {% endfor %}
                                {% endfor %}
                            </ul>
                        </div>
                    {% endif %}
                </li>
            {% endfor %}
        </ul>
    </nav>
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
