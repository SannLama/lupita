{# Only remove this if you want to take away the theme onboarding advices #}
{% set show_help = not has_products %}

{# Here we will add an example as a help, you can delete this after you upload your products #}

{% if show_help %}
	<div id="product-example">
		{% snipplet 'defaults/show_help_product.tpl' %}
	</div>
{% else %}
	{# La cifra es el cartel. El decrypt (lupita-motion) cambia el texto del
	   span; el lector de pantalla lee el aria-label del h1. #}
	<section class="lu-404" id="404">
		<div class="container">
			<span class="lu-rotulo lu-micro">{{ "Error" | translate }}</span>
			<h1 class="lu-404-cifra" aria-label="404"><span data-motion="decrypt" aria-hidden="true">404</span></h1>
			<p class="lu-404-texto">{{ "La página que estás buscando no existe." | translate }}</p>
			<div class="lu-404-buscar">
				{% include "snipplets/header/header-search.tpl" %}
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
{% endif %}
