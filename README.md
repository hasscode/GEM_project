# 🎓 EEM - Events Entry Manager

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white" />
  <img src="https://img.shields.io/badge/BLoC-E535AB?style=for-the-badge" />
</p>

A modern Flutter application for managing event guest entries with QR code verification, real-time statistics, and Excel/CSV data import.

---

## ✨ Features

- 📊 **Real-time Dashboard** - Live statistics for total, verified, and remaining guests
- 📁 **Excel/CSV Import** - Bulk import guest lists from spreadsheet files
- 📱 **QR Code Verification** - Fast and secure guest entry verification
- 👥 **Guest Management** - Track guests and their companions
- 💾 **Offline-First** - SQLite local database for reliability
- 🎨 **Modern UI** - Beautiful glassmorphic design with smooth animations
- 🎯 **Multi-Event Support** - Perfect for graduations, weddings, conferences, and any event

---

## 🎪 Use Cases

- 🎓 Graduation ceremonies
- 💍 Weddings & celebrations
- 🏢 Corporate events & conferences
- 🎉 Private parties & gatherings
- 🎭 Concerts & exhibitions
- 🏆 Award ceremonies

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.x |
| **Language** | Dart |
| **State Management** | BLoC/Cubit |
| **Database** | SQLite (sqflite) |
| **Architecture** | Repository Pattern + DAO |
| **UI Components** | Custom Glassmorphic Widgets |
| **File Handling** | Excel, CSV, File Picker |

---

## 📱 Screenshots

> Add screenshots here

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/YOUR_USERNAME/GEM_project.git
cd GEM_project
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

---

## 📂 Project Structure
```
lib/
├── model/
│   ├── data_source/
│   │   ├── database_helper.dart
│   │   ├── guest_local_data_source.dart (DAO)
│   │   └── services/
│   │       └── excel_import_service.dart
│   ├── models/
│   │   └── guest_model.dart
│   └── repositories/
│       └── guest_repository.dart
├── view/
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── data_initialization_page.dart
│   │   ├── guest_list_screen.dart
│   │   └── dashboard_screen.dart
│   └── widgets/
├── view_model/
│   ├── initialization_cubit/
│   ├── dashboard_cubit/
│   ├── scan_cubit/
│   └── guest_list_cubit/
├── core/
│   ├── styles/
│   └── widgets/
└── main.dart
```

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

- **Model Layer**: Data sources, repositories, and business entities
- **View Layer**: UI components and screens
- **ViewModel Layer**: BLoC/Cubit for state management
```
┌─────────────┐
│     UI      │ ← Screens & Widgets
└──────┬──────┘
       ↓
┌─────────────┐
│   BLoC      │ ← State Management
└──────┬──────┘
       ↓
┌─────────────┐
│ Repository  │ ← Business Logic
└──────┬──────┘
       ↓
┌─────────────┐
│     DAO     │ ← Data Access
└──────┬──────┘
       ↓
┌─────────────┐
│   SQLite    │ ← Database
└─────────────┘
```

---

## 📦 Dependencies
```yaml
dependencies:
  flutter_bloc: ^8.1.3
  sqflite: ^2.3.0
  excel: ^4.0.3
  file_picker: ^6.1.1
  flutter_screenutil: ^5.9.0
  # ... see pubspec.yaml for full list
```

---

## 🎯 Key Features Explained

### 1. Excel Import
- Supports `.xlsx` and `.csv` formats
- Bulk insert with batch operations for performance
- Automatic data validation

### 2. Guest Verification
- QR code scanning (ready for integration)
- Duplicate entry prevention
- Real-time status updates

### 3. Dashboard Statistics
- Total guests count
- Verified entries tracking
- Remaining guests calculation
- Companion tracking

---

## 🔄 State Management Flow
```dart
// Example: Guest Verification Flow
User Scans QR → ScanCubit.checkGuest()
                    ↓
              Repository.verifyGuest()
                    ↓
              DAO.getGuestById()
                    ↓
              SQLite Query
                    ↓
              Update Status
                    ↓
              Emit New State
                    ↓
              UI Updates
```

---
