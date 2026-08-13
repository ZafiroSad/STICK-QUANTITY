# STICK QUANTITY — Bitácora del proyecto

## Descripción y objetivo
Calculadora de **cantidades de obra** para el Señor Stick. Objetivo: reemplazar el cálculo manual
en papel/Excel para pedidos de material, empezando por mampostería y creciendo capítulo por
capítulo (concreto, acero, pañete, pisos). Repositorio **público** — es la primera app de la
familia Stick pensada para ser útil a cualquier persona en obra, no solo al Señor Stick.

## Ubicación
`C:\Users\kevin\Documents\KEVIN\02. WORK\03. PROYECTOS PERSONALES\STICK QUANTITY\`

- Repositorio: `ZafiroSad/STICK-QUANTITY` (público)
- Despliegue: GitHub Pages — https://zafirosad.github.io/STICK-QUANTITY/
- Rama `main`, carpeta raíz `/`, build legacy (mismo patrón que STICK FIT).
- **Publicado y verificado en vivo el 2026-08-06** (HTTP 200, 41.305 bytes, favicon 200).

## Estado actual — v1.10.0 (Mampostería + Concreto de columnas + Acero)

### La tarjeta pasa a ser el ELEMENTO, con barras de figuras distintas adentro (2026-08-12)

El Señor Stick lo pidió así: «que por tarjeta uno pueda agregar una de los 4 tipos —1 de la recta,
2 de escuadra sencilla y 1 de estribo— en la misma tarjeta todo, con un diagrama pequeñito para no
perderse». **Invierte la decisión que él mismo había tomado ese día** (tarjeta = una longitud de
corte); se le señaló antes de tocar nada y la confirmó.

**El modelo de datos cambia de raíz.** Antes la geometría vivía en la tarjeta y `lineas` eran
posiciones que compartían su longitud. Ahora:

```
fila  = { id, elem, barras:[ barra ] }              ← la tarjeta es el elemento
barra = { id, det, cant, dia,                       ← la posición
          fig, est, a,b,c,sb,sh,ge, iguales,        ← su propia figura y medidas
          abierta }                                 ← solo cómo se ve
```

- `calcBarra(b)` es el cálculo real; `calcAce(f)` solo suma las barras del elemento.
  `camposDe`, `nombreFig`, `cDe`, `geomAce`, `croquisAce`, `trazosAce` y `medidasAce` reciben
  ahora **una barra**, no una tarjeta.
- **`miniAce(b)`** es nuevo: el diagrama pequeñito del renglón cerrado, 52 × 26, la silueta y nada
  más —sin cotas ni texto—, atenuado mientras la barra esté a medio llenar. Sale de `geomAce`,
  igual que el croquis grande y que el del Excel: **una sola fuente de geometría, tres dibujos**.
- **El renglón se abre y se cierra** (`b.abierta`, la escogió él sobre las otras dos maquetas).
  Cerrado: diagrama + figura + longitud. Abierto: los cuatro botones de figura, las formas de
  estribo, los campos y el croquis acotado. `abierta` **no se guarda**: al cargar se abre sola la
  barra que esté incompleta, que es justo la que falta por terminar.
- **En el Excel una barra es UNA FILA entera** con su figura, croquis, medidas y L. unit. Se fueron
  las celdas combinadas a lo alto (`['B','D','E','G','H']`), que existían solo porque todas las
  posiciones de una tarjeta compartían una longitud. La hoja queda más parecida a la cartilla real.
- **Migración en cadena de las tres formas del guardado** (`migrarFilaAce` + `sanearBarra` nuevo):
  posición suelta → `lineas` con geometría en la raíz → barras propias. Cada posición vieja se
  vuelve una barra que hereda la figura y las medidas de su tarjeta, así que nada de lo escrito
  se pierde. Verificado sembrando un guardado de la forma anterior y recargando.

**Verificado en vivo (2026-08-12)**, no supuesto: migración de un guardado viejo (2 posiciones +
1 estribo → 3 barras, longitudes 4,20 / 4,20 / 1,24 y sin restos de `ganchos`/`le`/`sep`); un
elemento con las cuatro figuras a la vez (4,20 · 3,40 · 2,70 · 1,34 m); abrir una barra no abre las
otras; cambiar su figura no toca las demás y respeta el nombre que él escribió; escribir una medida
no pierde el foco. Sin errores de consola ni desborde en 1280 y 390 px, en ambos temas. El `.xlsx`
**abierto en Excel real por COM**: 3 hojas, 7 formas en la primera —una por barra más el logo—,
fórmulas vivas, consolidado referenciando ambas hojas, sin reparación.

### Fuera el gancho estándar; los desplegables se ven en PC (2026-08-12)

**El parámetro «Gancho estándar» se retiró.** Era el último cálculo automático que quedaba en el
capítulo: un desplegable de obra (90° = 12 db / 180° = 4 db ≥ 6,5 cm) que, junto con un selector
`Ganchos: ninguno / 1 / 2` en cada tarjeta, le sumaba la extensión a las barras longitudinales.
Con él se fue todo su aparato: el campo por tarjeta, el trazo del gancho en el croquis de pantalla
y en el del Excel, y la mención en el subtítulo de la hoja. Los parámetros quedan en tres —nombre
de la tanda, varilla comercial y desperdicio— y la rejilla `.g-ace` pasa de cinco columnas a tres.
El guardado anterior se limpia solo (`delete n.ganchos`, `delete estadoAce.gancho`).

**Los desplegables se veían blanco sobre blanco en el escritorio.** El menú de un `<select>` no lo
pinta la página: lo pinta el sistema. Sin `color-scheme` declarado, Windows lo abría en claro
mientras las opciones heredaban la tinta clara del tema oscuro. En el teléfono no pasaba porque la
hoja nativa usa el esquema del propio equipo. Tres arreglos:

- `color-scheme:dark` en `:root` (el `html.light` ya declaraba el suyo).
- Regla global `select option,select optgroup` con fondo y color propios, en los dos temas. Antes
  solo la tenía `.field select option`, así que **el desplegable de diámetro de cada tarjeta
  —`.linea select`— quedaba sin ninguna**.
- `.linea select` pasa a la misma píldora con flecha propia (`appearance:none` + `--flecha`) que
  los de arriba: en PC se ve como en el celular.

**Dos defectos vistos al medir, no supuestos:** en modo claro y al enfocar, la flecha del `<select>`
desaparecía. `html.light .field select` y `.field select:focus` usaban el atajo `background`, que
resetea `background-image`; ahora usan `background-color`.

**Verificado (2026-08-12)** con la app servida por HTTP y Chrome headless por CDP: `color-scheme`
resuelto a `dark`/`light` según el tema, las `option` de los tres desplegables con fondo
`rgb(29,31,38)` y tinta `rgb(247,248,250)` en oscuro y `#fff` sobre `rgb(21,22,27)` en claro, la
flecha presente en reposo y en foco, sin errores de consola ni desborde horizontal. Las longitudes
se recontaron contra la cartilla —recta 4,20; estribo cerrado 1,24; doble escuadra 2,70; gancho S
0,64— y el `.xlsx` se abrió **en Excel real por COM**: 3 hojas, 5 formas en la primera, `=11+7+11`
dando 29 y total 70,93 kg, sin reparación. **Lo que no se pudo capturar es el menú desplegado**: lo
dibuja el sistema operativo fuera de la página, así que ninguna captura del navegador lo contiene.

