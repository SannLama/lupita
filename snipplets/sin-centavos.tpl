{# /*============================================================================
  #Precios sin centavos (Santiago, 2026-09-29: "precios atractivos")
  Redondea al peso cualquier precio con centavos que aparezca en la pagina:
  "$77.689,60" -> "$77.690". Hace falta por JS y no por Twig porque varios
  precios los pinta Tiendanube despues de cargar (el de efectivo del
  componente payment-discount-price, los que cambian al elegir variante,
  el carrito), asi que un MutationObserver vuelve a pasar en cada cambio.

  Ademas mantiene la linea de 6 cuotas de la ficha (.js-lu-cuotas-valor):
  la recalcula del precio mostrado cuando cambia la variante.
==============================================================================*/#}
<script type="text/javascript">
    (function () {
        var CENTAVOS = /\$\s?(\d{1,3}(?:\.\d{3})*),(\d{2})(?!\d)/g;
        var SALTEAR = { SCRIPT: 1, STYLE: 1, TEXTAREA: 1, INPUT: 1, NOSCRIPT: 1 };

        function pesos(n) {
            return '$' + Math.round(n).toLocaleString('es-AR');
        }

        function redondear(txt) {
            return txt.replace(CENTAVOS, function (m, enteros, cent) {
                return pesos(parseFloat(enteros.replace(/\./g, '') + '.' + cent));
            });
        }

        function limpiar(raiz) {
            var w = document.createTreeWalker(raiz, NodeFilter.SHOW_TEXT, {
                acceptNode: function (n) {
                    var p = n.parentNode;
                    if (!p || SALTEAR[p.nodeName]) return NodeFilter.FILTER_REJECT;
                    return n.nodeValue.indexOf(',') > -1 && n.nodeValue.indexOf('$') > -1
                        ? NodeFilter.FILTER_ACCEPT : NodeFilter.FILTER_SKIP;
                }
            });
            var n, cambios = [];
            while ((n = w.nextNode())) cambios.push(n);
            cambios.forEach(function (t) {
                var nuevo = redondear(t.nodeValue);
                if (nuevo !== t.nodeValue) t.nodeValue = nuevo;
            });
        }

        function cuotas() {
            var precio = document.querySelector('#single-product #price_display');
            if (!precio) return;
            var num = parseFloat(precio.textContent.replace(/[^\d,]/g, '').replace(',', '.'));
            if (!num) return;
            var txt = pesos(num / 6);
            document.querySelectorAll('.js-lu-cuotas-valor').forEach(function (el) {
                if (el.textContent !== txt) el.textContent = txt;
            });
        }

        var pendiente = false;
        function pasar() {
            pendiente = false;
            limpiar(document.body);
            cuotas();
        }

        pasar();
        new MutationObserver(function () {
            if (pendiente) return;
            pendiente = true;
            // microtarea y no requestAnimationFrame: corre antes de pintar
            // (no se ven los centavos un instante) y tambien con la pestana oculta
            Promise.resolve().then(pasar);
        }).observe(document.body, { childList: true, subtree: true, characterData: true });
    })();
</script>
