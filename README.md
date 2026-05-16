# 🎮 Enzer

**Enzer** is a gamified pre-registration Flutter app designed to drive installs through referrals — helping founders build a large early-adopter community before their app goes live.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue) ![Supabase](https://img.shields.io/badge/Backend-Supabase-green) ![Architecture](https://img.shields.io/badge/Architecture-MVVM-purple) ![Firebase](https://img.shields.io/badge/Notifications-Firebase-orange)

---

## What it does

Enzer lets users sign up, receive a unique referral link, and invite others — earning rewards as their network grows. Founders get visibility into user growth through a lightweight admin dashboard, all before the full product launches.

---

## MVP Features

- Referral-based install tracking via unique invite links
- OTP-based phone authentication with forgot/reset password flow
- Gamified account creation with animated success screen
- Activity screen to track referrals and progress
- "How it works" onboarding flow
- Firebase push notifications
- Admin visibility into early adopter growth

---

## Architecture

**MVVM** — each screen has a paired `ViewModel` extending `BaseViewModel`, driving UI state via a `ViewState` enum (idle / busy / error). Services are wired via **GetIt** and state is exposed through **Provider**.

Each screen is broken into small, focused component files rather than monolithic widgets.


---

## Tech stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| State management | Provider + MVVM |
| Dependency injection | GetIt |
| Backend / Database | Supabase |
| Auth | Phone (OTP) |
| Deep linking / Referrals | `chottu_link` |
| Notifications | Firebase Messaging + Local Notifications |
| HTTP client | Dio |
| Fonts | Futura Bold (custom) |

---

## Key highlights

- Custom referral link system using `chottu_link` for install attribution
- OTP phone auth with full forgot/reset password flow
- Animated account creation screen with custom painters (diamond, triangle, floating shapes)
- Component-driven screen architecture — each screen split into focused widget files
- Shimmer loading states and cached network images for a polished UX
- Firebase push notifications with local notification support
