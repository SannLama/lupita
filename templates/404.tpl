{# La ayuda de Tiendanube ("Producto de ejemplo" mientras no hay productos
   cargados) se saco (2026-09-28): tapaba la pagina de error. #}
	{# Pagina no encontrada (Santiago, 2026-09-28): formato del "not found" de
	   21st.dev (nevsky118) con los colores de la marca. Un 404 enorme y tenue
	   en turquesa de fondo, el titulo en Pinyon, una frase, el buscador de la
	   tienda y dos salidas: volver atras o ir al inicio. #}
	<section class="lu-404">
		<div class="lu-404-escena">
			<span class="lu-404-fondo" aria-hidden="true">404</span>
			<div class="container lu-404-contenido">
				<h1 class="lu-404-titulo">{{ "Página no encontrada" | translate }}</h1>
				<p class="lu-404-texto">{{ "Esta página se perdió entre los percheros. Buscá lo que querías o volvé al inicio." | translate }}</p>
				<form class="lu-404-form" action="{{ store.search_url }}" method="get" role="search">
					<label class="lu-404-campo">
						{% include "snipplets/svg/search.tpl" with {svg_custom_class: "icon-inline lu-404-lupa"} %}
						<input type="search" name="q" autocomplete="off" placeholder="{{ 'Buscar prendas, marcas…' | translate }}" aria-label="{{ 'Buscador' | translate }}">
					</label>
					<button type="submit" class="lu-404-buscar-btn">{{ "Buscar" | translate }}</button>
				</form>
				<div class="lu-404-acciones">
					<button type="button" class="lu-404-volver" onclick="if (history.length > 1) { history.back(); } else { location.href = '{{ store.url }}'; }">
						<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M19 12H5"/><path d="m12 19-7-7 7-7"/></svg>
						{{ "Volver" | translate }}
					</button>
					<a href="{{ store.url }}" class="btn btn-primary lu-404-inicio">{{ "Ir al inicio" | translate }}</a>
				</div>
			</div>
		</div>
		{% set related_products = sections.primary.products | take(4) | shuffle %}
		{% if related_products | length > 1 %}
			<div class="container lu-404-sugeridos">
				<span class="lu-rotulo lu-micro">{{ "Quizás te interesen los siguientes productos." | translate }}</span>
			</div>
			<div class="container" style="padding:0">
				<div class="js-product-table row">
					{% for related in related_products %}
						{% include 'snipplets/grid/item.tpl' with {product : related} %}
					{% endfor %}
				</div>
			</div>
		{% endif %}
	</section>
