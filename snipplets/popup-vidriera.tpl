{# /*============================================================================
  #Popup de vidriera virtual (Santiago, 2026-09-28: "que al momento de entrar
  en la tienda te aparezca un pop up de que es una vidriera virtual")
  Aparece al segundo de entrar, una vez cada 7 dias por visitante
  (localStorage), en cualquier pagina menos la de contraseña. Mismos textos
  que el bloque de vidriera virtual (Personalizar diseño > Vidriera virtual)
  y la misma caja que el popup del canal (.lu-canal-popup). En la visita en
  que se muestra, el del canal no sale (sessionStorage 'lupita-vv-sesion'):
  dos ventanas seguidas al entrar es demasiado.
==============================================================================*/#}

{% if not settings.lupita_vidriera_ocultar and template != 'password' %}
    {% set lu_vv_rotulo = settings.lupita_vidriera_rotulo ?: 'Próximamente venta online' %}
    {% set lu_vv_titulo = settings.lupita_vidriera_titulo ?: '¿Qué es una vidriera virtual?' %}
    {% set lu_vv_texto = settings.lupita_vidriera_texto ?: 'Es nuestra tienda abierta en la web: recorré las prendas, mirá precios y talles y guardá tus favoritas con el corazón. Por ahora no vendemos online: la compra la terminás en cualquiera de nuestras tres tiendas o escribiéndonos por WhatsApp.' %}
    <div class="js-lu-vv-popup lu-canal-popup lu-vv-popup" role="dialog" aria-modal="true" aria-labelledby="lu-vv-popup-titulo" hidden>
        <div class="lu-canal-popup-caja">
            <button type="button" class="js-lu-vv-cerrar lu-canal-popup-cerrar" aria-label="{{ 'Cerrar' | translate }}">
                {% include "snipplets/svg/times.tpl" with {svg_custom_class: "icon-inline"} %}
            </button>
            <span class="lu-canal-popup-red">{{ lu_vv_rotulo }}</span>
            <p class="lu-canal-popup-titulo" id="lu-vv-popup-titulo">{{ lu_vv_titulo }}</p>
            <p class="lu-canal-popup-texto">{{ lu_vv_texto }}</p>
            <button type="button" class="js-lu-vv-cerrar js-lu-vv-ok btn lu-canal-btn lu-canal-popup-btn">{{ 'Entendido' | translate }}</button>
            <a class="lu-canal-popup-despues" href="{{ store.url }}/locales/">{{ 'Conocé nuestras tiendas' | translate }}</a>
        </div>
    </div>
    <script>
        (function () {
            var CLAVE = 'lupita-vv-popup', DIAS = 7;
            var popup = document.querySelector('.js-lu-vv-popup');
            if (!popup) return;
            try {
                var t = Number(localStorage.getItem(CLAVE));
                if (t && (Date.now() - t) < DIAS * 864e5) return;
            } catch (e) { return; }
            try { sessionStorage.setItem('lupita-vv-sesion', '1'); } catch (e) {}
            var anterior = null;
            var teclas = function (e) { if (e.key === 'Escape') cerrar(); };
            var cerrar = function () {
                popup.classList.remove('lu-canal-popup-visible');
                try { localStorage.setItem(CLAVE, String(Date.now())); } catch (e) {}
                setTimeout(function () { popup.hidden = true; }, 220);
                document.removeEventListener('keydown', teclas);
                if (anterior && anterior.focus) anterior.focus();
            };
            var abrir = function () {
                if (document.querySelector('.modal-show')) { setTimeout(abrir, 3000); return; }
                anterior = document.activeElement;
                popup.hidden = false;
                void popup.offsetWidth;
                popup.classList.add('lu-canal-popup-visible');
                popup.querySelector('.js-lu-vv-ok').focus();
                document.addEventListener('keydown', teclas);
            };
            popup.querySelectorAll('.js-lu-vv-cerrar').forEach(function (b) { b.addEventListener('click', cerrar); });
            popup.addEventListener('click', function (e) { if (e.target === popup) cerrar(); });
            setTimeout(abrir, 1000);
        })();
    </script>
{% endif %}
