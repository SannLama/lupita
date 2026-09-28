<div class="utilities-container">
	{# Lupa que se abre en una barra redondeada con el campo y la X (Santiago,
	   2026-09-28, con un componente React de referencia "expanding search
	   dock"; aca es el mismo comportamiento en CSS + JS chico, sin React).
	   Busca en la tienda (store.search_url, ?q=). El panel lateral de busqueda
	   del base (#nav-search) queda en header.tpl pero ya no se abre. #}
	<div class="utilities-item lu-lupa js-lu-lupa">
		<button type="button" class="utilities-link lu-lupa-abrir js-lu-lupa-abrir" aria-label="{{ 'Buscar' | translate }}" aria-expanded="false" aria-controls="lu-lupa-form">
			{% include "snipplets/svg/search.tpl" with {svg_custom_class: "icon-inline icon-w-16 svg-icon-text"} %}
		</button>
		<form id="lu-lupa-form" class="lu-lupa-form js-lu-lupa-form" action="{{ store.search_url }}" method="get" role="search">
			{% include "snipplets/svg/search.tpl" with {svg_custom_class: "icon-inline lu-lupa-icono"} %}
			<input class="lu-lupa-input js-lu-lupa-input" type="search" name="q" autocomplete="off" placeholder="{{ 'Buscar prendas, marcas…' | translate }}" aria-label="{{ 'Buscador' | translate }}" tabindex="-1"/>
			<button type="button" class="lu-lupa-cerrar js-lu-lupa-cerrar" aria-label="{{ 'Cerrar buscador' | translate }}" tabindex="-1">
				{% include "snipplets/svg/times.tpl" with {svg_custom_class: "icon-inline"} %}
			</button>
		</form>
		<script>
			(function () {
				var caja = document.querySelector('.js-lu-lupa');
				if (!caja) return;
				var abrirBtn = caja.querySelector('.js-lu-lupa-abrir');
				var form = caja.querySelector('.js-lu-lupa-form');
				var input = caja.querySelector('.js-lu-lupa-input');
				var cerrarBtn = caja.querySelector('.js-lu-lupa-cerrar');
				var abierta = function () { return caja.classList.contains('lu-lupa-abierta'); };
				var abrir = function () {
					caja.classList.add('lu-lupa-abierta');
					abrirBtn.setAttribute('aria-expanded', 'true');
					input.tabIndex = 0; cerrarBtn.tabIndex = 0;
					setTimeout(function () { input.focus(); }, 60);
				};
				var cerrar = function (devolverFoco) {
					if (!abierta()) return;
					caja.classList.remove('lu-lupa-abierta');
					abrirBtn.setAttribute('aria-expanded', 'false');
					input.value = '';
					input.tabIndex = -1; cerrarBtn.tabIndex = -1;
					if (devolverFoco) abrirBtn.focus();
				};
				abrirBtn.addEventListener('click', abrir);
				cerrarBtn.addEventListener('click', function () { cerrar(true); });
				form.addEventListener('submit', function (e) { if (!input.value.trim()) { e.preventDefault(); input.focus(); } });
				document.addEventListener('keydown', function (e) { if (e.key === 'Escape') cerrar(true); });
				document.addEventListener('click', function (e) { if (abierta() && !caja.contains(e.target) && !input.value.trim()) cerrar(false); });
			})();
		</script>
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