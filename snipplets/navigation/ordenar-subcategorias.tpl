{# /*============================================================================
  #Desplegable de "New collection": columnas por categoria (Santiago, 2026-09-29)
  Twig no ordena objetos por nombre, asi que lo hace esto sobre .js-lu-grupos
  (menu de compu y de celular):
  - dos columnas con el mismo nombre (p. ej. dos "Partes De Arriba" cargadas
    por separado) se funden en una, la primera;
  - dentro de cada columna, subcategorias en orden alfabetico y sin repetidos;
  - las columnas quedan en el orden del menu.
==============================================================================*/#}
<script type="text/javascript">
    (function () {
        function texto(el) { return el ? el.textContent.replace(/\s+/g, ' ').trim() : ''; }
        function ordenar() {
            document.querySelectorAll('.js-lu-grupos').forEach(function (cont) {
                var grupos = {};
                Array.prototype.slice.call(cont.querySelectorAll(':scope > .js-lu-grupo')).forEach(function (g) {
                    var clave = texto(g.querySelector('.js-lu-grupo-titulo')).toLowerCase();
                    var destino = grupos[clave];
                    if (!destino) { grupos[clave] = g; return; }
                    var lista = destino.querySelector('.js-lu-grupo-items');
                    var otra = g.querySelector('.js-lu-grupo-items');
                    if (otra && !lista) { destino.appendChild(otra); }
                    else if (otra) { while (otra.firstChild) lista.appendChild(otra.firstChild); }
                    g.remove();
                });
                cont.querySelectorAll('.js-lu-grupo-items').forEach(function (ul) {
                    var vistos = {};
                    var items = Array.prototype.slice.call(ul.children).filter(function (li) {
                        var clave = texto(li).toLowerCase();
                        if (!clave || vistos[clave]) { li.remove(); return false; }
                        vistos[clave] = true;
                        return true;
                    });
                    items.sort(function (a, b) {
                        return texto(a).localeCompare(texto(b), 'es', { sensitivity: 'base' });
                    });
                    items.forEach(function (li) { ul.appendChild(li); });
                });
            });
        }
        if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', ordenar);
        else ordenar();
    })();
</script>
