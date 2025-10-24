# PMHub (AltStore / local-first)

## Генерация Xcode-проекта
Проект описан в `project.yml` (XcodeGen).

1. Установи XcodeGen (на macOS):
   ```bash
   brew install xcodegen
   ```
2. Сгенерируй Xcode-проект:
   ```bash
   xcodegen generate
   open PMHub.xcodeproj
   ```

## Windows: как получить .ipa через GitHub Actions
Тебе не нужен macOS локально.

1. Форкни репозиторий или загрузи код в свой приватный репозиторий GitHub.
2. Подготовь сертификаты/профили:
   - Создай Apple Development сертификат (.p12) и профиль разработки (.mobileprovision) на developer.apple.com (нужна учётка разработчика).
   - Закодируй их в base64:
     - Windows PowerShell: `certutil -encode input.p12 output.b64` и `certutil -encode profile.mobileprovision profile.b64`
3. В репозитории GitHub → Settings → Secrets and variables → Actions → New repository secret:
   - `P12_BASE64` = содержимое .p12.b64 (без заголовочных строк)
   - `P12_PASSWORD` = пароль к .p12
   - `MOBILEPROVISION_BASE64` = содержимое .mobileprovision.b64
   - `APPLE_TEAM_ID` = твой Team ID (например, ABCD123456)
   - `APP_BUNDLE_ID` = `app.pmhub.local` (или свой bundle id, совпадающий с профилем)
   - `PROVISIONING_PROFILE_NAME` = имя профиля подписи
4. Запусти workflow вручную: GitHub → Actions → `iOS .ipa (AltStore)` → Run workflow.
5. После завершения скачай артефакт `PMHub.ipa` в разделе Artifacts.
6. Установи через AltStore (Windows): AltServer → AltStore на устройстве → My Apps → + → выбери `PMHub.ipa`.

## Архитектура
- iOS 16+, SwiftUI + MVVM.
- Local-first: JSON/SQLite (в этой версии: JSON FileDataStore), шифрование Keychain позже.
- Вкладки: Home, Waiting, People, Docs; FAB с тремя действиями.

## Каталоги
- `PMHub/App` — входная точка приложения.
- `PMHub/Shared` — дизайн-система, модели, сторедж, компоненты.
- `PMHub/Features/*` — экраны по фичам.
- `PMHub/Resources` — Info.plist и ресурсы.

## Зависимости
На текущем этапе без внешних зависимостей. Позже: AppAuth, GRDB/SQLCipher и т.п.
