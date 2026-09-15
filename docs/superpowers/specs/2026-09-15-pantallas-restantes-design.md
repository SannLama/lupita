# Pantallas restantes: búsqueda, 404, contacto, contraseña, blog y nota

Fecha: 2026-09-15 · Estado: diseño aprobado en chat, spec pendiente de revisión

## Objetivo

Diseñar como pantallas propias las seis plantillas que el harness nunca mostró,
con la dirección que ya tiene el theme (brutalismo suizo, papel `#F4F4F0`,
tinta `#0A0A0A`, turquesa `#6BB3B9` solo como fondo con tinta encima, macro
Italiana, micro Roboto Mono, marca Archivo Black) y **un único gesto de
movimiento por pantalla**, hecho con anime.js. Las ideas de React Bits y
21st.dev se toman como referencia y se reescriben sin React.

Fuera de alcance: las 9 pantallas de cuenta, y cualquier dato de la clienta que
no esté confirmado (horarios, WhatsApp, tercera dirección).

## 1. anime.js en el theme (opción A)

Tiendanube no compila JS: los `.js.tpl` se incluyen crudos en el layout.

- **Build propio con esbuild** desde `node_modules/animejs` (ya instalado,
  v4.5.0), solo con lo que se usa: `animate`, `stagger`, `splitText`,
  `utils` si hace falta. Salida: `static/js/lupita-motion.js.tpl`, IIFE
  minificado que expone `window.LupitaMotion`.
- El script de build vive en `_harness/motion/` (no se sube por FTP):
  `entrada.mjs` (qué se importa y los seis gestos) y `build.mjs`.
  `package.json` pasa a trackearse con `esbuild` como devDependency y un
  script `build:motion`. `node_modules/` sigue ignorado.
- **Presupuesto: ≤ 30 KB minificado.** Se mide después del primer build; si se
  pasa, se saca `splitText` y el corte de líneas se hace a mano.
- Carga: `layout.tpl` lo incluye después de `store.js.tpl`, dentro del mismo
  `<script>`. `password.tpl` no usa el layout: lo incluye en su propio
  `<script>` del final.
- **Cada gesto se activa por atributo**, no por plantilla:
  `data-motion="decrypt|stagger|spring|shake|hover-preview|split-lines"`. El
  módulo recorre `[data-motion]` al `DOMContentLoaded` y no hace nada si no
  encuentra.

### Reglas comunes a los seis gestos

1. **El HTML ya trae el estado final.** El JS parte de ahí y anima *hacia*
   él (from-values). Si el script no carga o tira error, la pantalla se ve
   completa y quieta.
2. **`prefers-reduced-motion: reduce` → el módulo sale sin animar nada**,
   incluido el shake.
3. **Solo `transform` y `opacity`**, salvo el decrypt que cambia texto.
4. Se corre una sola vez por carga de página; nada en loop.
5. Todo en `try/catch` por gesto: uno roto no apaga los demás.

## 2. Pantalla por pantalla

### 404 (`templates/404.tpl`)

- Rótulo micro "ERROR", **"404" en Italiana a escala de hero** (clamp, que no
  parta en 320), una línea "La página que buscás no existe".
- Debajo: el buscador (reusar el form de `header-search`), y las 4 prendas
  que ya trae el base, en la grilla de siempre con divisiones de 1px.
- **Gesto `decrypt`** (idea: DecryptedText de React Bits): cada dígito pasa
  por caracteres al azar (`0-9` y `#%&`) y se asienta de izquierda a
  derecha, ~900 ms en total. El texto real está en el DOM desde el inicio y
  un `aria-label="404"` en el contenedor evita que un lector lea el ruido.
- No se toca la rama `show_help` (onboarding sin productos).

### Búsqueda (`templates/search.tpl`)

- **Con resultados:** rótulo micro "BÚSQUEDA", el término en Italiana entre
  comillas, y la grilla de `product_grid.tpl` sin cambios.
- **Sin resultados:** el término tachado (`text-decoration: line-through` en
  tinta), "No encontramos nada con eso", y debajo las secciones de la tienda
  para seguir mirando: una lista de links a las categorías de primer nivel
  (`{% for category in categories %}`), con el estilo del riel de la
  categoría. No hay snipplet de riel para reusar (`home-banners` son banners
  configurados, no categorías). Si `categories` viene vacío, la lista no se
  dibuja. `categories` en esta plantilla queda en "Sin verificar".
- **`query` no está confirmado en esta plantilla.** Se usa con
  `{% if query %}`; sin él, el encabezado vuelve a "Resultados de búsqueda"
  y el diseño se sostiene igual. Queda en "Sin verificar".
- **No se muestra la cantidad de resultados**: `products | length` es la de
  la página, no el total, y no hay variable conocida para el total.
- **Gesto `stagger`** (solo con resultados): las tarjetas de la primera
  página suben 12 px y se funden, 40 ms entre una y otra, tope de 12
  tarjetas. Las que agrega el scroll infinito entran sin animar.

