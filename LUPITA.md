# Ahi! Lupita — theme de Tiendanube

Theme propio para la tienda de **Ahi! Lupita / Kit 'n Couch** (Lomas de Zamora y
Banfield), sobre el fork de [`TiendaNube/base-theme`](https://github.com/TiendaNube/base-theme).

El primer commit es el base oficial **sin tocar**, asi que `git diff 30d85ea`
muestra exactamente lo nuestro y nada mas.

---

## Antes que nada: esto todavia no se puede subir

Un theme propio se sube **por FTP**, y el acceso al FTP existe **desde el plan
Impulso** de Tiendanube. La tienda de Ahi! Lupita todavia no existe.

Y hay tres efectos colaterales que la clienta tiene que saber **antes** de
decidir. Estan abajo, en "Las tres letras chicas".

---

## Puesta en produccion

No hay nada que "conectar": **esto es la tienda**. No hay una API en el medio —
los `.tpl` los renderiza el servidor de Tiendanube, asi que subir el theme *es*
el deploy.

*(Verificado contra la documentacion de Tiendanube el 2026-09-10. Los precios se
mueven; el procedimiento, menos.)*

### Los pasos

1. **Crear la tienda** en Tiendanube. Hoy no existe: ese es el bloqueo real.
2. **Plan Impulso o superior.** Lo que hace falta se llama **"edicion
   estructural"** en su documentacion, y esta *desde* Impulso. En el gratuito y
   en Inicial no hay forma de subir un theme propio, por mas que el codigo este
   listo. A septiembre de 2026 su propio blog lo publica en **$234.999/mes, con
   25% off pagando anual** — confirmarlo en el panel antes de prometer nada.
3. **Habilitar el FTP** desde el panel: *Tienda online → Diseño → "Editar el
   codigo"* sobre la plantilla actual. De ahi salen las credenciales — host,
   usuario, contraseña y puerto.
4. **Conectar con FileZilla** (el cliente que ellos mismos recomiendan), con dos
   ajustes que no son opcionales:
   - **FTP sobre SSL/TLS**.
   - **Modo de transferencia binario, NO ASCII.** En ASCII tira
     `503 ASCII (text) data type is not supported for file transfer operations`.
5. **Subir cinco carpetas y nada mas:** `config/`, `layouts/`, `snipplets/`,
   `static/`, `templates/`. Son ~1,5 MB.
   **No se suben** `_harness/` (es local, para mirar el CSS), `LUPITA.md` ni
   `README.md`.
6. **Activar y revisar** la lista de "Sin verificar" de mas abajo, que es
   justamente lo que recien se puede probar con la tienda arriba.

### Las tres letras chicas

1. ⚠️ **Es un camino de ida.** Con el FTP abierto, la tienda **pierde la
   posibilidad de cambiar de plantilla desde el panel**.
2. ⚠️ **Deja de recibir las mejoras automaticas de diseño de Tiendanube.** Las
   tiendas con FTP abierto quedan afuera de sus actualizaciones. De ahora en
   mas, el mantenimiento del theme es nuestro.
3. ⚠️ **Si despues se cierra el FTP, se pierden TODAS las personalizaciones.**
   Tiendanube no preserva nada. **El respaldo es este repo git** — por eso el
   primer commit es el base sin tocar y por eso conviene que siga siendo la
   fuente de verdad, no los archivos que queden en su servidor.

### Lo que maneja la clienta una vez arriba

Sin tocar codigo, porque para eso esta escrito `config/settings.txt`: los cuatro
colores y las dos fuentes, las fotos y textos del carrusel, los banners, el
orden de las secciones de la home, y **las categorias del catalogo, que son las
que arman el riel de secciones**. Por eso las secciones no las decidimos
nosotros: se cargan y aparecen.

### Si se quedan en el plan gratuito

Este theme no se puede subir, y la salida es la que ya estaba archivada: **dos
sitios separados**, una landing propia que linkea a la tienda con la plantilla
default de Tiendanube. Peor, pero existe.

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
| Macro | **Italiana** (desde el 2026-09-11), `clamp()`, tracking `0.02em`, leading `1`, MAYUSCULAS |
| Micro | Roboto Mono, 0.58–0.84rem, tracking `0.08em`, MAYUSCULAS |
| Marca | Archivo Black — logotipo, menu, buscador, TOTAL del carrito |
| Geometria | `border-radius: 0` y sin sombras en todo |

**El turquesa esta sacado a ojo del avatar de Instagram (un JPEG comprimido).
Hay que confirmarlo contra el logo original.**

### 🔴 Cuatro voces desde el 2026-09-15: Great Vibes, Caveat, Instrument Sans y Roboto Mono

Santiago pidio **Liza Pro** para titulos, **Brown Sugar** (la manuscrita de
KA Designs, no la serif de Muntab Art) para subtitulos e **Instrument Sans**
para el texto. Liza Pro (Underware, licencia web por paginas vistas) y Brown
Sugar son pagas; eligio reemplazos libres de Google Fonts sobre una hoja de
muestras con 16 candidatas: **Great Vibes** y **Caveat**.

| Rol | Fuente | Token | Como se carga |
|---|---|---|---|
| Titulos (h1, h2, hero, modulos, compra rapida, blog, 404) | Great Vibes | `--lu-macro` | panel: `font_headings` |
| Subtitulos (h3–h5, descripciones del hero/portada/capsula, descripcion de categoria, texto de banners, mensaje de tienda cerrada) | Bodoni Moda (antes Caveat) | `--lu-sub` | fija |
| Texto corrido (body, descripcion de producto, `.user-content`, bienvenida, servicios, newsletter) | Instrument Sans | `--lu-texto` | panel: `font_rest` |
| Rotulos, precios, menu, botones, migas, formularios | Roboto Mono | `--lu-micro` | fija |
| Logotipo, TOTAL | Archivo Black | `--lu-marca` | fija |

- **Los titulos perdieron la MAYUSCULA y el tracking**: una script ligada en
  versales no se lee y el tracking separa letras que tienen que tocarse.
  Tamaños un ~25% mas grandes (la x es baja) e interlineado 1.15 para que los
  adornos no pisen el renglon de abajo. La mascara del titulo de la nota
  (`.lu-mascara`) se abrio en los cuatro lados: recortaba las colas.
- **Las fijas se cargan con un `<link>` a Google Fonts en `layout.tpl` y
  `password.tpl`.** El panel solo carga `font_headings` y `font_rest`.
- 🔴 **Bug encontrado de paso: Archivo Black no se cargaba en ningun lado.**
  Desde que `font_headings` paso a Italiana (2026-09-11), en la tienda el
  logotipo, el menu y el TOTAL iban a salir en la sans del sistema. El harness
  no lo mostraba porque su `CABEZA` carga Archivo Black por su cuenta — otra
  regla del andamio que no es la de la tienda.
- **Subtitulos: Caveat → Bodoni Moda (mismo dia).** Santiago pidio **Bigilla**
  (Jeremie Gauthier), pero es "free to try only": la web comercial necesita
  licencia paga. Bigilla por dentro trae solo `liga` (29 ligaduras) y `aalt`
  (~30 alternates). Entre libres con alternates reales se compararon Bodoni
  Moda, Cormorant Garamond, Instrument Serif, Playfair, Fraunces y Gloock
  (hoja de muestras, normal vs. con features); Bodoni Moda es la mas cercana
  por contraste de didona. Va en peso 400 con `dlig`, `hlig` y `ss01`
  prendidos (#Subtitulos, al final de la hoja).
- **Carrito y menu hamburguesa en Instrument Sans, minuscula normal**,
  TOTAL incluido (#Carrito y menu en la voz del texto). Se pisa con `body`
  delante de cada selector, sin `!important`.
- **Tarjeta y efectivo en el carrito:** con "Descuento por medio de pago"
  prendido en el panel (`payment_discount_price`), el TOTAL pasa a "Total con
  tarjeta", chico y al 60%, y el `component('payment-discount-price')` —que
  el base ya traia debajo— recibe clases propias (`lu-efectivo-precio`) y va
  grande en turquesa. ⚠️ Turquesa sobre papel = 2,17:1: Santiago lo eligio
  asi sabiendolo. **Sin verificar:** el HTML real del componente (el harness
  lo deduce) y que prender el checkbox tambien muestra el precio en efectivo
  en la grilla, la ficha y la compra rapida, que no se estilaron.
- **La frase de bienvenida del home salia ilegible:** `style-critical` le pone
  `text-transform: uppercase` a `.welcome-title` y el `h2` del base trae
  `font-weight: 700` — Great Vibes en versales y engordada a mano. Se piso en
  `#Bienvenida` (sin mayuscula, peso 400, mas grande). Revisado el resto del
  CSS base: era el unico titulo con mayuscula forzada.
- `settings.txt` suma Great Vibes y Caveat a las dos listas del panel;
  `defaults.txt` arranca con Great Vibes / Instrument Sans.
- **Sin verificar:** el layout pide pesos `300, 400, 700` y Great Vibes solo
  tiene 400 (mismo caso que tenia Italiana) — ver que el componente `fonts` no
  rompa la URL de Google Fonts.
- **Si compran las licencias:** Liza Pro y Brown Sugar van en `static/fonts/`
  con `@font-face` usando `static_url`, y se cambian `--lu-macro` / `--lu-sub`.
  Nada mas.

### El macro paso de Archivo Black a Italiana (2026-09-11) — reemplazado el 2026-09-15

Santiago pidio una tipografia "romantica y delicada" para los titulos
grandes, viendo el sistema con fotos reales. Eligio el alcance mas acotado
de los tres que le ofreci: **solo los titulos de contenido** (hero, Portada,
Capsula, el `<h1>` de categoria y de producto) — no todo el sistema.

Eso obligo a separar dos cosas que hasta ese dia usaban la misma variable:

- **`--lu-macro`** (`font_headings` del panel) → pasa a **Italiana**. Le
  quedan `h1`, `h2`, `h3-h5` y los `swiper-title` del hero/Portada/Capsula.
  El tracking negativo que le quedaba bien a Archivo Black (una masa solida
  de letras) aprieta una serif fina: pasa a positivo (`0.02em` en los
  titulos grandes, `0.01em` en h3-h5).
- **`--lu-marca`** (nueva, fija en `"Archivo Black", sans-serif`, NO sale de
  `font_headings`) → el logotipo, el menu de navegacion, el buscador y el
  TOTAL del carrito. Son identidad de marca y una cifra de plata, no
  titulos de contenido, y se quedan bold aunque la clienta cambie
  `font_headings` desde el panel.

**Efecto secundario, a proposito:** antes, si la clienta cambiaba la
tipografia de titulos desde el panel, el logotipo cambiaba con ella — un
acoplamiento que nadie habia pedido. Ahora el logotipo es fijo, y eso es
mejor comportamiento, no una regresion.

### ⚠️ El turquesa funciona con tinta, no con papel

Medido el 2026-09-10, no estimado:

| | Ratio | Sirve para |
|---|---|---|
| Turquesa sobre papel | **2.17:1** | nada |
| Papel sobre turquesa | **2.17:1** | nada |
| **Tinta sobre turquesa** | **8.27:1** | texto y graficos |
| Tinta sobre papel | 17.96:1 | todo |

WCAG pide 4.5:1 para texto chico y 3:1 para elementos graficos que transmiten
informacion. `#6BB3B9` es un color de luminancia media: **no contrasta ni con el
papel ni con el blanco**, en ninguna de las dos direcciones. Con la tinta, si.

Lo que implica: el acento sirve como **fondo con letras oscuras encima**, y no
como color de texto sobre papel ni con texto claro encima.

**Corregido:** la barra de envio gratis del carrito y el boton del hero
(2026-09-11), y el resto de la lista (2026-09-14) — la etiqueta OFERTA, el
boton primario, el boton del newsletter, y todos los links/rotulos sueltos en
turquesa ("borrar filtros", los accordion de talle/color, el `strong` de las
cuotas, los links de cabecera/carrito/footer/barra de aviso). Fondos en
turquesa pasan a texto en tinta (8.27:1); los links sueltos, tinta con
subrayado. Quedan sin tocar los dos bordes en turquesa (foco del buscador y
`.alert-success`) — son borde, no texto, y no estaban en esta lista.

Las dos fuentes salen del selector oficial del panel de Tiendanube, asi que la
clienta puede cambiarlas sin tocar codigo y Google Fonts las sirve solo.

---

## Que cambiamos del base

Tres archivos de configuracion:

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
  de producto, botones, compartimentacion, el marco entero (barra de aviso,
  cabecera, panel de navegacion, buscador, pie) y las secciones y filtros.

Y tres plantillas, con el cambio mas chico posible en cada una — todas por lo
mismo, sacar las secciones a la vista (ver "Buscar por secciones"):

- **`templates/category.tpl`** — el riel de secciones arriba de la grilla, y
  las secciones fuera del modal de filtros.
- **`snipplets/grid/categories.tpl`** — una rama `horizontal` que devuelve la
  misma lista en linea, sin acordeon. La lista vertical del base queda intacta.
- **`snipplets/grid/filters.tpl`** — **una palabra**: la clase `lu-aplicados`
  en el contenedor de "Filtrado por:", que no tenia ningun gancho propio.

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

Una cosa se aparta de la referencia a proposito:

1. **Contador `01 / 03` en vez de los puntitos**, sin tocar la plantilla: cada
   bullet incrementa un contador CSS, el activo muestra su numero, y el
   `::after` del contenedor — que se renderiza despues de todos los hijos —
   muestra el total.

Las fotos del slider las carga la clienta desde el panel (Diseño → Carrusel),
con titulo, descripcion, boton y link por slide.

### El texto va sobre la foto, sin nada atras

Hasta el 2026-09-10 el titulo iba adentro de un bloque macizo de tinta,
justamente para no depender de la foto. **Santiago pidio sacar el negro**, asi
que ahora se apoya directo sobre la imagen, en crema, como en Napoli.

⚠️ **Esto pasa a depender de cada foto de campaña.** Si la imagen es clara
justo donde cae el titulo, el texto se pierde, y no hay red de contencion: la
unica que existe sin degradados — que la direccion prohibe — es volver al
bloque. **Cuando lleguen las fotos hay que mirar slide por slide**, y si alguna
no aguanta, las salidas son recortar la foto para que la zona del titulo quede
oscura, o volver al bloque solo en esa.

**El 2026-09-11 llegaron 4 fotos reales de prueba** (una modelo, no material
oficial de la clienta todavia) y confirmaron exactamente este riesgo: en una
foto de playa clara (cielo y arena debajo del titulo) "NUEVA TEMPORADA" en
crema casi desaparecia. Ahi aparecio el bug de fondo: **el propio
`home-slider.tpl` del base ya manda `slide.color` → clase `swiper-white` /
`swiper-black`**, que es el selector de color de texto por slide que la
clienta tiene en el panel — pero nuestra hoja fijaba `color: var(--lu-papel)`
directo en `.swiper-text` sin mirar esa clase, asi que el selector del panel
no hacia nada. Se arreglo: ahora el color sale de `.swiper-white` /
`.swiper-black`, y con la foto de playa en negro el titulo se lee perfecto. La
clienta va a poder resolver una foto clara sola, desde el panel, sin pedirnos
nada. Las fotos de prueba quedaron en `_harness/img/` (no se suben por FTP) y
el harness las usa en vez del gris — ver el hero en `home.html`.

---

## El marco: barra de aviso, cabecera, menu, buscador y pie

Es lo que se ve en **todas** las paginas, y hasta ahora era el theme base sin
tocar. Ninguna plantilla se reescribio: todo sale de las clases que ya emiten
`header.tpl`, `navigation-panel.tpl`, `header-search.tpl` y `footer.tpl`.

### La barra de aviso

`ad_bar` prendida en `defaults.txt`, con **"20% OFF PAGANDO EN EFECTIVO — 3 Y 6
CUOTAS SIN INTERES"**. Es el unico lugar donde el mejor dato de la marca aparece
antes que cualquier foto. Los dos datos estan confirmados por Instagram; el
resto de los renglones del pie, no (ver mas abajo).

Nacio como franja de tinta con papel encima. **El 2026-09-10 Santiago pidio
sacar el negro**, asi que quedo como rotulo tecnico sobre papel, separado de la
cabecera por una regla de 1px para que las dos no se lean como un solo bloque.

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

## Movimiento

Criterio tomado de *Designing Fluid Interfaces* (WWDC). **Se aplica la fisica,
no el material.**

⚠️ **Lo que NO se aplica, a proposito:** materiales translucidos,
`backdrop-filter`, sombras contextuales y esquinas redondeadas. Toda esa parte
de la guia contradice la direccion del theme — brutalismo suizo, 90 grados, sin
sombras y sin degradados. La forma en que se mueven las cosas es prestable; el
material de iOS no.

### El hallazgo: el base anima `left`, no `transform`

`.modal { transition: all .2s }` con `.modal-left { left: -100% }` →
`.modal-left.modal-show { left: 0 }`.

Animar `left` en un elemento de **alto completo** obliga al navegador a
recalcular layout y repintar en **cada frame**; `transform` lo resuelve el
compositor. Es la diferencia entre suave y con tirones en un telefono — que es
de donde viene el trafico de esta tienda.

El arreglo no toca ni una plantilla ni el `store.js`: el panel se ancla en su
posicion final (`left: 0` / `right: 0`) y se lo corre con
`transform: translate3d()`. La clase que dispara todo sigue siendo la suya,
`.modal-show`.

Y `transition: all` pasa a `transition-property: transform`, para que no se le
escape ninguna propiedad de layout.

### Curvas

| | Duracion | Curva |
|---|---|---|
| Entrada | 340ms | `cubic-bezier(0.16, 0.84, 0.44, 1)` — frena al llegar |
| Salida | 260ms | `cubic-bezier(0.56, 0, 0.84, 0.16)` — la inversa |

Son una el espejo de la otra: lo que se fue por la izquierda vuelve por la
izquierda, con el mismo recorrido al reves.

**Sin rebote a proposito.** El rebote se justifica cuando el gesto trajo
inercia — un flick, un arrastre —, y aca todo se abre con un toque. Un panel
que rebota despues de un click se siente decorativo.

### Respuesta al apretar

Lo primero de la guia: el estado se muestra **al apretar, no al soltar**. Un
boton que solo reacciona al hover no existe en un telefono. Ahora los botones,
las fichas, el riel de secciones, los rubros del menu y los `+/-` del carrito
se invierten en `:active`, con `transition-duration: 0s` para que sea inmediato.

La *forma* de la respuesta es la del theme y no la de iOS: en vez de encoger el
elemento se lo invierte, que es el mismo idioma que ya usa el hover.

### La foto respira

Unico movimiento continuo del catalogo: `scale(1.04)` en 420ms al pasar por
encima. Es transform puro y la celda ya trae `overflow: hidden`, asi que la
foto crece **dentro** de su division de 1px y no pisa la de al lado.

El nombre se **subraya** en vez de cambiar de color, porque el turquesa sobre
papel da 2.17:1 (ver la nota de contraste).

### Movimiento reducido

El theme no tenia nada. Ahora `prefers-reduced-motion: reduce` cambia el
desplazamiento por un fundido corto de 160ms y apaga el `scale` de las fotos
(grilla de productos y banners de categoria). **No es "sin feedback"**: los
cambios de color se quedan, porque ayudan a entender que paso.

El unico caso que CSS no puede apagar es el video en loop de la Capsula
(`home-capsule.tpl`): un fondo en movimiento continuo es justo lo que la guia
marca como riesgo, y pausar un `<video>` necesita JS. Un script inline chico
lo saca de `autoplay` y lo deja en el primer frame si `matchMedia` detecta
`prefers-reduced-motion: reduce`. Sin probar en pantalla todavia: el mock del
harness dibuja la Capsula a mano con una `<img>` de reemplazo (no hay link de
video real puesto), asi que no pasa por `home-capsule.tpl` — recien se ve con
la tienda arriba o con un `capsule_video_url` real.

### Lo que esto NO es

**Son transiciones CSS, no resortes.** Una transicion no se puede agarrar y
revertir a mitad de camino — que es, segun la propia guia, el principio mas
importante. Para eso hacen falta resortes en JS con traspaso de velocidad, y
los paneles los abre el `store.js` de Tiendanube. Eso es Etapa 2 y recien se
puede probar con la tienda arriba: arrastrar el panel del carrito para cerrarlo,
con proyeccion de inercia y rubber-banding en el borde.

---

## El panel del carrito

El ultimo lugar donde alguien duda antes de pagar, asi que todo lo que no sea
la cifra o el boton se corre a un lado. Comparte snipplets con la pagina del
carrito (`cart-item-ajax.tpl` y `cart-totals.tpl`), asi que casi todo esto
sirve para las dos; lo que difiere va scopeado a `#modal-cart`.

### El renglon de producto tenia trece columnas de doce

`cart-item-ajax.tpl` arma cada renglon con `col-2` (foto) + `col-10`
(contenido) + `col-1` (tacho). **Suman 13**, asi que el tacho se caia a una
linea propia. En grilla explicita — `56px 1fr auto` — entra donde tiene que
entrar, y de paso queda la division de 1px que usa el resto del theme.

### Lo demas

- **`[− 1 +]` es una sola pieza** encerrada en 1px, no tres controles sueltos.
  Ojo: los signos vienen con class `btn`, y el `.btn` del sistema es un bloque
  macizo con padding grande — sin neutralizarlo, cada signo mide como un boton
  de comprar. Lo mismo con el tacho.
- **El TOTAL es la unica cifra macro del panel.** Llega con `class="h2"`, que es
  una clase de Bootstrap y **no** el elemento `h2`, asi que la escala macro no
  lo agarraba sola.
- ⚠️ **En 380px "TOTAL: $ 219.500" no entra en un renglon** y la cifra se partia
  despues del signo — `$` / `219.500` —, que es exactamente el error que ya
  habiamos corregido en la grilla de productos. En el panel se apilan: la
  palabra baja a rotulo y la cifra se queda con el renglon entero.
- **Los avisos** dejan de tener fondos de color. El que informa se queda en una
  regla de 1px; el que **frena una compra** — sin stock, monto minimo — se pone
  macizo en tinta. Son las dos unicas veces que el theme le corta el paso a
  alguien, y se nota.
- **La barra de envio gratis va en tinta**, no en el turquesa de la marca. Ver
  la nota de contraste mas arriba: el acento da 2.17:1 contra el papel y esta
  barra transmite informacion.

---

## Buscar por secciones

**Ahi! Lupita vende solo ropa de mujer.** No hay un nivel de genero que
separar, asi que las secciones son directamente las prendas — vestidos,
pantalones, abrigos — y eso cambia el diseno: caben todas en un renglon, sin
menu de dos pisos.

### El problema

El base **ya trae** la lista de secciones (`filter_categories`), pero la mete
**adentro del modal de filtros**: a un click de distancia, detras de un boton
que dice "Filtrar", y sin ninguna pista de que ahi adentro haya secciones. En
una tienda de ropa, recorrer secciones no es filtrar: es la forma normal de
mirar.

### El riel

Las secciones salieron del modal y quedaron en un riel a la vista, arriba de la
grilla. Misma mecanica que la grilla de productos — `gap: 1px` sobre fondo
linea —, y el ancho se acomoda solo:

- Cuando entran, las celdas crecen y el riel ocupa el ancho completo.
- Cuando no, se recorre de costado, como en cualquier tienda de ropa. El nombre
  cortado en el borde es la pista de que hay mas.

Esto sale de `width: max-content` mas `min-width: 100%` en la lista: el primero
la mide por su contenido, el segundo la estira hasta el container cuando sobra
lugar, y ahi recien el `flex-grow` reparte.

El **modal de "Filtrar" queda para lo que es un filtro de verdad**: talle,
color, precio. Y como ya no tiene secciones adentro, el boton dejo de abrirse
cuando lo unico que habia era una lista de categorias.

### Lo que no se pudo hacer

**La seccion activa no se marca.** `filter_categories` da `name` y `url` y nada
mas — no hay un `selected` ni forma confiable de compararlo — asi que el riel no
sabe en cual esta parado el visitante. El titulo de la pagina lo dice igual, en
Archivo Black y a pantalla completa.

**No hay contador de prendas.** Ninguna variable verificada del base devuelve
el total de una categoria (`pages.amount` cuenta paginas, no productos). El
rotulo "12 prendas" que el harness mostraba antes lo habia inventado yo: se
saco.

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

⚠️ **El andamio va ANTES de `lupita.css`**, que es como se cargan en la tienda
(`layout.tpl` mete la nuestra despues de `style-async`). Estuvo al reves hasta
que el andamio empezo a copiar reglas del base que nuestra hoja pisa — la
casilla de filtro, el `.filter-link` —: cargado despues, le ganaba los empates
de especificidad y el harness mostraba lo contrario de lo que va a pasar.

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

### Desde el 2026-09-15: dos paginas mas y un andamio mas fiel

`carrito.html` replica `templates/cart.tpl` (los renglones con
`cart_page = true`, el calculador de envio y el resumen pegado a la derecha)
y `pagina.html` replica `page.tpl` — migas, encabezado, texto institucional
con lista y tabla de talles — y debajo trae un **muestrario** de las piezas
que no tienen pagina propia donde verse: la notificacion de "agregado al
carrito", la busqueda sin resultados, los cuatro avisos, las etiquetas y el
banner de cookies. La home suma las cuatro secciones del base que faltaban
(servicios, modulo de imagen y texto, bienvenida, Instagram) y todas las
paginas llevan el boton flotante de WhatsApp.

El andamio copio mas reglas del base (`style-critical` + `style-async`):
los titulos por clase (`.h1`…`.h6`), el WhatsApp verde, la notificacion con
su rotacion 3D, los banners con su `padding-top: 100%` y su chip centrado,
los servicios, la bienvenida, el instafeed, y **las utilidades de Bootstrap
con su `!important`** (`.text-center`, `.mb-5`, `.text-right`…). Eso
destapo tres cosas que en el harness viejo se veian bien y en la tienda no
iban a verse — ver "2026-09-15" mas abajo.

### Mirarlo sin la extension de Chrome

Si la extension no conecta, sirve **Edge headless** (Chrome no esta en esta
maquina):

```
"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --headless=new
  --disable-gpu --hide-scrollbars --window-size=1440,4000
  --screenshot=home.png http://localhost:5200/home.html
```

Dos trampas: (1) **tampoco baja de ~500px de ancho**, asi que para mobile
hay que envolver la pagina en un `<iframe width="390">` (mismo truco que
`dispositivos.html`); (2) una captura de 6000px de alto se lee mal —
conviene un iframe con `margin-top` negativo adentro de una caja con
`overflow: hidden`, que hace de ventana sobre un tramo de la pagina.

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

**Despues de sacar los dos negros (2026-09-10):** la barra de aviso en papel con
su regla, y el hero sin bloque, en los siete anchos. Sobre las fotos falsas del
harness — un gris medio — **el titulo se lee flojo**, que es exactamente el
riesgo anotado arriba: lo decide la foto real, no el CSS.

**Con fotos reales (2026-09-11):** las 4 fotos de prueba en pantalla, en
desktop. Con `swiper-white`, las tres fotos oscuras/de contraste medio (rocas,
selfie urbano, restaurante) se leen bien. La foto de playa clara, en blanco,
confirmaba el riesgo — con `swiper-black` (arreglado el selector de color por
slide, ver arriba) se lee perfecto. Tambien en `dispositivos.html` en 320, 390
y 430 (la foto de rocas): el recorte vertical del hero movil sigue mostrando
la zona oscura debajo del titulo, sin perder contraste. **No se recorrio la
foto de playa slide por slide en mobile** — el arreglo es una propiedad
`color` heredada, no deberia depender del ancho, pero queda para confirmar.

**Del movimiento:** medido en el navegador, no deducido — el panel del carrito
sale con `right: 0` fijo y `transform` animandose, `transition-property` es
`transform` y no `all`, la entrada corre 340ms con su curva y la salida 260ms
con la inversa, y **las unicas propiedades que anima toda la hoja son
`transform`, `opacity` y colores**: ninguna de layout.

**Del movimiento, SIN verificar:** el bloque de `prefers-reduced-motion` — las
reglas estan y parsean, pero no se probo con la preferencia activada en el
sistema.

**Del panel del carrito:** abierto desde la bolsa de la cabecera, con dos
prendas, en desktop y **en 320** — los renglones con su foto, el `[− 1 +]`, el
tacho en su lugar y no en una linea propia, la barra de envio, el TOTAL entero
en un renglon y el boton de comprar a lo ancho.

**De las secciones y los filtros:** el riel ocupando el ancho completo en
desktop y **recorriendose de costado en 320** (probado moviendolo, no deducido),
el encabezado de categoria al ras de la izquierda, la fila de controles
alineada con el riel, las fichas de filtro aplicado, y el panel de filtros con
las casillas cuadradas llenandose de tinta al marcarse.

**Sin verificar, y no se puede hasta que exista la tienda:** que las plantillas
compilen en su servidor, que `google_fonts_url` sirva Archivo Black (que tiene
un solo peso, y el layout pide `300, 400, 700`), que `color-mix()` sobreviva a
su compilador de SCSS, y el comportamiento real de quickshop, filtros y carrito.

Del marco en particular: **el logo como imagen** (el harness solo prueba el
logotipo tipografico, que es el que usa el base cuando no hay imagen cargada),
**los modales de verdad** — el harness los abre y los cierra, pero la
animacion, el bloqueo del scroll y el acordeon de subrubros los maneja
`store.js` en la tienda — y el **panel del carrito**, que todavia no se toco.

**La Portada y la Capsula (`home_order_position_8/9`, 2026-09-11):** son las
unicas dos secciones de home que no vienen del base — se agregaron a mano en
`templates/home.tpl`, `config/settings.txt` (el widget `section_order` que
arma el orden de secciones) y `snipplets/home/home-section-switch.tpl`,
siguiendo el patron exacto de las secciones vecinas (`welcome`, `categories`,
`video`). **Sin verificar contra el panel real de Tiendanube** — que el
widget `section_order` acepte de verdad una opcion nueva agregada a mano en
`sections`, y que los campos de cada una aparezcan como se espera en el
editor — recien se puede probar con la tienda arriba. Visualmente se ven
bien en el harness, en desktop y en 320/390/430.

**La Capsula es un video en loop mudo, no el video-embed del base.** El base
ya trae una seccion "Video" (`video_embed`, YouTube/Vimeo con boton de play):
no sirve para esto porque es un reproductor a demanda, no un fondo que se
reproduce solo. `capsule_video_url` pide un link directo a un `.mp4`
alojado afuera de Tiendanube — la plataforma no aloja archivos de video
sueltos para el theme. Sin `muted` ningun navegador deja hacer autoplay, asi
que no hay sonido: no es una decision de diseño.

---

**Del 2026-09-15, en pantalla (Edge headless, 1440 y 390 via iframe):** el
home entero con las cuatro secciones nuevas del base, la pagina del carrito
en desktop y mobile, la pagina institucional con la notificacion desplegada,
el banner de cookies, los avisos y las etiquetas, y las tres paginas de
siempre sin regresiones. **Sin verificar:** el foco visible con teclado, la
entrada del texto del hero (son animaciones, la captura es estatica), la
ficha pegada al scrollear en desktop, la segunda foto al pasar el mouse
(`product_hover`, depende del lazyload del base), el modal de compra rapida,
la hoja de recomendados al agregar al carrito y `prefers-reduced-motion`.

**De las pantallas restantes (2026-09-15, tarde), sin verificar hasta que
exista la tienda:** que `query` y `categories` lleguen a `search.tpl` (sin
`query` el titulo vuelve a "Resultados de búsqueda"; sin `categories` no se
dibuja el riel); que `lupita.scss.tpl` y el JS lleguen a `password.tpl`; el
HTML real de `blog-post-item` y `blog-post-content` y que respeten las clases
que les pasamos; que `lupita-motion` conviva con `store.js`; y el scroll
infinito de la busqueda (las tarjetas que agrega entran sin animar, a
proposito). **Visto en pantalla** a 1440 y 390: las siete paginas, sin JS
(completas) y la 404 con movimiento reducido. El seguimiento del cursor del
blog no se puede ver en una captura.

## Pendientes con la clienta

1. **Logo vectorial** o el hex exacto del turquesa.
2. **La tercera direccion.** Instagram confirma España 137 y Loria 198 (Lomas);
   la de Banfield (Belgrano 1470) salio de guias comerciales, no de ella.
3. **Horarios y WhatsApp.** Las fuentes se contradicen (10:00–18:30 vs
   10:00–20:30). No rellenar por iniciativa propia.
4. **Plan Impulso**, con las tres letras chicas: camino de ida, sin las mejoras
   automaticas de Tiendanube, y si se cierra el FTP se pierde todo lo hecho.
   Ver "Puesta en produccion".
5. **Estandar de fotos.** La grilla aguanta fotos heterogeneas, pero mejora
   muchisimo si son verticales y a la misma distancia. Se logra con un celular
   y disciplina.
   ⚠️ **Las del hero ahora tienen un requisito extra**: como el titulo se apoya
   directo sobre la imagen, la zona de abajo al centro tiene que ser oscura.
   Conviene decirselo antes de que las saquen, no despues.

6a. **El título de la Portada.** Santiago pidió el formato (una foto a pantalla
   completa, sin carrusel, referencia Lara Casa) y va a pasar el título después.
   Hoy dice `[ Título a definir ]` en el harness — no rellenar con algo
   definitivo antes de que lo confirme.

6b. **El video de "The Trip".** Santiago dijo que ya tiene o va a conseguir el
   archivo/link (2026-09-11). Falta: el link directo al `.mp4` (alojado afuera
   de Tiendanube — ver la nota de la Cápsula más arriba) y confirmar si "The
   Trip" es el título que quiere ver en pantalla o solo el nombre interno de
   la cápsula. Hoy el harness usa "THE TRIP" como demo sobre una foto fija,
   sin el video real.

6. **Las secciones.** Las del menu y las del riel (`Vestidos`, `Pantalones`,
   `Abrigos`…) son de mentira, igual que las prendas del harness: sirven para
   ver el bloque, no para decidir el menu. Salen del catalogo real, y en
   Tiendanube **son las categorias de la tienda** — o sea que el riel se arma
   solo una vez que estan cargadas, sin tocar codigo.
7. **Cuantas secciones van a ser.** El riel aguanta las que sean, pero cambia de
   caracter: hasta ~10 entran de una en desktop; muchas mas y siempre hay que
   recorrerlo de costado.

## Lo que sigue en el codigo

Sin depender de la clienta **ya no queda nada del base sin restilar**: la
pagina del carrito, que era el ultimo punto de esta lista, se resolvio el
2026-09-15 junto con todo lo que faltaba (ver abajo). Lo que sigue es Etapa 2.

### Formularios y cuenta — resuelto el 2026-09-14

Contacto (`contact.tpl`) y las nueve plantillas de `templates/account/`
(login, registro, reset/newpass, info, address, addresses, orders, order)
comparten tres snipplets (`form.tpl`, `form-input.tpl`, `form-select.tpl`),
asi que unas pocas reglas genericas en `lupita.scss.tpl` alcanzaron para las
diez: caja con borde de 1px (`.form-control`/`.form-select`, foco en
turquesa), rotulo micro para `.form-label`, links sueltos en tinta con
subrayado en hover (`.btn-link`/`.btn-link-primary`, antes sin ningun
estilo propio), tarjetas de "Mis compras" con borde en vez de sombra
(`.card`), y los rotulos tecnicos ("Mis datos", "Detalles") vs. la cifra de
plata del total de una orden, escopeados a `.account-page .h5` / `.h3` para
no tocar esas mismas clases de Bootstrap en otras paginas. `.alert` ya
estaba resuelto de una sesion anterior — no hizo falta tocarlo.

**Checkout no se toco:** `static/checkout.scss.tpl` es la hoja que
Tiendanube aplica a su checkout alojado (una pantalla propia de la
plataforma, no una plantilla de este repo) y ya sale de `settings.*` —
toma turquesa/tinta/papel y `border-radius:0` solos. No hay brutalismo
posible ahi (no se controla el marcado), asi que "checkout" del punto
viejo de esta lista ya estaba cubierto sin escribir nada.

**Verificado en pantalla** con un mock suelto (`_harness/login-mock.html`,
no forma parte del recorrido del harness — se armo y se borro en la misma
sesion) replicando el DOM de `login.tpl` + `snipplets/forms/*` sobre el CSS
compilado. Encontro un problema real: `.alert` pegado directo a un `.btn`
sin margen se leia como un solo bloque negro — pero resulto ser un hueco
del mock (le faltaba el `margin-bottom: 35px` que el base ya le pone a
`.form-group`/`.alert` via `%element-margin`), no un bug de la hoja: en la
tienda de verdad ese respiro ya esta. El resto — caja de los inputs,
rotulo, links, tarjeta — se ve como se penso.

### 2026-09-15: revision general — lo que faltaba del base, foco y detalles

Santiago pidio "mejorala en lo que consideres necesario", con todas las
skills y MCP que sirvieran. Se paso `impeccable` (audit + polish) y el
checklist de `emil-design-eng`, se miro todo en pantalla con Edge headless
(la extension de Chrome no conecto) y se hizo esto:

**Lo que el base todavia mostraba con su estilo de fabrica** — todo por
clases, sin tocar plantillas:

- **WhatsApp flotante**: era un circulo verde con sombra; pasa a un cuadrado
  de tinta con el icono en papel, del tamano de un boton.
- **Notificacion "¡Ya agregamos tu producto al carrito!"** (`cart_open_type =
  show_notification`): caja de 1px en papel que baja medio centimetro y se
  funde (220ms / 160ms), en vez de la rotacion 3D con sombra del base.
- **Migas** en micro, con una raya vertical de 1px en vez del ">".
- **Encabezado de pagina** para todo lo que no es categoria ni producto
  (carrito, busqueda, institucionales, 404, cuenta): al ras de la izquierda y
  a `clamp(2rem, 6vw, 5rem)` — "Carrito de compras" a 9rem era un cartel.
- **Texto institucional** (`.user-content`: Como comprar, Cambios y
  devoluciones…): minusculas, 68ch, subtitulos macro, tabla con reglas de 1px
  y cabecera en rotulo. Es el unico texto largo ademas de la descripcion.
- **Vacios**: busqueda sin resultados, 404 y carrito vacio como rotulo al ras
  con su regla, no un parrafo centrado.
- **Servicios** (`banner-services`): tres celdas de la grilla de 1px con el
  icono a la izquierda; en mobile el Swiper del base con cuadrados en vez de
  puntos. Los puntos se esconden arriba de 768 porque ahi el base no arma el
  Swiper y el contenedor queda vacio.
- **Modulos de imagen y texto**: titulo macro, parrafo, boton; las dos
  columnas miden lo mismo y la foto llena la suya (con `align-items-center`
  del tpl, la columna baja dejaba ver el fondo de linea como un bloque gris).
- **Bienvenida**: centrada a proposito (es la unica seccion de solo texto),
  con la escala del sistema.
- **Instagram**: el usuario en la macro con la arroba y en minusculas, y las
  nueve fotos en grid de 3 con gap de 1px — el base usa `col-4` flotantes, y
  con 1px de gap tres tercios no entran.
- **Compra rapida** (modal): el nombre llega con `class="h1"` (la de
  Bootstrap, 28px bold) y el precio con `h4`: pasan a macro y micro.
- **Pagina del carrito** (`cart.tpl`): la lista con sus divisiones, y abajo
  el envio a la izquierda y el resumen a la derecha, pegado al scrollear
  (`position-sticky-md` sin `top` en el base). Los `mb-5` con `!important`
  de cada renglon se pisan con `!important` scopeado.
- **Cookies y "segui tu ultima compra"** (`.notification-secondary`): papel,
  regla maciza de 2px y micro, como el pie que tienen al lado.
- **Hojas desde abajo** (recomendados al agregar, promo cruzada): papel y
  regla; la mecanica es del base.
- **Etiquetas del carrito** (`label-accent`, `label-secondary`) y **paginacion**
  ("Mostrar mas productos").

**Foco y accesibilidad:**

- **Foco visible** global (`:focus-visible`, 2px en tinta con 2px de aire;
  en papel sobre foto o sobre tinta). El base apagaba el outline en varios
  lados y no ponia nada a cambio.
- Los tres focos que pasaban a **turquesa** (buscador, newsletter, campos de
  formulario) contradecian la nota de contraste: un indicador de foco pide
  3:1 (WCAG 1.4.11) y el turquesa da 2.17. Ahora el campo se tiñe (buscador,
  newsletter) o el borde se engrosa a 2px con un inset sin reflow (campos).
- `.alert-success` era solo un borde turquesa sobre papel: pasa a fondo
  turquesa con tinta, la unica combinacion del acento que contrasta.
- Se borro `.lu-marca` — una clase huerfana con turquesa + papel.
- El hover que agranda las fotos (grilla, banners, Instagram) queda gateado
  con `@media (hover: hover) and (pointer: fine)`: en un telefono el hover
  se dispara al tocar y la foto quedaba agrandada hasta tocar otra cosa.
- `prefers-reduced-motion` suma: el texto del hero sin subir, la notificacion
  sin desplazarse, el parpadeo gris de carga apagado, el Instagram sin scale.

**Tres bugs que el harness viejo escondia** (aparecieron al copiar mas reglas
del base al andamio):

1. 🔴 **Los chips de los banners de categoria iban a ser cajas de tinta del
   ancho del banner**, corridas a la izquierda. El base centra ese bloque con
   `top: 50%; left: 50%; width: 100%; transform: translate(-50%, -50%)` y
   nuestra regla solo cambiaba `left` y `bottom`. Ahora apaga los cuatro.
2. **`.textbanner-image` iba a medir cuadrado + tres cuartos**: el base arma
   el alto con `padding-top: 100%` y nosotros le pusimos `aspect-ratio`
   encima. `padding-top: 0`.
3. **La cifra del TOTAL del panel iba a quedar a la derecha**: el span lleva
   `.text-right`, que en Bootstrap es `!important`, y nuestra regla no lo
   era. Lo mismo con `justify-content-md-center` en el texto institucional.

**Detalles:**

- `text-wrap: balance` en los titulos macro (el "[ Titulo a definir ]" de la
  Portada dejaba el corchete solo en la segunda linea).
- El `h1` de la ficha tenia tracking negativo, heredado de cuando la macro
  era Archivo Black: pasa a positivo como el resto de Italiana.
- **La ficha se queda a la vista** mientras se recorren las fotos en desktop
  (`position: sticky` en la columna, `top: 4.5rem`, `align-self: flex-start`
  porque el `.row` es flex).
- **La foto de la grilla ahora funde al cargar**: `.item-image img` declaraba
  `transition: transform` con el shorthand y pisaba el `transition: opacity
  .2s` de `.fade-in` del base — la foto aparecia de golpe. Pasa a
  `transition-property: transform, opacity`. Lo mismo en los banners.
- Con eso arreglado se prendio **`product_hover = 1`**: la segunda foto al
  pasar el mouse, que el base ya implementa con opacity y estaba en la lista
  de Etapa 2. Depende del lazyload del base: recien se ve en la tienda.
- **El texto del hero asoma** al cargar (sube 0.75rem y se funde, 700ms,
  `backwards` para que si la animacion no corre el texto este visible igual).
  Unica animacion de carga del theme.
- Los links del nombre en la pagina del carrito salian en el azul del
  navegador (`.cart-item h6 a` no tenia regla, solo `.cart-item-name a`).
- El boton de comprar se pegaba a la descripcion (`p` del base sin margen
  superior): `margin-bottom` en el boton.

**Lo que NO se hizo, a proposito:** el modal de compra rapida y las hojas
desde abajo siguen animando `top`/`bottom` como en el base — el centrado en
desktop usa `transform` propio y pasarlos a `translate` sin poder probarlos
en la tienda era mas riesgo que beneficio. El `category-controls` sticky sin
`top` del base tampoco se toco: pegarlo debajo de la cabecera fija necesita
saber su alto, y eso es JS.

Ademas se escribio `PRODUCT.md` (el contexto que pide `impeccable`: registro
brand, usuarias, principios, anti-referencias) — es documentacion, no se sube.

### 2026-09-15 (tarde): busqueda, 404, contacto, contraseña, blog y nota

Las seis plantillas que el harness nunca habia mostrado, cada una con **un
solo gesto de movimiento**. Spec en
`docs/superpowers/specs/2026-09-15-pantallas-restantes-design.md`, plan en
`docs/superpowers/plans/2026-09-15-pantallas-restantes.md`.

**El movimiento: `static/js/lupita-motion.js.tpl` (SI se sube, va en
`static/`).** Es anime.js recortado con esbuild desde
`_harness/motion/entrada.mjs`; se regenera con `npm run build:motion` y **no se
edita a mano**. Pesa **20,9 KB** (tope 30). Tres decisiones:

- **`waapi.animate` y no `animate`.** El motor completo de anime.js pesaba
  41,7 KB (16,5 con gzip) aunque se sacara todo lo demas: el tope de 30 no se
  podia cumplir. `waapi` usa las animaciones nativas del navegador y baja a
  19,8. Lo que waapi no hace (animar texto y valores sueltos) va a mano con
  `requestAnimationFrame`: el decrypt de la 404 y el seguimiento del cursor
  del blog. Sin `splitText` tambien: el titulo de la nota se corta por
  palabras a mano.
- **Se activa por atributo** (`data-motion="decrypt|stagger|spring|shake|
  split-lines|hover-preview"`), no por plantilla. Un gesto roto no apaga los
  demas (`try/catch` por gesto) y va en un `<script>` propio en `layout.tpl`,
  asi un error no se lleva puesto el JS de la tienda.
- **El HTML trae el estado final.** Todo anima *desde* otro valor. Sin JS la
  pantalla esta completa; con `prefers-reduced-motion` el modulo sale sin
  animar nada. `build.mjs` tambien neutraliza `{{`, `{%` y `{#` del minificado
  (Twig incluye el archivo crudo) y compila el resultado para confirmar que
  sigue siendo JS valido.

**Por pantalla:**

- **404** — "404" en Italiana a escala de hero, buscador y 4 prendas en la
  grilla del sistema (`js-product-table`, sin esa clase la grilla se cortaba).
  Gesto: los digitos pasan por numeros al azar y se asientan. Solo digitos: `#`
  y `%` en Italiana son mucho mas anchos y la cifra saltaba. Un `setTimeout` de
  respaldo la deja en "404" aunque la pestaña este en segundo plano (ahi rAF
  se frena — Edge headless la capturaba a medio desordenar).
- **Busqueda** — encabezado propio: rotulo "Búsqueda" y el termino entre
  comillas como titulo; sin resultados, el termino tachado y el riel de
  secciones (`categories.tpl` con `filter_categories: categories`). No se
  muestra la cantidad: `products | length` es la de la pagina, no el total.
  Gesto: las tarjetas de la primera pagina entran escalonadas.
- **Contacto** — dos columnas desde 768: lo que carga el panel a la izquierda
  (nada escrito a mano), formulario a la derecha con la linea de 1px en el
  medio. Cancelacion, honeypot y consulta por producto intactos. Gesto: el
  aviso de "gracias" entra con resorte.
- **Contraseña** — turquesa a sangre con tinta encima, logotipo en Archivo
  Black, mensaje del panel en Italiana, campo en caja de papel. `password.tpl`
  no usa el layout: carga `lupita.scss.tpl` y el JS por su cuenta. Gesto: el
  formulario tiembla una vez si la contraseña es incorrecta.
- **Blog** — lista editorial: primera nota grande a dos columnas, el resto en
  filas de 1px. Gesto: con mouse, la foto de la fila se oculta y aparece
  flotando junto al cursor; en tactil y sin JS queda chica y fija.
- **Nota** — columna de 680px, fecha como rotulo, cuerpo con `user-content`
  (hereda #Texto institucional). Gesto: el titulo sube palabra por palabra
  (`data-motion` en `page-header.tpl`, solo para `blog-post`).

**El blog es el punto flojo:** `component('blog/blog-post-item')` y
`blog-post-content` son de la plataforma y su HTML no esta publicado. Todo el
CSS apunta a las clases que pasamos nosotros (`lu-post*`, `lu-nota-*`), nunca a
las internas; el DOM del harness es deducido.

**Harness:** `404.html`, `busqueda.html`, `busqueda-vacia.html`,
`contacto.html`, `contrasena.html`, `blog.html`, `nota.html`, todas en
`dispositivos.html`. Nuevo `movil.html?p=<pagina>`: la pagina pedida en un
iframe de 390 para capturar mobile con Edge. Se copiaron al andamio el aire de
`.form-group` (35px, de style-async: sin eso cada rotulo se pegaba a la caja de
arriba), la lista de `contact-links`, el blog de style-critical y
`.container-narrow`. En `movil.html` las filas del blog salen sin foto: Edge
headless dice tener mouse y se activa la vista previa — en un telefono no pasa.

## Etapa 2 (cuando haya tienda)

Hero de campaña a sangre, y la revision
de producto, carrito y cuenta con contenido real.

Y el movimiento que hoy no se puede hacer con CSS: **arrastrar el panel del
carrito para cerrarlo**, con seguimiento 1:1 del dedo, traspaso de velocidad al
soltar, proyeccion de inercia para decidir si cierra o vuelve, y
rubber-banding en el borde. Todo eso necesita resortes en JS sobre el
`store.js` de Tiendanube, y no se puede probar sin la tienda arriba.
