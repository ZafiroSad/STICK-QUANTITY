# STICK QUANTITY

Calculadora de **cantidades de obra**. Aplicación web de un solo archivo, sin dependencias ni
servidor: se abre en el navegador y funciona también sin conexión una vez cargada.

**En línea:** https://zafirosad.github.io/STICK-QUANTITY/

---

## Capítulos

| Capítulo | Estado |
|---|---|
| Mampostería — ladrillos, junta y mortero de pega | Disponible |
| Concreto — columnas y formaleta | Disponible |
| Acero — despiece, peso y varillas | Disponible |
| Concreto — vigas y losas | Pendiente |
| Pañete / revoque | Pendiente |
| Pisos y enchapes | Pendiente |

---

## Mampostería

Calcula la cantidad de unidades a partir de:

- **Tipo de unidad** — catálogo de referencias del mercado colombiano (bloque H-10 a H-20,
  estructural, tolete, farol, bloque de concreto) o medidas personalizadas medidas en obra.
- **Junta** — 1.0, 1.5, 2.0, 2.5, 3.0 cm o un valor propio.
- **Muros** — una fila por muro, en área directa (m²) o largo × alto (m), con cantidad de
  muros iguales y descuento de vanos.
- **Desperdicio** — porcentaje global, 5 % por defecto.

Entrega el total a pedir, el área neta, el rendimiento en und/m² y una estimación del mortero
de pega.

### Fórmulas

Unidades por metro cuadrado:

```
und/m² = 10 000 / [ (L + j) · (H + j) ]
```

`L` = largo de la cara vista (cm), `H` = alto de la cara vista (cm), `j` = junta (cm).
Cada unidad ocupa en el muro su propia medida más una junta horizontal y una vertical.

Mortero de pega, en m³ por m² de muro:

```
V = [ 1 − (L · H) / ((L + j) · (H + j)) ] · e · f
```

El corchete es la fracción del paño ocupada por juntas; `e` es el espesor del muro (m) y `f` el
factor de contacto: `1.00` para junta llena en todo el espesor y `0.55` cuando solo se pega sobre
las paredes del bloque hueco.

### Advertencia técnica

Las medidas del catálogo son **nominales típicas** y varían entre ladrilleras. Antes de emitir un
pedido, confirmar contra la ficha técnica del proveedor o medir la unidad en obra y usar la opción
*Personalizada*. La estimación de mortero cubre únicamente el volumen de junta: no incluye relleno
de celdas, dovelas ni mortero de inyección.

---

## Concreto — columnas

Calcula el volumen de concreto y **cuántas formaletas pedir**, contadas por medida.

- **Sección** — rectangular (ancho × largo en cm), circular (Ø en cm) o libre (área declarada).
- **Resistencia por columna** — 17.5 a 35 MPa. El resumen agrupa el concreto por resistencia.
- **Altura, cantidad de columnas iguales** y **caras a formaletear**.
- **Catálogo de formaletas** — de fábrica trae los anchos de 25 a 60 cm en pasos de 5, todos de
  1,20 m de alto. Cada medida se activa o desactiva, y se pueden agregar otras (un ancho de 20,
  un panel de 2,40 de alto). El catálogo se muestra agrupado por altura de panel.
- **Formaleta por fila** — `Automática`, que combina las medidas activas buscando el mejor
  encaje, o una medida concreta («Solo 30 × 120 cm»).

### Fórmulas

Volumen de concreto:

```
V = A_sección · altura · cantidad
```

con `A` rectangular = `ancho · largo`, circular = `π · D² / 4`, o el área declarada en modo libre.
Las secciones se escriben en cm y la altura en m.

**Formaleta.** Cada cara a encofrar es un rectángulo de ancho `W` y altura `H` que se cubre por
hiladas de altura uniforme: primero se escoge la combinación de alturas de panel que suma `H`, y
cada hilada se completa a lo ancho con los paneles que existan en esa altura. Entre las
combinaciones posibles gana, en este orden, la que **cierra exacto**, la de **menos piezas** y la
de **menos sobrante**.

> Columna de 30 × 30 cm y 3,60 m de alto, 4 caras, con paneles de 30 × 120: cada cara son tres
> paneles → **12 formaletas**.

Cuando una cara no cierra exacta —una columna de 20 cm de ancho sin panel de 20 en el catálogo, o
una altura de 2,50 m con paneles de 1,20— la fila avisa cuántos centímetros sobran. La salida es
agregar la medida que falta al catálogo.

Las caras que se retiran son las del **largo**:

| Caras | Se encofra |
|---|---|
| 4 — columna exenta | `ancho, largo, ancho, largo` |
| 3 — una cara contra muro | `ancho, ancho, largo` |
| 2 — confinamiento | `ancho, ancho` |
| 1 | `ancho` |
| 0 | nada |

