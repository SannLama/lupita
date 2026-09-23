{% for item in navigation %}
    {% if item.subitems %}
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