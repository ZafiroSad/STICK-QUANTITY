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

## Estado actual — v1.0.0 (capítulo Mampostería completo)
- Catálogo de unidades: bloque de arcilla H-10/H-12/H-15/H-20, estructural 12/15/20,
  tolete común, tolete prensado, farol, bloque de concreto 10/12/15/20, y **Personalizada**.
- Junta seleccionable (1.0 / 1.5 / 2.0 / 2.5 / 3.0 cm + valor propio).
- Filas de muro ilimitadas, cada una en modo **Largo × Alto** o **Área**, con cantidad de muros
  iguales y descuento de vanos en m².
- Desperdicio global (5 % por defecto), mortero de pega estimado, exportación CSV y copia de
  resumen en texto.
- Persistencia en `localStorage` bajo la clave `stick-quantity-v1`.

## Arquitectura
Un solo archivo `index.html` con CSS y JS embebidos, sin build ni dependencias —
mismo patrón que STICK FIT y URL-MP4 (proyectos autónomos, sin acoplar).

| Archivo | Rol |
|---|---|
| `index.html` | Toda la app: estilos, catálogo, motor de cálculo y UI |
| `favicon.svg` | Marca (dos hiladas de ladrillo, trazo zinc-200) |
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

## Decisiones tomadas
- **Repo público.** Excepción deliberada a la regla de repos privados por defecto: la utilidad es
  general y no expone datos del Señor Stick (todo vive en `localStorage` del visitante).
- **Un solo HTML, sin build.** GitHub Pages sirve el archivo tal cual; no hay CI ni compilación
  que mantener. Descartado React+Vite por sobredimensionado para una calculadora.
- **Sistema visual Stick en CSS puro**, variante AROS (Century Gothic → AppleGothic →
  Trebuchet MS → system-ui), según `STICK_UI_SYSTEM.md` §0.4 (la variante por defecto es AROS).
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
- Verificar las medidas del catálogo contra fichas técnicas reales (Ladrillera Santafé, Ocaña,
  Alfa). Hoy son valores de mercado comunes; el estructural 33×23 y el tolete 25×6.5×12.5 son
  los de mayor incertidumbre.
- Capítulos siguientes: concreto (vigas, columnas, losas), acero de refuerzo (despiece y peso por
  diámetro), pañete, pisos y enchapes.
- No hay PWA (`manifest.json` / service worker). Evaluar si se quiere instalable como STICK FIT.
- Falta soporte de aparejos distintos al de soga (unidad pegada de tizón o de canto cambia la cara
  vista); hoy se resuelve con la opción Personalizada.
- No hay logo propio; la marca del header es un SVG inline.
