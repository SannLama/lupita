{# /*============================================================================
  #New In (2026-09-25)
  Del PDF "Paginas Web implementar" (lam. 13: Naima): carrusel con lo ultimo
  que entro. Los productos se eligen en Tiendanube como los Destacados, pero
  en la seccion "Novedades" (config/sections.txt). Sin productos cargados en
  esa seccion, no sale nada.

  Mismo item de grilla (snipplets/grid/item.tpl) que el resto de la tienda;
  el slider lo arma static/js/store.js.tpl (.js-swiper-newin).
==============================================================================*/#}

{% if sections.new.products and not settings.lupita_newin_ocultar %}
	<section class="section-featured-home lu-newin" data-store="home-products-new">
		<div class="container">
			<div class="row">
				<div class="col-12 lu-newin-cabecera">
					<h3 class="lu-newin-titulo">{{ settings.lupita_newin_titulo ?: 'New In' }}</h3>
					{% if settings.lupita_newin_url %}
						<a href="{{ settings.lupita_newin_url | setting_url }}" class="lu-newin-todo">{{ settings.lupita_newin_boton ?: 'Ver todo' }}</a>
					{% endif %}
				</div>
				<div class="col-12">
					<div class="js-swiper-newin swiper-container">
						<div class="swiper-wrapper">
							{% for product in sections.new.products %}
								{% include 'snipplets/grid/item.tpl' with {'slide_item': true, 'section_name': 'new'} %}
							{% endfor %}
						</div>
						<div class="js-swiper-newin-pagination swiper-pagination"></div>
						<div class="js-swiper-newin-prev swiper-button-prev d-none d-md-block">{% include "snipplets/svg/chevron-left.tpl" with {svg_custom_class: "icon-inline icon-w-8 icon-2x svg-icon-text"} %}</div>
						<div class="js-swiper-newin-next swiper-button-next d-none d-md-block">{% include "snipplets/svg/chevron-right.tpl" with {svg_custom_class: "icon-inline icon-w-8 icon-2x svg-icon-text"} %}</div>
					</div>
				</div>
			</div>
		</div>
	</section>
{% endif %}
