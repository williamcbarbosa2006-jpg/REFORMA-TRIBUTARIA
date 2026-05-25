# Gera os 4 módulos em PDF (A5) via Chrome headless
# Execute: .\gerar-pdfs.ps1

$chrome  = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$repo    = "C:\Users\willi\reforma-tributaria-barbosa"
$outDir  = "C:\Users\willi\Desktop\PDFs-Reforma-Tributaria"

New-Item -ItemType Directory -Force $outDir | Out-Null

$modulos = @(
    @{ html = "modulos\m1-visao-geral.html";      pdf = "M1-ReformaTributaria-VisaoGeral.pdf" },
    @{ html = "modulos\m2-novos-tributos.html";    pdf = "M2-ReformaTributaria-CBS-IBS-IS.pdf" },
    @{ html = "modulos\m3-impacto-setorial.html";  pdf = "M3-ReformaTributaria-ImpactoSetorial.pdf" },
    @{ html = "modulos\m4-plano-adequacao.html";   pdf = "M4-ReformaTributaria-PlanoAdequacao.pdf" }
)

Write-Host "`n=== Grupo Barbosa — Gerador de PDFs Reforma Tributária ===" -ForegroundColor Cyan
Write-Host "Destino: $outDir`n"

foreach ($m in $modulos) {
    $htmlPath = "$repo\$($m.html)"
    $pdfPath  = "$outDir\$($m.pdf)"

    Write-Host "Gerando: $($m.pdf) ..." -NoNewline

    Start-Process -FilePath $chrome -ArgumentList @(
        "--headless=new",
        "--disable-gpu",
        "--no-pdf-header-footer",
        "--print-to-pdf-no-header",
        "--virtual-time-budget=15000",
        "--print-to-pdf=`"$pdfPath`"",
        "file:///$htmlPath"
    ) -Wait -PassThru | Out-Null

    Start-Sleep -Seconds 2

    $kb = [math]::Round((Get-Item $pdfPath).Length / 1KB)
    Write-Host " OK ($($kb)KB)" -ForegroundColor Green
}

Write-Host "`nTodos os PDFs gerados em: $outDir" -ForegroundColor Cyan
Write-Host "Próximo passo: fazer upload de cada PDF na Kiwify (área de membros)`n"
