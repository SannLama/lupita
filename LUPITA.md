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

- **`config/defaults.txt`** — los cuatro colores, las dos fuentes, el orden de
  las secciones de la home (slider → destacados → categorias → modulos →
  instafeed → informativos → bienvenida → video), la barra de aviso prendida
  con el 20% y las cuotas, y la cabecera en `light` y opaca (el base la traia
  `dark` y transparente sobre el hero).
- **`config/settings.txt`** — la paleta de la marca como primera opcion, para
  que la clienta pueda volver a los colores originales si toca algo.
- **`layouts/layout.tpl`** — carga `lupita.scss.tpl` **despues** de
  `style-async`, para ganar la cascada por orden de documento sin llenar todo
  de `!important`.

Y el sistema en si:

- **`static/css/lupita.scss.tpl`** — tokens, reset, tipografia, grilla, tarjeta
  de producto, botones, compartimentacion, y el marco entero: barra de aviso,
  cabecera, panel de navegacion, buscador y pie.

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

## El marco: barra de aviso, cabecera, menu, buscador y pie

Es lo que se ve en **todas** las paginas, y hasta ahora era el theme base sin
tocar. Ninguna plantilla se reescribio: todo sale de las clases que ya emiten
`header.tpl`, `navigation-panel.tpl`, `header-search.tpl` y `footer.tpl`.

### La barra de aviso

`ad_bar` prendida en `defaults.txt`, con **"20% OFF PAGANDO EN EFECTIVO — 3 Y 6
CUOTAS SIN INTERES"**. Franja de tinta con papel encima: es el unico lugar donde
el mejor dato de la marca aparece antes que cualquier foto. Los dos datos estan
confirmados por Instagram; el resto de los renglones del pie, no (ver mas abajo).

### La cabecera

El base la arma en tres columnas — hamburguesa / logo / utilidades — y esa
estructura se conserva, que es la de Zara. Lo que cambia es el peso: fondo papel
con una regla de 2px al ras, y todo lo demas en micro.

Cuatro cosas que no eran obvias:

1. **La cabecera pasa a `light` y opaca.** El base la traia `dark` y
   transparente sobre el hero. Transparente sobre foto es la misma apuesta que
   ya habiamos descartado en el hero: depende de que la foto tenga una zona
   oscura justo ahi.
2. **El logotipo llega con `class="h1"`**, y el `h1` del sistema es tamaño
   portada (`clamp` hasta 9rem). Sin acotarlo, la cabecera medía media pantalla.
3. **En 320 se partia en dos renglones.** Las tres columnas del base son
   tercios iguales y el del medio es mas angosto que la palabra. La columna del
   logo pasa a medir lo que mide el logo (`flex: 0 1 auto`) y las de los
   costados se reparten el resto.
4. **Los rotulos MENÚ y BUSCAR** se inyectan por `::after` — un icono
   hamburguesa sin palabra es la parte mas floja del base — pero con
   `{{ 'Menú' | translate }}`, no hardcodeados, asi siguen el idioma de la
   tienda. Solo arriba de 768, que es donde entran.
   ⚠️ El espacio despues de `\00a0` **cierra el escape**: sin el, `"\00a0B"` se
   lee como un solo codigo de seis digitos hexadecimales y BUSCAR salia como un
   cuadrito seguido de USCAR.

El contador de la bolsa va entre corchetes — `[0] `— que es la misma sintaxis
tecnica que usan los rotulos del resto del theme.

### El panel de navegacion

Es la unica pantalla del theme sin fotos: puro texto, asi que se trata como
tipografia macro. Cada rubro es un bloque con su division de 1px que cruza el
panel entero, igual que las celdas de la grilla, y el hover invierte el bloque
completo. Los subrubros bajan a micro para no competir con el rubro que los
contiene. La unidad de cuenta queda abajo, separada por una regla de 2px.

### El buscador

Un renglon macro sobre una regla de 2px, sin caja: la unica forma de campo que
no contradice el "sin bordes redondeados, sin sombras".

### El pie

