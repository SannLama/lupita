<div class="utilities-container">
	<div class="utilities-item">
		<a href="#" class="js-modal-open js-toggle-search utilities-link" data-toggle="#nav-search" aria-label="{{ 'Buscador' | translate }}">
			{% include "snipplets/svg/search.tpl" with {svg_custom_class: "icon-inline icon-w-16 svg-icon-text"} %}
		</a>
	</div>
	{# Favoritos: hidden hasta que lupita-favoritos confirme que puede guardar #}
	<div class="utilities-item js-favs-acceso" hidden>
		<a href="#" class="js-modal-open utilities-link lu-favs-link" data-toggle="#modal-favoritos" aria-label="{{ 'Favoritos' | translate }}">
			{% include "snipplets/svg/heart.tpl" with {svg_custom_class: "icon-inline icon-w-16 svg-icon-text"} %}
			<span class="js-favs-cantidad lu-favs-cantidad">0</span>
		</a>
	</div>
	{# Carrito visible pero sin venta (Santiago, 2026-09-28: "que el carrito aparezca
	   pero que no deje comprar y que diga proximamente la venta online"). El icono
	   va directo a /comprar/, que muestra el aviso; no abre el panel lateral ni
	   lleva al checkout. Sin contador: no se puede agregar nada (el boton de la
	   ficha abre WhatsApp). Para volver a vender online: volver al bloque original
	   (git 7abb366) y sacar el aviso de templates/cart.tpl. #}
	{% if not store.is_catalog %}
	<div class="utilities-item">
		<div class="cart-summary">
		    <a href="{{ store.cart_url }}" class="utilities-link" aria-label="{{ 'Carrito: próximamente la venta online' | translate }}">
		    	{% include "snipplets/svg/shopping-bag.tpl" with {svg_custom_class: "icon-inline icon-w-14 svg-icon-text"} %}
		    </a>
		</div>
	</div>
	{% endif %}
</div>