### Tres formas de estribo, tomadas de la cartilla de hierros (2026-08-12)

Fuente: `Downloads\CARTILLA HIERROS LOTE 23.xlsx` y `... CASA 23.xlsx`, la cartilla real del Señor
Stick. Sus columnas son ELEMENTO · LONG · ESCUADRA · FIGURACION · DIM · P/UNIT · CANT · LONG TOTAL
· P/TOTAL, y el vocabulario de figuras que usa es `ESCUADRA SENCILLA`, `DOBLE ESCUADRA`,
`DE 0.27x0.27`, `GANCHO C DE 0.37`, `GANCHO S DE 0.42`.

El botón **Estribo** abre un sub-selector con tres formas (`ESTRIBOS`, campo `f.est`). Las
longitudes se confirmaron contra las de su propia cartilla, no contra una fórmula supuesta:

| Forma | Su fila | Longitud |
|---|---|---|
| `cuad` Estribo cerrado | `DE 0.27x0.27` + doble gancho 0,08 → **1,24** | `2B + 2H + 2g` |
| `c` Gancho C | `GANCHO C DE 0.37` + gancho 0,08 → **0,53** | `D + 2g` |
| `s` Gancho S | `GANCHO S DE 0.42` + gancho 0,11 → **0,64** | `D + 2g` |

La C y la S **miden lo mismo**: cambia hacia dónde dobla cada pata —al mismo lado en la C, a lados
opuestos en la S—, y por eso solo se distinguen en el dibujo. En la columna FIGURA del Excel salen
como `Estribo`, `Gancho C` y `Gancho S`, igual que en su cartilla, y la posición se nombra sola
`estribo` o `gancho` según la forma.

**Defecto encontrado al verificar en captura** (no supuesto): el croquis medía su caja solo con
`geomAce().pts`, y como la C y la S son una recta —caja de alto cero— las patas se salían del
lienzo y la cota las cruzaba. Ahora la caja incluye las patas y en estas dos formas la cota se sube
por encima de todo el dibujo.

## Estado anterior — v1.7.0 (Mampostería + Concreto de columnas + Acero)

### Tercera pasada del capítulo Acero (2026-08-12)

- **Doble escuadra:** los campos se ven como se lee la figura — las dos escuadras arriba (`B` izq.
  y `C` der.) y abajo el tramo recto `A` junto al botón `B = C`. El orden de pantalla es una lista
  aparte (`ui`) del orden geométrico (`campos`): el desglose sigue saliendo `0,30 + 2,10 + 0,30`,
  que es como recorre la barra sus tramos.
- **Las posiciones se nombran solas:** la primera `arriba`, la segunda `abajo`, y en una tarjeta de
  estribo todas `estribo`. Al cambiar de figura se renombran **solo las que puso la app**
  (`AUTO_DET`); lo que el Señor Stick escriba no se toca.
- Una tarjeta nueva hereda elemento, figura y el diámetro de la última posición.

## Estado anterior — v1.6.1 (Mampostería + Concreto de columnas + Acero)

### Mensaje de pedido por WhatsApp en el capítulo de columnas (2026-08-12)

El resumen se copiaba entero y en formato de listado técnico. El Señor Stick lo manda por WhatsApp
a proveedores y contratistas, y cada uno necesita una cosa distinta.

- **Dos interruptores** en la cabecera del resumen —`Concreto` y `Formaleta`— deciden qué entra al
  mensaje. Se guardan en `estadoCol.copiar` y no se dejan apagar los dos.
- **Botón «Copiar para WhatsApp»** visible en la sección; el ícono de la topbar despacha al mismo
  sitio cuando el capítulo activo es columnas, y el aviso dice qué se copió.