El total alcanza para **encofrar todas las columnas de la lista al mismo tiempo**: la cantidad de
columnas iguales de cada fila multiplica tanto el concreto como las piezas. Seis columnas de
30 × 30 y 3,60 m piden 72 formaletas de 30 × 120. Quien las funda por tandas y rote el juego pide
solo lo de la tanda más grande: el detalle de cada fila muestra las piezas de una sola columna.

### Pedido por WhatsApp

El resumen se copia como un **mensaje de pedido**, listo para pegar en WhatsApp: el total arriba en
negrita, el desglose debajo y el detalle por columna al final. Dos interruptores deciden qué entra —
**Concreto**, **Formaleta** o los dos—, de modo que a la planta de concreto le llegue solo el m³ por
resistencia y al alquilador de formaleta solo el conteo de piezas. El título del mensaje cambia
según el caso: *PEDIDO DE OBRA*, *PEDIDO DE CONCRETO* o *PEDIDO DE FORMALETA*.

En concreto, el mensaje añade el volumen redondeado a pasos de 0,5 m³, que es como se despacha el
premezclado.

### Advertencia técnica

Las medidas del catálogo son las **modulares habituales** del mercado, no el catálogo verificado de
un proveedor: confirmar con el alquilador y agregar las que falten. Con solo paneles de 1,20 m de
alto, las alturas de columna que no sean múltiplo de 1,20 no cierran exactas. El cálculo cubre solo el
concreto — no incluye acero de refuerzo, alambre, separadores, dados de cimentación ni los
accesorios de la formaleta (grapas, pines, alineadores, puntales). Las secciones circular y libre
solo entregan volumen, porque el panel recto no las encofra.

---

## Acero — despiece

Una **tarjeta por longitud de corte**. Arriba, la figura —que se escoge **tocando su dibujo**:
recta, escuadra sencilla, doble escuadra o estribo— y sus medidas; las letras `A`, `B` y `C` del
dibujo son las mismas de los campos. En medio, el **croquis acotado de esa barra, a escala**, con
las medidas escritas y sus ganchos. Abajo, las **posiciones** que comparten esa longitud —arriba,
abajo, estribos—, cada una con su cantidad y su diámetro. Así una viga entera cabe en una tarjeta.

La **cantidad admite sumas**: `11+7+11` son once estribos en un extremo, siete al centro y once en
el otro. Se guarda tal cual y el Excel se lleva las dos cosas, el reparto y su total.

En la doble escuadra, el botón **B = C** hace que la escuadra derecha copie a la izquierda.

El trabajo se organiza en **tandas** (una fundida cada una). Cada tanda tiene su nombre y su lista;
la varilla comercial, el desperdicio y el gancho estándar valen para todas.

### Fórmulas

Longitud de corte, como se despieza en obra — **suma de tramos cara a cara**, sin descontar el
desarrollo del doblez (queda del lado de la seguridad):

```
L = Σ tramos + ganchos

Gancho 90°   →  12 db                     (NSR-10 C.7.1)
Gancho 180°  →  4 db, mínimo 6,5 cm
Estribo      →  2·B + 2·H + 2·gancho      (los tres se escriben a mano, en m)
Peso  =  L total × masa nominal           (NTC 2289)
```

Las varillas se cuentan por **corte real**: cuántas piezas enteras salen de una varilla comercial,
sin combinar barras de filas ni de tandas distintas.

### Exportación a Excel

El botón **Exportar a Excel** entrega un `.xlsx` de verdad, escrito a mano por la app (sin
librerías): **una hoja por tanda** y una hoja **CONSOLIDADO** cuando hay más de una. Cada hoja lleva
el croquis de cada barra como **figura vectorial**, la columna `A` libre para marcar con «x» lo ya
cortado, y la marca de STICK QUANTITY en la esquina.

Cada tarjeta es un bloque: las celdas de figura, croquis, medidas y longitud unitaria van
**combinadas a lo alto** de sus posiciones, y cada posición es una fila. El reparto de estribos
aparece dos veces a propósito — en `REPARTO` como texto (`11 + 7 + 11`) y en `CANT` como la
fórmula `=11+7+11`, que muestra `29`.

La hoja sale **viva**: los metrajes, los pesos, los subtotales, el resumen por diámetro y el
consolidado son fórmulas. Corregir una cantidad dentro de Excel —o el propio reparto— recalcula
todo lo demás, incluida la hoja de consolidado, sin volver a la app.

### Advertencia técnica

El despiece **no** resuelve traslapos, longitudes de desarrollo ni alambre de amarre: si una pieza
no sale de una varilla, la app avisa, pero el traslapo se define según la **NSR-10 C.12**. Las
masas son las nominales de la **NTC 2289**; el acero real varía dentro de la tolerancia de fábrica.
Verificar siempre contra los planos estructurales.

---

## Uso

Abrir `index.html` en cualquier navegador, o entrar al enlace de GitHub Pages. Los datos quedan
guardados en el navegador (`localStorage`); no se envía nada a ningún servidor.

## Stack

HTML + CSS + JavaScript en un único archivo. Sistema visual de la familia Stick
(dark-first, escala zinc, tipografía del sistema), replicado en CSS puro.
