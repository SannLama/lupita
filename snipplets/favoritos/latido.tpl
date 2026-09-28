{# /*============================================================================
  #Favoritos: animacion al guardar (Santiago, 2026-09-28)
  Referencia: "Heart Favorite" de UI TripleD (21st.dev, React + framer-motion).
  Aca es CSS (lupita.scss.tpl, #Favoritos: latido) y este script chico:
  - Al guardar: el corazon se achica, salta con rebote y larga una ronda de
    ocho particulas y un anillo turquesa.
  - Al quitar: se achica un poco y vuelve.
  lupita-favoritos.js (minificado) maneja el guardado con un listener en
  captura sobre document y corta la propagacion; por eso este escucha en
  captura sobre window (corre antes) y lee el estado un instante despues.
==============================================================================*/#}
<script>
    (function () {
        var quieto = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        window.addEventListener('click', function (e) {
            var b = e.target.closest && e.target.closest('.js-fav');
            if (!b || quieto) return;
            setTimeout(function () {
                var guardado = b.getAttribute('aria-pressed') === 'true';
                b.classList.remove('lu-fav-latido', 'lu-fav-suelta');
                void b.offsetWidth;
                b.classList.add(guardado ? 'lu-fav-latido' : 'lu-fav-suelta');
                if (!guardado) return;
                var ronda = document.createElement('span');
                ronda.className = 'lu-fav-ronda';
                ronda.setAttribute('aria-hidden', 'true');
                for (var i = 0; i < 8; i++) {
                    var p = document.createElement('i');
                    p.style.setProperty('--a', (i * 45) + 'deg');
                    ronda.appendChild(p);
                }
                b.appendChild(ronda);
                setTimeout(function () { ronda.remove(); }, 800);
            }, 0);
        }, true);
    })();
</script>