- **Mensaje reescrito** (`resumenTextoCol`): título según el modo —PEDIDO DE OBRA / DE CONCRETO /
  DE FORMALETA—, el total arriba en `*negrita*` (WhatsApp la interpreta), el desglose debajo y el
  detalle por columna al final. En concreto añade el redondeo a mixer (`volMixer`, pasos de 0,5 m³).
  Con los dos bloques activos el detalle va en dos renglones rotulados: el punto medio que los
  separaba se confundía con el de «21 MPa · 3000 psi».
- **Segunda pasada del mensaje (2026-08-12).** El Señor Stick reescribió el detalle a mano y pasó
  su versión. Cada columna es ahora un bloque de renglones cortos —título en negrita, geometría con
  `|`, cantidades— separado por una línea en blanco. Al armarlo a mano se le renumeraron todas las
  columnas como «1.»: **WhatsApp convierte una línea que empieza con `1. ` en lista numerada** y la
  renumera. Por eso el título del bloque va como `*1. C30x30*`, con el asterisco de la negrita
  delante: deja de ser lista y el número se conserva. Por lo mismo las viñetas son `•` literales y
  nunca `- `.

### Segunda pasada del capítulo Acero tras revisión del Señor Stick (2026-08-12)

La primera versión ponía **una tarjeta por marca de barra** y la lista se estiraba a decenas de
tarjetas. Él pidió que la tarjeta fuera «básicamente una fila del Excel»: escogió que la tarjeta
agrupe **una longitud de corte** y que adentro se listen las posiciones que la comparten.

- **Tarjeta = una longitud.** Figura + medidas + croquis arriba; abajo, N líneas
  `posición · cantidad · diámetro`. En el Excel cada línea es una fila y las celdas de la tarjeta
  —figura, croquis, medidas, L. unit— van **combinadas a lo alto** del bloque.
- **La cantidad admite sumas.** «11+7+11» se guarda tal cual —el reparto es dato de obra— y el
  Excel se lleva las dos cosas: la columna `REPARTO` con el texto `11 + 7 + 11` y la columna `CANT`
  con la **fórmula** `=11+7+11`, que muestra 29 y sigue viva.
- **El estribo se escribe entero, a mano.** Fuera la separación y el conteo automático; fuera el
  recubrimiento. Sus campos son `B`, `H` y `Gancho`, los tres en metros, y la longitud es
  `2·B + 2·H + 2·gancho` — el desglose sale literal: `0,20 + 0,40 + 0,20 + 0,40 + 0,10 + 0,10`.
- **Botón «B = C» en la doble escuadra**: mientras esté puesto, la escuadra derecha copia a la
  izquierda y su campo queda inhabilitado.
- Los parámetros del despiece quedan en cuatro: nombre de la tanda, varilla comercial, desperdicio
  y gancho estándar. **El recubrimiento se retiró**: solo alimentaba el estribo, que ya no lo usa.
- Migración automática del guardado anterior: la posición suelta pasa a `lineas`, el estribo se
  convierte de sección en cm a medidas en m (sección − 2 recubrimientos) y **se rescata la cantidad
  que la app calculaba con la separación**, para no perder la cuenta ya hecha.

### Capítulo Acero — despiece (2026-08-12)
Tercer capítulo, nacido de replicar «pero mejor» el Excel de obra
`LOTE 23 VILLAS DE CANTABRIA\FORMALETA COLUMNAS.xlsx` (dos hojas, «PRIMERA TANDA» y
«SEGUNDA TANDA»; columna A libre para marcar con «x»; Century Gothic; sin rejilla).

- **La figura se escoge tocando el dibujo**, no un desplegable: cuatro botones con la silueta
  de Recta / Escuadra sencilla / Doble escuadra / Estribo. Las letras A/B/C del dibujo son las
  mismas de los campos de la fila.
- **Croquis acotado por fila** (`geomAce` / `croquisAce`): además del selector, cada fila dibuja
  **su** barra **a escala** con las medidas escritas, líneas de cota con marcas y los ganchos que
  le sumen longitud. Mientras la fila está vacía se dibuja el ejemplo (los placeholders) atenuado.
- **Tandas**: pestañas dentro del capítulo. Cada tanda tiene su nombre y sus barras; los parámetros
  (varilla, desperdicio, recubrimiento, gancho) son de la obra y valen para todas.
- **Exportación a .xlsx sin dependencias** (`zipStore`, ZIP «store» a mano): **una hoja por tanda**
  más una hoja **CONSOLIDADO** cuando hay más de una. Lleva el croquis dentro como **figura
  vectorial** (`custGeom`, no imagen) anclada en la columna CROQUIS, y el logo en A1 de cada hoja.
- **La hoja sale viva, con fórmulas**, no con números muertos: `L. TOTAL = H·I`, `PESO = J·kg/m`,
  subtotales con `SUM`, resumen por diámetro con `SUMIF` sobre las filas de datos, y el consolidado
  referenciando las hojas de cada tanda. Probado en Excel real: subir una cantidad de 4 a 8 movió
  la fila, el subtotal, el resumen de la hoja (88,82 → 103,64 kg) y el consolidado (151,14 → 165,96).
- Masas nominales NTC 2289; ganchos NSR-10 C.7.1 (90° = 12 db; 180° = 4 db ≥ 6,5 cm;
  estribos 135° = 6 db ≥ 7,5 cm, dos por estribo). Las longitudes se suman **cara a cara**.
- Persistencia propia en `localStorage` bajo `stick-quantity-acero-v1`, con migración automática
  del formato anterior (lista suelta `filas`/`titulo`) al de tandas.

**Verificado en vivo (2026-08-12)**, no supuesto: app servida por HTTP y manejada por CDP en
Chrome headless (tres capítulos, ambos temas, 1280 y 390 px, sin errores de consola ni desborde
horizontal), y el `.xlsx` **abierto en Excel real por COM** —3 hojas, 6 formas en la primera, sin
reparación— y exportado a PDF para mirarlo.

