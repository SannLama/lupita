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
{# Para "New collection" (ver navigation-desktop.tpl): las categorias del
   menu de primer nivel. En las subcategorias no hay "New collection", asi que
   la lista solo se usa en la primera vuelta. #}
{% set lu_nl_cats = navigation %}
{% for item in navigation if item.name | lower not in ['envíos', 'envios'] %}
    {% if not item.subitems and 'new collection' in item.name | lower %}
        <li class="item-with-subitems" data-component="menu.item">
            <div class="js-nav-list-toggle-accordion">
                <a class="js-toggle-page-accordion nav-list-link" href="#">
                    {{ item.name }}
                    <span class="nav-list-arrow transition-soft">
                        {% include "snipplets/svg/chevron-down.tpl" with {svg_custom_class: "icon-inline svg-icon-text"} %}
                    </span>
                </a>
            </div>
            <ul class="js-pages-accordion list-subitems nav-list-accordion" style="display:none;">
                {% if item.url %}
                    <li class="nav-item">
                        <a class="nav-list-link" href="{{ item.url | setting_url }}"><strong>{{ 'Ver todo en' | translate }} {{ item.name }}</strong></a>
                    </li>
                {% endif %}
                {% for lu_nc in lu_nc_secciones %}
                    <li class="nav-item">
                        <a class="nav-list-link" href="{{ store.url }}{{ lu_nc[1] }}">{{ lu_nc[0] }}</a>
                    </li>
                {% endfor %}
            </ul>
        </li>
    {% elseif item.subitems %}
        <li class="item-with-subitems" data-component="menu.item">
            <div class="js-nav-list-toggle-accordion">
                <a class="js-toggle-page-accordion nav-list-link {{ (item.isCategory and item.category.images is not empty) ? 'lu-nav-con-preview' : '' }}" href="#">
                    {{ item.name }}
                    {% if item.isCategory and item.category.images is not empty %}
                        <img class="lu-nav-preview" src="{{ item.category.images | first | category_image_url('large') }}" alt="" loading="lazy">
                    {% endif %}
                    <span class="nav-list-arrow transition-soft">
                        {% include "snipplets/svg/chevron-down.tpl" with {svg_custom_class: "icon-inline svg-icon-text"} %}
                    </span>
                </a>
            </div>
            <ul class="js-pages-accordion list-subitems nav-list-accordion" style="display:none;">
                {% if item.isCategory %}
                    <li class="nav-item">
                        <a class="nav-list-link {{ item.current ? 'selected' : '' }}" href="{{ item.url }}">
                            <strong>
                                {% if item.isRootCategory %}
                                    {{ 'Ver todos los productos' | translate }}
                                {% else %}
                                    {{ 'Ver todo en' | translate }} {{ item.name }}
                                {% endif %}
                            </strong>
                        </a>
                    </li>
                {% endif %}
                {% snipplet "navigation/navigation-nav-list.tpl" with navigation = item.subitems %}
            </ul>
        </li>
    {% else %}
        <li data-component="menu.item">
            <a class="nav-list-link {{ (item.isCategory and item.category.images is not empty) ? 'lu-nav-con-preview' : '' }}" href="{% if item.url %}{{ item.url | setting_url }}{% else %}#{% endif %}">
                {{ item.name }}
                {% if item.isCategory and item.category.images is not empty %}
                    <img class="lu-nav-preview" src="{{ item.category.images | first | category_image_url('large') }}" alt="" loading="lazy">
                {% endif %}
            </a>
        </li>
    {% endif %}
{% endfor %}