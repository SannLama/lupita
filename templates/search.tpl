{% paginate by 12 %}

{# Encabezado propio (no page-header.tpl): el rotulo va arriba del termino.
   query no esta confirmado en esta plantilla: sin el, vuelve al titulo del base. #}
<section class="page-header mt-3 lu-busqueda-header" data-store="page-title">
	<div class="container">
		<div class="row">
			<div class="col">
				<span class="lu-rotulo lu-micro">{{ "Búsqueda" | translate }}</span>
				<h1>
					{% if query %}
						<span class="lu-busqueda-termino{% if not products %} lu-tachado{% endif %}">“{{ query }}”</span>
					{% else %}
						{{ "Resultados de búsqueda" | translate }}
					{% endif %}
				</h1>
			</div>
		</div>
	</div>
</section>

<section class="category-body">
	<div class="container">
		{% if products %}
			<div class="js-product-table row" data-motion="stagger">
				{% include 'snipplets/product_grid.tpl' %}
			</div>
			{% include 'snipplets/grid/pagination.tpl' with { infinite_scroll: true } %}
		{% else %}
			<p class="lu-busqueda-vacia">{{ "No hubo resultados para tu búsqueda" | translate }}</p>
			{% if categories %}
				<span class="lu-rotulo lu-micro lu-busqueda-seguir">{{ "Seguí mirando" | translate }}</span>
				{% include 'snipplets/grid/categories.tpl' with { horizontal: true, filter_categories: categories } %}
			{% endif %}
		{% endif %}
	</div>
</section>
