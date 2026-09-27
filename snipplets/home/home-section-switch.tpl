{% if section_select == 'slider' %}
	
	{#  **** Home slider ****  #}
	<section data-store="home-slider">
		{% if show_help or (show_component_help and not (has_main_slider or has_mobile_slider)) %}
			{% snipplet 'defaults/home/slider_help.tpl' %}
		{% elseif settings.lupita_hero_video %}
			{# Video de portada en lugar del carrusel (2026-09-25) #}
			{% include 'snipplets/home/home-hero-video.tpl' %}
		{% else %}
			{% include 'snipplets/home/home-slider.tpl' %}
			{% if has_mobile_slider %}
				{% include 'snipplets/home/home-slider.tpl' with {mobile: true} %}
			{% endif %}
		{% endif %}
	</section>

{% elseif section_select == 'products' %}

    {#  **** Featured products ****  #}
    {% if show_help or (show_component_help and not has_products) %}
		{% include 'snipplets/defaults/home/featured_products_help.tpl' %}
	{% else %}
		{% include 'snipplets/home/home-featured-products.tpl' %}
	{% endif %}

{% elseif section_select == 'informatives' %}

	{#  **** Informative banners ****  #}
	{% if show_help or (show_component_help and not has_informative_banners) %}
		{% snipplet 'defaults/home/informative_banners_help.tpl' %}
	{% else %}
		{% include 'snipplets/banner-services/banner-services.tpl' %}
	{% endif %}

{% elseif section_select == 'categories' %}

	{% include 'snipplets/home/home-sandwich.tpl' with {lu_sw_video: settings.lupita_sandwich_top_video, lu_sw_img: 'sandwich-arriba.jpg', lu_sw_title: settings.lupita_sandwich_top_title ?: 'Jeans', lu_sw_button: settings.lupita_sandwich_top_button ?: 'Ver jeans', lu_sw_url: settings.lupita_sandwich_top_url ?: '/denimwear-zem5c/'} %}

	{#  **** Categories banners ****  #}
	{% if show_help or (show_component_help and not has_category_banners) %}
		{% include 'snipplets/defaults/home/banners_help.tpl' with {
			banner_title: 'Categoría' | translate,
			banner_help_text: 'Podés destacar categorías de tu tienda desde' | translate,
			banner_help_section: 'Banners de categorías' | translate,
			data_store: 'home-banner-categories',
			banners_amount: 3} 
		%}
	{% else %}
		{% include 'snipplets/home/home-banners.tpl' with {'textoverimage': true} %}
	{% endif %}

	{% include 'snipplets/home/home-sandwich.tpl' with {lu_sw_video: settings.lupita_sandwich_bottom_video, lu_sw_img: 'sandwich-abajo.jpg', lu_sw_title: settings.lupita_sandwich_bottom_title ?: 'Accesorios y Complementos', lu_sw_button: settings.lupita_sandwich_bottom_button ?: 'Ver accesorios', lu_sw_url: settings.lupita_sandwich_bottom_url ?: '/accesorios-8acou/'} %}

{% elseif section_select == 'welcome' %}

	{#  **** Welcome message ****  #}
	{% if show_help or (show_component_help and not has_welcome_message) %}
		{% include 'snipplets/defaults/home/welcome_message_help.tpl' %}
	{% else %}
		{% include 'snipplets/home/home-welcome-message.tpl' %}
	{% endif %}

{% elseif section_select == 'video' %}

	{#  **** Video embed ****  #}
	{% if show_help or (show_component_help and not has_video) %}
		{% include 'snipplets/defaults/home/video_help.tpl' %}
	{% else %}
		{% include 'snipplets/home/home-video.tpl' %}
	{% endif %}

{% elseif section_select == 'instafeed' %}

	{# 'welcome' (Mensaje institucional) nunca tiene posicion propia en esta
	   tienda -- 'instafeed' si la tiene, heredada del theme Rio -- asi que
	   'welcome' siempre caia al final por el loop de respaldo de home.tpl,
	   sin importar el orden de ese array. Va pegada arriba de instafeed
	   (pedido de Santiago, 2026-09-23), mismo patron que campanas/capsula. #}
	{% if show_help or (show_component_help and not has_welcome_message) %}
		{% include 'snipplets/defaults/home/welcome_message_help.tpl' %}
	{% else %}
		{% include 'snipplets/home/home-welcome-message.tpl' %}
	{% endif %}

	{#  **** Instafeed ****  #}
	{% if show_help or (show_component_help and not has_instafeed) %}
		{% include 'snipplets/defaults/home/instafeed_help.tpl' %}
	{% else %}
		{% include 'snipplets/home/home-instafeed.tpl' %}
	{% endif %}

{% elseif section_select == 'modules' %}

	{#  **** Modules banners ****  #}
	{% if show_help or (show_component_help and not has_image_text_modules) %}
		{% include 'snipplets/defaults/home/banners_help.tpl' with {
			banner_title: 'Módulo de imagen y texto' | translate,
			banner_help_text: 'Podés mostrar tus últimas novedades desde' | translate,
			banner_help_section: 'Módulo de imagen y texto' | translate,
			data_store: 'home-image-text-module',
			banner_module: true,
			banners_amount: 1} 
		%}
	{% else %}
		{% include 'snipplets/home/home-modules.tpl' with {'textoverimage': false} %}
	{% endif %}

{% elseif section_select == 'cover' %}

	{#  **** Portada: una foto a pantalla completa, sin carrusel ****  #}
	{% if show_help or (show_component_help and not has_cover) %}
		{% include 'snipplets/defaults/home/cover_help.tpl' %}
	{% else %}
		{% include 'snipplets/home/home-cover.tpl' %}
	{% endif %}

{% elseif section_select == 'capsule' %}

	{#  **** Capsula: video en loop, sin sonido, de fondo ****  #}
	{% if show_help or (show_component_help and not has_capsule) %}
		{% include 'snipplets/defaults/home/capsule_help.tpl' %}
	{% else %}
		{% include 'snipplets/home/home-capsule.tpl' %}
	{% endif %}
	{# Galeria de campanas debajo de los videos: sale sola con sus imagenes #}
	{% include 'snipplets/home/home-campanas.tpl' %}

{% elseif section_select == 'payments' %}

	{#  **** Medios de pago de Lupita: textos desde "Medios de pago de Lupita" ****  #}
	{# Vidriera virtual arriba de las formas de pago (Santiago, 2026-09-27) #}
	{% include 'snipplets/vidriera-virtual.tpl' with {lu_vv_id: 'home'} %}
	{% include 'snipplets/medios-de-pago.tpl' with {tamano: 'grande'} %}

{% elseif section_select == 'collection' %}

	{#  **** Coleccion de temporada (2026-09-25) ****  #}
	{% include 'snipplets/home/home-coleccion.tpl' %}

{% elseif section_select == 'newin' %}

	{#  **** New In: productos de la seccion "Novedades" (2026-09-25) ****  #}
	{% include 'snipplets/home/home-newin.tpl' %}

{% elseif section_select == 'bestsellers' %}

	{#  **** Mas vendidos: productos de la seccion "Mas vendidos" (2026-09-25) ****  #}
	{% include 'snipplets/home/home-mas-vendidos.tpl' %}

{% elseif section_select == 'rail' %}

	{#  **** Riel de categorias (2026-09-25) ****  #}
	{% include 'snipplets/home/home-riel.tpl' %}

{% elseif section_select == 'backstage' %}

	{#  **** Backstage con la cinta de temporada (2026-09-25) ****  #}
	{% include 'snipplets/home/home-backstage.tpl' %}

{% elseif section_select == 'shoplook' %}

	{#  **** Shop the look (2026-09-25) ****  #}
	{% include 'snipplets/home/home-shoplook.tpl' %}

{% elseif section_select == 'igstrip' %}

	{#  **** Cinta de Instagram (2026-09-25) ****  #}
	{% include 'snipplets/home/home-ig-cinta.tpl' %}

{% elseif section_select == 'promo' %}

	{#  **** Banner de promocion: un solo mensaje de pago (2026-09-25) ****  #}
	{% include 'snipplets/home/home-promo.tpl' %}

{% endif %}