## Estado anterior — v1.2.0 (Mampostería + Concreto de columnas)

### Capítulo Concreto — columnas (2026-08-10)
Segundo capítulo. La barra de capítulos deja de ser decorativa: `Mampostería` y
`Concreto · Columnas` son `<button data-cap>` que alternan `#vistaMamposteria` / `#vistaColumnas`;
el capítulo activo se recuerda en `localStorage` (`stick:capitulo`) y los botones de copiar/CSV
de la topbar despachan al capítulo visible.

- Botón **Registrar columna**. Filas ilimitadas, cada una en modo **Rectangular** (ancho × largo
  en cm), **Circular** (Ø cm) o **Libre** (área m² declarada a mano).
- Cada fila trae su propia **resistencia** (17.5 a 35 MPa) y el resumen entrega el concreto
  **agrupado por resistencia**, para poder pedir por separado a la planta.
- Altura en m, cantidad de columnas iguales y **caras a formaletear** (4/3/2/1/0).
- **Catálogo de formaletas** (`FORMALETAS`): anchos de 25 a 60 cm en pasos de 5, todos de 1,20 m de
  alto. Desactivables uno a uno y ampliables con medidas propias desde la UI. Se muestra **agrupado
  por altura de panel**, con el chip llevando solo el ancho.
- La formaleta se entrega en **piezas contadas por medida**, no en m². Cada fila escoge
  `Automática` —el motor combina las medidas activas— o una medida concreta («Solo 30 × 120 cm»).
- Persistencia independiente en `localStorage` bajo `stick-quantity-columnas-v1`, para no tocar
  los datos ya guardados de mampostería.

**Segunda pasada tras revisión del Señor Stick (2026-08-10):** la primera versión entregaba m² de
formaleta, dosificación de mezcla (cemento/arena/grava/agua) y «usos previstos». Se retiró todo:
no entendía los usos previstos, no necesitaba el desglose de materiales y lo que quería era el
conteo de piezas. Su frase de referencia —«una columna de 3,60 de alto de 30×30 necesitaría 12
formaletas de 1,20 × 0,30»— es hoy un caso de prueba.

## Estado anterior — v1.0.0 (capítulo Mampostería completo)
- Catálogo de unidades: bloque de arcilla H-10/H-12/H-15/H-20, estructural 12/15/20,
  tolete común, tolete prensado, farol, bloque de concreto 10/12/15/20, y **Personalizada**.
- Junta seleccionable (1.0 / 1.5 / 2.0 / 2.5 / 3.0 cm + valor propio).
- Filas de muro ilimitadas, cada una en modo **Largo × Alto** o **Área**, con cantidad de muros
  iguales y descuento de vanos en m².
- Desperdicio global (5 % por defecto), mortero de pega estimado, exportación CSV y copia de
  resumen en texto.
- Persistencia en `localStorage` bajo la clave `stick-quantity-v1`.
- **Marca propia aplicada (2026-08-06):** favicon, ícono de iOS, imagen de enlace compartido y marca
  del encabezado salen del maestro `LOGO.png`. Reemplaza el ícono provisional de dos hiladas de
  ladrillo.

## Arquitectura
Un solo archivo `index.html` con CSS y JS embebidos, sin build ni dependencias —
mismo patrón que STICK FIT y URL-MP4 (proyectos autónomos, sin acoplar).

| Archivo | Rol |
|---|---|
| `index.html` | Toda la app: estilos, catálogo, motor de cálculo y UI |
| `LOGO.png` | **Maestro de marca** (2000×2000, glifo blanco sobre `#1e1f1f`) |
| `favicon.svg` | Favicon vectorial (Chrome, Edge, Firefox) |
| `favicon.png` | Favicon 64×64 de respaldo — **Safari no soporta SVG** |
| `apple-touch-icon.png` | Ícono iOS 180×180, remuestreado del maestro |
| `icon-512.png` | Imagen de enlace compartido (`og:image`), 512×512 |
| `tools/gen-favicon.ps1` | Redibuja `favicon.png` con la geometría del logo. Fuera de la app |
| `README.md` | Documentación pública, fórmulas y advertencia técnica |
| `.gitignore` | OS + editores + temporales |

Piezas clave dentro de `index.html`:
- `CATALOGO` — arreglo de grupos/unidades. `l` = largo de cara, `h` = alto de cara,
  `a` = ancho (espesor del muro), en cm. **Agregar referencias aquí, no en la UI.**
- `porM2()` — rendimiento: `10000 / ((l+j)·(h+j))`.
- `morteroPorM2()` — volumen de junta: `[1 − (l·h)/((l+j)(h+j))] · (a/100) · factor`.
- `calcFila()` / `totales()` — cálculo por fila y agregado con desperdicio.
- `pintarFilasSuave()` — actualiza subtotales **sin** re-pintar los inputs, para no perder el
  foco mientras se escribe (mismo problema ya resuelto en STICK FIT v1.13.0).
- `csvTexto()` / `exportarCsv()` — generación y descarga separadas, para poder verificar el
  contenido del CSV sin depender de que el navegador materialice la descarga.

Capítulo de columnas (mismo archivo, funciones con sufijo `Col`):
- `RESISTENCIAS` — lista de f'c. `FORMALETAS` — catálogo de paneles `{a, h}` en cm.
  **Agregar referencias aquí, no en la UI.**
- `seccionCol()` / `carasCol()` — área de la sección y anchos de las caras a encofrar.
- `cubrir()` — reparto mínimo de piezas sobre una longitud (cambio de moneda en cm).
- `elegirCorte()` — entre los totales que alcanzan el objetivo escoge el mejor:
  exacto → menos piezas → menos sobrante. La usan tanto el ancho como la altura.
