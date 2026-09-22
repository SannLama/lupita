{# /*============================================================================
  #Titulo al salir de la pestaña
  Cuando el visitante cambia de pestaña o minimiza la ventana, el titulo de
  la pestaña va rotando entre varios mensajes para llamar la atencion;
  vuelve al titulo real de la pagina apenas vuelve. Nace del titulo real
  (document.title), asi que funciona igual en home, categoria, producto,
  etc. sin tocar cada template. Mensajes ajustables: `mensajes` mas abajo.
==============================================================================*/#}
<script type="text/javascript">
    (function () {
        var tituloReal = document.title;
        var mensajes = ['¡No te vayas! 🛍️', 'Te esperamos 💛', '¿Seguimos viendo? 👀'];
        var indice = 0;
        var intervalo = null;
        document.addEventListener('visibilitychange', function () {
            if (document.hidden) {
                indice = 0;
                document.title = mensajes[indice];
                intervalo = setInterval(function () {
                    indice = (indice + 1) % mensajes.length;
                    document.title = mensajes[indice];
                }, 2000);
            } else {
                clearInterval(intervalo);
                document.title = tituloReal;
            }
        });
    })();
</script>
