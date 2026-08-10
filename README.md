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
| Concreto — vigas y losas | Pendiente |
| Acero de refuerzo | Pendiente |
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

Calcula el volumen de concreto y el área de formaleta a partir de:

- **Sección** — rectangular (b × h en cm), circular (Ø en cm) o libre (área y perímetro
  medidos directamente, para secciones en L, T o cualquier otra forma).
- **Altura, cantidad de columnas iguales** y **caras a formaletear**.
- **Mezcla** — 17.5 / 21 / 24.5 / 28 MPa con dosificación de referencia, o una propia.
- **Suministro** — premezclado (se pide en m³) o hecho en obra (se piden cemento, arena,
  grava y agua).
- **Formaleta** — metálica o madera, usos previstos y desperdicio propio.

Entrega el volumen a pedir, el área de contacto de la formaleta, el juego a montar, los
tableros de madera equivalentes, el desmoldante y los materiales de la mezcla.

### Fórmulas

Volumen de concreto:

```
V = A_sección · altura · cantidad
```

con `A` rectangular = `b · h`, circular = `π · D² / 4`, o el área declarada en modo libre.
Las secciones se escriben en cm y la altura en m.

Área de formaleta, medida como **área de contacto** con el concreto:

```
A_form = p_contacto · altura · cantidad
```

`p_contacto` es el perímetro efectivamente encofrado. Una columna exenta encofra su perímetro
completo; una columna de confinamiento embebida en el muro solo encofra las caras libres. Las
caras que se retiran son las de dimensión `h`:

| Caras | Perímetro de contacto |
|---|---|
| 4 — columna exenta | `2 · (b + h)` |
| 3 — una cara contra muro | `2b + h` |
| 2 — confinamiento | `2b` |
| 1 | `b` |
| 0 | `0` |

En sección circular el número de caras se lee como fracción del perímetro `π · D`:
4 = completo, 3 = ¾, 2 = ½, 1 = ¼.

La **formaleta a montar** es el área de contacto dividida entre los usos previstos, más su
desperdicio: es lo que hay que tener físicamente en obra si se rota el juego. El área de
contacto en sí no lleva desperdicio, porque es una medida y no un material.

### Advertencia técnica

Las dosificaciones son **valores de referencia** para mezcla hecha en obra: el diseño de mezcla
del laboratorio y la ficha del cemento mandan sobre esa tabla. El cálculo cubre *solo el concreto
de la columna* — no incluye acero de refuerzo, alambre, separadores, dados de cimentación ni la
porción de columna embebida en viga o losa.

---

## Uso

Abrir `index.html` en cualquier navegador, o entrar al enlace de GitHub Pages. Los datos quedan
guardados en el navegador (`localStorage`); no se envía nada a ningún servidor.

## Stack

HTML + CSS + JavaScript en un único archivo. Sistema visual de la familia Stick
(dark-first, escala zinc, tipografía del sistema), replicado en CSS puro.
