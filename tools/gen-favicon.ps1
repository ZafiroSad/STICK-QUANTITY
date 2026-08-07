# Genera favicon.png dibujando la marca vectorialmente, para navegadores que no
# soportan favicon en SVG (Safari). Misma geometria que favicon.svg y que la marca
# del encabezado, medida de LOGO.png.
#
# Caja del glifo: 961 x 859. Cinco barras de 132 de alto, paso 182, radio 66,
# partidas por un hueco vertical en x 369-503. La cobertura sube a 0.86 (frente al
# 0.48 del maestro) porque a 16 px el glifo del maestro queda diminuto: mismo
# criterio que tools/gen-icons.ps1 de STICK FIT.
Add-Type -AssemblyName System.Drawing

$OUT = "C:\Users\kevin\Documents\KEVIN\02. WORK\03. PROYECTOS PERSONALES\STICK QUANTITY"
$FG = [System.Drawing.Color]::FromArgb(255, 255, 255)  # blanco del logo
$BG = [System.Drawing.Color]::FromArgb(30, 31, 31)     # #1E1F1F, fondo del maestro

$GW = 961.0; $GH = 859.0                # caja del glifo
$BARS = @(                              # x, y, ancho, alto
    @(269, 0,   268, 132),
    @(77,  182, 595, 132),
    @(195, 364, 766, 132),
    @(0,   546, 796, 132),
    @(269, 728, 370, 132)
)
$GAPX = 369.0; $GAPW = 134.0            # hueco vertical

function New-Favicon($size, $coverage, $path) {
    $bmp = New-Object System.Drawing.Bitmap $size, $size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear($BG)

    $s = ($size * $coverage) / $GW      # escala glifo -> destino
    $ox = ($size - $GW * $s) * 0.5
    $oy = ($size - $GH * $s) * 0.5
    $brush = New-Object System.Drawing.SolidBrush $FG

    foreach ($b in $BARS) {
        $x = $ox + $b[0] * $s
        $y = $oy + $b[1] * $s
        $w = $b[2] * $s
        $h = $b[3] * $s
        $p = New-Object System.Drawing.Drawing2D.GraphicsPath
        $p.AddArc([float]$x, [float]$y, [float]$h, [float]$h, 90, 180)              # tapa izquierda
        $p.AddArc([float]($x + $w - $h), [float]$y, [float]$h, [float]$h, 270, 180) # tapa derecha
        $p.CloseFigure()
        $g.FillPath($brush, $p)
        $p.Dispose()
    }

    # El hueco vertical se pinta encima con el fondo: las barras 1 y 5 quedan
    # cortadas a media curva, asi que como piezas sueltas no darian la misma forma.
    $gapBrush = New-Object System.Drawing.SolidBrush $BG
    $g.FillRectangle($gapBrush, [float]($ox + $GAPX * $s), 0.0, [float]($GAPW * $s), [float]$size)

    $brush.Dispose(); $gapBrush.Dispose(); $g.Dispose()
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    "{0}  ->  {1}px (cobertura {2})" -f (Split-Path $path -Leaf), $size, $coverage
}

New-Favicon 64 0.86 (Join-Path $OUT "favicon.png")
