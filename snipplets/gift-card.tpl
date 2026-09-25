{# /*============================================================================
  #Gift Card (2026-09-25)
  Pagina propia: page.tpl la usa cuando la pagina se llama "Gift Card" (handle
  gift-card / giftcard, o con "gift" y "card" en el nombre). La clienta la
  crea en "Mi Tiendanube > Paginas" y la suma al menu.

  La tarjeta es un dibujo 2D de la gift card: el monto que se elige con la
  barra o con los montos rapidos se escribe en la tarjeta en vivo, y "Para" /
  "De" / el mensaje van al dorso, que se da vuelta al escribirlos.

  Ahi! Lupita no vende online: el boton arma el pedido y abre WhatsApp, igual
  que la ficha de producto (static/js/lupita-comprar-whatsapp.js.tpl). Textos
  y montos desde "Personalizar diseno > Gift Card".

  Lo que se escriba en el contenido de la pagina va debajo.
==============================================================================*/#}

{% set lu_gc_min = settings.lupita_gift_min | default(50000) %}
{% set lu_gc_max = settings.lupita_gift_max | default(3000000) %}
{% set lu_gc_paso = settings.lupita_gift_paso | default(5000) %}
{% set lu_gc_montos = [] %}
{% for lu_gc_m in (settings.lupita_gift_montos | default('50000,100000,500000,1000000')) | split(',') %}
    {# replace con diccionario ({'.': ''}) tira "Inconvenientes con el servidor"
       en Tiendanube: solo anda la forma de dos argumentos #}
    {% set lu_gc_m = lu_gc_m | replace('.', '') | replace('$', '') | trim %}
    {% if lu_gc_m %}
        {% set lu_gc_montos = lu_gc_montos | merge([lu_gc_m]) %}
    {% endif %}
{% endfor %}
{% set lu_gc_inicial = lu_gc_montos | length > 1 ? lu_gc_montos[1] : (lu_gc_montos | first | default(lu_gc_min)) %}
{% set lu_gc_numero = store.whatsapp | trim('https://wa.me/') %}

<section class="lu-gift js-lu-gift" data-store="page-gift-card"
    data-min="{{ lu_gc_min }}" data-max="{{ lu_gc_max }}" data-paso="{{ lu_gc_paso }}"
    data-whatsapp="{{ lu_gc_numero }}" data-contacto="{{ store.contact_url }}">
    <div class="container">
        <div class="lu-gift-grilla">

            {# La tarjeta. aria-live: el monto que se lee es el de la tarjeta #}
            <div class="lu-gift-escena">
                <div class="lu-gift-tarjeta js-lu-gift-tarjeta">
                    {# Frente con el formato de la tarjeta "Club Ahi!Lupita" de la marca
                       (Santiago, 2026-09-25): crema, el A! gigante de marca de agua,
                       la marca arriba a la derecha, "Gift Card" en script montado
                       sobre el monto en serif, y una frase al pie. #}
                    {# Sin frase fija al pie (Santiago, 2026-09-25): solo "Para X" si se escribe #}
                    {% set lu_gc_frase = settings.lupita_gift_frase %}
                    <div class="lu-gift-cara lu-gift-frente">
                        <span class="lu-gift-brillo" aria-hidden="true"></span>
                        {# Foil dorado del A! (2026-09-25): degrade de dorados, grano de
                           ruido y una luz especular que recorre la letra. Las
                           definiciones van aca y el CSS las aplica solo a .lu-gift-agua;
                           el logo del encabezado no cambia. #}
                        <svg class="lu-gift-defs" width="0" height="0" aria-hidden="true" focusable="false">
                            <defs>
                                <linearGradient id="lu-gift-oro" x1="0" y1="0" x2="1" y2="1">
                                    <stop offset="0" stop-color="#8c6a26"/>
                                    <stop offset="0.22" stop-color="#e2bf6c"/>
                                    <stop offset="0.4" stop-color="#b48a3b"/>
                                    <stop offset="0.58" stop-color="#f3dc98"/>
                                    <stop offset="0.78" stop-color="#a47b30"/>
                                    <stop offset="1" stop-color="#d6b25e"/>
                                </linearGradient>
                                <filter id="lu-gift-foil" x="-5%" y="-5%" width="110%" height="110%" primitiveUnits="objectBoundingBox" color-interpolation-filters="sRGB">
                                    <feTurbulence type="fractalNoise" baseFrequency="1.6" numOctaves="2" seed="7" result="ruido"/>
                                    <feColorMatrix in="ruido" type="matrix" values="0 0 0 0 0.5  0 0 0 0 0.5  0 0 0 0 0.5  0.33 0.33 0.33 0 -0.35" result="grano"/>
                                    <feComposite in="grano" in2="SourceAlpha" operator="in" result="granoIn"/>
                                    <feBlend in="SourceGraphic" in2="granoIn" mode="multiply" result="metal"/>
                                    <feGaussianBlur in="SourceAlpha" stdDeviation="0.006" result="relieve"/>
                                    <feSpecularLighting in="relieve" surfaceScale="4" specularConstant="1.1" specularExponent="24" lighting-color="#fff4d2" result="luz">
                                        <fePointLight class="js-lu-gift-luz" x="0.2" y="0.1" z="0.35">
                                            <animate attributeName="x" values="-0.2;1.2;-0.2" dur="7s" repeatCount="indefinite"/>
                                        </fePointLight>
                                    </feSpecularLighting>
                                    <feComposite in="luz" in2="SourceAlpha" operator="in" result="luzIn"/>
                                    <feComposite in="metal" in2="luzIn" operator="arithmetic" k1="0" k2="1" k3="0.75" k4="0"/>
                                </filter>
                            </defs>
                        </svg>
                        {% include "snipplets/svg/logo-lupita.tpl" with {svg_custom_class: 'lu-gift-agua'} %}
                        <div class="lu-gift-marca">
                            <p class="lu-gift-marca-nombre">{{ settings.lupita_gift_marca ?: 'Ahí!Lupita' }}</p>
                            <p class="lu-gift-rotulo">{{ settings.lupita_gift_rotulo | default("Kit n'Couch") }}</p>
                        </div>
                        <div class="lu-gift-centro">
                            <p class="lu-gift-nombre">Gift Card</p>
                            <p class="lu-gift-monto" aria-live="polite">$<span class="js-lu-gift-monto">{{ lu_gc_inicial }}</span></p>
                        </div>
                        <p class="lu-gift-para js-lu-gift-para-frente" data-frase="{{ lu_gc_frase }}"{% if not lu_gc_frase %} hidden{% endif %}>{{ lu_gc_frase }}</p>
                    </div>
                    <div class="lu-gift-cara lu-gift-dorso" aria-hidden="true">
                        <span class="lu-gift-banda"></span>
                        <dl class="lu-gift-datos">
                            <dt>{{ 'Para' | translate }}</dt>
                            <dd class="js-lu-gift-dorso-para">&nbsp;</dd>
                            <dt>{{ 'De' | translate }}</dt>
                            <dd class="js-lu-gift-dorso-de">&nbsp;</dd>
                        </dl>
                        <p class="lu-gift-mensaje js-lu-gift-dorso-mensaje"></p>
                        <p class="lu-gift-dorso-pie">
                            <span>$<span class="js-lu-gift-monto">{{ lu_gc_inicial }}</span></span>
                            <span>Ahí! Lupita</span>
                        </p>
                    </div>
                </div>
                <button type="button" class="lu-gift-girar js-lu-gift-girar">{{ 'Dar vuelta la tarjeta' | translate }}</button>
            </div>

            {# El formulario #}
            <form class="lu-gift-form js-lu-gift-form" novalidate>
                <h1 class="lu-gift-titulo">{{ settings.lupita_gift_titulo | default(page.name) }}</h1>
                {# Los textos por defecto van aca tambien: la tienda en vivo no toma
                   defaults.txt para campos nuevos del panel #}
                <p class="lu-gift-bajada">{{ settings.lupita_gift_texto ?: 'El regalo que siempre queda bien: elegí el monto, escribile unas palabras y quien la recibe elige lo que más le guste en cualquiera de nuestras tiendas.' }}</p>

                <fieldset class="lu-gift-paso">
                    <legend class="lu-gift-paso-rotulo"><span>1</span>{{ 'Elegí el monto' | translate }}</legend>
                    {% if lu_gc_montos %}
                        <div class="lu-gift-montos" role="group" aria-label="{{ 'Montos rápidos' | translate }}">
                            {% for lu_gc_m in lu_gc_montos %}
                                <button type="button" class="lu-gift-chip js-lu-gift-chip{% if lu_gc_m == lu_gc_inicial %} is-activo{% endif %}" data-monto="{{ lu_gc_m }}" aria-pressed="{{ lu_gc_m == lu_gc_inicial ? 'true' : 'false' }}">${{ lu_gc_m }}</button>
                            {% endfor %}
                        </div>
                    {% endif %}
                    <label class="lu-gift-rango-rotulo" for="lu-gift-rango">{{ 'O deslizá hasta el monto que quieras' | translate }}</label>
                    <input id="lu-gift-rango" class="lu-gift-rango js-lu-gift-rango" type="range" min="{{ lu_gc_min }}" max="{{ lu_gc_max }}" step="{{ lu_gc_paso }}" value="{{ lu_gc_inicial }}">
                    <div class="lu-gift-rango-extremos" aria-hidden="true">
                        <span>${{ lu_gc_min }}</span><span>${{ lu_gc_max }}</span>
                    </div>
                </fieldset>

                <fieldset class="lu-gift-paso">
                    <legend class="lu-gift-paso-rotulo"><span>2</span>{{ 'Personalizala' | translate }} <em>({{ 'opcional' | translate }})</em></legend>
                    <div class="lu-gift-campos">
                        <label class="lu-gift-campo">
                            <span>{{ 'Para' | translate }}</span>
                            <input type="text" class="form-control js-lu-gift-para" maxlength="28" autocomplete="off" placeholder="{{ 'Nombre de quien la recibe' | translate }}">
                        </label>
                        <label class="lu-gift-campo">
                            <span>{{ 'De' | translate }}</span>
                            <input type="text" class="form-control js-lu-gift-de" maxlength="28" autocomplete="off" placeholder="{{ 'Tu nombre' | translate }}">
                        </label>
                        <label class="lu-gift-campo lu-gift-campo-ancho">
                            <span>{{ 'Mensaje' | translate }}</span>
                            <textarea class="form-control js-lu-gift-mensaje" rows="3" maxlength="110" placeholder="{{ 'Unas palabras para acompañarla' | translate }}"></textarea>
                        </label>
                    </div>
                </fieldset>

                <button type="submit" class="btn btn-primary btn-block lu-gift-cta">
                    {{ 'Pedir mi Gift Card por WhatsApp' | translate }}
                </button>

                <p class="lu-gift-legal">{{ settings.lupita_gift_legal ?: 'Se canjea en nuestras tres tiendas de Lomas de Zamora y Banfield.' }}</p>
            </form>
        </div>

        {% if page.content %}
            <div class="user-content lu-pagina-extra">{{ page.content }}</div>
        {% endif %}
    </div>
</section>

<script type="text/javascript">
    (function () {
        var raiz = document.querySelector('.js-lu-gift');
        if (!raiz) return;

        var min = parseInt(raiz.dataset.min, 10) || 0;
        var max = parseInt(raiz.dataset.max, 10) || 0;
        var tarjeta = raiz.querySelector('.js-lu-gift-tarjeta');
        var rango = raiz.querySelector('.js-lu-gift-rango');
        var chips = raiz.querySelectorAll('.js-lu-gift-chip');
        var montos = raiz.querySelectorAll('.js-lu-gift-monto');
        var campoPara = raiz.querySelector('.js-lu-gift-para');
        var campoDe = raiz.querySelector('.js-lu-gift-de');
        var campoMensaje = raiz.querySelector('.js-lu-gift-mensaje');
        var paraFrente = raiz.querySelector('.js-lu-gift-para-frente');
        var quieto = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        var formato = new Intl.NumberFormat('es-AR', { maximumFractionDigits: 0 });

        var elegido = parseInt(rango.value, 10) || min;
        var cifraFrente = raiz.querySelector('.lu-gift-frente .lu-gift-monto');

        {# Montos de 7 cifras o mas ($1.000.000) van un poco mas chicos, para que
           no choquen con el "Para" del frente #}
        function pintarMonto(n) {
            var texto = formato.format(Math.round(n));
            montos.forEach(function (el) { el.textContent = texto; });
            tarjeta.classList.toggle('is-largo', texto.length > 7);
        }

        {# Sutil (pedido de Santiago, 2026-09-25): el numero cambia de una, sin
           correr. Con los montos rapidos entra con un fundido corto de abajo;
           con la barra no se anima, porque cambia en cada paso del arrastre. #}
        function irA(n, animar) {
            elegido = Math.min(max, Math.max(min, n));
            pintarMonto(elegido);
            if (animar && !quieto && cifraFrente.animate) {
                cifraFrente.animate(
                    [{ opacity: 0.25, transform: 'translateY(0.08em)' }, { opacity: 1, transform: 'none' }],
                    { duration: 280, easing: 'cubic-bezier(0.16, 0.84, 0.44, 1)' }
                );
            }
        }

        function marcarChips() {
            chips.forEach(function (chip) {
                var activo = parseInt(chip.dataset.monto, 10) === elegido;
                chip.classList.toggle('is-activo', activo);
                chip.setAttribute('aria-pressed', activo ? 'true' : 'false');
            });
        }

        function pintarRango() {
            var p = max > min ? (elegido - min) / (max - min) * 100 : 0;
            rango.style.setProperty('--lu-gift-lleno', p + '%');
        }

        function girar(dorso) {
            tarjeta.classList.toggle('is-dorso', dorso);
        }

        chips.forEach(function (chip) {
            var monto = parseInt(chip.dataset.monto, 10);
            if (monto < min || monto > max) { chip.hidden = true; return; }
            chip.textContent = '$' + formato.format(parseInt(chip.dataset.monto, 10));
            chip.addEventListener('click', function () {
                var n = parseInt(chip.dataset.monto, 10);
                rango.value = n;
                irA(n, true); marcarChips(); pintarRango(); girar(false);
            });
        });
        raiz.querySelectorAll('.lu-gift-rango-extremos span').forEach(function (el) {
            el.textContent = '$' + formato.format(parseInt(el.textContent.replace(/\D/g, ''), 10));
        });

        rango.addEventListener('input', function () {
            irA(parseInt(rango.value, 10), false); marcarChips(); pintarRango(); girar(false);
        });

        {# Para / De / mensaje: se escriben en el dorso y la tarjeta se da vuelta
           mientras se tipea. El "Para" tambien queda en el frente. #}
        function escribir(campo, destino, vacio) {
            var el = raiz.querySelector(destino);
            campo.addEventListener('input', function () {
                el.textContent = campo.value.trim() || vacio;
                girar(true);
                var para = campoPara.value.trim();
                paraFrente.textContent = para ? 'Para ' + para : paraFrente.dataset.frase;
                paraFrente.hidden = !paraFrente.textContent;
            });
            campo.addEventListener('focus', function () { girar(true); });
        }
        escribir(campoPara, '.js-lu-gift-dorso-para', ' ');
        escribir(campoDe, '.js-lu-gift-dorso-de', ' ');
        escribir(campoMensaje, '.js-lu-gift-dorso-mensaje', '');

        raiz.querySelector('.js-lu-gift-girar').addEventListener('click', function () {
            girar(!tarjeta.classList.contains('is-dorso'));
        });

        {# Con movimiento reducido, el brillo del A! queda quieto #}
        if (quieto) {
            raiz.querySelectorAll('.lu-gift-defs animate').forEach(function (an) { an.remove(); });
        }

        {# Inclinacion leve que sigue al puntero (solo mouse, no en celular) #}
        if (!quieto && window.matchMedia('(hover: hover) and (pointer: fine)').matches) {
            var escena = raiz.querySelector('.lu-gift-escena');
            escena.addEventListener('pointermove', function (e) {
                var r = escena.getBoundingClientRect();
                var x = (e.clientX - r.left) / r.width - 0.5;
                var y = (e.clientY - r.top) / r.height - 0.5;
                tarjeta.style.setProperty('--lu-gift-rx', (y * -8).toFixed(2) + 'deg');
                tarjeta.style.setProperty('--lu-gift-ry', (x * 10).toFixed(2) + 'deg');
                tarjeta.style.setProperty('--lu-gift-bx', ((x + 0.5) * 100).toFixed(1) + '%');
                tarjeta.style.setProperty('--lu-gift-by', ((y + 0.5) * 100).toFixed(1) + '%');
            });
            escena.addEventListener('pointerleave', function () {
                tarjeta.style.setProperty('--lu-gift-rx', '0deg');
                tarjeta.style.setProperty('--lu-gift-ry', '0deg');
            });
        }

        raiz.querySelector('.js-lu-gift-form').addEventListener('submit', function (e) {
            e.preventDefault();
            var lineas = ['Hola! Quiero una Gift Card de $' + formato.format(elegido) + '.'];
            if (campoPara.value.trim()) lineas.push('Para: ' + campoPara.value.trim());
            if (campoDe.value.trim()) lineas.push('De: ' + campoDe.value.trim());
            if (campoMensaje.value.trim()) lineas.push('Mensaje: ' + campoMensaje.value.trim());
            var numero = raiz.dataset.whatsapp;
            if (numero) {
                window.open('https://wa.me/' + numero + '?text=' + encodeURIComponent(lineas.join('\n')), '_blank');
            } else if (raiz.dataset.contacto) {
                window.location.href = raiz.dataset.contacto;
            }
        });

        pintarMonto(elegido); marcarChips(); pintarRango();
    })();
</script>
