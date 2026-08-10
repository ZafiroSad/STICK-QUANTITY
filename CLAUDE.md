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

## Estado actual — v1.1.0 (Mampostería + Concreto de columnas)

### Capítulo Concreto — columnas (2026-08-10)
Segundo capítulo. La barra de capítulos deja de ser decorativa: `Mampostería` y
`Concreto · Columnas` son `<button data-cap>` que alternan `#vistaMamposteria` / `#vistaColumnas`;
el capítulo activo se recuerda en `localStorage` (`stick:capitulo`) y los botones de copiar/CSV
de la topbar despachan al capítulo visible.

- Filas de columna ilimitadas, cada una en modo **Rectangular** (b × h cm), **Circular** (Ø cm) o
  **Libre** (área m² y perímetro m declarados a mano — cubre secciones en L, T o cualquier otra).
- Altura en m, cantidad de columnas iguales y **caras a formaletear** (4/3/2/1/0).
- Mezcla: 17.5 / 21 / 24.5 / 28 MPa con dosificación de referencia por m³, o **Personalizada**.
- Suministro **premezclado** (pide m³, con sugerencia redondeada al medio m³) o **hecho en obra**
  (pide cemento en sacos de 50 kg, arena, grava y agua).
- Formaleta metálica o de madera, con usos previstos, desperdicio propio y desmoldante en L/m².
- Persistencia independiente en `localStorage` bajo `stick-quantity-columnas-v1`, para no tocar
  los datos ya guardados de mampostería.

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
- `MEZCLAS` — dosificaciones de referencia por m³ (sacos de 50 kg, arena, grava, agua).
  **Agregar resistencias aquí, no en la UI.**
- `seccionCol()` / `perimetroCol()` — área de la sección y perímetro efectivamente encofrado.
- `calcCol()` / `totalesCol()` — volumen y formaleta por fila, y el agregado con desperdicios.
- `pintarFilasColSuave()` — mismo criterio que en mampostería: actualiza los pies sin re-pintar
  los inputs, para no perder el foco.
- `pintarCapitulo()` — alterna las dos vistas y el estado `on` de los chips.

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
- Verificar las medidas del catálogo contra fichas técnicas reales (Ladrillera Santafé, Ocaña,
  Alfa). Hoy son valores de mercado comunes; el estructural 33×23 y el tolete 25×6.5×12.5 son
  los de mayor incertidumbre.
- Capítulos siguientes: concreto de vigas y losas, acero de refuerzo (despiece y peso por
  diámetro), pañete, pisos y enchapes.
- **Dosificaciones del capítulo de concreto sin verificar contra fichas técnicas.** Son valores de
  mercado comunes (6.5 a 9.5 sacos/m³ según resistencia); el agua es la de mayor incertidumbre
  porque depende del asentamiento. Confirmar con Argos / Cemex antes de darlos por buenos.
- El capítulo de columnas no incluye acero de refuerzo: hasta que exista el capítulo de acero, el
  despiece de estribos y longitudinales sigue siendo manual.
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
