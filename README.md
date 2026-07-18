![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Dart](https://img.shields.io/badge/Dart-3.x-blue)
![BLoC](https://img.shields.io/badge/State-BLoC-green)
![License](https://img.shields.io/badge/License-Educational-orange)

# 🌱 Agri-Sense AI

An AI-powered smart agriculture application built with **Flutter**, designed to help farmers and agricultural consultants make informed decisions through crop recommendations, weather forecasting, farm mapping, and AI assistance.

---

## 📱 Features

### 🤖 AI Crop Recommendation
- Intelligent crop recommendations based on soil analysis.
- AI-powered decision support for selecting suitable crops.

### 🌦 Real-Time Weather
- Integrated with **Open-Meteo API** (Free – No API Key Required).
- Automatically detects the user's current location using **Geolocator**.
- Displays current weather conditions and temperature.

### 🗺 Smart Farm Mapping
- Interactive GIS-inspired farm map.
- Field selection and management.
- Soil nutrient visualization including:
  - Nitrogen (N)
  - Phosphorus (P)
  - Potassium (K)

### 💬 AI Agricultural Assistant
- AI chatbot for answering agriculture-related questions.
- Provides guidance and farming recommendations.

### 🌿 Plant Disease Detection
- Detects plant diseases using AI image classification.
- Provides disease diagnosis and treatment suggestions.

### 📊 Recommendation History
- Stores previous crop recommendations.
- Allows users to review historical analyses.

### 👤 User Profile
- Profile management.
- Update personal information and profile image.

### 🔐 Authentication
- Secure Login & Registration.
- JWT-based authentication.

### 🏠 Modern Dashboard
- Personalized greeting.
- Live weather information.
- Quick access to application features.
- Beautiful and responsive interface.

---

# 🏗 Project Architecture

The project follows **Clean Architecture** with feature-based modular development.

```
lib/
│
├── core/
│   ├── constants/
│   ├── services/
│   ├── theme/
│   ├── widgets/
│   └── utils/
│
├── features/
│   ├── auth/
│   ├── home/
│   ├── mapping/
│   ├── weather/
│   ├── ai_chat/
│   ├── crop_recommendation/
│   ├── plant_disease/
│   ├── reports/
│   └── profile/
│
│   ├── data/
│   ├── domain/
│   └── presentation/
│
└── main.dart
```

---

# 🛠 Tech Stack

- Flutter
- Dart
- Clean Architecture
- BLoC State Management
- REST API
- Open-Meteo API
- Geolocator
- Flutter Map
- HTTP Package
- Shared Preferences
- Material Design
- Google Fonts

---

# 📷 Application Screens

- Splash Screen
- Login
- Register
- Dashboard
- Weather
- Farm Mapping
- Soil Analysis
- Crop Recommendation
- AI Chat
- Plant Disease Detection
- Reports
- Profile

---

# ⚙ Getting Started

## Prerequisites

- Flutter SDK (3.0+)
- Dart SDK
- Android Studio / VS Code

---

## Installation

Clone the repository

```bash
git clone https://github.com/yourusername/agri_sense_ai.git
```

Go to project directory

```bash
cd agri_sense_ai
```

Install dependencies

```bash
flutter pub get
```

Run the application

```bash
flutter run
```

---

# 📍 Weather & Location

The application uses:

- Open-Meteo API
- Geolocator

No API key is required.

Make sure location permission is granted to retrieve weather information based on the user's current location.

---

# 🧠 State Management

### BLoC

Used for:

- Authentication
- Weather
- Crop Recommendation
- Plant Disease Detection

### Local State

Used for:

- Forms
- Tabs
- UI interactions

---

# 🎨 Design System

| Property | Value |
|----------|-------|
| Primary Green | #16A34A |
| Primary Blue | #0EA5E9 |
| Font | Inter / Poppins |
| Icons | Material Design |

---

# 🧪 Testing

Run tests using:

```bash
flutter test
```

---

# 🚀 Future Enhancements

- Offline Mode
- Push Notifications
- IoT Sensor Integration
- Crop Yield Prediction
- Fertilizer Recommendation
- Satellite Monitoring
- Multi-language Support
- Cloud Synchronization

---

# 👨‍💻 Developed By

Graduation Project Team

Faculty of Computers and Artificial Intelligence

Beni-Suef University

---

# 📄 License

This project is developed for educational and research purposes.