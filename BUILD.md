# Paano gawin ang APK, Windows app, at iOS app

May dalawang paraan. **Paraan A** ang pinakamadali (walang kailangang i-install sa computer mo).

---

## Paraan A: Hayaan ang GitHub ang gumawa (libre)

1. Gumawa ng libreng account sa https://github.com at gumawa ng bagong **repository** (hal. `maxine`).
2. I-upload ang buong laman ng folder na ito sa repository (pwede i-drag and drop sa "Add file > Upload files").
   Siguraduhing kasama ang folder na `.github` (naka-hide minsan; sa Windows, i-on ang "Show hidden items").
3. **Pinakamadali:** pagkatapos ng mga 10 minuto, buksan ang **Releases** sa kanang bahagi ng repo page (o `github.com/<username>/maxine/releases`). Nandoon ang `Maxine-Android.apk`, `Maxine-Windows.zip`, at iba pa.
   Alternatibo: pumunta sa tab na **Actions**. Kusang magsisimula ang "Build Maxine". Hintayin ng mga 10–15 minuto.
4. Buksan ang natapos na run, at sa ibaba sa **Artifacts**, i-download ang:
   - `maxine-android-apk` → may laman na `app-release.apk`
   - `maxine-windows` → buksan ang `maxine.exe`
   - `maxine-macos` → `maxine.app`
   - `maxine-linux`
   - `maxine-ios-unsigned` → `.ipa` (kailangan pa i-sign, tingnan sa ibaba)
   - `maxine-web` → pwedeng i-host bilang website

### I-install ang APK sa Android
1. Ilipat ang `app-release.apk` sa phone (USB, Google Drive, Messenger, atbp).
2. Buksan ito. Kapag nagtanong, payagan ang "Install unknown apps" para sa app na ginamit mo (hal. Files o Chrome).
3. I-tap ang Install. Buksan si Maxine at payagan ang microphone kung gusto mong kausapin siya sa boses.

---

## Paraan B: Sa sarili mong computer

1. I-install ang Flutter: https://docs.flutter.dev/get-started/install (sundin ang para sa Windows/Mac/Linux).
2. Para sa Android: i-install ang **Android Studio** (kasama na ang Android SDK). Patakbuhin ang `flutter doctor` at sundin ang mga sinasabi nito.
3. Sa folder na ito, patakbuhin:

```bash
flutter pub get
flutter test                 # sinusubok ang utak ni Maxine
flutter build apk --release  # Android → build/app/outputs/flutter-apk/app-release.apk
flutter build windows        # Windows → build/windows/x64/runner/Release/maxine.exe  (kailangan ng Visual Studio "Desktop development with C++")
flutter build macos          # Mac
flutter build linux          # Linux
flutter build web            # Web
flutter run                  # subukan habang naka-konekta ang phone
```

---

## iPhone / iPad (iOS) – mahalagang paalala

Apple ang may mahigpit na patakaran, kaya **hindi pwedeng direktang i-install ang app na parang APK**. Mga opsyon:

1. **May Mac ka:** buksan ang `ios/Runner.xcworkspace` sa Xcode, ilagay ang libreng Apple ID mo sa *Signing & Capabilities*, ikonekta ang iPhone, at pindutin ang ▶ Run.
   Sa libreng Apple ID, kailangang i-install ulit kada 7 araw.
2. **Apple Developer Program ($99/taon):** para ma-install nang permanente, magamit ang TestFlight, o mailagay sa App Store.
3. **Walang Mac:** gamitin ang `.ipa` mula sa Paraan A kasama ang tool tulad ng Sideloadly o AltStore (kailangan pa rin ng Apple ID at computer).
4. **Pinakamabilis na alternatibo:** buksan ang web version sa Safari at piliin ang *Share > Add to Home Screen*. Magmumukha itong app.

---

## Tungkol sa boses at offline

- **Pagsasalita ni Maxine (text-to-speech):** gumagamit ng boses na nasa device, kaya gumagana offline.
  Kung may Filipino na boses ang device, iyon ang gagamitin. Kung wala, English na boses ang babasa (medyo may accent).
  Sa Android, pwedeng mag-download ng Filipino na boses: *Settings > Accessibility > Text-to-speech > Speech Services by Google > Install voice data > Filipino*.
- **Pakikinig sa boses mo (speech-to-text):**
  - Android at iPhone: gumagana. Para gumana offline, i-download ang offline language pack (Android: *Google app > Settings > Voice > Offline speech recognition*).
  - Mac at web (Chrome/Edge): gumagana pero kadalasan kailangan ng internet.
  - Windows/Linux: maaaring hindi lumabas ang mic button; i-type na lang ang mensahe.
- **Online Mode (opsyonal, may LIBRENG option):** para masagot ni Maxine ang halos kahit anong tanong.
  - **Libre: Google Gemini.** Buksan ang https://aistudio.google.com/apikey, mag-login gamit ang Gmail, i-click ang "Create API key", kopyahin,
    tapos sa app: Settings > Online Mode > piliin ang "Gemini (LIBRE)" > i-paste ang key. Walang credit card na kailangan.
    May limitasyon ang libre (mga ilang daang tanong bawat araw), sobra-sobra na para sa karaniwang kwentuhan.
  - **May bayad: Claude**, mula sa https://console.anthropic.com.
  Ginagamit lang ang Online Mode kapag hindi alam ng offline na Maxine ang sagot, kaya mabilis pa rin ang karaniwang usapan.
