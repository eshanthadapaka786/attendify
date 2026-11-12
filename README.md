# 🎓 ATTENDIFY – Student Attendance Management System

> **A modern, polished, and responsive Material 3 Flutter application designed for educational institutions and faculty roll-call management.**

---

## 🌟 Overview & College Lab Highlights

**ATTENDIFY** is built specifically for college laboratory demonstrations and coursework submissions. It showcases senior-level Flutter UI/UX architecture with:
- **Material 3 Design System**: Custom typography, elevation curves, rounded corners (16–24px), squircle icon badges, and a signature **Purple, Indigo, and Crisp White** color scheme.
- **In-Memory Reactive State**: Powered by clean Flutter `ChangeNotifier` + `InheritedNotifier` (`AttendanceScope`), ensuring that marking attendance immediately recalculates statistics, updates progress rings, and streams activity logs with **zero delay**.
- **100% Offline & Pure Dart**: Uses Flutter SDK and Material 3 without complex external dependencies, ensuring instant compilation and flawless cross-platform execution on Android, iOS, Web, and Desktop.

---

## 🚀 How to Run in Visual Studio Code

### Prerequisites
1. **Flutter SDK** (v3.0.0 or higher) installed on your system.
2. **VS Code** with the official **Flutter** and **Dart** extensions installed.
3. An active device or emulator (Android Emulator, Chrome Browser, or Windows Desktop).

### Steps to Run
1. Open Visual Studio Code:
   ```bash
   code .
   ```
2. Open the integrated terminal (`Ctrl + ` `~` on Windows) and fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Check connected devices:
   ```bash
   flutter devices
   ```
4. Run the project:
   - **Press `F5`** or go to `Run -> Start Debugging`.
   - Alternatively, run from terminal:
     ```bash
     flutter run -d chrome       # To run in Google Chrome
     # OR
     flutter run -d windows      # To run as Windows Desktop app
     # OR
     flutter run                 # To run on connected Android emulator/phone
     ```

---

## 📐 Project Structure

The project follows a clean, modular architecture:

```
lib/
├── main.dart                      # App entry point, MaterialApp, theme & state injection
├── theme/
│   └── app_theme.dart             # Material 3 colors, gradients, typography & component themes
├── models/
│   ├── student.dart               # Student profile model with attendance enum
│   ├── attendance_record.dart     # Timestamped attendance log entry model
│   └── notification_item.dart     # Faculty alerts & notification item model
├── data/
│   └── sample_data.dart           # Realistic college sample dataset (students, logs, weekly trends)
├── state/
│   └── attendance_state.dart      # Reactive in-memory state manager (ChangeNotifier & InheritedNotifier)
├── widgets/
│   ├── responsive_container.dart  # Adaptive layout wrapper preventing wide stretch on desktop/tablet
│   ├── stat_card.dart             # Reusable stat card with icons, trends & circular progress
│   ├── weekly_chart.dart          # Interactive weekly bar chart with 75% college rule target line
│   ├── activity_tile.dart         # Attendance check-in stream tile with status pill
│   ├── student_card.dart          # Student row with instant interactive [P] [A] [L] toggles
│   ├── add_student_dialog.dart    # Form validation modal with simulated async loading
│   └── notifications_sheet.dart   # Sliding drawer for faculty notifications & alerts
└── screens/
    ├── dashboard_screen.dart      # Complete Landing Page (10 required components)
    ├── mark_attendance_screen.dart# Full roll-call screen with batch actions & date picker
    ├── students_screen.dart       # Student directory with search, class filtering & details
    ├── reports_screen.dart        # Academic SaaS analytics, defaulters list (<75%) & export
    ├── profile_screen.dart        # Faculty profile, lab specs & system settings
    └── main_navigation_shell.dart # Scaffold with Material 3 NavigationBar connecting all 5 tabs
```

---

## 🎯 Landing Page Features Checklist (10/10 Delivered)

1. ✅ **App Bar**: Branded Attendify logo, dynamic notification badge, and teacher avatar.
2. ✅ **Welcome Header**: `"Hello, Teacher! 👋"` greeting with interactive calendar date picker button.
3. ✅ **Hero Card**: `"Smart Attendance, Smarter Learning"` gradient banner with quick metrics and `"Mark Attendance"` CTA.
4. ✅ **Four Metric Cards**:
   - **Total Students** (with class counts)
   - **Present Today** (emerald green badge & late count)
   - **Absent Today** (danger red badge & alert counter)
   - **Attendance Percentage** (circular progress gauge)
5. ✅ **Weekly Attendance Overview**: Custom interactive bar chart showing Monday–Saturday percentages with a **dashed 75% college requirement target line**.
6. ✅ **Quick Action Cards**: Direct navigation to *Mark Attendance*, *Add Student*, *View Reports*, and *Manage Classes*.
7. ✅ **Recent Activity Stream**: Live feed of student check-ins with timestamps and Present/Absent badges.
8. ✅ **Student Roster Preview**: Real-time search filter and instant `[P]` (Present) / `[A]` (Absent) / `[L]` (Late) toggle buttons.
9. ✅ **Monthly Progress Section**: Visual monthly progress bar with achievement metrics (+6.4% above target).
10. ✅ **Bottom Navigation Bar**: 5 interactive tabs (**Home**, **Students**, **Attendance**, **Reports**, **Profile**).

---

## 💡 Interactive Highlights for Evaluation

- **Live Stat Recalculation**: Tap any `[P]` or `[A]` button on the landing page or attendance screen — watch the *Present Today*, *Absent Today*, and *Attendance Rate* instantly recalculate in real-time.
- **Batch Actions**: Navigate to the **Attendance** tab and tap **"Mark All Present"** or **"Mark All Absent"** to observe instant batch state updates.
- **Add Student with Form Validation**: Tap **"Add Student"** to open a validated dialog. Input a name and roll number, submit, and observe the simulated loading spinner, success toast, and automatic roster update.
- **Date Selector**: Tap the date badge on the header to select any past or future date via the native Material 3 date picker.
- **Responsive Layout**: Resize your browser or desktop window — cards gracefully reflow without any pixel overflow errors!
