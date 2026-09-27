{% if payments %}
	{# Sin Cabal ni Naranja X (Santiago, 2026-09-27): la tienda no las toma #}
	{% for payment in settings.payments if 'cabal' not in payment and 'naranja' not in payment %}
		<img src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ payment | payment_new_logo }}" class="icon-logo lazyload" alt="{{ payment }}" width="50" height="35">
    {% endfor %}
{% elseif shipping %}
	{% for shipping in settings.shipping %}
		<img src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ shipping | shipping_logo }}" class="icon-logo lazyload" alt="{{ shipping }}" width="50" height="35">
    {% endfor %}
{% endif %}