- `encofrarCara()` — cubre una cara por hiladas: elige la combinación de alturas y completa cada
  hilada a lo ancho. `PENA_ANCHO` castiga la hilada que no cierra exacta.
- `formaletaCol()` / `calcCol()` / `totalesCol()` — piezas por columna, volumen por fila y el
  agregado (concreto por resistencia + piezas por medida).
- `pintarCapitulo()` — alterna las tres vistas y el estado `on` de los chips.

Capítulo de acero (mismo archivo, sufijo `Ace`):
- `ACEROS` — masas nominales por diámetro. `FIGURAS` — figuras y sus campos, con `ph` (placeholder)
  que además alimenta el croquis de ejemplo. `SVG_FIG` — los íconos del selector.
  **Agregar referencias aquí, no en la UI.**
- `calcAce()` / `totalesAce(filas)` — longitud de corte, piezas, peso y varillas por corte real.
- `geomAce(barra)` — **única fuente de la geometría**: puntos de la figura en metros más los
  ganchos. La consumen los **tres** dibujos: el diagrama del renglón, el croquis grande y el Excel.
- `croquisAce(barra)` — SVG acotado, alto adaptativo según la forma. `miniAce(barra)` — el
  diagrama pequeñito del renglón cerrado. `trazosAce()` / `figuraXlsx()` — la misma silueta como
  polilíneas y como `<xdr:sp>` con `custGeom` para la hoja.
- `calcBarra(barra)` — longitud de corte, piezas, peso y varillas de UNA barra.
  `calcAce(fila)` suma las del elemento; `totalesAce(filas)` agrega la tanda.
- `sanearBarra()` / `migrarFilaAce()` — normalizan una barra y convierten las tres formas
  históricas del guardado a la de hoy.
- `hojaAceroXml(tanda, i)` / `hojaConsolidadoXml()` / `envolverHoja()` — las hojas.
  `libroAceroXlsx()` arma el ZIP con una hoja, un dibujo y sus rels por tanda.
- `zipStore()` / `crc32()` — escritor de ZIP sin compresión. Excel acepta el método «store».

## Migración al UI SYSTEM v2 «Campo y Vidrio» (2026-08-09)

Cuarta app migrada de la familia (tras AROS, PROJECTS y ASSETS). Al ser un solo HTML sin Tailwind,
la migración se hizo sobre las variables CSS propias, no copiando el `index.css` canónico:

- **Rampa grafito.** Las variables `--zinc-*` conservan sus nombres y cambian todos sus valores a los
  grises fríos del portafolio. Se añaden `--tinta` (`#f7f8fa`) y `--contratinta` (`#15161b`), que
  sustituyen a los `#fff`/`#000` fijos: el blanco y el negro puros salen de la paleta.
- **El campo** (`.campo` + 4 `.masa` + `.grano`) sustituye al `background-image` radial del `body`;
  todo el contenido pasa a `.lienzo`. Tokens `--bg`, `--bg-2`, `--bg-3`.
- **Vidrio líquido** en tarjetas (`.card` a 26 px), topbar, botones secundarios, botones ícono, toast
  y campos, con `--v-fondo`/`--v-borde`/`--v-blur`/`--v-filo`/`--v-sombra`.
- **Píldoras:** `.btn-primary`, `.btn-secondary`, `.btn-danger`, `.btn-icon`, `.seg`, `.chip`,
  `.field input/select` y el toast pasan a `border-radius: 999px`.
- **Modo claro (§10, ahora obligatorio en toda la familia):** bloque `html.light` que reespeja la
  rampa e invierte el filo del vidrio, botón Sol/Luna `#btnTema` en la topbar, persistencia en
  `localStorage` (`stick:tema`) y script anti-destello en el `<head>` antes del `<style>`.
- `theme-color` del `<head>` actualizado de `#0c0d10` a `#15161b`.

**Defecto encontrado al verificar en modo claro** (no supuesto: se vio en captura): cuatro textos
tenían `color:#fff` en estilos en línea del marcado —el título "STICK QUANTITY" de la topbar, las
medidas nominales, la unidad del resumen y el contador de unidades por fila— y quedaban blancos
sobre fondo blanco. Corregidos a `var(--tinta)`. El `fill="#ffffff"` del SVG de la marca **se
conserva a propósito**: va en negativo sobre su tile oscuro en ambos temas.

Verificado en vivo con Chrome headless sobre la app servida por HTTP (1280×900), en ambos temas.

## Decisiones tomadas
- **La tarjeta es el ELEMENTO y cada barra lleva su figura (2026-08-12, pedido por el Señor
  Stick).** Sustituye a la decisión de esa misma mañana —tarjeta = una longitud de corte—, que él
  había escogido con maqueta. La razón del cambio es la de un plano: una viga no se lee por
  longitudes de corte sino por elemento, y su despiece son cuatro figuras distintas juntas.
  **La decisión anterior queda anulada, no en discusión.**
- **El renglón de una barra se abre y se cierra (2026-08-12).** Se le mostraron tres maquetas
  —renglón plegable, todo abierto siempre, dos renglones densos— y escogió la primera. Con seis
  barras, tenerlas todas abiertas hace una tarjeta que no cabe en pantalla; cerradas, el diagrama
  pequeñito es lo que permite reconocer cada una sin leer.
- **`abierta` no se guarda (2026-08-12).** Es estado de pantalla, no dato de obra. Al cargar se
  abre sola la barra incompleta: al volver al despiece, lo que está a medio escribir salta a la
  vista en vez de esconderse.
