<section class="section-home-modules" data-store="home-image-text-module">
    <div class="container{% if settings.modules_full %}-fluid p-0{% endif %}">

        {% set section_first = settings.home_order_position_0 == 'modules' %}

        {% set num_modules = 0 %}
        {% for module in ['module_01', 'module_02'] %}
            {% set module_show = attribute(settings,"#{module}_show") %}
            {% set module_title = attribute(settings,"#{module}_title") %}
            {% set module_button_text = attribute(settings,"#{module}_button") %}
            {% set has_module =  module_show and (module_title or module_description or "#{module}.jpg" | has_custom_image) %}
            {% if has_module %}
                {% set num_modules = num_modules + 1 %}
            {% endif %}
        {% endfor %}

        {% set priority_assigned = false %}

        {% for module in ['module_01', 'module_02'] %}
            {% set module_show = attribute(settings,"#{module}_show") %}
            {% set module_image = "#{module}.jpg" | has_custom_image %}
            {% set module_align = attribute(settings,"#{module}_align") %}
            {% set module_title = attribute(settings,"#{module}_title") %}
            {% set module_description = attribute(settings,"#{module}_description") %}
            {% set module_button_text = attribute(settings,"#{module}_button") %}
            {% set module_url = attribute(settings,"#{module}_url") %}
            {% set has_module =  module_show and (module_title or module_description or "#{module}.jpg" | has_custom_image) %}
            {% set has_module_text =  module_title or module_description or module_button_text %}

            {# Assign priority to the first banner (no matter banner order) #}

            {% set has_priority = has_module and module_image and not priority_assigned %}
            {% if has_priority %}
                {% set priority_assigned = true %}
            {% endif %}

            {% set apply_lazy_load = 
                not section_first 
                or not has_priority
            %}

            {% if apply_lazy_load %}
                {% set module_src = 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==' %}
            {% else %}
                {% set module_src = "#{module}.jpg" | static_url | settings_image_url('large') %}
            {% endif %}

            {% if has_module %}
                {# 2026-09-15 (Santiago): el bloque ya no es un link entero; solo
                   el boton lleva a module_url. Asi el texto se puede leer y
                   seleccionar sin salir de la pagina. #}
                {# align-items-center (Bootstrap, !important) le ganaba a
                   nuestro align-items:stretch de abajo, que existe justo para
                   que las dos columnas midan lo mismo: con center, la columna
                   mas corta (el texto) dejaba ver el fondo de linea como un
                   bloque gris arriba y abajo suyo. #}
                <div class="row {% if settings.modules_full %}no-gutters{% endif %}">               
                    
                    <div class="col-md {% if module_align == 'right' %}order-md-2{% endif %}">
                        <div class="textbanner">
                            <div class="textbanner-image{% if has_banner_text and textoverimage %} overlay{% endif %}">
                                <img 
                                    {% if not apply_lazy_load %}fetchpriority="high"{% endif %}
                                    {% if apply_lazy_load %}data-{% endif %}src="{{ module_src }}"
                                    {% if apply_lazy_load %}data-{% endif %}srcset='{{ "#{module}.jpg" | static_url | settings_image_url('large') }} 480w, {{ "#{module}.jpg" | static_url | settings_image_url('huge') }} 640w'
                                    {% if apply_lazy_load %}
                                    data-sizes="auto" 
                                    data-expand="-10"
                                    {% endif %}
                                    class="textbanner-image-background {% if apply_lazy_load %}lazyautosizes lazyload fade-in{% endif %}" 
                                    {% if module_title %}alt="{{ module_title }}"{% else %}alt="{{ 'Módulo de' | translate }} {{ store.name }}"{% endif %} 
                                />
                            </div>
                        </div>
                    </div>
                    <div class="col-md lu-mod-col-texto">
                        <div class="textbanner-text{% if textoverimage %} over-image{% endif %}">
                            {% if module_title %}
                                {# Primera palabra en mayuscula SemiBold, el resto en italica corrida
                                   a la derecha (Santiago, 2026-09-24, con un diseno). #}
                                {% set lu_titulo = module_title | trim | split(' ', 2) %}
                                <div class="h1 textbanner-title">{% set lu_t1 = lu_titulo[0] | split('á') %}<span class="lu-mod-t1">{% if lu_t1 | length == 2 %}{{ lu_t1[0] }}<span class="lu-mod-bang">a</span>{{ lu_t1[1] }}{% else %}{{ lu_titulo[0] }}{% endif %}</span>{% if lu_titulo[1] is defined %} <span class="lu-mod-t2">{{ lu_titulo[1] }}</span>{% endif %}</div>
                            {% endif %}
                            {% if module_description %}
                                <div class="textbanner-paragraph">{{ module_description }}</div>
                            {% endif %}
                            {% if module_url and module_button_text %}
                                {% set module_link = module_url | setting_url %}
                                <a href="{{ module_link }}" class="btn btn-primary btn-small"{% if 'http' in module_link and store.url not in module_link %} target="_blank" rel="noopener"{% endif %}>{{ module_button_text }}</a>
                            {% endif %}
                        </div>
                    </div>
                </div>
            {% endif %}
        {% endfor %}
    </div>
</section>