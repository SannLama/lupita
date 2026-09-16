{# /*============================================================================
  #Popup del canal de difusion de Instagram (2026-09-15)
  Pedido de Santiago: en vez de pedir que se creen una cuenta, invitar a
  unirse al canal de difusion de Instagram. Aparece una vez por visitante (se
  recuerda 14 dias en localStorage) a los 6 segundos de entrar, en cualquier
  pagina menos el checkout y la contraseña. Usa los mismos textos y link que
  el bloque del pie (grupo "Tiendas e Instagram de Lupita"); sin link cargado
  no aparece. Script propio y chico: no depende de store.js.
==============================================================================*/#}

{% if settings.lupita_canal_popup and settings.lupita_canal_url and template != 'password' %}
    <div class="js-lu-canal-popup lu-canal-popup" role="dialog" aria-modal="true" aria-labelledby="lu-canal-popup-titulo" hidden>
        <div class="lu-canal-popup-caja">
            <button type="button" class="js-lu-canal-cerrar lu-canal-popup-cerrar" aria-label="{{ 'Cerrar' | translate }}">
                {% include "snipplets/svg/times.tpl" with {svg_custom_class: "icon-inline"} %}
            </button>
            <span class="lu-canal-popup-red">
                {% include "snipplets/svg/instagram.tpl" with {svg_custom_class: "icon-inline"} %}
                {{ 'Canal de difusión' | translate }}
            </span>
            <p class="lu-canal-popup-titulo" id="lu-canal-popup-titulo">{{ settings.lupita_canal_titulo ? settings.lupita_canal_titulo : 'Unite a nuestro canal' | translate }}</p>
            {% if settings.lupita_canal_texto %}
                <p class="lu-canal-popup-texto">{{ settings.lupita_canal_texto }}</p>
            {% endif %}
            <a href="{{ settings.lupita_canal_url }}" target="_blank" rel="noopener" class="js-lu-canal-unirme btn lu-canal-btn lu-canal-popup-btn">{{ settings.lupita_canal_boton ? settings.lupita_canal_boton : 'Unirme al canal' | translate }}</a>
            <button type="button" class="js-lu-canal-cerrar lu-canal-popup-despues">{{ 'Ahora no' | translate }}</button>
        </div>
    </div>
    <script>
        (function () {
            var CLAVE = 'lupita-canal-popup', DIAS = 14;
            var popup = document.querySelector('.js-lu-canal-popup');
            if (!popup) return;
            var guardar = function () { try { localStorage.setItem(CLAVE, String(Date.now())); } catch (e) {} };
            var visto = function () {
                try { var t = Number(localStorage.getItem(CLAVE)); return t && (Date.now() - t) < DIAS * 864e5; }
                catch (e) { return true; }
            };
            if (visto()) return;
            var anterior = null;
            var cerrar = function () {
                popup.classList.remove('lu-canal-popup-visible');
                guardar();
                setTimeout(function () { popup.hidden = true; }, 220);
                document.removeEventListener('keydown', teclas);
                if (anterior && anterior.focus) anterior.focus();
            };
            var teclas = function (e) { if (e.key === 'Escape') cerrar(); };
            var abrir = function () {
                if (document.querySelector('.modal-show')) { setTimeout(abrir, 4000); return; }
                anterior = document.activeElement;
                popup.hidden = false;
                void popup.offsetWidth;
                popup.classList.add('lu-canal-popup-visible');
                var boton = popup.querySelector('.js-lu-canal-unirme');
                if (boton) boton.focus();
                document.addEventListener('keydown', teclas);
            };
            popup.querySelectorAll('.js-lu-canal-cerrar').forEach(function (b) { b.addEventListener('click', cerrar); });
            popup.querySelector('.js-lu-canal-unirme').addEventListener('click', cerrar);
            popup.addEventListener('click', function (e) { if (e.target === popup) cerrar(); });
            setTimeout(abrir, 6000);
        })();
    </script>
{% endif %}
