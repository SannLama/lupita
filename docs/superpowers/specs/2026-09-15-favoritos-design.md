# Favoritos: "guardala y probátela en el local"

Fecha: 2026-09-15 · Estado: diseño aprobado en chat

## Objetivo

Wishlist propia del theme (sin app) cuyo fin no es comprar después online sino
**venir a probarse las prendas a los locales**. Tres invitaciones: texto con la
dirección del panel, botón de WhatsApp con la lista armada, y un aviso al
guardar.

## Decisiones

- **Almacenamiento:** `localStorage`, clave `lupita:favoritos`, máximo 50
  prendas (se descarta la más vieja). No se sincroniza entre dispositivos ni
  da estadísticas — aceptado. Si el navegador no deja guardar (modo privado),
  el módulo **no muestra los corazones**.
- **Datos por prenda:** `{ id, nombre, url, imagen, precio, variante }`,
  leídos de atributos `data-fav-*` que pone Twig. `variante` ("Talle M /
  Negro") solo se completa desde la ficha, leyendo lo elegido al guardar.
- **Clave:** el `id` del producto. Guardar de nuevo el mismo producto con otra
  variante actualiza la variante, no duplica.

## Piezas

| Pieza | Archivo |
|---|---|
| Lógica pura (con tests) | `_harness/favoritos/logica.mjs`, `logica.test.mjs` |
| Interfaz (DOM) | `_harness/favoritos/entrada.mjs` |
| Build | `_harness/favoritos/build.mjs` → `static/js/lupita-favoritos.js.tpl` |
| Botón corazón | `snipplets/favoritos/boton.tpl` |
| Panel | `snipplets/favoritos/panel.tpl`, embebido en `header.tpl` con `modal.tpl` |
| Acceso en cabecera | `snipplets/header/header-utilities.tpl` |
| Estilos | `#Favoritos` al final de `lupita.scss.tpl` |

### Corazón
- Tarjetas (`item.tpl`, dentro de `floating_elements`, arriba a la derecha
  de la foto), ficha (`product-form.tpl`, al lado de agregar al carrito) y
  compra rápida (`quick-shop.tpl`: vacío al render, el JS le copia los
  `data-fav-*` de la tarjeta que abrió el modal).
- `<button type="button" class="js-fav lu-fav" aria-pressed aria-label>`:
  "Guardar en favoritos" / "Quitar de favoritos". Guardado = corazón relleno
  en tinta sobre cuadrado turquesa (8,27:1). Sin guardar = contorno en tinta
  sobre papel.
- Nace con `hidden`; el JS lo muestra solo si hay `localStorage`.

### Aviso
Fijo abajo, `role="status"`: "Guardada. Probátela en cualquiera de los
locales" + link "Ver favoritos". Se va a los 3,5 s. Sin desplazamiento con
`prefers-reduced-motion`.

### Cabecera y panel
- Corazón al lado de la bolsa con `[n]`, abre `#modal-favoritos`
  (`js-modal-open`, mismo mecanismo que el carrito).
- Panel: título "Favoritos"; arriba "Vení a probártelas" + `store.address`
  (si hay); lista (foto, nombre, variante, precio, link, quitar); vacío:
  "Todavía no guardaste nada. Tocá el corazón en las prendas que quieras
  probarte."; pie: "Reservar para probármelas" → WhatsApp con
  `Hola! Quiero probarme estas prendas en el local:` + una línea por prenda.
  Solo si `store.whatsapp` existe.

## Verificación
`node --test _harness/favoritos/`; harness con corazones y panel; capturas
1440/390.

## Sin verificar hasta que exista la tienda
Formato real de `store.address` y `store.whatsapp`; que `js-modal-open`
abra un modal nuevo sin tocar `store.js`; que el modal de compra rápida
conserve el botón al rellenarse.

## Pasos
1. Tests de la lógica (rojo) → lógica (verde).
2. Interfaz + build.
3. Twig: botón, panel, cabecera, tarjeta, ficha, compra rápida, layout.
4. CSS `#Favoritos`.
5. Harness + capturas.
6. Documentación (`LUPITA.md`, vault, memoria).
