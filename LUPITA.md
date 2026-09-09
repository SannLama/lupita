# Ahi! Lupita — theme de Tiendanube

Theme propio para la tienda de **Ahi! Lupita / Kit 'n Couch** (Lomas de Zamora y
Banfield), sobre el fork de [`TiendaNube/base-theme`](https://github.com/TiendaNube/base-theme).

El primer commit es el base oficial **sin tocar**, asi que `git diff 30d85ea`
muestra exactamente lo nuestro y nada mas.

---

## Antes que nada: esto todavia no se puede subir

Un theme propio se sube **por FTP**, y el acceso al FTP existe **desde el plan
Impulso** de Tiendanube. La tienda de Ahi! Lupita todavia no existe.

Y hay un efecto colateral que la clienta tiene que saber antes de decidir:
**al habilitar el FTP, la tienda pierde la posibilidad de cambiar de plantilla
desde el panel.** Es un camino de ida.

---

## Direccion de diseno

**Brutalismo suizo (Swiss Industrial Print) con el turquesa de la marca**, con la
densidad y la sobriedad de la grilla de Zara.

Por que esa mezcla y no Zara a secas: Zara puede permitirse el vacio blanco
porque cada foto es de estudio — mismo fondo, misma luz, mismo encuadre. Las
fotos de Ahi! Lupita son de los locales, con ladrillo a la vista y luz natural.
Buenas, pero **no comparten fondo entre si**, y flotando sobre blanco vacio se
ven desprolijas. La grilla brutalista con divisiones de 1px encierra cada foto
en su celda: la estructura hace el trabajo que en Zara hace la uniformidad
fotografica.

El logotipo ya venia en este idioma: `AHI ! LUPITA`, con el signo separado por
espacios, funciona igual que los simbolos que el brutalismo usa como piezas
geometricas.

### Valores

| | |
|---|---|
| Papel | `#F4F4F0` (no blanco puro: perdona fotos de luz despareja) |
| Tinta | `#0A0A0A` |
| Acento unico | `#6BB3B9` turquesa |
| Macro | Archivo Black, `clamp()`, tracking `-0.04em`, leading `0.9`, MAYUSCULAS |
| Micro | Roboto Mono, 0.58–0.84rem, tracking `0.08em`, MAYUSCULAS |
| Geometria | `border-radius: 0` y sin sombras en todo |

**El turquesa esta sacado a ojo del avatar de Instagram (un JPEG comprimido).
Hay que confirmarlo contra el logo original.**

Las dos fuentes salen del selector oficial del panel de Tiendanube, asi que la
clienta puede cambiarlas sin tocar codigo y Google Fonts las sirve solo.

---

## Que cambiamos del base

Tres archivos del theme, nada mas:

- **`config/defaults.txt`** — los cuatro colores, las dos fuentes y el orden de
  las secciones de la home (slider → destacados → categorias → modulos →
  instafeed → informativos → bienvenida → video).
- **`config/settings.txt`** — la paleta de la marca como primera opcion, para
  que la clienta pueda volver a los colores originales si toca algo.
- **`layouts/layout.tpl`** — carga `lupita.scss.tpl` **despues** de
  `style-async`, para ganar la cascada por orden de documento sin llenar todo
  de `!important`.

Y el sistema en si:

- **`static/css/lupita.scss.tpl`** — tokens, reset, tipografia, grilla, tarjeta
  de producto, botones y compartimentacion.

**No reescribimos `snipplets/grid/item.tpl`.** El marcado del base ya trae
quickshop, variantes, datos estructurados y lazy load; la hoja lo restila
entero por sus clases (`item-name`, `item-price`, `item-installments`). Menos
codigo propio que mantener y menos superficie para romper.

### Un detalle que salio gratis

El base ya renderiza `component('installments')` bajo cada producto. Ese
renglon — que en Zara dice "*Precio sin impuestos nacionales" — es donde cae
solo **"3 y 6 cuotas sin interes"**, que es el argumento de venta de esta marca.
La estructura que copiamos ya tenia el hueco hecho para su mejor dato.

---

## El hero de la home

Referencia: [tiendanapoli.com](https://www.tiendanapoli.com/) — slider a pantalla
completa con las fotos pasando solas, texto encima, contador discreto y flechas
finas. **El theme base ya traia la pieza** (`snipplets/home/home-slider.tpl`, con
Swiper): esto es configurarla y restilarla, no escribirla.

- `config/defaults.txt` → `slider_auto = 1`
- `static/js/store.js.tpl` → delay 6000 a 5000, y **autoplay tambien en mobile**.
  El base lo apagaba por debajo de 768px; el trafico de esta tienda viene de
  Instagram, o sea del telefono, que es justo donde un hero quieto no se
  entiende.

Dos cosas se apartan de la referencia a proposito:

1. **El texto no se apoya sobre la foto.** Napoli pone blanco directamente sobre
   la imagen, lo que depende de que ahi haya una zona oscura — y las fotos de
   Ahi! Lupita todavia no existen. Va dentro de un bloque macizo de tinta:
   contraste garantizado con cualquier foto, y ademas es brutalismo suizo puro
   (la skill prohibe los degradados con los que se suele tapar este problema).
2. **Contador `01 / 03` en vez de los puntitos**, sin tocar la plantilla: cada
   bullet incrementa un contador CSS, el activo muestra su numero, y el
   `::after` del contenedor — que se renderiza despues de todos los hijos —
   muestra el total.

Las fotos del slider las carga la clienta desde el panel (Diseño → Carrusel),
con titulo, descripcion, boton y link por slide.

---

## El harness (`_harness/`, NO se sube por FTP)

Tiendanube compila los `.tpl` en su servidor y no hay forma de correr eso
localmente. Esto no lo reemplaza: resuelve los `{{ settings.x }}` de la hoja
leyendo `config/defaults.txt` **de verdad**, y arma una pagina que replica el
DOM real de `item.tpl`.

O sea: **verifica el CSS, que es lo unico que escribimos nosotros.** No verifica
las plantillas ni las funciones propias de la plataforma.

```bash
node _harness/render.mjs     # genera _harness/out/
node _harness/servir.mjs     # http://localhost:5200/categoria.html
```

`dispositivos.html` renderiza home y categoria en **siete anchos** — 320, 390,
430, 768, 1024, 1280 y 1920 — dentro de iframes. Cada iframe genera su propio
viewport, asi que las media queries responden al ancho real; el `scale` es solo
para que entren todos en la pantalla, y un 1920 escalado a 0.32 **sigue siendo
un 1920** para el CSS de adentro.

Hace falta porque **Chrome en Windows no deja achicar la ventana por debajo de
~500px**: `resize_window` a 390 contesta que funciono, pero el viewport nunca
baja del breakpoint y se sigue mirando el layout de escritorio.

### Escalera de la grilla

| Ancho | Columnas |
|---|---|
| < 768 | 2 |
| 768 – 1099 | 3 |
| 1100 – 1599 | 4 |
| ≥ 1600 | 5 |

Arriba de 1100 la grilla **se suelta del `max-width` del container** apuntando a
`.template-category` (clase que el layout ya pone en el `<body>`), porque si no
queda encajonada al centro con franjas muertas a los costados. Se evita `100vw`
a proposito: mete scroll horizontal cuando hay barra de desplazamiento.

La hoja esta escrita como **CSS plano** a proposito (nada de anidado ni `$vars`
de SCSS): Tiendanube la compila igual, y asi el harness la sirve cruda sin
tener que compilar nada.

---

## Verificado / no verificado

**Visto en pantalla** en 320, 390, 430, 768, 1024, 1280 y 1920: la escalera de
2/3/4/5 columnas, las divisiones de 1px, los precios alineados por fila, las
cuotas en un renglon, el autoplay del hero corriendo y el contador avanzando, y
el logotipo y las cifras sin partirse.

**Sin verificar, y no se puede hasta que exista la tienda:** que las plantillas
compilen en su servidor, que `google_fonts_url` sirva Archivo Black (que tiene
un solo peso, y el layout pide `300, 400, 700`), que `color-mix()` sobreviva a
su compilador de SCSS, y el comportamiento real de quickshop, filtros y carrito.

---

## Pendientes con la clienta

1. **Logo vectorial** o el hex exacto del turquesa.
2. **La tercera direccion.** Instagram confirma España 137 y Loria 198 (Lomas);
   la de Banfield (Belgrano 1470) salio de guias comerciales, no de ella.
3. **Horarios y WhatsApp.** Las fuentes se contradicen (10:00–18:30 vs
   10:00–20:30). No rellenar por iniciativa propia.
4. **Plan Impulso**, con el aviso del camino de ida.
5. **Estandar de fotos.** La grilla aguanta fotos heterogeneas, pero mejora
   muchisimo si son verticales y a la misma distancia. Se logra con un celular
   y disciplina.

## Etapa 2 (cuando haya tienda)

Animaciones con GSAP, hero de campaña a sangre, segunda imagen al hover en la
grilla, y la revision de producto, carrito y cuenta con contenido real.
