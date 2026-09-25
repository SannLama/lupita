{# /*============================================================================
  #Mas vendidos (2026-09-25)
  Del PDF "Paginas Web implementar" (lam. 11: Naima): carrusel de los mas
  vendidos. Tiendanube no le pasa al theme cuanto se vendio: los productos se
  eligen a mano, como los Destacados, en la seccion "Mas vendidos"
  (config/sections.txt, clave sale). Sin productos ahi, no sale nada.

  Mismo item de grilla (snipplets/grid/item.tpl) que el resto de la tienda;
  el slider lo arma static/js/store.js.tpl (.js-swiper-mas).
==============================================================================*/#}

{% if sections.sale.products and not settings.lupita_mas_ocultar %}
	<section class="section-featured-home lu-newin lu-mas" data-store="home-products-bestsellers">
		<div class="container">
			<div class="row">
				<div class="col-12 lu-newin-cabecera">
					<h3 class="lu-newin-titulo">{{ settings.lupita_mas_titulo ?: 'Más vendidos' }}</h3>
					{% if settings.lupita_mas_url %}
						<a href="{{ settings.lupita_mas_url | setting_url }}" class="lu-newin-todo">{{ settings.lupita_mas_boton ?: 'Ver todo' }}</a>
					{% endif %}
				</div>
				<div class="col-12">
					<div class="js-swiper-mas swiper-container">
						<div class="swiper-wrapper">
							{% for product in sections.sale.products %}
								{% include 'snipplets/grid/item.tpl' with {'slide_item': true, 'section_name': 'sale'} %}
							{% endfor %}
						</div>
						<div class="js-swiper-mas-pagination swiper-pagination"></div>
						<div class="js-swiper-mas-prev swiper-button-prev d-none d-md-block">{% include "snipplets/svg/chevron-left.tpl" with {svg_custom_class: "icon-inline icon-w-8 icon-2x svg-icon-text"} %}</div>
						<div class="js-swiper-mas-next swiper-button-next d-none d-md-block">{% include "snipplets/svg/chevron-right.tpl" with {svg_custom_class: "icon-inline icon-w-8 icon-2x svg-icon-text"} %}</div>
					</div>
				</div>
			</div>
		</div>
	</section>
{% endif %}
