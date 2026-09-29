{# /*============================================================================
  #Desplegable de "New collection": columnas por categoria (Santiago, 2026-09-29)
  Twig no ordena objetos por nombre, asi que lo hace esto sobre .js-lu-grupos
  (menu de compu y de celular):
  - dos columnas con el mismo nombre (p. ej. dos "Partes De Arriba" cargadas
    por separado) se funden en una, la primera;
  - los nombres se muestran prolijos: el sistema del local separa con puntos
    ("Remeras . Remerones", "Skorts .Short Pollera.") y aca pasan a "y";
  - sin repetidos aunque esten escritos distinto: "Buzos . Hoodies" y "Buzos
    Y Hoodies", o "Panuelso . Pareos" (typo del panel) y "Panuelos Y Pareos",
    comparan por las 4 primeras letras de cada palabra;
  - dentro de cada columna, orden alfabetico; las columnas, en el orden del menu.
==============================================================================*/#}
<script type="text/javascript">
    (function () {
        function texto(el) { return el ? el.textContent.replace(/\s+/g, ' ').trim() : ''; }
        function prolijo(t) {
            // "Sa.Le" es la marca del sale: se escribe SA!LE (Santiago, 2026-09-29)
            if (/^sa\s*\.\s*le$/i.test(t.trim())) return 'SA!LE';
            if (/^\S{1,3}\.\S{1,3}$/.test(t.trim())) return t.trim();
            return t.replace(/\s*\.\s*$/, '')
                .replace(/\s*\.\s*/g, ' y ')
                .replace(/\s+Y\s+/g, ' y ')
                .replace(/\s+/g, ' ')
                .trim();
        }
        function clave(t) {
            return prolijo(t).toLowerCase().split(' ')
                .filter(function (p) { return p && p !== 'y'; })
                .map(function (p) { return p.slice(0, 4); })
                .join(' ');
        }
        function ordenar() {
            document.querySelectorAll('.js-lu-grupos').forEach(function (cont) {
                var grupos = {};
                Array.prototype.slice.call(cont.querySelectorAll(':scope > .js-lu-grupo')).forEach(function (g) {
                    var k = texto(g.querySelector('.js-lu-grupo-titulo')).toLowerCase();
                    var destino = grupos[k];
                    if (!destino) { grupos[k] = g; return; }
                    var lista = destino.querySelector('.js-lu-grupo-items');
                    var otra = g.querySelector('.js-lu-grupo-items');
                    if (otra && !lista) { destino.appendChild(otra); }
                    else if (otra) { while (otra.firstChild) lista.appendChild(otra.firstChild); }
                    g.remove();
                });
                // Night out y Vestidos: solo "Ver todo" (Santiago, 2026-09-29)
                Array.prototype.slice.call(cont.querySelectorAll(':scope > .js-lu-grupo')).forEach(function (g) {
                    var tit = g.querySelector('.js-lu-grupo-titulo');
                    var ul = g.querySelector('.js-lu-grupo-items');
                    if (!tit || !ul || !/night out|vestidos/i.test(texto(tit))) return;
                    // "Vestidos, catsuits y sets" -> "Vestidos" (Santiago, 2026-09-29)
                    if (/vestidos/i.test(texto(tit))) tit.textContent = 'Vestidos';
                    var li = ul.firstElementChild ? ul.firstElementChild.cloneNode(true) : document.createElement('li');
                    var a = li.querySelector('a') || li.appendChild(document.createElement('a'));
                    a.href = tit.getAttribute('href');
                    a.textContent = 'Ver todo';
                    a.classList.add('lu-nc-ver-todo');
                    ul.textContent = '';
                    ul.appendChild(li);
                    ul.setAttribute('data-lu-fijo', '1');
                });
                cont.querySelectorAll('.js-lu-grupo-items:not([data-lu-fijo])').forEach(function (ul) {
                    var vistos = {};
                    // entre repetidos gana la carga escrita con "Y" (sin typos)
                    var items = Array.prototype.slice.call(ul.children).sort(function (a, b) {
                        return (/ Y /.test(texto(a)) ? 0 : 1) - (/ Y /.test(texto(b)) ? 0 : 1);
                    }).filter(function (li) {
                        var a = li.querySelector('a') || li;
                        var k = clave(texto(a));
                        if (!k || vistos[k]) { li.remove(); return false; }
                        vistos[k] = true;
                        a.textContent = prolijo(texto(a));
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
