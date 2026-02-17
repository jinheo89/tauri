# tauri-app 빌드 가이드 (macOS · Android)

이 프로젝트는 **Vite + React** 프론트엔드와 **Tauri 2** 백엔드로, 아래 플랫폼으로 빌드할 수 있습니다.

- **macOS** — 네이티브 `.app` / `.dmg`
- **Android** — `.apk` / `.aab` (모바일 앱)

---

## 1. macOS 빌드

### 1.1 Mac에서 직접 빌드

```bash
# 의존성 설치 (최초 1회)
npm install

# Apple Silicon (M1/M2/M3)용
npm run build:mac

# Intel Mac용
npm run build:mac:x64
```

- **결과물**: `src-tauri/target/aarch64-apple-darwin/release/bundle/` (또는 `x86_64-apple-darwin`)
  - `.app`: `bundle/macos/tauri-app.app`
  - `.dmg`: `bundle/dmg/` 내 설치용 디스크 이미지

### 1.2 Windows에서 macOS 빌드 (GitHub Actions)

1. 저장소를 GitHub에 push
2. **Settings → Actions → General**에서 Workflow permissions를 **Read and write**로 설정
3. **Actions** 탭 → **Build macOS** → **Run workflow** 실행
4. 완료 후 Artifacts 또는 Releases에서 `.dmg` / `.app` 다운로드

`release` 브랜치에 push해도 동일 워크플로가 실행됩니다.

---

## 2. Android 빌드

### 2.1 사전 요구사항 (로컬)

- [Rust](https://rustup.rs/) (Android 타겟 포함)  
  - 설치 후 **기본 툴체인 설정**: `rustup default stable`
  - Cursor/VS Code 터미널에서 `cargo`를 못 찾으면:  
    `$env:Path = "$env:USERPROFILE\.cargo\bin;" + $env:Path` (PowerShell)  
    또는 `tauri-app`에서 `.\scripts\env-with-cargo.ps1` 실행 후 Tauri 명령 실행
- [Node.js](https://nodejs.org/) LTS
- [Android Studio](https://developer.android.com/studio) 또는 Android SDK/NDK만 설치

### 2.2 Android 프로젝트 초기화 (최초 1회)

```bash
npm install
npm run android:init
```

- `android:init`은 `src-tauri/gen/android/` 아래에 Android 프로젝트를 생성합니다.
- Rust Android 타겟이 없으면 CLI가 설치를 안내합니다.

### 2.3 개발 모드 (실기기/에뮬레이터)

```bash
# USB로 기기 연결 또는 에뮬레이터 실행 후
npm run android:dev
```

- 개발 서버가 기기에서 접속 가능한 주소로 올라가며, 핫 리로드가 동작합니다.

### 2.4 릴리스 빌드

```bash
# APK + AAB 모두 생성
npm run android:build

# APK만
npm run android:build:apk

# AAB만 (Play Store 업로드용)
npm run android:build:aab
```

- **APK 결과물**: `src-tauri/gen/android/app/build/outputs/apk/`
- **AAB 결과물**: `src-tauri/gen/android/app/build/outputs/bundle/`

### 2.4.1 빌드된 Android 앱 실행하기

**방법 1 – 프로덕션 모드로 빌드 후 바로 실행 (권장)**

```bash
# 연결된 기기 또는 실행 중인 에뮬레이터에 앱을 빌드·설치·실행
npm run android:run
```

- USB로 기기를 연결했거나 에뮬레이터가 켜져 있어야 합니다.
- 필요하면 `adb devices`로 기기 인식 여부를 확인하세요.

**방법 2 – 이미 빌드된 APK 설치 후 실행**

1. APK 경로 (릴리스 빌드 기준):
   - `src-tauri/gen/android/app/build/outputs/apk/release/app-release-unsigned.apk`
   - 또는 ABI별: `.../apk/release/app-arm64-v8a-release-unsigned.apk` 등

2. **실기기**: APK 파일을 기기로 복사한 뒤 파일 관리자에서 탭해 설치·실행  
   또는 PC에서:
   ```bash
   adb install -r src-tauri/gen/android/app/build/outputs/apk/release/app-release-unsigned.apk
   ```

3. **에뮬레이터**: 에뮬레이터 실행 후
   ```bash
   adb -e install -r src-tauri/gen/android/app/build/outputs/apk/release/app-release-unsigned.apk
   ```

4. 설치 후 기기/에뮬레이터 앱 목록에서 **tauri-app** 아이콘을 눌러 실행합니다.

**ADB 없이 실기기에서만**: APK를 이메일/드라이브로 보내거나 USB로 복사한 뒤, 기기에서 “알 수 없는 앱 설치” 허용 후 해당 APK를 열어 설치·실행하면 됩니다.

### 2.5 CI에서 Android 빌드 (GitHub Actions)

1. 저장소를 GitHub에 push
2. **Actions** 탭 → **Build Android** → **Run workflow** 실행
3. 완료 후 **Artifacts**에서 `android-apk` 다운로드

`release` 브랜치에 push해도 **Build Android** 워크플로가 실행됩니다.

---

## 3. 스크립트 요약 (package.json)

| 스크립트 | 설명 |
|----------|------|
| `npm run dev` | Vite 개발 서버 (데스크톱/모바일 공통) |
| `npm run build` | React 프로덕션 빌드 (Tauri용 `dist` 생성) |
| `npm run tauri build` | 현재 OS용 네이티브 앱 (Windows: .exe, Mac: .app 등) |
| `npm run build:mac` | macOS Apple Silicon용 앱 (Mac에서만) |
| `npm run build:mac:x64` | macOS Intel용 앱 (Mac에서만) |
| `npm run android:init` | Android 타겟 초기화 (최초 1회) |
| `npm run android:dev` | Android 개발 모드 (기기/에뮬레이터) |
| `npm run android:build` | Android APK + AAB 빌드 |
| `npm run android:build:apk` | Android APK만 빌드 |
| `npm run android:build:aab` | Android AAB만 빌드 |
| `npm run android:run` | Android 앱을 프로덕션 모드로 빌드 후 기기/에뮬레이터에서 실행 |

---

## 4. 설정 파일 요약

- **tauri.conf.json** — 공통 Tauri 설정, 번들(macOS/Android) 옵션
- **src-tauri/tauri.android.conf.json** — Android 전용 오버라이드 (창 크기 등)
- **.github/workflows/build-macos.yml** — macOS 빌드 CI
- **.github/workflows/build-android.yml** — Android 빌드 CI

---

## 5. 참고 링크

- [Tauri 문서](https://v2.tauri.app/)
- [Tauri 배포 가이드](https://v2.tauri.app/distribute/)
- [Android 코드 서명](https://v2.tauri.app/distribute/sign/android) (Play Store 배포 시)
