# 🩺 RefluxCare – Návod na spustenie projektu

> **Pre Katku** – krok za krokom, od nuly až po bežiacu appku na telefóne/emulátore.

---

## 📋 Čo je RefluxCare?

Flutter mobilná aplikácia pre Android a iOS, ktorá pomáha ľuďom s refluxnou chorobou (GERD/LPR):
- 🍽️ Odporúčané jedlá s pH hodnotami a rizikom refluxu
- 📸 AI skenovanie jedla cez fotku (Anthropic Claude API)
- 📓 Denník symptómov s grafmi
- 📅 Týždenný jedálniček
- 👤 Personalizovaný profil s dotazníkom

---

## 🛠️ Čo potrebuješ nainštalovať (predpoklady)

### 1. Flutter SDK

1. Stiahni Flutter z: **https://docs.flutter.dev/get-started/install/windows/mobile**
2. Rozbaľ do priečinka (napr. `C:\flutter`)
3. Pridaj `C:\flutter\bin` do **systémovej premennej PATH**:
   - Hľadaj v Start menu: „Upraviť premenné prostredia systému"
   - Klikni **Premenné prostredia** → v **Systémové premenné** nájdi `Path` → **Upraviť** → **Nový** → vlož `C:\flutter\bin`
4. Otvor **nový** PowerShell/CMD a over:
   ```
   flutter --version
   ```
   Mal by sa ukázať výpis s verziou Flutter 3.x.x

### 2. Android Studio

1. Stiahni z: **https://developer.android.com/studio**
2. Nainštaluj a spusti
3. Pri prvom spustení nainštaluj **Android SDK** (ponúkne to automaticky)
4. Nainštaluj plugin **Flutter**:
   - Android Studio → **Settings** → **Plugins** → hľadaj **Flutter** → **Install**
   - Automaticky sa nainštaluje aj **Dart** plugin
5. Nainštaluj plugin **Dart** (ak sa nenainštaloval automaticky)

### 3. Android Emulátor

1. V Android Studio otvor **Tools → Device Manager**
2. Klikni **Create Virtual Device**
3. Vyber zariadenie (napr. **Pixel 9 Pro**) → **Next**
4. Stiahni systémový obraz (napr. **API 34** alebo **API 36**) → **Next** → **Finish**
5. Klikni ▶ na spustenie emulátora

> **💡 Tip:** Ak emulátor padá, v editácii zariadenia zmeň **Graphics** z „Automatic" na **„Software - GLES 2.0"**

### 4. Over, že je všetko OK

Otvor PowerShell a spusti:
```
flutter doctor
```

Mal by si vidieť niečo ako:
```
[✓] Flutter (Channel stable, 3.x.x)
[✓] Android toolchain - develop for Android devices
[✓] Android Studio
[✓] Connected device (1 available)   ← toto len ak beží emulátor
```

Ak niečo chýba, `flutter doctor` ti presne napíše čo treba urobiť.

---

## 📂 Štruktúra projektu

```
Filickova_app/
├── lib/                          ← 💡 TU JE CELÝ KÓD APLIKÁCIE
│   ├── main.dart                 ← vstupný bod appky
│   ├── app.dart                  ← navigácia (GoRouter) + téma
│   ├── core/
│   │   ├── theme/app_theme.dart  ← farby, fonty, dizajn systém
│   │   ├── constants/reflux_data.dart  ← mock dáta jedál
│   │   └── services/
│   │       ├── claude_ai_service.dart  ← AI analýza fotiek
│   │       ├── health_service.dart     ← smart hodinky (placeholder)
│   │       └── storage_service.dart    ← lokálna databáza (Hive)
│   ├── features/
│   │   ├── onboarding/           ← uvítacie obrazovky + dotazník
│   │   ├── dashboard/            ← hlavná obrazovka (domov)
│   │   ├── meal_plan/            ← jedálniček + detail jedla
│   │   ├── food_scanner/         ← skenovanie jedla kamerou
│   │   ├── food_search/          ← vyhľadávanie jedál
│   │   ├── symptom_diary/        ← denník symptómov
│   │   └── profile/              ← profil a nastavenia
│   └── shared/
│       ├── models/               ← dátové modely (FoodItem, UserProfile...)
│       └── widgets/              ← zdieľané UI komponenty
├── android/                      ← Android-špecifický kód (netreba meniť)
├── ios/                          ← iOS-špecifický kód (netreba meniť)
├── assets/                       ← obrázky, ikony
├── pubspec.yaml                  ← zoznam závislostí (balíčkov)
└── test/                         ← testy
```

---

## 🚀 Spustenie projektu – krok za krokom

### Krok 1: Otvor projekt

**Spôsob A – Android Studio (odporúčané):**
1. Otvor Android Studio
2. **File → Open** → vyber priečinok `D:\AndroidStudioProjects\Filickova_app`
3. Počkaj kým sa projekt načíta (môže trvať 1-2 minúty)

**Spôsob B – VS Code:**
1. Otvor VS Code
2. **File → Open Folder** → vyber `D:\AndroidStudioProjects\Filickova_app`
3. Nainštaluj rozšírenia **Flutter** a **Dart** (ponúkne automaticky)

### Krok 2: Stiahni závislosti

Otvor terminál (v Android Studio: **View → Tool Windows → Terminal**) a spusti:

```powershell
cd D:\AndroidStudioProjects\Filickova_app
flutter pub get
```

Toto stiahne všetky balíčky, ktoré projekt potrebuje. Malo by skončiť s textom typu:
```
Changed 62 dependencies!
```

### Krok 3: Spusti emulátor

