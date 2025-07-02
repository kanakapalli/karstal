# K.A.R.S.T.A.L.

**Knowledge-Adaptive Reasoning System for Task-Aware Learning**

A system that dynamically adapts to user goals, learns from interactions, and reasons across multi-domain tasks.

> **Inspiration:** "Karstala" is a stylized version of "Karst," representing complex layered systems, evoking planetary terrain.

---

## Overview
KARSTAL is a modern Flutter chat application demonstrating adaptive UI, state management, and navigation. It features:
- Mock ChatGPT-like conversations
- Riverpod for robust state management
- GoRouter for seamless navigation
- Persistent login with Hive
- Clean, modular architecture

## Features
- **Login:** Static credentials (admin/admin), persistent session
- **Dashboard:** Mock chat list with avatars and previews
- **Chat Detail:** Modern chat UI, bot replies, profile, and UX enhancements
- **State Management:** Powered by Riverpod
- **Navigation:** GoRouter
- **Persistence:** Hive for local storage

## Getting Started
1. Install dependencies:
   ```sh
   flutter pub get
   ```
2. Run the app:
   ```sh
   flutter run
   ```

## Project Structure
```
lib/
  app/           # Router, theme
  features/      # Auth, chat (MVC)
  services/      # Hive, mock API, ChatGPT
  utils/         # Helpers, constants
  widgets/       # Reusable widgets
```

## Inspiration
KARSTAL is inspired by the complexity and adaptability of karst landscapes—layered, evolving, and interconnected, just like adaptive reasoning systems.

---

Built with Flutter, Riverpod, GoRouter, and Hive.
