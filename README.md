# Styla Mobile App

> A Personal Style Assistant for Wardrobe Organization and Outfit Recommendations

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue)](https://flutter.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-2.10.2-green)](https://supabase.com/)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean-orange)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

## Overview

Styla is a mobile application that helps users organize their wardrobe, receive daily outfit recommendations, explore fashion ideas, and share inspiration within a community of style enthusiasts. Built with Flutter and following Clean Architecture principles, it provides a scalable foundation for personal styling features powered by Supabase backend services.

---

## Contents

- [Styla Mobile App](#styla-mobile-app)
  - [Overview](#overview)
  - [Contents](#contents)
  - [Core Features](#core-features)
  - [System Architecture](#system-architecture)
  - [Project Structure](#project-structure)
  - [Getting Started](#getting-started)
  - [Navigation Flow](#navigation-flow)
  - [Development Status](#development-status)
  - [Contributors](#contributors)

---

## Core Features

**Authentication & Onboarding**
* Email-based authentication with secure session management
* Multi-step onboarding flow for profile setup and style preferences
* Gender selection, body measurements, and style profile configuration

**Wardrobe Management**
* Digital wardrobe with image storage and metadata tagging
* Advanced filtering by category, color, style, tags, and occasions
* Custom tag system for flexible garment organization
* Detailed garment views with full CRUD operations

**Community & Social**
* Public feed for sharing outfit posts and inspiration
* Bookmark system for saving favorite posts
* User profiles with published posts gallery
* Like and comment interactions on community posts

**AI Recommendations**
* Intelligent outfit suggestions based on wardrobe inventory
* Personalized recommendations considering style preferences
* Context-aware outfit generation

---

## System Architecture

> **Note:** This application follows Clean Architecture principles with clear separation between data, domain, and presentation layers. State management is handled through BLoC pattern for predictable and testable state transitions.

**Technology Stack**
* **Framework:** Flutter 3.9.2
* **Backend:** Supabase (PostgreSQL + Storage + Auth)
* **State Management:** flutter_bloc 9.1.1
* **Architecture:** Clean Architecture with BLoC pattern

**Layer Structure**
* `data/` - Repository implementations, data sources, and API clients
* `domain/` - Business logic, use cases, entities, and repository interfaces
* `ui/` - Screens, widgets, and BLoC components

---

## Project Structure

```text
lib/
├── main.dart
├── core/
│   ├── domain/model/          # Shared models (Garment)
│   └── ui/
│       ├── design/            # Design system (colors, typography, spacing, radius)
│       └── widgets/           # Reusable components (buttons, text fields, chips)
│
└── features/
    ├── auth/                  # Authentication flow
    │   ├── data/              # Auth repository implementation
    │   ├── domain/usecases/   # Login, Register, Logout
    │   └── ui/                # Signin/Signup screens + BLoC
    │
    ├── onboarding/            # Initial profile setup
    │   ├── data/              # Onboarding data sources
    │   ├── domain/usecases/   # CompleteOnboarding, GetOptions
    │   └── ui/                # Onboarding wizard + BLoC
    │
    ├── wardrobe/              # Wardrobe management
    │   ├── data/source/       # WardrobeDataSource, StorageDataSource
    │   ├── domain/
    │   │   ├── model/         # Category, Tag, ColorOption, StyleOption
    │   │   └── usecases/      # AddGarment, GetGarments, UpdateGarment
    │   └── ui/
    │       ├── screens/       # Wardrobe, AddGarment, GarmentDetail
    │       └── widgets/       # GarmentGridTile, FilterSection, Controls
    │
    ├── community/             # Social features
    │   ├── data/source/       # CommunityDataSource
    │   ├── domain/
    │   │   ├── model/         # Post, Comment
    │   │   └── usecases/      # CreatePost, GetFeed, SavePost
    │   └── ui/                # FeedScreen, CreatePostScreen, SavedPostsScreen
    │
    └── profile/               # User profile
        ├── domain/usecases/   # GetProfile, UpdateProfile, SignOut
        └── ui/                # Profile screen + BLoC
```

---

## Getting Started

> **Warning:** This project requires Flutter 3.9.2 or higher and a configured Supabase project with the appropriate database schema.

**Prerequisites**
* Flutter SDK 3.9.2+
* Dart SDK
* Supabase account and project
* Android Studio / Xcode for emulators

**Installation**

```bash
# Clone repository
git clone https://github.com/RonyOz/styla_mobile_app
cd styla_mobile_app

# Install dependencies
flutter pub get

# Run application
flutter run
```

**Supabase Setup**

Required tables: `profiles`, `garments`, `garment_categories`, `tags`, `posts`, `saved_posts`

Refer to `doc/sql_saved_posts.md` for database schema examples.

---

## Navigation Flow

**Routes**

```dart
AppRoutes.welcome       // /welcome - Landing screen
AppRoutes.signin        // /signin - Email login
AppRoutes.signup        // /signup - User registration
AppRoutes.onboarding    // /onboarding - Profile setup wizard
AppRoutes.home          // /home - Main dashboard
AppRoutes.wardrobe      // /wardrobe - Wardrobe management
AppRoutes.addGarment    // /add-garment - Add new garment
AppRoutes.garmentDetail // /garment-detail/:id - Garment details
AppRoutes.feed          // /feed - Community feed
AppRoutes.createPost    // /create-post - Create outfit post
AppRoutes.profile       // /profile - User profile
```

**Flow Diagram**

```
Welcome → Signin/Signup → Onboarding → Home/Dashboard
                                          ├─→ Wardrobe → Add/Edit Garments
                                          ├─→ Community Feed → Create Post
                                          └─→ Profile → Settings
```

---

## Development Status

**Completed Features**
* Authentication & onboarding flow
* Wardrobe CRUD with image storage
* Advanced filtering and tag system
* Community feed with posts
* Bookmark/save posts functionality
* User profiles

**In Progress**
* AI-powered outfit recommendations
* Outfit calendar and planning
* Like and comment system on posts
* User follow system

**Planned**
* Weather-based outfit suggestions
* Outfit history tracking
* Social profile analytics

---

## Contributors

* [Mariana Agudelo](https://github.com/lilmagusa17)
* [Rony Ordoñez](https://github.com/RonyOz)
* [Juan José de la Pava](https://github.com/JuanJDlp)
* [Mateo Silva](https://github.com/MateoSilvaLasso)
* [Natalia Vargas](https://github.com/NattVS)

---

> Built with Clean Architecture principles to ensure scalability, maintainability, and testability. This project serves as a foundation for a comprehensive personal styling platform.
