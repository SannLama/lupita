{# Para "New collection" (ver navigation-desktop.tpl): el menu elegido en
   Diseno para su desplegable, o el Menu principal. En las subcategorias no
   hay "New collection", asi que solo se usa en la primera vuelta. #}
{% set lu_nc_fuente = settings.lupita_newcol_menu ? menus[settings.lupita_newcol_menu] : navigation %}
{% set lu_nc_fuente = lu_nc_fuente ?: navigation %}
{% for item in navigation if item.name | lower not in ['envíos', 'envios'] %}
    {% if 'new collection' in item.name | lower %}
        <li class="item-with-subitems" data-component="menu.item">
            <div class="js-nav-list-toggle-accordion">
                <a class="js-toggle-page-accordion nav-list-link" href="#">
                    {{ item.name }}
                    <span class="nav-list-arrow transition-soft">
                        {% include "snipplets/svg/chevron-down.tpl" with {svg_custom_class: "icon-inline svg-icon-text"} %}
                    </span>
                </a>
            </div>
            <ul class="js-pages-accordion js-lu-grupos list-subitems nav-list-accordion" style="display:none;">
                {% if item.url %}
                    <li class="nav-item">
                        <a class="nav-list-link" href="{{ item.url | setting_url }}"><strong>{{ 'Ver todo en' | translate }} {{ item.name }}</strong></a>
                    </li>
                {% endif %}
                {% for lu_g in lu_nc_fuente if lu_g.name != item.name and lu_g.name | lower not in ['envíos', 'envios'] %}
                    {% if lu_g.isCategory and lu_g.category and lu_g.category.subcategories is not empty %}
                        <li class="js-lu-grupo nav-item lu-nc-grupo-movil">
                            <a class="js-lu-grupo-titulo nav-list-link lu-nc-titulo" href="{{ lu_g.category.url }}">{{ lu_g.name }}</a>
                                <ul class="js-lu-grupo-items lu-nc-items-movil list-unstyled">
                                    {% for lu_s in lu_g.category.subcategories %}
                                        <li class="nav-item"><a class="nav-list-link" href="{{ lu_s.url }}">{{ lu_s.name }}</a></li>
                                    {% endfor %}
                                </ul>
                        </li>
                    {% elseif lu_g.subitems %}
                        <li class="js-lu-grupo nav-item lu-nc-grupo-movil">
                            <a class="js-lu-grupo-titulo nav-list-link lu-nc-titulo" href="{% if lu_g.url %}{{ lu_g.url | setting_url }}{% else %}#{% endif %}">{{ lu_g.name }}</a>
                            <ul class="js-lu-grupo-items lu-nc-items-movil list-unstyled">
                                {% for lu_s in lu_g.subitems %}
                                    <li class="nav-item"><a class="nav-list-link" href="{% if lu_s.url %}{{ lu_s.url | setting_url }}{% else %}#{% endif %}">{{ lu_s.name }}</a></li>
                                {% endfor %}
                            </ul>
                        </li>
                    {% endif %}
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