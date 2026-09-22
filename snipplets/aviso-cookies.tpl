{# /*============================================================================
  #Aviso de cookies (propio)
  El aviso del base de Tiendanube (js-notification-cookie-banner) corre el
  codigo (empuja WhatsApp/asesor 70px y le agrega padding al pie) pero el
  jQuery ".show()" nunca lo deja visible - bug del JS minificado del base,
  no de este theme, y no se pudo cazar la causa exacta. Este reemplaza esa
  pieza por completo: propio localStorage, propio show/hide, sin tocar en
  absoluto el js-notification-cookie-banner original (pedido de Santiago,
  2026-09-22). Nace hidden: sin JS no hay aviso que no funcione. #}
<div class="js-aviso-cookies lu-cookies" hidden role="region" aria-label="{{ 'Aviso de cookies' | translate }}">
    <p class="lu-cookies-texto">{{ 'Usamos cookies para mejorar tu experiencia en la tienda.' | translate }}</p>
    <button type="button" class="js-aviso-cookies-ok lu-cookies-boton">{{ 'Entendido' | translate }}</button>
</div>
<script type="text/javascript">
    (function () {
        var CLAVE = 'lupita:cookies-ok';
        var aviso = document.querySelector('.js-aviso-cookies');
        if (!aviso) return;
        var boton = aviso.querySelector('.js-aviso-cookies-ok');

        var aceptado;
        try { aceptado = window.localStorage.getItem(CLAVE); } catch (e) { aceptado = '1'; }

        if (!aceptado) {
            aviso.hidden = false;
            requestAnimationFrame(function () { aviso.classList.add('lu-cookies-visible'); });
        }

        boton.addEventListener('click', function () {
            try { window.localStorage.setItem(CLAVE, '1'); } catch (e) {}
            aviso.classList.remove('lu-cookies-visible');
            setTimeout(function () { aviso.hidden = true; }, 250);
        });
    })();
</script>
