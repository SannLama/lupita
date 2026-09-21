# Ahí! Lupita — carpeta para subir a Tienda Nube

Armada el 2026-09-21 desde `C:\xampp\htdocs\ahilupita-theme`
(repo: github.com/SannLama/lupita, commit `4b1756a`).

## Qué hay acá

| Carpeta | Qué es |
|---|---|
| `SUBIR-POR-FTP/` | Las cinco carpetas del theme, 1,2 MB. **Esto y nada más** va por FTP. |
| `VIDEOS-para-Netlify/` | Los dos videos. **NO van por FTP**: se publican aparte (ver abajo). |
| `CHECKLIST-SUBIDA.md` | La lista completa para ir tildando. |

## Antes de subir: tres cosas que no tienen vuelta atrás

Habilitar el FTP le cambia la vida a la tienda. La clienta tiene que saberlo **antes**:

1. **Es un camino de ida.** La tienda pierde la posibilidad de cambiar de plantilla desde el panel.
2. **Deja de recibir las mejoras automáticas de diseño** de Tienda Nube. De ahí en más el mantenimiento del theme es nuestro.
3. **Si después se cierra el FTP, se pierde todo lo personalizado.** Tienda Nube no guarda nada. El respaldo es el repo de GitHub.

Y hace falta **plan Impulso o superior**: el FTP no existe en el gratuito ni en Inicial.

## Cómo subirlo

1. En el panel: *Tienda online → Diseño → "Editar el código"*. De ahí salen host, usuario, contraseña y puerto.
2. Conectar con **FileZilla**, con dos ajustes que no son opcionales:
   - **FTP sobre SSL/TLS**
   - **Modo de transferencia binario, NO ASCII.** En ASCII falla con `503 ASCII (text) data type is not supported for file transfer operations`.
3. Arrastrar las cinco carpetas que están dentro de `SUBIR-POR-FTP/`: `config`, `layouts`, `snipplets`, `static`, `templates`.
4. Activar la plantilla y revisar el `CHECKLIST-SUBIDA.md`.

## Los videos — ⚠️ PENDIENTE, todavía no están publicados

Tienda Nube **no aloja archivos de video sueltos** para el theme. El hero usa un
`<video>` nativo con `<source type="video/mp4">`, así que necesita un **link directo
a un archivo `.mp4`**. Por eso **YouTube no sirve**: da una página o un iframe, nunca
el archivo, y un video en privado ni siquiera reproduce embebido.

La carpeta `VIDEOS-para-Netlify/` ya está lista para publicar tal cual:

- Los dos `.mp4` y sus pósters.
- `index.html` — reproduce ambos y **muestra en pantalla las URLs finales** para copiar.
- `_headers` — caché de un año, para que el video no se baje de nuevo en cada visita.

**Cómo publicarla:** entrar a `app.netlify.com/drop` y arrastrar la carpeta entera.
Devuelve la URL en el momento, sin instalar nada. (También se puede con el CLI:
`netlify login` y después `netlify deploy --prod --dir VIDEOS-para-Netlify`.)

Una vez publicada, abrir la URL que devuelva y copiar de ahí cada link al panel:

| Archivo | Va en el ajuste |
|---|---|
| `portada.mp4` (3,2 MB) | `cover_video_url` — portada "Sea of Dreams" |
| `capsula.mp4` (5,3 MB) | `capsule_video_url` — cápsula "City Moves" |

Los `-poster.jpg` son la imagen que se ve mientras carga el video: se suben como
imagen normal desde el panel.

⚠️ Los videos quedan **públicos**, no hay alternativa: el navegador de cualquiera que
entre a la tienda los tiene que poder descargar. El `index.html` lleva `noindex` para
que al menos no aparezca en Google.

## Lo que todavía falta

- **Logo vectorial** o el hex exacto del turquesa (hoy el acento es `#6BB3B9` y el logotipo es tipográfico).
- **Tabla de talles real** de la marca: los números del asesor (`lupita_talle_*`) son de ejemplo.
- **Los productos.** El theme lee lo que tenga la plataforma, así que el catálogo del local hay que importarlo aparte. Dos cosas a respetar en esa carga, porque arreglarlas después producto por producto es un dolor:
  - Las variantes tienen que llamarse exactamente **"Color"** y **"Talle"**: el theme las reconoce por el nombre.
  - Para que el asesor encuentre algo, la **ocasión** y el **talle** tienen que estar en el nombre, las etiquetas o las variantes.
- **WhatsApp** cargado en los datos de contacto del panel: el theme lo lee de ahí, no lo tiene escrito.

## Ojo

Esta carpeta es una **copia**. Si hay que tocar algo, se toca en
`C:\xampp\htdocs\ahilupita-theme`, se commitea, y se vuelve a copiar —
si no, el cambio se pierde en la próxima.
