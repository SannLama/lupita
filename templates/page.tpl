{# "Sobre nosotros" tiene su propio diseño (snipplets/sobre-nosotros.tpl), con
   los textos y fotos de "Personalizar diseño > Sobre nosotros". Se reconoce
   por el handle o por el nombre, por si la clienta la nombra con mayusculas.
   Lo que escriba en el contenido de la pagina va debajo. #}
{% set lu_es_sobre_nosotros = settings.lupita_about_show and (page.handle == 'sobre-nosotros' or page.name|lower == 'sobre nosotros') %}
{# "Preguntas frecuentes" igual: snipplets/preguntas-frecuentes.tpl, que ya
   pone el contenido de la pagina adentro, antes del boton de arrepentimiento. #}
{% set lu_es_faq = settings.lupita_faq_show and (page.handle in ['preguntas-frecuentes', 'faq'] or page.name|lower in ['preguntas frecuentes', 'faq']) %}

{# "Medios de pago" y "Cómo comprar" (2026-09-15): los links del pie llevan a
   paginas con estos nombres, que muestran el bloque de pagos del panel y los
   pasos de compra. #}
{% set lu_es_pagos = page.handle == 'medios-de-pago' or page.name|lower == 'medios de pago' %}
{% set lu_es_comprar = page.handle == 'como-comprar' or page.name|lower in ['cómo comprar', 'como comprar'] %}

{% if lu_es_faq %}

	{% include 'snipplets/preguntas-frecuentes.tpl' %}

{% elseif lu_es_pagos or lu_es_comprar %}

	{% include 'snipplets/pagina-lupita.tpl' with {lu_tipo: lu_es_pagos ? 'pagos' : 'comprar'} %}

{% elseif lu_es_sobre_nosotros %}

	{% include 'snipplets/sobre-nosotros.tpl' %}

	{% if page.content %}
		<section class="user-content">
			<div class="container">
				<div class="row justify-content-md-center">
					<div class="col-md-8">
						{{ page.content }}
					</div>
				</div>
			</div>
		</section>
	{% endif %}

{% else %}

	{% embed "snipplets/page-header.tpl" with {'breadcrumbs': true} %}
		{% block page_header_text %}{{ page.name }}{% endblock page_header_text %}
	{% endembed %}

	{# Institutional page  #}

	<section class="user-content">
		<div class="container">
			<div class="row justify-content-md-center">
				<div class="col-md-8">
					{{ page.content }}
				</div>
			</div>
		</div>
	</section>

{% endif %}
