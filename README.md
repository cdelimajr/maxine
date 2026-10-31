# Maxine – ang kausap mong kaibigan

Si Maxine ay app na pwede mong kausapin (sa type o sa boses) kapag masaya ka, malungkot, pagod, bored, o may tanong ka.
Kinakamusta ka niya, siya ang nagsisimula ng usapan, nagbibigay ng payo, at nagpapaliwanag na parang sa 10 taong gulang.

Gumagana sa: **Android (.apk), Windows, macOS, Linux, iPhone/iPad, at web browser** – iisang code (Flutter).

## Ano ang kaya ni Maxine

| Feature | Offline? |
|---|---|
| Nakakaramdam ng mood (malungkot, masaya, galit, pagod, kabado, bored, stressed) at nagtatanong kung bakit | ✅ |
| Payo depende sa dahilan (school, kaibigan, pamilya, crush, trabaho, pera, sakit, alaga) | ✅ |
| Tumutulong sumagot sa mahihirap na tanong (3 hakbang) | ✅ |
| Paliwanag na pambata: langit, ulan, bahaghari, gravity, buwan, planeta, bulkan, lindol, atbp. | ✅ |
| "Paano" tips: mag-aral, mag-focus, makipagkaibigan, mag-sorry, kumalma, matulog, mag-ipon, magsaing | ✅ |
| Kinakamusta ka pagbukas ng app, naaalala kung malungkot ka noong huli | ✅ |
| Siya ang nagsisimula ng usapan kapag tahimik ka (base sa hilig mo) | ✅ |
| Naaalala ang pangalan at mga hilig mo | ✅ |
| Bugtong, biro, fun facts, breathing exercise | ✅ |
| Nagsasalita (text-to-speech) gamit ang boses ng device | ✅ |
| Nakikinig sa boses mo (speech-to-text) | ⚠️ depende sa device (tingnan sa ibaba) |
| Sumagot sa **kahit anong** tanong | 🌐 Online Mode lang (opsyonal, kailangan ng Claude API key) |
| Babala at hotline (NCMH 1553) kapag may panganib sa sarili | ✅ |

Ang offline na sagot ay **instant** (mas mabilis pa sa 1 millisecond, nasubukan: 1000 sagot < 1 segundo).

## Paano idagdag ang mga alam ni Maxine

Lahat ng sagot ay nasa `lib/brain/knowledge.dart`. Para magdagdag ng bagong paliwanag, kopyahin lang ang isang `Topic([...], '...')` at palitan ang mga salita at sagot.

## Istruktura

```
lib/
  main.dart                 – simula ng app
  brain/maxine_brain.dart   – ang "utak" (mood, payo, usapan, check-in)
  brain/knowledge.dart      – lahat ng sagot, payo, biro, bugtong (madaling i-edit)
  brain/memory.dart         – naaalala (pangalan, hilig, huling mood) – naka-save sa device lang
  services/voice.dart       – boses at pakikinig
  services/online_brain.dart– opsyonal na Online Mode (Claude API)
  screens/                  – chat at settings
  widgets/maxine_face.dart  – animated na mukha ni Maxine
test/brain_test.dart        – mga test ng utak
.github/workflows/build.yml – awtomatikong gumagawa ng APK/EXE/iOS sa GitHub
```

Basahin ang **BUILD.md** para sa paggawa ng APK, Windows, at iOS.
