# Product

## Register

brand

Es una tienda, pero el diseño ES el producto: una marca de ropa que vende por
Instagram necesita que la tienda se vea como la cuenta. Las pantallas de tarea
(carrito, cuenta, formularios) heredan el mismo sistema, no otro.

## Users

Mujeres del sur del GBA (Lomas de Zamora, Banfield y alrededores) que ya siguen
a la marca en Instagram (131 K seguidoras) y llegan a la tienda desde una
historia o un posteo, **desde el teléfono**. Vienen a ver qué entró y cuánto
sale; muchas van a terminar comprando en el local, así que la tienda también
es la vidriera de los tres locales.

## Product Purpose

Theme propio de Tiendanube para **Ahí! Lupita / Kit 'n Couch**, tienda de ropa
de mujer multimarca con tres locales. Reemplaza la plantilla default de la
plataforma por una tienda con la identidad de la marca, sin apps ni código
externo: los `.tpl` los renderiza Tiendanube y la clienta maneja fotos,
textos, colores y secciones desde su panel.

Éxito: que la tienda se vea como la cuenta de Instagram, que el mejor dato de
la marca (20% en efectivo, 3 y 6 cuotas) esté antes que cualquier foto, y que
el catálogo aguante fotos sacadas en los locales con un celular.

## Brand Personality

Directa, barrial y segura de sí misma. Tres palabras: **cruda, ordenada,
cercana.** Referencias: la densidad y la sobriedad de la grilla de Zara; el
hero a pantalla completa de tiendanapoli.com; el logotipo `AHI ! LUPITA`, que
ya venía en idioma brutalista.

## Anti-references

- Las plantillas default de Tiendanube: tarjetas con sombra, bordes redondeados,
  botones de colores, íconos redondos.
- Boutique "delicada": crema, script, degradados, fotos de estudio que la marca
  no tiene.
- Cualquier cosa que dependa de que la foto sea oscura o clara en un lugar fijo
  (la clienta saca las fotos con un celular en el local).

## Design Principles

1. **La estructura hace el trabajo que las fotos no pueden.** Divisiones de 1px
   y celdas cerradas sostienen fotos heterogéneas.
2. **El mejor dato, antes que la foto.** Efectivo y cuotas se leen sin scrollear.
3. **Lo que la clienta pueda resolver desde el panel, no se resuelve en código.**
   Color de texto por slide, secciones, banners, orden de la home.
4. **El teléfono primero.** El tráfico viene de Instagram: autoplay en mobile,
   estados al apretar, nada que dependa del hover.
5. **Papel, tinta y un solo acento.** El turquesa sólo como fondo con tinta
   encima (2.17:1 contra papel, 8.27:1 contra tinta).

## Accessibility & Inclusion

Texto y elementos gráficos a WCAG AA (4.5:1 / 3:1), verificado con medición y
no a ojo. Foco visible en todo lo interactivo. `prefers-reduced-motion`
respetado en paneles, fotos, hero y video en loop. Sin dependencia del hover
para ninguna acción.
