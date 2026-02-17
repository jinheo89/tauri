# Cursor/VS Code 터미널에서 Cargo를 찾지 못할 때 사용하세요.
# 사용법: . .\scripts\env-with-cargo.ps1   또는 터미널에서 먼저 실행 후 npm run tauri ...
$cargoBin = "$env:USERPROFILE\.cargo\bin"
if (Test-Path $cargoBin) {
  $env:Path = "$cargoBin;$env:Path"
  Write-Host "Cargo added to PATH for this session. You can now run: npx tauri android init" -ForegroundColor Green
} else {
  Write-Host "Cargo not found at $cargoBin. Install Rust from https://rustup.rs" -ForegroundColor Yellow
}
