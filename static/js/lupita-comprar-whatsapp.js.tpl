{# /*============================================================================
  #Comprar por WhatsApp
  Ahi! Lupita no vende online (aviso en la barra de arriba), pero el base
  sigue dejando avanzar el "Agregar al carrito" hasta el checkout real. Esto
  intercepta el submit del formulario de producto (ficha, compra rapida
  chica y el modal de quickshop, los tres comparten .js-product-form /
  .js-addtocart) y en vez de mandar al carrito abre WhatsApp con la prenda
  y la variante elegida, igual que ya hace snipplets/favoritos con "Reservar
  para probarmelas". No toca el carrito en si: si alguna vez vuelven a
  vender online, alcanza con sacar este script de layout.tpl. #}
<script type="text/javascript">
    (function () {
        var numero = {{ (store.whatsapp | trim('https://wa.me/')) | json_encode | raw }};
        if (!numero) return;

        function varianteElegida(form) {
            var partes = [];
            form.querySelectorAll('.js-product-variants-group').forEach(function (grupo) {
                var activo = grupo.querySelector('.js-insta-variant.selected .btn-variant-content');
                var select = grupo.querySelector('select.js-variation-option');
                var valor = activo ? activo.getAttribute('data-name') : (select && select.selectedIndex >= 0 ? select.options[select.selectedIndex].text : '');
                if (!valor) return;
                var rotulo = grupo.querySelector('.form-label');
                var nombre = rotulo ? rotulo.textContent.trim() : '';
                partes.push(nombre && !/^(color|cor)$/i.test(nombre) ? (nombre + ' ' + valor.trim()) : valor.trim());
            });
            return partes.join(' / ');
        }

        function alEnviar(e) {
            var form = e.target.closest('.js-product-form');
            if (!form) return;
            var boton = form.querySelector('.js-addtocart');
            if (!boton || boton.disabled) return;

            {# stopImmediatePropagation, no solo preventDefault: el submit real de
               Tiendanube (store.js) tambien escucha "submit" y agrega al carrito
               por AJAX aunque el navegador no llegue a enviar el form. #}
            e.preventDefault();
            e.stopImmediatePropagation();
            var nombreProducto = form.dataset.nombreProducto || document.title;
            var variante = varianteElegida(form);
            var mensaje = 'Hola! Quiero consultar por ' + nombreProducto + (variante ? ' (' + variante + ')' : '') + '.';
            window.open('https://wa.me/' + numero + '?text=' + encodeURIComponent(mensaje), '_blank');
        }

        document.addEventListener('submit', alEnviar, true);
    })();
</script>
