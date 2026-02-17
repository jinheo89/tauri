# React + Tauri 앱 빌드 가이드 (macOS 네이티브)

이 프로젝트는 **React + Vite** 프론트엔드와 **Tauri 2** 백엔드로, 네이티브 macOS 앱(.app, .dmg)으로 빌드할 수 있습니다.

---

## 1. macOS에서 직접 빌드

Mac이 있는 경우 터미널에서 다음을 실행하세요.

```bash
cd tauri-app

# 의존성 설치 (최초 1회)
npm install

# Apple Silicon (M1/M2/M3)용 빌드
npm run build:mac

# 또는 Intel Mac용 빌드
npm run build:mac:x64
```

- **결과물 위치**: `tauri-app/src-tauri/target/aarch64-apple-darwin/release/bundle/` (또는 `x86_64-apple-darwin`)
  - **.app**: `bundle/macos/tauri-app.app`
  - **.dmg**: `bundle/dmg/` 폴더 내 설치용 디스크 이미지

---

## 2. Windows에서 macOS 빌드 받기 (GitHub Actions)

현재 PC가 **Windows**이므로 macOS용 바이너리는 **GitHub Actions**로 빌드하는 것이 좋습니다.

### 사전 준비

1. 이 프로젝트를 **GitHub 저장소**에 올립니다.
2. 저장소 **Settings → Actions → General**에서  
   **Workflow permissions**를 **"Read and write permissions"**로 설정합니다.

### 빌드 실행 방법

**방법 A – 수동 실행**

1. GitHub 저장소 **Actions** 탭 이동
2. 왼쪽에서 **"Build macOS"** 워크플로 선택
3. **"Run workflow"** → **Run workflow** 클릭
4. 완료 후 **해당 run** 클릭 → **Artifacts**에서 `.dmg` / `.app` 다운로드

**방법 B – release 브랜치로 push**

```bash
git checkout -b release
git push origin release
```

- `release` 브랜치에 push할 때마다 자동으로 macOS 빌드가 돌고,  
  **Releases**에 드래프트가 생성됩니다.  
  **Actions** 탭에서 진행 상황을 확인할 수 있습니다.

### 결과물

- **Apple Silicon (M1 이상)**: `--target aarch64-apple-darwin` 빌드
- **Intel Mac**: `--target x86_64-apple-darwin` 빌드  
각각 GitHub **Artifacts** 또는 **Releases**에서 다운로드할 수 있습니다.

---

## 3. 스크립트 요약 (tauri-app/package.json)

| 스크립트 | 설명 |
|----------|------|
| `npm run build` | React 프론트엔드만 빌드 (Tauri용 dist 생성) |
| `npm run tauri build` | 현재 OS용 네이티브 앱 빌드 (Windows면 .exe, Mac이면 .app 등) |
| `npm run build:mac` | macOS Apple Silicon용 앱 빌드 (Mac에서만 가능) |
| `npm run build:mac:x64` | macOS Intel용 앱 빌드 (Mac에서만 가능) |

---

## 4. 참고

- **macOS 최소 버전**: Tauri 기본 설정 기준 (필요 시 `src-tauri/tauri.conf.json`의 `bundle.macOS.minimumSystemVersion` 등으로 조정 가능).
- **코드 서명/공증**: 앱을 다른 Mac에 배포하려면 Apple 개발자 계정으로 서명·공증을 설정하는 것이 좋습니다.  
  자세한 내용은 [Tauri 문서 – Distributing](https://v2.tauri.app/distribute/)를 참고하세요.
