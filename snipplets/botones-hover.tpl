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
==============================================================================*/#}
<script>
    (function () {
        var FLECHA = '<svg class="lu-ihb-flecha" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>';
        var armar = function () {
            var botones = document.querySelectorAll('a.btn, button.btn');
            Array.prototype.forEach.call(botones, function (b) {
                if (b.classList.contains('lu-ihb') || b.classList.contains('btn-link')) return;
                if (b.classList.contains('lu-gift-chip') || b.closest('.swiper-button-prev, .swiper-button-next')) return;
                if (b.children.length) return;
                var texto = b.textContent.replace(/\s+/g, ' ').trim();
                if (!texto) return;
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
