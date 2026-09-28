{# /*============================================================================
  #Favoritos: animacion al guardar (Santiago, 2026-09-28)
  Referencia: "Heart Favorite" de UI TripleD (21st.dev, React + framer-motion).
  Aca es CSS (lupita.scss.tpl, #Favoritos: latido) y este script chico:
  - Al guardar: el corazon se achica, salta con rebote y larga una ronda de
    ocho particulas y un anillo turquesa.
  - Al quitar: se achica un poco y vuelve.
  Corazon del header (wishlist, "no tiene animacion el wishlist"): late al
  pasar el mouse (CSS); cuando se guarda algo en cualquier parte, salta,
  larga las particulas y el contador pega un saltito; al tocarlo, un latido.
  lupita-favoritos.js (minificado) maneja el guardado con un listener en
  captura sobre document y corta la propagacion; por eso este escucha en
  captura sobre window (corre antes) y lee el estado un instante despues.
==============================================================================*/#}
<script>
    (function () {
        var quieto = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        var ronda = function (el) {
            var r = document.createElement('span');
            r.className = 'lu-fav-ronda';
            r.setAttribute('aria-hidden', 'true');
            for (var i = 0; i < 8; i++) {
                var p = document.createElement('i');
                p.style.setProperty('--a', (i * 45) + 'deg');
                r.appendChild(p);
            }
            el.appendChild(r);
            setTimeout(function () { r.remove(); }, 800);
        };
        var repetir = function (el, clase) {
            el.classList.remove(clase);
            void el.offsetWidth;
            el.classList.add(clase);
        };

        {# Corazon del header: cuando sube el contador, salta con particulas #}
        var vigilar = function () {
            Array.prototype.forEach.call(document.querySelectorAll('.js-favs-cantidad'), function (c) {
                var link = c.closest('.lu-favs-link');
                if (!link) return;
                var antes = parseInt(c.textContent, 10) || 0;
                new MutationObserver(function () {
                    var ahora = parseInt(c.textContent, 10) || 0;
                    if (ahora > antes && !quieto) {
                        repetir(link, 'lu-favs-salto');
                        repetir(c, 'lu-favs-cuenta-salto');
                        ronda(link);
                    }
                    antes = ahora;
                }).observe(c, { childList: true, characterData: true, subtree: true });
                link.addEventListener('click', function () { if (!quieto) repetir(link, 'lu-favs-salto'); });
            });
        };
        if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', vigilar);
        else vigilar();
        window.addEventListener('click', function (e) {
            var b = e.target.closest && e.target.closest('.js-fav');
            if (!b || quieto) return;
            setTimeout(function () {
                var guardado = b.getAttribute('aria-pressed') === 'true';
                b.classList.remove('lu-fav-latido', 'lu-fav-suelta');
                void b.offsetWidth;
                b.classList.add(guardado ? 'lu-fav-latido' : 'lu-fav-suelta');
                if (!guardado) return;
                ronda(b);
            }, 0);
        }, true);
    })();
</script>
