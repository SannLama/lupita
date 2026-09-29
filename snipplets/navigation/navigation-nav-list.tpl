{# Para "New collection" (ver navigation-desktop.tpl): las categorias del
   menu de primer nivel. En las subcategorias no hay "New collection", asi que
   la lista solo se usa en la primera vuelta. #}
{% set lu_nl_cats = navigation %}
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
            <ul class="js-pages-accordion js-lu-ordenar list-subitems nav-list-accordion" style="display:none;">
                {% if item.url %}
                    <li class="nav-item">
                        <a class="nav-list-link" href="{{ item.url | setting_url }}"><strong>{{ 'Ver todo en' | translate }} {{ item.name }}</strong></a>
                    </li>
                {% endif %}
                {% for lu_nc_sub in item.subitems %}
                    <li class="nav-item">
                        <a class="nav-list-link" href="{% if lu_nc_sub.url %}{{ lu_nc_sub.url | setting_url }}{% else %}#{% endif %}">{{ lu_nc_sub.name }}</a>
                    </li>
                {% endfor %}
                {% for lu_nc_rubro in lu_nl_cats if lu_nc_rubro.name != item.name %}
                    {% for lu_nc_sub in lu_nc_rubro.subitems %}
                        <li class="nav-item">
                            <a class="nav-list-link" href="{% if lu_nc_sub.url %}{{ lu_nc_sub.url | setting_url }}{% else %}#{% endif %}">{{ lu_nc_sub.name }}</a>
                        </li>
                    {% endfor %}
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