El base lo centra todo, y centrado no hay grilla. Cada unidad pasa a la
izquierda y el contenedor usa **el mismo recurso que la grilla de productos**:
`gap: 1px` sobre fondo linea. Ademas de compartimentar, resuelve que el pie
fuera una columna larga con medio ancho de pantalla vacio al lado.

Va en **flex y no en grid** a proposito: con grid, las columnas que sobran
quedan vacias y dejan ver el fondo de linea como un bloque gris. Y las filas
anchas (newsletter, tira de logos, firma legal) se eligen **por clase, no por
posicion**: social, menu y logos son opcionales y la clienta los prende y apaga
desde el panel, asi que cualquier regla basada en `nth-child` se rompia sola.

Los logos de medios de pago y envio van en escala de grises: vienen en los
colores de cada marca y son una fuga de color en una paleta de tres.

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
node _harness/servir.mjs     # http://localhost:5200/home.html
```

**Se puede recorrer**: la cabecera, el boton del hero y las tarjetas navegan
entre `home.html`, `categoria.html` y `producto.html`; las flechas y los puntos
del slider funcionan (reinician el reloj del autoplay, como hace Swiper); y
**MENÚ y BUSCAR abren sus paneles**, con velo y cierre, como los modales del
base. La ficha de producto replica el DOM de `templates/product.tpl`.

Ademas del CSS, ahora resuelve `{{ 'Texto' | translate }}`, que es como la hoja
inyecta los rotulos de la cabecera.

Dos numeros del andamio salen del Bootstrap que viene embebido en
`style-critical.tpl`, no inventados: el `padding` del `.container` es **15px**
(en 320, esos 18px de diferencia contra `1.5rem` deciden si la cabecera entra en
un renglon) y los iconos de utilidades miden **15px fijos**, porque el base les
pone `icon-w-14`/`icon-w-16` y no dependen del cuerpo del texto de al lado.

⚠️ **Lo que el harness todavia no replica:** el `max-width` del `.container` del
base es 1140px arriba de 1200, y aca son 1600. La home y la ficha de producto
van a ser mas angostas en la tienda de lo que se ven aca. No rompe nada, pero
las capturas de 1280 y 1920 son mas anchas que la realidad.

`dispositivos.html` renderiza home, categoria y producto en **siete anchos** —
320, 390, 430, 768, 1024, 1280 y 1920 — dentro de iframes. Cada iframe genera su propio
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

**Del marco, tambien visto en pantalla:** la barra de aviso, la cabecera en un
solo renglon en los siete anchos (incluido 320), los rotulos MENÚ y BUSCAR
apareciendo recien en 768, el panel de navegacion abriendo con sus divisiones al
ancho completo y el hover invirtiendo el bloque, el buscador, y el pie
repartiendose en tres columnas arriba de 768 y apilandose de a una abajo.

**Sin verificar, y no se puede hasta que exista la tienda:** que las plantillas
compilen en su servidor, que `google_fonts_url` sirva Archivo Black (que tiene
un solo peso, y el layout pide `300, 400, 700`), que `color-mix()` sobreviva a
su compilador de SCSS, y el comportamiento real de quickshop, filtros y carrito.

Del marco en particular: **el logo como imagen** (el harness solo prueba el
logotipo tipografico, que es el que usa el base cuando no hay imagen cargada),
**los modales de verdad** — el harness los abre y los cierra, pero la
animacion, el bloqueo del scroll y el acordeon de subrubros los maneja
`store.js` en la tienda — y el **panel del carrito**, que todavia no se toco.

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

6. **El menu.** Los rubros del panel (`Vestidos`, `Pantalones`, `Abrigos`…) son
   de mentira, igual que las prendas del harness: sirven para ver el bloque, no
   para decidir el menu. Eso sale del catalogo real.

## Lo que sigue en el codigo

Sin depender de la clienta: el **panel del carrito** (`cart-panel.tpl`), los
**filtros y el orden** de la categoria, y los **formularios** (contacto, cuenta,
checkout). Son las tres piezas del theme que todavia estan con el estilo del
base.

## Etapa 2 (cuando haya tienda)

Animaciones con GSAP, hero de campaña a sangre, segunda imagen al hover en la
grilla, y la revision de producto, carrito y cuenta con contenido real.
