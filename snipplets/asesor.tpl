{# /*============================================================================
  #Guia de asesoramiento sin IA (2026-09-18)
  Pedido de Santiago: un boton flotante que abre un mini-quiz (ocasion + talle)
  y lleva a la busqueda nativa de Tiendanube con esos terminos (store.search_url,
  la misma que usa el buscador del header). Nada de IA ni de logica de filtros
  propia. Si en el futuro quieren un asistente con IA real, eso necesita un
  backend aparte fuera de Tiendanube: esto no lo reemplaza, es un paso
  intermedio sin costo ni codigo externo.

  "No estoy segura" (paso 3): pide busto/cintura/cadera y calcula el talle
  contra settings.lupita_talle_* (cm limite de cada talle). Esos numeros son
  de ejemplo hasta que la clienta confirme la tabla real de la marca — se
  ajustan desde el panel, sin tocar este archivo.
==============================================================================*/#}

{% if settings.lupita_asesor_activo and template != 'password' %}
    <button type="button" class="js-lu-asesor-abrir btn-asesor" aria-haspopup="dialog" aria-controls="lu-asesor-popup" aria-label="{{ 'Ayudame a elegir' | translate }}">
        {% include "snipplets/svg/comments.tpl" with {svg_custom_class: "icon-inline"} %}
    </button>
    <div id="lu-asesor-popup" class="js-lu-asesor-popup lu-asesor-popup" role="dialog" aria-modal="true" aria-labelledby="lu-asesor-titulo-1" data-buscar="{{ store.search_url }}" data-limites="{{ {'busto': [settings.lupita_talle_busto_s|default(87), settings.lupita_talle_busto_m|default(93), settings.lupita_talle_busto_l|default(99)], 'cintura': [settings.lupita_talle_cintura_s|default(67), settings.lupita_talle_cintura_m|default(73), settings.lupita_talle_cintura_l|default(79)], 'cadera': [settings.lupita_talle_cadera_s|default(93), settings.lupita_talle_cadera_m|default(99), settings.lupita_talle_cadera_l|default(105)]} | json_encode }}" hidden>
        <div class="lu-asesor-caja">
            <button type="button" class="js-lu-asesor-cerrar lu-asesor-cerrar" aria-label="{{ 'Cerrar' | translate }}">
                {% include "snipplets/svg/times.tpl" with {svg_custom_class: "icon-inline"} %}
            </button>
            <span class="lu-asesor-etiqueta">{{ 'Ayudame a elegir' | translate }}</span>

            <div class="js-lu-asesor-paso lu-asesor-paso" data-paso="1">
                <p class="lu-asesor-titulo" id="lu-asesor-titulo-1">{{ '¿Para qué ocasión buscás algo?' | translate }}</p>
                <div class="lu-asesor-opciones" role="group" aria-label="{{ 'Ocasión' | translate }}">
                    <button type="button" class="js-lu-asesor-opcion lu-asesor-opcion" data-valor="casual">{{ 'Casual' | translate }}</button>
                    <button type="button" class="js-lu-asesor-opcion lu-asesor-opcion" data-valor="salida">{{ 'Salida' | translate }}</button>
                    <button type="button" class="js-lu-asesor-opcion lu-asesor-opcion" data-valor="fiesta">{{ 'Fiesta' | translate }}</button>
                    <button type="button" class="js-lu-asesor-opcion lu-asesor-opcion" data-valor="trabajo">{{ 'Trabajo' | translate }}</button>
                </div>
            </div>

            <div class="js-lu-asesor-paso lu-asesor-paso" data-paso="2" hidden>
                <button type="button" class="js-lu-asesor-volver lu-asesor-volver" data-volver="1">{{ '← Volver' | translate }}</button>
                <p class="lu-asesor-titulo" id="lu-asesor-titulo-2">{{ '¿Qué talle usás?' | translate }}</p>
                <div class="lu-asesor-opciones" role="group" aria-label="{{ 'Talle' | translate }}">
                    <button type="button" class="js-lu-asesor-opcion lu-asesor-opcion" data-valor="s">S</button>
                    <button type="button" class="js-lu-asesor-opcion lu-asesor-opcion" data-valor="m">M</button>
                    <button type="button" class="js-lu-asesor-opcion lu-asesor-opcion" data-valor="l">L</button>
                    <button type="button" class="js-lu-asesor-opcion lu-asesor-opcion" data-valor="xl">XL</button>
                    <button type="button" class="js-lu-asesor-sin-talle lu-asesor-opcion">{{ 'No estoy segura' | translate }}</button>
                </div>
            </div>

            <div class="js-lu-asesor-paso lu-asesor-paso" data-paso="3" hidden>
                <button type="button" class="js-lu-asesor-volver lu-asesor-volver" data-volver="2">{{ '← Volver' | translate }}</button>
                <p class="lu-asesor-titulo" id="lu-asesor-titulo-3">{{ 'Pasame tus medidas (en cm)' | translate }}</p>
                <div class="js-lu-asesor-medidas lu-asesor-medidas">
                    <label class="lu-asesor-campo">{{ 'Busto' | translate }}
                        <input type="number" inputmode="numeric" min="0" class="js-lu-asesor-medida form-control" data-medida="busto">
                    </label>
                    <label class="lu-asesor-campo">{{ 'Cintura' | translate }}
                        <input type="number" inputmode="numeric" min="0" class="js-lu-asesor-medida form-control" data-medida="cintura">
                    </label>
                    <label class="lu-asesor-campo">{{ 'Cadera' | translate }}
                        <input type="number" inputmode="numeric" min="0" class="js-lu-asesor-medida form-control" data-medida="cadera">
                    </label>
                </div>
                <button type="button" class="js-lu-asesor-calcular btn lu-asesor-calcular">{{ 'Ver mi talle' | translate }}</button>
                <p class="js-lu-asesor-resultado lu-asesor-resultado" hidden></p>
            </div>
        </div>
    </div>
    <script>
        (function () {
            var boton = document.querySelector('.js-lu-asesor-abrir');
            var popup = document.querySelector('.js-lu-asesor-popup');
            if (!boton || !popup) return;
            var pasos = Array.prototype.slice.call(popup.querySelectorAll('.js-lu-asesor-paso'));
            var respuestas = {};
            var anterior = null;

            /* Tabla de referencia (data-limites, armado desde settings.lupita_talle_*
               en el tpl): cm hasta los que entra cada talle en busto, cintura y
               cadera. Son numeros de ejemplo (pedido de Santiago 2026-09-18, sin
               la tabla real de la marca todavia) y se pueden ajustar desde el
               panel sin tocar este archivo, apenas la clienta confirme los suyos. */
            var TALLES = ['s', 'm', 'l', 'xl'];
            var LIMITES = JSON.parse(popup.dataset.limites || '{}');

            var indiceTalle = function (valor, limites) {
                for (var i = 0; i < limites.length; i++) {
                    if (valor <= limites[i]) return i;
                }
                return limites.length;
            };

            var calcularTalle = function (medidas) {
                var indices = [];
                Object.keys(medidas).forEach(function (medida) {
                    var valor = parseFloat(medidas[medida]);
                    if (!isNaN(valor) && valor > 0 && LIMITES[medida]) indices.push(indiceTalle(valor, LIMITES[medida]));
                });
                if (!indices.length) return null;
                var conteo = [0, 0, 0, 0];
                indices.forEach(function (i) { conteo[i]++; });
                var mejor = 0;
                for (var i = 1; i < conteo.length; i++) {
                    if (conteo[i] >= conteo[mejor]) mejor = i;
                }
                return TALLES[mejor];
            };

            var mostrarPaso = function (n) {
                pasos.forEach(function (p) { p.hidden = Number(p.dataset.paso) !== n; });
                popup.setAttribute('aria-labelledby', 'lu-asesor-titulo-' + n);
            };

            var teclas = function (e) { if (e.key === 'Escape') cerrar(); };

            var cerrar = function () {
                popup.classList.remove('lu-asesor-popup-visible');
                setTimeout(function () { popup.hidden = true; }, 220);
                document.removeEventListener('keydown', teclas);
                if (anterior && anterior.focus) anterior.focus();
            };

            var abrir = function () {
                anterior = document.activeElement;
                respuestas = {};
                mostrarPaso(1);
                popup.hidden = false;
                void popup.offsetWidth;
                popup.classList.add('lu-asesor-popup-visible');
                var primeraOpcion = popup.querySelector('.js-lu-asesor-opcion');
                if (primeraOpcion) primeraOpcion.focus();
                document.addEventListener('keydown', teclas);
            };

            var buscar = function () {
                var terminos = [respuestas.ocasion, respuestas.talle].filter(Boolean).join(' ');
                window.location.href = popup.dataset.buscar + '?q=' + encodeURIComponent(terminos);
            };

            popup.querySelectorAll('[data-paso="1"] .js-lu-asesor-opcion').forEach(function (b) {
                b.addEventListener('click', function () {
                    respuestas.ocasion = b.dataset.valor;
                    mostrarPaso(2);
                    var siguiente = popup.querySelector('[data-paso="2"] .js-lu-asesor-opcion');
                    if (siguiente) siguiente.focus();
                });
            });

            popup.querySelectorAll('[data-paso="2"] .js-lu-asesor-opcion').forEach(function (b) {
                b.addEventListener('click', function () {
                    respuestas.talle = b.dataset.valor;
                    buscar();
                });
            });

            popup.querySelector('.js-lu-asesor-sin-talle').addEventListener('click', function () {
                mostrarPaso(3);
                var primerCampo = popup.querySelector('.js-lu-asesor-medida');
                if (primerCampo) primerCampo.focus();
            });

            popup.querySelector('.js-lu-asesor-calcular').addEventListener('click', function () {
                var medidas = {};
                popup.querySelectorAll('.js-lu-asesor-medida').forEach(function (input) {
                    medidas[input.dataset.medida] = input.value;
                });
                var talle = calcularTalle(medidas);
                var resultado = popup.querySelector('.js-lu-asesor-resultado');
                if (!talle) {
                    resultado.textContent = '{{ "Cargá al menos una medida para calcular tu talle." | translate }}';
                    resultado.hidden = false;
                    return;
                }
                respuestas.talle = talle;
                resultado.textContent = '{{ "Con esas medidas, tu talle sería aproximadamente" | translate }} ' + talle.toUpperCase() + '. {{ "Es una guía aproximada: puede variar según el modelo." | translate }}';
                resultado.hidden = false;
                setTimeout(buscar, 1400);
            });

            popup.querySelectorAll('.js-lu-asesor-volver').forEach(function (b) {
                b.addEventListener('click', function () {
                    var destino = Number(b.dataset.volver);
                    mostrarPaso(destino);
                    var primeraOpcion = popup.querySelector('[data-paso="' + destino + '"] .js-lu-asesor-opcion');
                    if (primeraOpcion) primeraOpcion.focus();
                });
            });

            popup.querySelectorAll('.js-lu-asesor-cerrar').forEach(function (b) { b.addEventListener('click', cerrar); });
            popup.addEventListener('click', function (e) { if (e.target === popup) cerrar(); });
            boton.addEventListener('click', abrir);
        })();
    </script>
{% endif %}