**Spôsob A – z Android Studio:**
1. **Tools → Device Manager** → klikni ▶ pri Pixel 9 Pro
2. Počkaj kým sa emulátor nabootuje (vidíš Android domovskú obrazovku)

**Spôsob B – z terminálu:**
```powershell
flutter emulators --launch Pixel_9_Pro
```

### Krok 4: Over, že Flutter vidí zariadenie

```powershell
flutter devices
```

Mal by si vidieť niečo ako:
```
Found 2 connected devices:
  sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64 • Android 16 (API 36)
  Chrome (web)                  • chrome        • web-javascript
```

> ⚠️ Ak nevidíš Android zariadenie, emulátor ešte nedobootoval. Počkaj a skús znova.

### Krok 5: Spusti appku! 🎉

**Spôsob A – z Android Studio:**
1. Hore v paneli vyber **main.dart** ako konfiguráciu
2. Vyber zariadenie (emulátor) v dropdown menu vedľa
3. Klikni zelený ▶ **Run** tlačidlo

**Spôsob B – z terminálu:**
```powershell
cd D:\AndroidStudioProjects\Filickova_app
flutter run
```

Prvé spustenie trvá dlhšie (1-3 minúty) kvôli Gradle buildu. Potom uvidíš:
```
✓ Built build\app\outputs\flutter-apk\app-debug.apk
Syncing files to device...
Flutter run key commands:
  r  Hot reload
  R  Hot restart
  q  Quit
```

**Appka by sa mala zobraziť na emulátore! 🎉**

---

## 📱 Spustenie na fyzickom Android telefóne

1. Na telefóne zapni **Režim vývojára**:
   - **Nastavenia → O telefóne → Číslo zostavy** → ťukni 7× rýchlo za sebou
2. Zapni **Ladenie cez USB**:
   - **Nastavenia → Vývojárske možnosti → Ladenie cez USB** → zapni
3. Pripoj telefón USB káblom k počítaču
4. Na telefóne potvrď „Dôverovať tomuto počítaču?"
5. Over v termináli:
   ```powershell
   flutter devices
   ```
   Mal by si vidieť svoj telefón v zozname
6. Spusti:
   ```powershell
   flutter run
   ```

---

## 🔑 Nastavenie AI skenera (voliteľné)

Skenovanie jedla cez fotku používa **Anthropic Claude API**. Bez API kľúča funguje **demo režim** (ukáže ukážkové dáta).

Ak chceš zapnúť reálnu AI analýzu:

1. Zaregistruj sa na **https://console.anthropic.com/**
2. Vytvor API kľúč
3. Spusti appku s kľúčom:
   ```powershell
   flutter run --dart-define=CLAUDE_API_KEY=tvoj-api-kluc-sem
   ```

---

## 🔧 Užitočné príkazy

| Príkaz | Čo robí |
|--------|---------|
| `flutter pub get` | Stiahne/aktualizuje závislosti |
| `flutter run` | Spustí appku na pripojenom zariadení |
| `flutter run -d chrome` | Spustí appku v Chrome prehliadači (web verzia) |
| `flutter analyze` | Skontroluje kód na chyby |
| `flutter clean` | Vyčistí build cache (ak niečo nefunguje) |
| `flutter pub get` | Po `flutter clean` treba znova stiahnuť závislosti |
| `r` (počas behu) | Hot reload – okamžite zobrazí zmeny v kóde |
| `R` (počas behu) | Hot restart – reštartuje celú appku |
| `q` (počas behu) | Ukončí appku |

---

## ❗ Časté problémy a riešenia

### „No connected devices"
→ Emulátor ešte nebeží. Spusti ho cez Device Manager alebo `flutter emulators --launch Pixel_9_Pro`

### „Gradle build failed"
→ Skús:
```powershell
flutter clean
flutter pub get
flutter run
```

### „main.dart – not applicable" v Android Studio
→ Skontroluj, že máš otvorený **Flutter projekt** (nie natívny Android). V hornom paneli musí byť vybraná konfigurácia **main.dart** s Flutter ikonou.

### Emulátor padá / je pomalý
→ V Device Manager → Edit device → **Graphics: Software - GLES 2.0** a zníž RAM na **2048 MB**

### „SDK not found" alebo „Java not found"
→ Spusti `flutter doctor -v` a postupuj podľa pokynov

### Appka zamrzne po spustení
→ Stlač `R` v termináli pre Hot restart

---

## 📖 Ako appka funguje

1. **Prvé spustenie** → Zobrazí sa **Onboarding** (uvítacie slajdy)
2. **Dotazník** → Vyplníš meno, typ refluxu, spúšťače, ciele, alergie
3. **Dashboard** → Hlavná obrazovka s odporúčanými jedlami a denníkom
4. **Jedálniček** (Kalendár ikona) → Týždenný plán jedál
5. **Skener** (stredné tlačidlo) → Odfotíš jedlo a AI ho analyzuje
6. **Denník** → Zaznamenávaš symptómy a sleduješ grafy
7. **Profil** → Nastavenia, export, GDPR info

---

## 🧪 Technológie použité v projekte

| Technológia | Účel |
|-------------|------|
| **Flutter & Dart** | Framework pre multiplatformovú appku |
| **Riverpod** | Správa stavu (state management) |
| **GoRouter** | Navigácia medzi obrazovkami |
| **Hive** | Lokálna databáza (offline-first) |
| **Dio** | HTTP požiadavky na API |
| **fl_chart** | Grafy (týždenný trend symptómov) |
| **Google Fonts (DM Sans)** | Typografia |
| **Anthropic Claude API** | AI analýza fotiek jedál |
| **image_picker** | Výber/fotenie obrázkov |

---

**Vytvorené pre bakalársku prácu – RefluxCare © 2026**

