{# /*============================================================================
  #Volver arriba
  Aparece cuando se bajo mas de una pantalla. Nace hidden: sin JS no hay
  boton que no funcione. Desplazamiento suave salvo con movimiento reducido.
==============================================================================*/#}

<button type="button" class="js-volver-arriba lu-arriba" aria-label="{{ 'Volver arriba' | translate }}" hidden>
    <svg aria-hidden="true" viewBox="0 0 448 512"><path d="M34.9 289.5l-22.2-22.2c-9.4-9.4-9.4-24.6 0-33.9L207 39c9.4-9.4 24.6-9.4 33.9 0l194.3 194.3c9.4 9.4 9.4 24.6 0 33.9L413 289.4c-9.5 9.5-25 9.3-34.3-.4L264 168.6V456c0 13.3-10.7 24-24 24h-32c-13.3 0-24-10.7-24-24V168.6L69.2 289.1c-9.3 9.8-24.8 10-34.3.4z"/></svg>
    <span class="lu-arriba-texto">{{ 'Arriba' | translate }}</span>
</button>
<script type="text/javascript">
    (function () {
        var boton = document.querySelector('.js-volver-arriba');
        if (!boton) return;
        boton.hidden = false;
        var visible = false;
        function revisar() {
            var ahora = window.scrollY > window.innerHeight;
            if (ahora !== visible) {
                visible = ahora;
                boton.classList.toggle('lu-arriba-visible', ahora);
            }
        }
        window.addEventListener('scroll', revisar, { passive: true });
        revisar();
        boton.addEventListener('click', function () {
            var quieto = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
            window.scrollTo({ top: 0, behavior: quieto ? 'auto' : 'smooth' });
            /* el foco vuelve al principio: con teclado no queda parado al pie */
            var inicio = document.querySelector('.head-main a');
            if (inicio) inicio.focus({ preventScroll: true });
        });
    })();
</script>
