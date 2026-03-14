---
stepsCompleted: [1]
inputDocuments: []
session_topic: 'Full project analysis — gaps, bugs, improvements'
session_goals: 'Identify missing features, bugs, security issues, architecture problems'
selected_approach: 'AI-Recommended'
techniques_used: [code-review, static-analysis, architecture-audit]
ideas_generated: []
context_file: ''
---

# Brainstorming Session — Full Project Analysis

**Facilitator:** mti  
**Date:** 2026-03-07  

## Session Overview

**Topic:** Full analysis of Yntymak MVP — what's missing, what needs fixing  
**Goals:** Identify all gaps, bugs, security risks, and improvement opportunities

---

## Analysis Results

### Project Summary

| Metric | Value |
|---|---|
| Screens | 14 (splash, onboarding, login, signup, forgot password, services, help, volunteers, charity, favorites, profile, add post, detail, main frame) |
| Providers | 5 (Auth, Service, Volunteer, Locale, Translation) |
| Models | 2 (ServiceItem, OnboardingModel) |
| Widgets | 5 (ServiceCard, ServiceGridCard, HelpCard, HelpGridCard, SearchBar) |
| Backend | Supabase (Auth + DB + Storage) |
| Localization | 3 languages (RU, KY, EN) |
| Static analysis | 2 warnings |

---

## 🔴 CRITICAL ISSUES

### 1. Security — API keys hardcoded in source code
`main.dart` contains the Supabase URL and anon key directly in the code. This is a **security risk** if the repo is public.
**Fix:** Use environment variables or `.env` file with `flutter_dotenv`.

### 2. No RLS policies verification
The app uses Supabase but there is no indication that Row Level Security (RLS) policies are properly configured on `service_posts`, `volunteer_posts`, `favorites`, `volunteer_favorites`, and `profiles` tables.
**Fix:** Audit and verify RLS policies on all tables.

### 3. Package name violates Dart conventions
`pubspec.yaml` has `name: YntymakAppMVP` — Dart requires `lower_case_with_underscores`.
**Fix:** Rename to `yntymak_app_mvp` and update all imports.

---

## 🟠 ARCHITECTURE ISSUES

### 4. No error handling layer
All errors are caught with generic `catch(e)` and logged with `debugPrint`. There is no user-facing error handling strategy, no retry logic (except one hacky retry in auth), no offline state detection.
**Fix:** Create a centralized error handling service with user-friendly error messages.

### 5. No connectivity check
The app has no offline mode detection. If the user has no internet, all Supabase calls fail silently.
**Fix:** Add `connectivity_plus` package and handle offline state.

### 6. `StorageService` is dead code
`lib/core/storage_service/storage_service.dart` has `isLoggedIn()`, `saveFavorites()`, etc. but these are **never used** — auth state comes from Supabase, favorites live in the DB.
**Fix:** Remove or repurpose.

### 7. `MockData` is dead code
`lib/services/mock_data.dart` is never imported or used anywhere.
**Fix:** Remove.

### 8. `AppTheme.lightTheme` is never applied
`main.dart` creates `MaterialApp` without `theme: AppTheme.lightTheme`. The theme definition exists but is not wired up.
**Fix:** Add `theme: AppTheme.lightTheme` to `MaterialApp`.

### 9. Duplicate logic between `ServiceProvider` and `VolunteerProvider`
80% of the code is identical — both have `loadData()`, `addPost()`, `deletePost()`, `toggleFavorite()`, `_loadFavorites()` with the same structure. Only table names differ.
**Fix:** Create a base `PostProvider` class or use a shared repository pattern.

### 10. No route management
All navigation uses raw `Navigator.push()` with `MaterialPageRoute`. No named routes, no route constants.
**Fix:** Implement named routes or use `go_router` for cleaner navigation.

---

## 🟡 MISSING FEATURES (for MVP)

### 11. No push notifications
Users don't know when someone responds to their post or favorites their service.
**Fix:** Implement FCM (Firebase Cloud Messaging) or Supabase Edge Functions + push.

