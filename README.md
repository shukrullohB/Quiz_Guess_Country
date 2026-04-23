# 🌍 World Explorer

**World Explorer** is a Flutter app for visual geography learning and world discovery.  
It combines a **country-guessing quiz** with a growing **world places exploration** experience.
---
## Download
- **latest version**
- [⬇️ Download APK](https://github.com/shukrullohB/Quiz_Guess_Country/releases/download/v2.0.0/app-release.apk)
---

## 📱 Overview

World Explorer helps users learn countries through images and progression-based gameplay.

Main menu sections:
- **Start** — level-based country quiz
- **The World** — interactive places map and discovery
- **Options** — app settings and progress management
- **Exit**
<img width="1200" height="624" alt="quiz-app-img" src="https://github.com/user-attachments/assets/85644877-a63c-4d15-a998-a11022032b40" />
---

## 🎮 Start — Quiz Mode

This is the core game mode.

### Level Progression
- The game contains **30 levels**.
- Each level represents **one country**.
- Levels are shown in a grid.
- Progression is **sequential**:
  - Only **Level 1** is open at first.
  - Next levels unlock only after completing previous ones.
- Completed levels are marked visually.
- Locked levels show a lock icon and unlock hint.

### Gameplay
- Each level displays multiple photo clues.
- User types a country name in an input field.
- Press **Check** to validate the answer.

### Feedback Flow
- Correct answer:
  - Correct text is shown.
  - Celebration effect appears.
  - Progress is saved automatically.
  - **Next** action appears to continue.
- Wrong answer:
  - Clear visual feedback is shown (shake/error state).

### Completion Flow
- After all levels are completed:
  - Progress panel shows full completion state.
  - User gets a congratulation experience.
  - Optional **Play Again** reset is available.

---

## 🌎 The World — Places Experience

The app includes an interactive world places screen.

### Current Experience
- Visual map with connected place points.
- Tap nodes to open place details.
- Place card includes image and external location link.
- Improved tap reliability and clearer visual selection.
- Better readability for labels and route path styling.

### Product Direction
- Continue evolving into a non-quiz exploration mode:
  - Beautiful and interesting places by country/category
  - Lightweight descriptions
  - Save/favorite system
  - Inspiration-first browsing

---

## ⚙️ Options

Functional settings are implemented and persisted:
- **Sound effects** — on/off
- **Vibration** — on/off
- **Animations** — on/off
- **Reset progress** — with confirmation

All settings and progress are saved locally and restored on restart.

---

## ✨ UX & Visual Design

- Dark, modern visual language
- Bright accent colors for actions and progression
- Rounded cards/buttons and clean composition
- Animated intro and polished menu motion
- Improved navigation transitions
- Mobile-focused design with readable hierarchy

---

## 🛠️ Tech Stack

- **Flutter**
- **Dart**
- **Material Design**
- **shared_preferences** (local persistence)
- **url_launcher** (external links)
- **confetti** (success feedback)

---

## 📦 Project Structure (high-level)

- `lib/main.dart` — app entry, theme, routing, main menu
- `lib/all_levels/` — quiz level screens (1–30)
- `lib/level_page/levels.dart` — level grid and lock/unlock logic
- `lib/the_world/world.dart` — world places interactive screen
- `lib/options/options_page.dart` — settings UI
- `lib/settings/` — settings/progress repositories and controller
- `lib/intro/animated_intro_page.dart` — startup intro

---

## 🚀 Getting Started

```bash
flutter pub get
flutter run
```
---

## Author
- Name: Shukrullo Baxtiyorov
- GitHub: https://github.com/shukrullohB