- **Ningún gancho se calcula solo (2026-08-12).** El estribo ya se escribía entero a mano; el
  gancho estándar de las barras longitudinales era la excepción que quedaba, y el Señor Stick la
  retiró. Hoy el gancho va escrito dentro del tramo que lo lleva y la app suma lo que esté escrito.
  La NSR-10 C.7.1 queda en la nota de la app como referencia de qué medida escribir, no como
  fórmula que la app aplique.
- **El `<select>` se pinta entero, no se deja al sistema (2026-08-12).** El control cerrado lleva
  la píldora y la flecha de la familia; el menú abierto se gobierna con `color-scheme` y con fondo
  y color propios en `option`. Regla a replicar: **un `<select>` nuevo hereda las dos cosas**, y el
  atajo `background` nunca se usa sobre un select que lleve flecha —borra la imagen.
- **El resumen de columnas se copia por partes, no entero (2026-08-12).** A la planta de concreto
  no le sirve el conteo de formaleta y al alquilador de formaleta no le sirve el m³. Dos
  interruptores, y el mensaje cambia hasta el título. No se dejan apagar los dos: un mensaje vacío
  no le sirve a nadie y el botón tiene que entregar siempre algo.
- **El mensaje se escribe para WhatsApp, no para una hoja (2026-08-12).** Total arriba en negrita,
  desglose debajo, detalle al final; `*negrita*` y `_cursiva_` porque WhatsApp las interpreta. Sin
  emojis: el registro del Señor Stick con proveedores es formal.
- ~~**La tarjeta agrupa UNA longitud de corte, no un elemento (2026-08-12, elegido por el Señor
  Stick).** Se le ofrecieron las dos formas con maqueta: tarjeta por longitud (con las posiciones
  adentro) o tarjeta por elemento (con varias figuras adentro). Escogió la primera.~~
  **ANULADA ese mismo día:** pidió la segunda forma y hoy la tarjeta es el elemento. Se conserva
  la nota para no volver a proponer el cambio como si fuera nuevo.
- **El estribo no se calcula solo (2026-08-12).** Ni la cantidad por separación ni la medida por
  recubrimiento: «que el usuario ponga el total de estribos». La app suma lo que él escribe, y esa
  es toda la magia. Con eso el recubrimiento se quedó sin uso y se retiró del capítulo.
- **La cantidad se guarda como se escribió, no como su total (2026-08-12).** «11+7+11» son once
  estribos en un extremo, siete al centro y once en el otro: el reparto es información de obra que
  se pierde al guardar solo el 29. Por eso el Excel lleva las dos columnas y la fórmula viva.
- **El botón «B = C» en vez de un campo que se copie solo (2026-08-12).** El bastón simétrico es la
  regla; obligar a escribir dos veces la misma medida es pedir un error de digitación.
- **La figura de la barra se escoge tocando su dibujo (2026-08-12).** Lo pidió el Señor Stick:
  «en vez de escoger si es doble escuadra o escuadra sencilla, que se vea un boceto de la forma
  de la barra». En obra la figura se reconoce de un vistazo; un desplegable con nombres obliga a
  traducir.
- **El croquis de la fila es a escala y con las medidas escritas, no un ícono (2026-08-12).** Un
  ícono ya lo da el selector. Lo que un despiece necesita al lado de cada marca es la figura
  acotada, y dibujarla con los números reales convierte un error de digitación (una escuadra de
  3 m en vez de 0,30 m) en algo que se ve sin leer.
- **Una sola escala para los dos ejes del croquis (2026-08-12).** Estirar cada eje por separado
  llenaría la caja, pero el dibujo mentiría sobre la forma: una barra de 4,20 con escuadra de
  0,30 se vería como una U cuadrada.
- **Las medidas van en UNA columna de texto en el Excel, no en tres numéricas (2026-08-12).** Un
  estribo se mide en cm y con separación; una barra recta, en m. Una cabecera fija «A / B / C»
  mentiría en las filas de estribo.
- **El croquis del Excel es vector, no imagen (2026-08-12).** `custGeom` con la polilínea de la
  figura: se amplía sin pixelarse, el archivo no engorda y no hay que generar un PNG por fila.
  Verificado abriendo el libro en Excel real: las formas sobreviven, no hay reparación.
- **Una hoja por tanda, más un consolidado (2026-08-12).** Es la estructura del Excel del Señor
  Stick —«PRIMERA TANDA» y «SEGUNDA TANDA» en hojas distintas—. El consolidado es lo que él sí
  tenía que sumar a mano, y es justo el trabajo que la app quita.
- **Las varillas no se combinan entre tandas ni entre filas (2026-08-12).** Cada corte sale de su
  varilla; combinar sobrantes de dos fundidas distintas sería contabilidad, no obra.
- **El .xlsx exportado lleva fórmulas, no valores muertos (2026-08-12).** Es lo único que el Excel
  del Señor Stick hacía y la primera versión de la exportación no: su columna `M2` es
  `=2*((C4*F4)+(D4*F4))`, viva. Si la hoja exportada solo trajera números, corregir una cantidad
  allá obligaría a volver a la app. El conteo de **varillas** sí queda estático: sale de un reparto
  por corte real, no de una multiplicación, y fingirlo con una fórmula sería mentir.
- **La formaleta se entrega en piezas, no en m² (2026-08-10, tras revisión).** El Señor Stick no
  compra metros cuadrados: pide formaletas de una medida. El resumen lista «30 × 120 cm → 12 und».
