{# /*============================================================================
  #Subcategorias de "New collection" en orden alfabetico y sin repetidos
  (Santiago, 2026-09-29). Twig no ordena objetos del menu por nombre, asi que
  lo hace esto sobre las listas marcadas .js-lu-ordenar (menu de compu y de
  celular). "Ver todo" queda primero. Si dos rubros traen una subcategoria
  con el mismo nombre (p. ej. "Partes de arriba"), queda la primera.
==============================================================================*/#}
<script type="text/javascript">
    (function () {
        function ordenar() {
            document.querySelectorAll('.js-lu-ordenar').forEach(function (ul) {
                var items = Array.prototype.slice.call(ul.children);
                var primero = items[0] && items[0].querySelector('.lu-nav-desk-todo, strong') ? items.shift() : null;
                var vistos = {};
                items = items.filter(function (li) {
                    var clave = li.textContent.trim().toLowerCase();
                    if (!clave || vistos[clave]) { li.remove(); return false; }
                    vistos[clave] = true;
                    return true;
                });
                items.sort(function (a, b) {
                    return a.textContent.trim().localeCompare(b.textContent.trim(), 'es', { sensitivity: 'base' });
                });
                items.forEach(function (li) { ul.appendChild(li); });
                if (primero) ul.insertBefore(primero, ul.firstChild);
            });
        }
        if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', ordenar);
        else ordenar();
    })();
</script>