### Contacto (`templates/contact.tpl`)

- Desde 768: **dos columnas** — izquierda `contact_intro` y
  `contact-links.tpl` (lo que carga el panel), derecha el formulario. Abajo
  de 768, apilado: datos arriba, formulario abajo.
- **No se escribe a mano ningún dato de la clienta.** Si el panel no tiene
  nada, la columna izquierda muestra solo el título.
- Se mantiene intacta la lógica de cancelación de compra
  (`is_order_cancellation`, `is_order_cancellation_without_id`), el
  honeypot `winnie-pooh` y la consulta por producto (miniatura con borde de
  1px, sin sombra).
- **Gesto `spring`:** el aviso de éxito (`contact-success-message` y el de
  cancelación) entra con un resorte corto (sube 16 px, leve rebote, ~500 ms).
  El de error no rebota: aparece quieto.

### Contraseña (`templates/password.tpl`)

- **Pantalla completa en turquesa con tinta encima** (8.27:1), logotipo en
  Archivo Black grande, el `message` del panel en Italiana, y el campo en una
  caja de papel con borde de tinta.
- Sin la cabecera ni el pie de la tienda más allá del `footer.tpl` que ya
  incluye (se deja, pero se estila sobre turquesa).
- El foco sigue la regla del theme: nada pasa a turquesa al enfocarse (ahí
  el fondo ya es turquesa, así que el foco es borde de tinta de 2 px).
- **Gesto `shake`:** si `invalid_password`, el campo tiembla una vez
  (±6 px, 4 idas y vueltas, ~400 ms) al cargar. Con reduced-motion no tiembla
  y el error se lee igual por el aviso.
- Necesita `lupita.scss.tpl` cargado en esta plantilla: verificar que llegue,
  porque no usa el layout.

### Blog (`templates/blog.tpl`)

- **Lista editorial** en vez de la grilla de 3: una fila por nota, separadas
  por 1px de tinta; título en Italiana, resumen en Roboto Mono, "Leer" como
  link en tinta. La **primera nota** va más grande, con su foto a la vista.
- `blog-post-item` es componente de la plataforma: **solo se cambian las
  clases** que recibe (`post_item_classes`) y el `row`/`col` que lo envuelve
  en la plantilla. Todo lo demás es CSS.
- **Gesto `hover-preview`** (idea: Hover Preview de 21st.dev): con
  `(hover: hover) and (pointer: fine)`, la foto de la fila se oculta en su
  lugar y aparece flotando cerca del cursor mientras está encima, seguida con
  un leve retraso. En táctil y sin JS, cada fila muestra su foto chica fija.
- Paginación con el estilo que ya tiene el theme.

### Nota (`templates/blog-post.tpl`)

- Columna angosta (`container-narrow`), migas, título en Italiana grande,
  fecha como rótulo micro, imagen a ancho de columna, cuerpo con medida de
  lectura (~65 caracteres) e interlineado cómodo. Estilos para `h2/h3`,
  listas, citas y links dentro del contenido que carga el panel.
- `blog-post-content` es componente de la plataforma: mismas reglas que el
  blog (solo clases + CSS).
- **Gesto `split-lines`** (idea: SplitText de React Bits): el título del
  `page-header` se corta en líneas y cada una sube desde abajo de su
  máscara, 80 ms entre líneas. Si hay que recortar peso, el corte se hace
  por palabras envueltas a mano.

## 3. Harness

- **Primero se copia el CSS del base** que toca cada pantalla al andamio
  (`CABEZA` en `render.mjs`), después se escribe la regla (lección del
  2026-09-15).
- Páginas nuevas en `_harness/out/`: `busqueda.html` (con resultados),
  `busqueda-vacia.html`, `404.html`, `contacto.html` (con el aviso de
  éxito visible), `contrasena.html` (con `invalid_password`), `blog.html`,
  `nota.html`. Todas en `dispositivos.html`.
- `render.mjs` incluye `lupita-motion.js.tpl` crudo, igual que la tienda.
- Datos de relleno marcados como tales (títulos y resúmenes de notas de
  mentira), sin inventar datos de la clienta.

## 4. Verificación

- Build de `lupita-motion` y su tamaño medido contra los 30 KB.
- Capturas con Edge headless en desktop y con iframes a 320/390 de las siete
  páginas.
- Cada gesto probado en el navegador (la captura es estática): que corre, que
  termina en el estado del HTML, y que con reduced-motion no corre.
- Sin JS (script quitado): las siete páginas completas.

## 5. Sin verificar hasta que exista la tienda

`query` y `categories` en `search.tpl`; que `lupita.scss.tpl` y el JS lleguen a
`password.tpl`; las clases reales que acepta cada componente de blog; que
`component('blog/...')` respete las clases pasadas; el scroll infinito de la
búsqueda con las tarjetas animadas.

## 6. Documentación

`LUPITA.md` (sección nueva por pantalla + "Sin verificar"), nota
`Temas/Ahi-Lupita.md` y Bitácora del vault. Los commits los pide Santiago.
