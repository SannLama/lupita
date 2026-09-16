{# /*============================================================================
  #Cinta de video (2026-09-16)
  Pedido de Santiago: el video de la Portada y el de la Capsula repetido
  varias veces, corriendo de costado sin fin, como la barra de aviso.

  Dos copias por tanda y la tanda duplicada: la pista mide dos tandas y el
  CSS la corre exactamente -50%, asi el salto del final cae sobre una imagen
  identica y no se nota. Dos copias de 55vw cubren 110vw: nunca queda un
  hueco a la derecha. Van pegadas, sin aire, para que no asome el fondo.

  Toda la cinta es decorativa (aria-hidden): el titulo de encima es el
  contenido. Con movimiento reducido la cinta queda quieta y los videos en
  pausa en el primer cuadro. Fuera de pantalla se pausan (lupita-motion,
  gesto "cinta") para no decodificar cuatro videos que nadie ve.

  Parametros: video_url, poster_url (opcional), clase_video.
==============================================================================*/ #}

<div class="lu-cinta" data-motion="cinta" aria-hidden="true">
    <div class="lu-cinta-pista">
        {% for copia in 1..4 %}
            <div class="lu-cinta-panel">
                <video
                    class="lu-cinta-video {{ clase_video }}"
                    autoplay
                    muted
                    loop
                    playsinline
                    preload="auto"
                    {% if poster_url %}poster="{{ poster_url }}"{% endif %}
                    tabindex="-1"
                >
                    <source src="{{ video_url }}" type="video/mp4">
                </video>
            </div>
        {% endfor %}
    </div>
</div>
<script>
    (function () {
        var cintas = document.querySelectorAll('.lu-cinta');
        var cinta = cintas[cintas.length - 1];
        if (!cinta || !window.matchMedia || !window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
        cinta.querySelectorAll('video').forEach(function (v) {
            v.removeAttribute('autoplay');
            v.pause();
            v.currentTime = 0;
        });
    })();
</script>