- **El conteo multiplica por la cantidad de columnas de la fila (2026-08-10, cuarta pasada).**
  Primero se entregó el juego de UNA columna, leyendo mal su ejemplo («una columna de 3,60 de alto
  de 30×30 necesitaría 12 formaletas de 1,20 × 0,30»): esa frase daba la tasa por columna, no decía
  que no se multiplicara. Él lo corrigió — «hace mal el cálculo, pide menos formaletas». Hoy el
  total alcanza para encofrar todas las columnas de la lista al tiempo, y el detalle de cada fila
  sigue mostrando las piezas de una sola columna para quien funda por tandas y rote el juego.
- **Cada cara se cubre por hiladas de altura uniforme (2026-08-10).** Teselar un rectángulo con
  rectángulos cualesquiera es un problema duro y además no es como se arma en obra. Se elige
  primero la combinación de alturas que suma la altura de la columna y luego se completa cada
  hilada a lo ancho. Da la respuesta que da un maestro con el catálogo en la mano.
- **La hilada que no cierra exacta a lo ancho pesa más que cualquier conteo de piezas
  (`PENA_ANCHO`, 2026-08-10).** Sin ese castigo el DP prefería una hilada alta que desborda la cara
  —un panel de 40 sobre una cara de 30— antes que tres hiladas exactas de 30. Se vio en prueba, no
  se supuso.
- **El catálogo arranca en 25 cm de ancho y solo 1,20 m de alto (2026-08-10, tercera pasada).** La
  primera versión traía 29 referencias en una tira plana y el Señor Stick la vio desordenada. Pidió
  la serie 25→60 de 5 en 5, toda de 1,20. Lo que falte se agrega desde la UI: la app avisa cuando
  una cara no cierra, así que el hueco se ve en vez de esconderse.
- **El catálogo se agrupa por altura de panel (2026-08-10).** Dentro de un grupo todas las piezas
  miden lo mismo de alto, así que el chip solo lleva el ancho; repetir "× 120 cm" en cada ficha era
  ruido. Rejilla `auto-fill` en vez de `flex-wrap` para que los anchos queden alineados en columnas.
- **La resistencia va en la fila, no arriba (2026-08-10).** Es un dato de la columna, no del
  capítulo, y permite que el resumen agrupe el concreto por f'c para pedirlo por separado.
- **Fuera dosificación, suministro y usos previstos (2026-08-10).** Los quitó el Señor Stick en la
  revisión: los usos no se entendían y el desglose de cemento/arena/grava no le servía. Con ellos
  se fue también el desmoldante, que colgaba de los m².
- **La formaleta se mide como área de contacto, no como perímetro completo (2026-08-10).** La
  columna de confinamiento —el caso más común en obra pequeña— va embebida en el muro y solo
  encofra dos caras; cobrar su perímetro completo infla la cantidad casi al doble. Por eso la fila
  tiene un selector de caras y las caras que se retiran son siempre las de dimensión `h`, en el
  orden `4 → 2(b+h)`, `3 → 2b+h`, `2 → 2b`, `1 → b`. En sección circular el mismo selector se lee
  como fracción del perímetro (4 = completo, 3 = ¾, 2 = ½, 1 = ¼).
- **El desperdicio de formaleta va sobre el juego a montar, no sobre el área de contacto
  (2026-08-10).** El área de contacto es una *medida* del elemento y no admite desperdicio; lo que
  se desperdicia es el material que se compra. Por eso `juego = área / usos · (1 + desp)` y el área
  de contacto se muestra limpia.
- **Estado y clave de `localStorage` separados por capítulo (2026-08-10).** `stick-quantity-v1`
  para mampostería y `stick-quantity-columnas-v1` para columnas. Meter todo en una sola clave
  habría invalidado los datos que el Señor Stick ya tiene guardados.
- **Modo Libre en vez de un catálogo de secciones raras (2026-08-10).** Mismo criterio que la
  opción *Personalizada* de mampostería: en lugar de inventar un catálogo de columnas en L y en T,
  se deja declarar el área y el perímetro medidos. Cubre cualquier sección sin fingir precisión.
- **Logo propio (2026-08-06).** El Señor Stick entregó `LOGO.png`: un glifo tipo almohadilla formado
  por 5 barras horizontales redondeadas partidas por un hueco vertical. Se reprodujo **como vector**
  (no como PNG incrustado) midiendo el maestro píxel a píxel: caja del glifo 961×859, barras de
  132 px de alto con paso de 182 px y radio 66, hueco vertical de 134 px en x 369–503. El hueco se
  recorta con una `<mask>` en vez de dibujar 10 piezas sueltas, porque las barras 1 y 5 quedan
  cortadas a media curva y como rectángulos redondeados independientes no darían la misma forma.
  Ese mismo SVG alimenta el `favicon.svg` y la marca del encabezado; el PNG maestro alimenta el
  `apple-touch-icon` (iOS no acepta SVG) y el `og:image`.
- **Favicon doble: SVG + PNG (2026-08-06).** `favicon.svg` se declara primero y lo usan Chrome, Edge
  y Firefox; **Safari no soporta favicon en SVG** y caería a nada, así que se declara detrás
  `favicon.png` (64×64, `tools/gen-favicon.ps1`). Importa porque el Señor Stick revisa desde iPhone,
  donde Safari sí muestra el ícono en la barra de pestañas. Los dos archivos son gemelos exactos:
  fondo `#1e1f1f` a sangre y glifo blanco con **cobertura 0.86**, no la del maestro (0.48) — a 16 px
  el glifo del maestro queda diminuto. Mismo criterio que `tools/gen-icons.ps1` de STICK FIT.
- **Repo público.** Excepción deliberada a la regla de repos privados por defecto: la utilidad es
  general y no expone datos del Señor Stick (todo vive en `localStorage` del visitante).
