{# "Sobre nosotros" tiene su propio diseño (snipplets/sobre-nosotros.tpl), con
   los textos y fotos de "Personalizar diseño > Sobre nosotros". Se reconoce
   por el handle o por el nombre, por si la clienta la nombra con mayusculas.
   Lo que escriba en el contenido de la pagina va debajo. #}
{% set lu_es_sobre_nosotros = settings.lupita_about_show and (page.handle == 'sobre-nosotros' or page.name|lower == 'sobre nosotros') %}
{# "Preguntas frecuentes" igual: snipplets/preguntas-frecuentes.tpl, que ya
   pone el contenido de la pagina adentro, antes del boton de arrepentimiento. #}
{# La pagina real de la clienta se llama "FA!Q - Preguntas Frecuentes" (handle
   faq-preguntas-frecuentes): alcanza con que el handle contenga una de las dos. #}
{% set lu_es_faq = settings.lupita_faq_show and ('preguntas-frecuentes' in page.handle or 'faq' in page.handle) %}

{# "Medios de pago" y "Cómo comprar" (2026-09-15): los links del pie llevan a
   paginas con estos nombres, que muestran el bloque de pagos del panel y los
   pasos de compra. #}
{% set lu_es_pagos = page.handle == 'medios-de-pago' or page.name|lower == 'medios de pago' %}
{% set lu_es_comprar = page.handle == 'como-comprar' or page.name|lower in ['cómo comprar', 'como comprar'] %}
{# "Gift Card" (2026-09-25): tarjeta 2D con el monto a eleccion, snipplets/gift-card.tpl #}
{# "Locales" / "Tiendas" (2026-09-25): las tres tiendas con fotos y Maps, snipplets/pagina-tiendas.tpl #}
{% set lu_es_tiendas = page.handle in ['locales', 'tiendas', 'nuestras-tiendas'] %}
{% set lu_es_gift = 'gift-card' in page.handle or 'giftcard' in page.handle or ('gift' in page.name|lower and 'card' in page.name|lower) %}

{% if lu_es_tiendas %}

	{% include 'snipplets/pagina-tiendas.tpl' %}

{% elseif lu_es_gift %}

	{% include 'snipplets/gift-card.tpl' %}

{% elseif lu_es_faq %}

	{% include 'snipplets/preguntas-frecuentes.tpl' %}

{% elseif lu_es_pagos or lu_es_comprar %}

	{% include 'snipplets/pagina-lupita.tpl' with {lu_tipo: lu_es_pagos ? 'pagos' : 'comprar'} %}

{% elseif lu_es_sobre_nosotros %}

	{% include 'snipplets/sobre-nosotros.tpl' %}

	{# 2026-09-23: el contenido de la pagina era solo el collage viejo; se
	   borro y el panel exige algo de texto, asi que aca no se muestra. #}
	{% if false %}
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

	{# Envios (Santiago, 2026-09-25): todavia no hay envios; el texto viejo del
	   contenido de la pagina (compras con envio, plazos, costos, sucursal) no
	   se muestra y en su lugar va el aviso de proximamente. #}
	{% if page.handle == 'envios' %}
		{% include 'snipplets/vidriera-virtual.tpl' with {lu_vv_id: 'envios'} %}
		<section class="lu-envios" data-store="page-envios">
			<div class="container">
				<div class="lu-envios-caja">
					<h2 class="lu-envios-titulo">{{ 'Próximamente envíos a todo el país' | translate }}</h2>
					<p class="lu-envios-paso"><span class="lu-envios-numero" aria-hidden="true">1</span><span>{{ 'Agregá tus favoritos a la wishlist y vení a nuestras tiendas a probarte y asesorarte.' | translate }}</span></p>
					<a class="lu-envios-link" href="{{ store.url }}/locales/">{{ 'Conocé nuestras tiendas' | translate }} &rarr;</a>
				</div>
			</div>
		</section>
	{% else %}
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

{% endif %}
