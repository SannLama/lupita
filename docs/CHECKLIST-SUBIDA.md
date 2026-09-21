# Checklist de subida a Tienda Nube — Ahí! Lupita

Resumen operativo de "Puesta en produccion" de `LUPITA.md`. Marcá cada casilla
en orden; lo que está en ⚠️ no tiene vuelta atrás.

## 0. Antes de tocar nada (decisión de la clienta)

- [ ] La clienta leyó y aceptó las tres letras chicas del FTP:
  - [ ] ⚠️ Camino de ida: la tienda ya no puede cambiar de plantilla desde el panel.
  - [ ] ⚠️ Deja de recibir las mejoras automáticas de diseño de Tienda Nube; el mantenimiento pasa a ser nuestro.
  - [ ] ⚠️ Si se cierra el FTP se pierden TODAS las personalizaciones. El respaldo es este repo (`github.com/SannLama/lupita`).
- [ ] Confirmó el plan **Impulso o superior** (precio a confirmar en el panel; a septiembre de 2026, $234.999/mes, 25% off pagando anual).

## 1. Tienda y acceso

- [ ] La tienda está creada en Tienda Nube con el plan Impulso o superior.
- [ ] Datos de contacto cargados en el panel, incluido el **WhatsApp** (`store.whatsapp` = +54 9 11 2862-2903). El theme lo lee de ahí; no hay mail (no se carga `store.email`).
- [ ] FTP habilitado: *Tienda online → Diseño → "Editar el código"*. Anotadas las credenciales (host, usuario, contraseña, puerto).

## 2. Material que falta

- [ ] **Logo vectorial** o hex exacto del turquesa (hoy el logotipo es tipográfico y el acento es `#6BB3B9`).
- [ ] **Tabla de talles real** para cargar en `lupita_talle_*` (hoy son números de ejemplo: 87/93/99, 67/73/79, 93/99/105).
- [ ] **Videos alojados afuera de Tienda Nube**, con link directo a `.mp4`:
  - [ ] Portada: `_harness/out/video/portada.mp4` (3,2 MB) → `cover_video_url`
  - [ ] Cápsula: `_harness/out/video/capsula.mp4` (5,3 MB) → `capsule_video_url`
- [ ] **Fotos** de campaña; las del hero necesitan la zona de abajo al centro oscura (el título se apoya directo sobre la imagen).
- [ ] Direcciones revisadas por la clienta, sobre todo Belgrano 1470, Banfield.
- [ ] Horario confirmado: lunes a sábados de 10:30 a 19:30.

## 3. Verificación local (antes de subir)

- [ ] `node _harness/render.mjs` termina con `OK`.
- [ ] `node --test _harness/favoritos/logica.test.mjs` pasa.
- [ ] Se ven bien en `http://localhost:5200/` (`node _harness/servir.mjs`): `home`, `categoria`, `producto`, `carrito`, `asesor`, `dispositivos`.
- [ ] `git status` limpio y `git push` hecho: lo que se sube es lo que está en GitHub.

## 4. Subida por FTP

- [ ] FileZilla conectado por **FTP sobre SSL/TLS**.
- [ ] Modo de transferencia **binario** (en ASCII falla con `503 ASCII (text) data type is not supported`).
- [ ] Subidas **solo** estas cinco carpetas (~1,7 MB): `config/`, `layouts/`, `snipplets/`, `static/`, `templates/`.
- [ ] **No** subidas: `_harness/`, `docs/`, `node_modules/`, `LUPITA.md`, `README.md`, `PRODUCT.md`, `package*.json`.

## 5. Carga en el panel (sin tocar código)

- [ ] Los cuatro colores y las dos fuentes.
- [ ] Textos y fotos del carrusel, banners, orden de las secciones de la home.
- [ ] **Categorías reales**: arman el riel de secciones (las del harness son de mentira).
- [ ] Links de video de portada y cápsula.
- [ ] Grupo "Tiendas e Instagram de Lupita": `lupita_tienda_1/2/3` e Instagram.
- [ ] Grupo "Talle según medidas": la tabla real de la marca.
- [ ] Productos con fotos verticales y a la misma distancia; **ocasión y talle en nombre, etiquetas o variantes** (si no, la búsqueda del asesor vuelve vacía).

## 6. Revisión en la tienda arriba (lo que solo se puede probar ahí)

- [ ] `query` y `categories` llegan a la búsqueda (título "Resultados de …" y riel de categorías).
- [ ] `lupita.scss.tpl` y el JS llegan a la página de contraseña.
- [ ] El HTML real de `blog-post-item` y `blog-post-content` respeta las clases.
- [ ] `lupita-motion` convive con `store.js`; scroll infinito de la búsqueda.
- [ ] Modal de compra rápida, hoja de recomendados al agregar al carrito, segunda foto al pasar el mouse.
- [ ] Foco visible con teclado y `prefers-reduced-motion`.
- [ ] **Asesor:** el botón abre, el quiz recorre los tres pasos, `Escape` cierra, y la búsqueda (`store.search_url?q=…`) encuentra productos con el catálogo real.
- [ ] Favoritos, carrito y checkout completos de punta a punta en celular.
- [ ] Lo mismo en 320, 390 y 768 de ancho.