- **Un solo HTML, sin build.** GitHub Pages sirve el archivo tal cual; no hay CI ni compilación
  que mantener. Descartado React+Vite por sobredimensionado para una calculadora.
- **Sistema visual Stick en CSS puro**, variante AROS (Century Gothic → AppleGothic →
  Trebuchet MS → system-ui), según `STICK_UI_SYSTEM.md` §0.4 (la variante por defecto es AROS).
  **Desde el 2026-08-09 rige la v2 «Campo y Vidrio»** — ver sección de migración más abajo.
- **Anti-zoom de la familia Stick aplicado** (meta viewport + `touch-action:manipulation` +
  campos a 16px bajo `pointer:coarse`).
- **Medidas del catálogo declaradas como nominales típicas**, no como dato normativo: varían por
  ladrillera. La app muestra advertencia visible y ofrece la opción Personalizada. No inventar
  precisión que no existe.
- **El mortero es estimación de volumen de junta**, no de mortero total: no incluye relleno de
  celdas, dovelas ni inyección. Declarado en la UI y en el README.
- **Sin backend, sin cuentas, sin analítica.** La app no envía nada a ningún servidor.
- **Campos numéricos en `type="text"` con `inputmode="decimal"`, no `type="number"`.** En Colombia
  se escribe la coma decimal (`2,5`) y `input[type=number]` la descarta: el campo devuelve cadena
  vacía y el cálculo daba cero en silencio. Se filtra la entrada a `[0-9.,]` y `num()` normaliza la
  coma a punto. Regla a replicar en los capítulos siguientes.
- **Animación de fila solo en el primer render y en la fila nueva.** Repintar la lista completa en
  cada cambio de modo re-animaba todas las filas (parpadeo). Controlado con `animarTodo`/`animarId`.
- **El total se redondea hacia arriba una sola vez, sobre el agregado** (`Math.ceil` en `totales()`);
  los subtotales por fila se muestran redondeados al entero más cercano. Antes el detalle usaba
  `ceil` sobre el neto y no cuadraba con la suma visible de las filas.

## Pendientes y problemas conocidos
- **El despiece no resuelve traslapos ni longitudes de desarrollo.** Cuando una pieza no sale de
  una varilla la app avisa, pero el traslapo lo define el Señor Stick según la NSR-10 C.12.
- **No hay figura para barras dobladas en más de dos puntos** (zunchos en espiral, ganchos de
  columna en «pata de elefante», barras en Z con tramos inclinados). Hoy se resuelven con varias
  filas rectas.
- **El croquis del Excel no lleva cotas**, solo la silueta; las medidas viven en su columna. Poner
  texto dentro de la figura obligaría a un `txBody` por tramo y ensuciaría la hoja.
- Falta decidir si el consolidado debería contar las varillas combinando sobrantes entre tandas
  (hoy no lo hace, a propósito).
- Verificar las medidas del catálogo contra fichas técnicas reales (Ladrillera Santafé, Ocaña,
  Alfa). Hoy son valores de mercado comunes; el estructural 33×23 y el tolete 25×6.5×12.5 son
  los de mayor incertidumbre.
- Capítulos siguientes: concreto de vigas y losas, acero de refuerzo (despiece y peso por
  diámetro), pañete, pisos y enchapes.
- **El catálogo de formaletas no está verificado contra un proveedor.** Confirmar contra Forsa /
  Formesan / el alquilador de la zona. Mitigado: cada medida se puede desactivar y se pueden
  agregar propias desde la UI.
- **Con un catálogo de solo 1,20 m de alto, las alturas que no sean múltiplo de 1,20 no cierran.**
  Una columna de 2,50 m avisa que sobran 110 cm. Falta decidir con el Señor Stick si se agrega de
  fábrica una serie de alturas cortas (30/45/60/90 cm) para rematar, o si eso se resuelve a mano.
- El capítulo ya no calcula dosificación de mezcla. Si vuelve a hacer falta, la tabla anterior
  (6.5 a 9.5 sacos/m³ según resistencia) está en el historial de git, sin verificar.
- El capítulo de columnas no incluye acero de refuerzo: hasta que exista el capítulo de acero, el
  despiece de estribos y longitudinales sigue siendo manual.
- **Las secciones circular y libre solo entregan volumen.** El panel recto no encofra un círculo;
  faltaría un catálogo de camisa circular (tubo de cartón / molde curvo) que no se ha verificado.
- El conteo de formaletas no incluye accesorios: grapas, pines, chavetas, alineadores ni puntales.
- Las columnas de sección variable (troncocónicas, con cambio de sección por piso) se resuelven
  hoy con varias filas; no hay un modo propio.
- No hay PWA (`manifest.json` / service worker). Evaluar si se quiere instalable como STICK FIT.
- Falta soporte de aparejos distintos al de soga (unidad pegada de tizón o de canto cambia la cara
  vista); hoy se resuelve con la opción Personalizada.

## Nota de despliegue (2026-08-06)
El primer despliegue quedó bloqueado por una caída de GitHub (Actions y Pages en `major_outage`;
webhooks limitados al 15 %, runners atascados). El workflow `pages build and deployment` falló con
`Failed to resolve action download info. Error: Service Unavailable` y un reintento quedó más de una
hora en `queued` sin runner asignado.

**Solución que sí funcionó:** solicitar la compilación directamente por la API de Pages, que no
depende de la cola de Actions ni del webhook del push:

```powershell
gh api -X POST repos/ZafiroSad/STICK-QUANTITY/pages/builds
gh api repos/ZafiroSad/STICK-QUANTITY/pages/builds/latest --jq .status   # queued -> building -> built
```

Recordar esta vía si un `push` no dispara el despliegue.