### 12. No chat/messaging system
Users can only call via phone. There's no in-app messaging.
**Fix:** Add a simple chat using Supabase Realtime.

### 13. No image support for posts
Posts only have text — no photos/images for services or help requests.
**Fix:** Add image upload (similar to avatar upload) for posts.

### 14. No post editing
Users can delete posts but not edit them.
**Fix:** Add an edit flow to `AddPostScreen`.

### 15. No user ratings/reviews
No way for users to rate service providers after interaction.
**Fix:** Add a ratings table and UI.

### 16. No search functionality on backend
Search is client-side only (filtering in memory). With many posts, this won't scale.
**Fix:** Implement Supabase full-text search.

### 17. No pagination / infinite scroll
`loadData()` loads ALL posts at once. This will be slow with hundreds of posts.
**Fix:** Implement pagination using Supabase `.range()`.

### 18. No pull-to-refresh
Users can't manually refresh list screens.
**Fix:** Add `RefreshIndicator` widgets.

### 19. No location/geo features
Posts have no location data. Users can't find nearby services.
**Fix:** Add location field to posts, integrate maps.

### 20. No onboarding skip / "already seen" check
There's no check if the user has already seen onboarding. Unknown if it re-shows every time.
**Fix:** Use `SharedPreferences` to track first launch.

---

## 🔵 CODE QUALITY ISSUES

### 21. `BuildContext` used across async gaps
Dart analyzer warning in `onboarding_screen.dart:102` — `BuildContext` used after async gap without proper `mounted` check.
**Fix:** Add `if (!mounted) return;` before using context.

### 22. `DropdownButtonFormField` uses deprecated `initialValue`
In `add_post_screen.dart:237`, `initialValue` is used instead of `value`.
**Fix:** Replace with the `value` parameter.

### 23. Hardcoded colors throughout screens
Many screens use inline `Color(0xFF...)` instead of theme constants. Examples: `Color(0xFF1B334B)`, `Color(0xFF7B1FA2)`, `Color(0xFFE8DEF8)`.
**Fix:** Define all colors in `AppTheme` and reference them consistently.

### 24. No `const` constructors where possible
Many widgets could benefit from `const` constructors for better performance.

### 25. No tests at all
Zero test files exist. No unit, widget, or integration tests.
**Fix:** Add at minimum unit tests for providers and model serialization.

---

## 🟢 WHAT WORKS WELL

- ✅ Clean Provider architecture — separation of concerns between auth, services, volunteers
- ✅ Supabase integration is solid — auth, CRUD, storage, favorites
- ✅ Comprehensive localization — 3 languages with 100+ translation keys
- ✅ Dual-mode UI — user mode vs volunteer/org mode is clever
- ✅ Account switching built-in
- ✅ Verified badge system
- ✅ Category system with emoji support
- ✅ Grid/list toggle for different views
- ✅ Avatar upload with Supabase Storage
- ✅ Optimistic UI updates for favorites (with rollback)

---

## Priority Action Plan

| Priority | Item | Effort |
|---|---|---|
| 🔴 P0 | Fix hardcoded API keys | 1 hour |
| 🔴 P0 | Verify RLS policies | 2 hours |
| 🔴 P0 | Fix package name | 30 min |
| 🟠 P1 | Wire up AppTheme | 10 min |
| 🟠 P1 | Remove dead code | 15 min |
| 🟠 P1 | Add pagination | 3 hours |
| 🟠 P1 | Add pull-to-refresh | 1 hour |
| 🟠 P1 | Fix async context warnings | 30 min |
| 🟡 P2 | Add image support for posts | 4 hours |
| 🟡 P2 | Add post editing | 3 hours |
| 🟡 P2 | Add push notifications | 8 hours |
| 🟡 P2 | Add chat/messaging | 16 hours |
| 🔵 P3 | Add tests | 8 hours |
| 🔵 P3 | Refactor duplicate providers | 4 hours |
| 🔵 P3 | Add location features | 12 hours |
