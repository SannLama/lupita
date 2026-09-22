{# /*============================================================================
  #Titulo al salir de la pestaña
  Cuando el visitante cambia de pestaña o minimiza la ventana, el titulo de
  la pestaña cambia a un mensaje para llamar la atencion; vuelve al titulo
  real de la pagina apenas vuelve. Nace del titulo real (document.title), asi
  que funciona igual en home, categoria, producto, etc. sin tocar cada
  template. Mensaje ajustable: `Mensaje de reclamo` mas abajo.
==============================================================================*/#}
<script type="text/javascript">
    (function () {
        var tituloReal = document.title;
        var tituloAusente = '¡No te vayas! 🛍️';
        document.addEventListener('visibilitychange', function () {
            document.title = document.hidden ? tituloAusente : tituloReal;
        });
    })();
</script>
