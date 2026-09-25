{# Detect presence of features that remove empty placeholders #}

{% set has_main_slider = settings.slider and settings.slider is not empty %}
{% set has_mobile_slider = settings.toggle_slider_mobile and settings.slider_mobile and settings.slider_mobile is not empty %}
{% set has_informative_banners = settings.banner_services and (settings.banner_services_01_title or settings.banner_services_02_title or settings.banner_services_03_title or settings.banner_services_04_title) %}
{% set has_category_banners =  settings.banner_01_show or settings.banner_02_show or settings.banner_03_show %}
{% set has_welcome_message = settings.welcome_message %}
{% set has_image_text_modules = settings.module_01_show or settings.module_02_show or settings.module_03_show %}
{% set has_video = settings.video_embed %}
{% set has_instafeed = store.instagram and settings.show_instafeed and store.hasInstagramToken() %}
{% set has_cover = settings.cover_show and (settings.cover_video_url or ('cover.jpg' | has_custom_image)) %}
{% set has_capsule = settings.capsule_show and settings.capsule_video_url %}

{% set show_help = not (has_main_slider or has_mobile_slider or has_category_banners or has_image_text_modules or has_video or has_instafeed or has_informative_banners or has_cover or has_capsule) and not has_products %}

{% set show_component_help = params.preview %}

{% if not params.preview %}
	{% set admin_link = is_theme_draft ? '/admin/themes/settings/draft/' : '/admin/themes/settings/active/' %}
{% endif %}

{#  **** Features Order ****  #}
{% set newArray = [] %}

<div class="js-home-sections-container">
	{# 0..13: la 10 es "Medios de pago" (2026-09-15); 11-13 Coleccion, New In
	   y Banner de promocion; 14-15 Mas vendidos y Riel de categorias; 16-18 Backstage, Shop the look y
	   Cinta de Instagram (2026-09-25) #}
	{% for i in 0..18 %}
		{% set section = 'home_order_position_' ~ i %}
		{% set section_select = attribute(settings, section) %}

		{% if section_select not in newArray %}
			{% include 'snipplets/home/home-section-switch.tpl' %}
			{% set newArray = newArray|merge([section_select]) %}
		{% endif %}

	{% endfor %}

	{# Una tienda que viene de otro theme guarda posiciones con nombres ajenos
	   ('institutional', 'new', 'sale'...) que ocupan el lugar de las nuestras:
	   lo que no entro en ninguna posicion sale igual, en el orden de defaults.
	   'welcome' no esta en esta lista: se renderiza pegada arriba de
	   'instafeed' (ver home-section-switch.tpl) porque 'instafeed' si tiene
	   posicion propia en esta tienda y 'welcome' nunca llegaba antes. #}
	{% for section_select in ['slider', 'collection', 'newin', 'rail', 'products', 'bestsellers', 'informatives', 'categories', 'promo', 'instafeed', 'video', 'cover', 'capsule', 'modules', 'payments', 'backstage', 'shoplook', 'igstrip'] %}
		{% if section_select not in newArray %}
			{% include 'snipplets/home/home-section-switch.tpl' %}
			{% set newArray = newArray|merge([section_select]) %}
		{% endif %}
	{% endfor %}

	{#  **** Hidden Sections ****  #}
	{% if show_component_help %}
		<div style="display:none">
			{% for section_select in ['slider', 'products', 'informatives', 'categories', 'welcome', 'video', 'instafeed', 'modules', 'cover', 'capsule', 'payments'] %}
				{% if section_select not in newArray %}
					{% include 'snipplets/home/home-section-switch.tpl' %}
				{% endif %}
			{% endfor %}
		</div>
	{% endif %}
</div>

{% if settings.home_promotional_popup %}
    {% include 'snipplets/home/home-popup.tpl' %}
{% endif %}
