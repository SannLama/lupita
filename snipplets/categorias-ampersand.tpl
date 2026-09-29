{# /*============================================================================
  #Nombres de categorias con "&" (Santiago, 2026-09-29: "eso de cambiar las y
  por & hacelo con todas las categorias y secciones del header")
  El sistema del local carga las categorias como "Buzos . Hoodies" o
  "Remeras Y Remerones". Aca se muestran como "Buzos & Hoodies" en: menu de
  compu (todos los desplegables), menu de celular, migas, titulo de la pagina
  de categoria y fila de secciones. No toca nombres de producto ni textos.
  "Sa.Le" -> "SA!LE". El desplegable de New collection ademas lo ordena
  ordenar-subcategorias.tpl.
==============================================================================*/#}
<script type="text/javascript">
    (function () {
        var ZONAS = '.lu-nav-desk, .nav-primary .nav-list, .breadcrumbs, .category-header .page-header h1, .lu-secciones';
        var SALTEAR = { SCRIPT: 1, STYLE: 1, SVG: 1 };
        function arreglar(t) {
            var limpio = t.trim();
            if (/^sa\s*\.\s*le$/i.test(limpio)) return t.replace(limpio, 'SA!LE');
            return t.replace(/\s*\.\s*(?=\S)/g, function (m, i, s) {
                    // solo puntos entre palabras ("Buzos . Hoodies"), no "Sa.Le" suelto
                    return /\s/.test(m) ? ' & ' : m;
                })
                .replace(/\s+[Yy]\s+/g, ' & ')
                .replace(/\s*\.\s*$/, function (m) { return /\S/.test(t.slice(0, -m.length)) ? '' : m; });
        }
        function pasar() {
            document.querySelectorAll(ZONAS).forEach(function (zona) {
                var w = document.createTreeWalker(zona, NodeFilter.SHOW_TEXT, {
                    acceptNode: function (n) {
                        var p = n.parentNode;
                        if (!p || SALTEAR[p.nodeName.toUpperCase()]) return NodeFilter.FILTER_REJECT;
                        return /(\s[Yy]\s)|(\s\.\s?)|(\S\s\.)|(sa\s*\.\s*le)/i.test(n.nodeValue) ? NodeFilter.FILTER_ACCEPT : NodeFilter.FILTER_SKIP;
                    }
                });
                var n, lista = [];
                while ((n = w.nextNode())) lista.push(n);
                lista.forEach(function (t) {
                    var nuevo = arreglar(t.nodeValue);
                    if (nuevo !== t.nodeValue) t.nodeValue = nuevo;
                });
            });
        }
        if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', pasar);
        else pasar();
    })();
</script>
