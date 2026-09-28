{# /*============================================================================
  #Botones con hover interactivo (Santiago, 2026-09-28)
  Referencia: "Interactive Hover Button" de Magic UI (21st.dev, React +
  Tailwind). Aca es CSS (lupita.scss.tpl, #Botones con hover interactivo) y
  este script chico, sin React:
  - En reposo el boton lleva un puntito turquesa antes del texto.
  - Al pasar el mouse (o con foco de teclado) el puntito crece hasta llenar el
    boton, el texto se va hacia la derecha y entra el mismo texto con una
    flecha.
  El script arma esa estructura en los botones de TEXTO de la tienda
  (a.btn / button.btn sin iconos adentro). No toca los .btn-link (links
  subrayados), los chips de montos de la gift card ni los que ya tienen
  iconos. Los botones que se crean despues de cargar la pagina (por AJAX)
  quedan como estaban.

  Colores ("cuidado con los colores para que no queden invisibles"): el
  script mira el fondo del boton y el de lo que tiene atras.
  - Boton turquesa: el puntito va en chocolate (turquesa sobre turquesa no se ve).
  - Boton sobre un fondo turquesa (el pie): el relleno es chocolate y el texto
    que entra, crema (un relleno turquesa se perdia contra el fondo).

  "Conocé / Conocer las tiendas" (Santiago, 2026-09-28: "subrayá el conocé
  las tiendas", todos): si es un boton, deja de serlo y pasa a link
  subrayado. Toma el color del fondo del boton si lo tenia (un boton oscuro
  con letra crema sobre crema quedaria invisible como link) o el de su letra
  si era transparente.
==============================================================================*/#}
<script>
    (function () {
        var FLECHA = '<svg class="lu-ihb-flecha" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>';
        var TIENDAS = /conoc(e|é|er)\s+(las|nuestras)\s+tiendas/i;
        var rgb = function (c) {
            var m = (c || '').match(/rgba?\(([^)]+)\)/);
            if (!m) return null;
            var p = m[1].split(',').map(function (x) { return parseFloat(x); });
            return { r: p[0], g: p[1], b: p[2], a: p.length > 3 ? p[3] : 1 };
        };
        var parecidos = function (a, b) {
            return a && b && Math.abs(a.r - b.r) + Math.abs(a.g - b.g) + Math.abs(a.b - b.b) < 60;
        };
        var fondoDetras = function (el) {
            for (var p = el.parentElement; p; p = p.parentElement) {
                var c = rgb(getComputedStyle(p).backgroundColor);
                if (c && c.a > 0.5) return c;
            }
            return null;
        };
        var armar = function () {
            var acento = rgb('rgb(' + (function () {
                var t = document.createElement('span');
                t.style.color = 'var(--lu-acento)';
                document.body.appendChild(t);
                var v = getComputedStyle(t).color;
                t.remove();
                return (v.match(/\(([^)]+)\)/) || [0, '100,178,179'])[1];
            })() + ')');

            {# 1. "Conocé las tiendas": de boton a link subrayado #}
            Array.prototype.forEach.call(document.querySelectorAll('a.btn'), function (a) {
                if (!TIENDAS.test(a.textContent)) return;
                var cs = getComputedStyle(a);
                var fondo = rgb(cs.backgroundColor);
                var color = fondo && fondo.a > 0.5 ? cs.backgroundColor : cs.color;
                a.className = a.className.replace(/\bbtn(-[a-z]+)*\b/g, '').trim() + ' lu-link-tiendas';
                a.style.color = color;
            });

            {# 2. El resto de los botones de texto: estructura del hover #}
            Array.prototype.forEach.call(document.querySelectorAll('a.btn, button.btn'), function (b) {
                if (b.classList.contains('lu-ihb') || b.classList.contains('btn-link')) return;
                if (b.classList.contains('lu-gift-chip') || b.closest('.swiper-button-prev, .swiper-button-next')) return;
                if (b.children.length) return;
                var texto = b.textContent.replace(/\s+/g, ' ').trim();
                if (!texto) return;
                var propio = rgb(getComputedStyle(b).backgroundColor);
                if (propio && propio.a > 0.5 && parecidos(propio, acento)) b.classList.add('lu-ihb-turquesa');
                if (parecidos(fondoDetras(b), acento)) b.classList.add('lu-ihb-sobre-turquesa');
                b.classList.add('lu-ihb');
                b.textContent = '';
                var base = document.createElement('span');
                base.className = 'lu-ihb-base';
                var punto = document.createElement('span');
                punto.className = 'lu-ihb-punto';
                var t = document.createElement('span');
                t.className = 'lu-ihb-texto';
                t.textContent = texto;
                base.appendChild(punto);
                base.appendChild(t);
                var capa = document.createElement('span');
                capa.className = 'lu-ihb-capa';
                capa.setAttribute('aria-hidden', 'true');
                var t2 = document.createElement('span');
                t2.textContent = texto;
                capa.appendChild(t2);
                capa.insertAdjacentHTML('beforeend', FLECHA);
                b.appendChild(base);
                b.appendChild(capa);
            });
        };
        if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', armar);
        else armar();
    })();
</script>
