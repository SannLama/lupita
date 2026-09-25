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
    <nav class="lu-nav-desk" aria-label="{{ 'Menú principal' | translate }}">
        <ul class="lu-nav-desk-lista list-unstyled">
            {% for item in navigation %}
                {% set lu_nd_url = item.url ? (item.url | setting_url) : '#' %}
                <li class="lu-nav-desk-item{% if item.subitems %} lu-nav-desk-con-sub{% endif %}">
                    <a class="lu-nav-desk-link{% if item.current %} is-actual{% endif %}" href="{{ lu_nd_url }}"{% if item.subitems %} aria-haspopup="true"{% endif %}>
                        {{ item.name }}
                        {% if item.subitems %}
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
                    {% endif %}
                </li>
            {% endfor %}
        </ul>
    </nav>
    <script type="text/javascript">
        {# La fila de subcategorias sale siempre desde la seccion; si no entra
           hasta el borde derecho, se parte en renglones (ancho maximo = lo que
           queda hasta el borde). No se corre a la izquierda. #}
        (function () {
            document.querySelectorAll('.lu-nav-desk-con-sub').forEach(function (li) {
                var panel = li.querySelector('.lu-nav-desk-panel');
                function ajustar() {
                    var izq = li.getBoundingClientRect().left;
                    var disponible = document.documentElement.clientWidth - 16 - izq + 18;
                    panel.style.setProperty('--lu-nd-max', Math.max(220, Math.floor(disponible)) + 'px');
                }
                li.addEventListener('mouseenter', ajustar);
                li.addEventListener('focusin', ajustar);
            });
        })();
    </script>
{% endif %}
