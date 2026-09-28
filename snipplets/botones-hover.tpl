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
  script elige, entre turquesa, chocolate y crema, el color del puntito (que
  despues es el relleno) que mejor contrasta a la vez con el boton y con lo
  que tiene atras; prefiere el turquesa si se distingue lo suficiente. El
  texto con flecha que entra va en chocolate o crema, el que mas contraste
  con ese relleno. Ej.: boton chocolate sobre el pie turquesa -> relleno
  crema y texto chocolate (antes quedaba chocolate sobre chocolate).

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
        var fondoDetras = function (el) {
            for (var p = el.parentElement; p; p = p.parentElement) {
                var c = rgb(getComputedStyle(p).backgroundColor);
                if (c && c.a > 0.5) return c;
            }
            return null;
        };
        var lum = function (c) {
            var f = function (v) { v /= 255; return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4); };
            return 0.2126 * f(c.r) + 0.7152 * f(c.g) + 0.0722 * f(c.b);
        };
        var contraste = function (a, b) {
            var x = lum(a), y = lum(b);
            return (Math.max(x, y) + 0.05) / (Math.min(x, y) + 0.05);
        };
        var variable = function (nombre, porDefecto) {
            var t = document.createElement('span');
            t.style.color = 'var(' + nombre + ', ' + porDefecto + ')';
            document.body.appendChild(t);
            var c = rgb(getComputedStyle(t).color);
            t.remove();
            return c;
        };
        var css = function (c) { return 'rgb(' + c.r + ',' + c.g + ',' + c.b + ')'; };
        var armar = function () {
            var acento = variable('--lu-acento', '#64b2b3');
            var tinta = variable('--lu-tinta', '#2e1d21');
            var papel = variable('--lu-papel', '#f5efe4');

            {# 0. Boton 3D del canal: cada letra en su span para la ola del hover
               (Array.from respeta las tildes). Los .lu-3d tienen hijos, asi que
               el paso 2 no los toca. #}
            Array.prototype.forEach.call(document.querySelectorAll('.js-lu-3d-texto'), function (t) {
                var frase = t.textContent.trim();
                t.setAttribute('aria-label', frase);
                t.textContent = '';
                Array.from(frase).forEach(function (l, i) {
                    var s = document.createElement('span');
                    s.className = 'lu-3d-letra';
                    s.setAttribute('aria-hidden', 'true');
                    s.style.setProperty('--i', i);
                    s.textContent = l === ' ' ? '\u00a0' : l;
                    t.appendChild(s);
                });
            });

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
                var atras = fondoDetras(b) || papel;
                var boton = propio && propio.a > 0.5 ? propio : atras;
                var nota = function (c) { return Math.min(contraste(c, boton), contraste(c, atras)); };
                var relleno = nota(acento) >= 1.8 ? acento : (nota(tinta) >= nota(papel) ? tinta : papel);
                var letra = contraste(tinta, relleno) >= contraste(papel, relleno) ? tinta : papel;
                b.style.setProperty('--lu-ihb-relleno', css(relleno));
                b.style.setProperty('--lu-ihb-letra', css(letra));
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
