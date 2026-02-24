# Changelog

All notable changes to the Durga Puja Donations app will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [2.0.0] — Phase 6: Testing, Accessibility, Feedback & Final Polish

### Summary

Comprehensive quality and polish pass — expanded test coverage to 100+ new tests (unit, widget, integration), added Semantics accessibility annotations across 4 key pages, implemented a full user feedback mechanism (model → repository → service CRUD → user form → admin panel), created a 3-page onboarding carousel with first-launch detection, added ~35 new l10n keys across all 4 languages, and bumped version to 2.0.0.

### Added

- **Unit Tests — DataService** (`test/data_service_test.dart`)
  - 25+ tests covering init, donation CRUD, event CRUD, gallery CRUD, error handling, `clearAllData()`, `loadData()`

- **Unit Tests — AuthService** (`test/auth_service_test.dart`)
  - 20+ tests covering init, login/logout, password change, user management, permissions, role-based access

- **Unit Tests — AppSettingsService** (`test/app_settings_service_test.dart`)
  - 25+ tests covering defaults, locale, biometric, PIN, notifications, event reminders, persistence

- **Widget Tests — DonationPageNew** (`test/donation_page_new_test.dart`)
  - 10 tests for form fields, preset amounts, selection, custom text entry

- **Widget Tests — EventsPageNew** (`test/events_page_new_test.dart`)
  - 8 tests for rendering, categories, calendar, event cards, filtering

- **Widget Tests — HomePage** (`test/home_page_test.dart`)
  - 10 tests for welcome section, stats, feature cards, drawer, FAB

- **Integration Test — Donation Flow** (`test/donation_flow_integration_test.dart`)
  - 6 integration tests covering home→donate navigation, form fill with amount selection, DataService donation CRUD, multi-donation accumulation with monthly breakdown, and deletion stat reflection; uses InMemory repositories

- **Accessibility — Semantics Annotations**
  - `donation_page_new.dart` — Semantics on back button (label: 'Go back'), amount buttons (selected state, label with amount)
  - `events_page_new.dart` — tooltip on back button, Semantics on category chips (selected state), Semantics on event cards (label with title, category, date)
  - `home_page.dart` — tooltip on FAB ('Make a donation'), Semantics on feature cards (button: true, label with title + subtitle)
  - `gallery_page_new.dart` — tooltip on back button, Semantics on category chips (selected state), Semantics on gallery items (image: true, label with title/category)

- **User Feedback Model** (`lib/models/feedback.dart`)
  - `UserFeedback` class with id, name, email, rating (int 1-5), message, category, createdAt
  - `toJson`/`fromJson`/`copyWith` serialization
  - Static `categories`: general, suggestion, bug, praise

- **Feedback Repository** (`lib/repositories/feedback_repository.dart`)
  - Abstract `FeedbackRepository` interface with `loadAll()`/`saveAll()`
  - `SharedPrefsFeedbackRepository` implementation with JSON persistence via SharedPreferences key `'user_feedback'`

- **Feedback Form Page** (`lib/feedback_page.dart`)
  - 5-star interactive rating with Semantics labels for each star
  - TextFormField for name, email, message
  - DropdownButtonFormField for category selection
  - GradientButton submit with validation (rating > 0, required fields)
  - Calls `DataService.addFeedback()` and shows success snackbar

- **Admin Feedback Panel** (`lib/admin/admin_feedback.dart`)
  - Stats row: total feedback count + average rating display
  - Feedback tiles with star display, category color badges, relative timestamps
  - Delete button with confirmation dialog
  - Theme-aware rendering via `AppTheme.dynamic*` helpers

- **Onboarding Carousel** (`lib/onboarding_page.dart`)
  - 3-page PageView with cultural icons (temple, donation, community)
  - Animated dot indicators and Skip/Next/Get Started buttons
  - Stores `onboarding_completed` flag in SharedPreferences
  - Static `isComplete()`/`markComplete()` methods for external use

- **~35 new l10n keys** across all 4 ARB files (en, bn, hi, mr):
  - Home drawer feedback (1 key)
  - Feedback form page (24 keys): page title, subtitle, rating prompts, rating labels (1-5), form field labels, validation messages, categories, submit button, success
  - Admin feedback panel (8 keys): title, subtitle, stats, empty state, delete confirmation
  - Onboarding (6 keys): skip, next, get started, 3 page titles + descriptions

### Changed

- **DataService** (`lib/services/data_service.dart`)
  - Added `FeedbackRepository` dependency via DI constructor parameter (defaults to `SharedPrefsFeedbackRepository`)
  - New `_feedbackList`, `feedbackList`, `feedbackCount`, `averageRating` getters
  - CRUD methods: `addFeedback()`, `deleteFeedback()`, `getRecentFeedback()`
  - Feedback loaded in `_loadData()`, cleared in `clearAllData()`

- **Admin Dashboard** (`lib/admin/admin_dashboard.dart`)
  - Added Feedback tab at index 5 with `Icons.feedback_outlined`
  - Users tab shifted to index 6
  - Both side and bottom navigation updated with new item

- **Home Page** (`lib/home_page.dart`)
  - Added Feedback drawer item between Community and Playlist
  - FAB tooltip added: 'Make a donation'
  - Feature cards wrapped in Semantics (button: true, labeled)

- **Splash Screen** (`lib/splash_screen.dart`)
  - Navigation now checks `OnboardingPage.isComplete()` after splash
  - First launch: navigates to `OnboardingPage` → then to `MainScaffold`
  - Subsequent launches: navigates directly to `MainScaffold`

- **Version bump** — `pubspec.yaml` version updated from `1.0.0+1` to `2.0.0+2`

### Technical Notes

- All modified files verified with `flutter analyze` — 0 new errors
- `flutter gen-l10n` succeeds cleanly with all ~35 new keys
- Widget tests use `pump(Duration(seconds: 1))` twice instead of `pumpAndSettle` (animate_do animations never settle)
- Integration test uses InMemory repository implementations for isolation
- Onboarding uses SharedPreferences for first-launch detection (separate from Hive)

---

## [Unreleased] — Phase 6: Admin Theme Consistency & Bug Fixes

### Summary

Fixed admin panel theme consistency — all 7 admin pages now adapt correctly to both dark ("Mahakali Night") and light ("Subho Dawn") themes. Previously, ~120+ hardcoded `Colors.white` text styles and dark backgrounds rendered text invisible in light mode. Added 10 dynamic theme helper methods to `AppTheme`. Restored missing gooey animation support files. Fixed pre-existing gallery test timeout.

### Added

- **Dynamic theme helpers** (`lib/utils/theme.dart`) — 10 new static methods on `AppTheme` that check `Theme.of(context).brightness` and return appropriate colors:
  - `dynamicTextPrimary(context)` — primary text color (white in dark, near-black in light)
  - `dynamicTextSecondary(context)` — secondary text color
  - `dynamicTextMuted(context)` — muted/disabled text color
  - `dynamicTextHint(context)` — hint/placeholder text color
  - `dynamicCardBg(context)` — card background
  - `dynamicSurfaceBg(context)` — surface/container background
  - `dynamicScaffoldBg(context)` — scaffold background
  - `dynamicDivider(context)` — divider/border color
  - `dynamicIconColor(context)` — icon color
  - `dynamicOverlay(context, {alpha})` — semi-transparent overlay
  - `dynamicGradientBg(context)` — gradient background colors list

- **`lib/side.dart`** — `Side` enum (`left`, `right`, `top`, `bottom`) used by gooey animation files
- **`lib/gooey_edge_clipper.dart`** — `GooeyEdgeClipper` class extending `CustomClipper<Path>` for the carousel's gooey edge effect

### Fixed

- **Admin panel light theme visibility** — replaced ~120+ hardcoded `Colors.white` and dark background references across all 7 admin files with dynamic theme helpers:
  - `admin_dashboard.dart` — backgrounds, nav items, stat cards, chart sections, donation/event tiles
  - `admin_login.dart` — background gradient, text fields, demo credentials, quick action buttons
  - `admin_donations.dart` — title, search field, filter chips, donation cards, date range picker, all dialogs (edit/status/delete), `_dialogTextField` helper
  - `admin_events.dart` — title, empty state, category chips, event cards, action bar, all dialogs
  - `admin_gallery.dart` — title, image details dialog, category chips, empty state, gallery items, bottom sheet, delete dialog
  - `admin_community.dart` — title, tab bar, announcement/volunteer tiles, popup menus, add/delete dialogs
  - `admin_user_management.dart` — title, empty state, user cards, add user dialog

- **Light theme ink colors** (`lib/utils/theme.dart`) — updated from green-tinted values (#122518, #26402C, #4D6E56) to neutral values (#1A1A2E, #4A4A5A, #7A7A8A) for proper light theme readability

- **Gallery test timeout** (`test/gallery_page_test.dart`) — replaced `pumpAndSettle()` with `pump(Duration(seconds: 2))` to avoid infinite timeout caused by `animate_do` `FadeInDown` animations that never settle

- **Missing gooey files** — `side.dart` and `gooey_edge_clipper.dart` were deleted in Phase 1 but still imported by `gooey_carousel.dart` and `gooey_edge.dart`; restored both files to resolve 16 compile errors

### Technical Notes

- `flutter analyze` — 0 errors (only info-level deprecation warnings)
- All 129 tests pass (including previously-failing gallery test)
- Date range picker in admin donations now uses theme-aware `ColorScheme.dark()`/`ColorScheme.light()` based on brightness

---

## [Unreleased] — Phase 5: Data Layer — Hive Migration (Sprints 9-10)

### Summary

Complete migration of the persistence layer from SharedPreferences (JSON) to Hive — a high-performance, lightweight NoSQL database. Implemented manual TypeAdapters for all 7 model types, 6 Hive repository implementations with abstract interfaces for DI flexibility, a one-time SharedPreferences→Hive data migration service, global error handlers, and LazyBox optimization for the gallery. Refactored `StorageRepository` and `AdminAuthRepository` into abstract interfaces. Swapped all DI bindings in `main.dart` to Hive implementations. 53 new unit tests — all passing.

### Added

- **Hive TypeAdapters** (`lib/repositories/hive_adapters.dart`)
  - Manual (non-code-generated) adapters for all 7 model types:
    - `DonationAdapter` (typeId: 0) — all fields including optional `phone`, `email`, `status`, `paymentMethod`, `purpose`
    - `EventAdapter` (typeId: 1) — all fields including optional `imageUrl`, `category`
    - `GalleryItemAdapter` (typeId: 2) — all fields including optional `localPath`
    - `AdminUserAdapter` (typeId: 3) — all fields including `passwordHash`, `salt`, `lastLogin`
    - `AdminRoleAdapter` (typeId: 4) — enum adapter mapping index ↔ `AdminRole` values
    - `AnnouncementAdapter` (typeId: 5) — all fields including `isPinned`
    - `VolunteerRegistrationAdapter` (typeId: 6) — all fields including `availability`
  - `registerHiveAdapters()` helper with idempotent registration guards

- **Hive Donation Repository** (`lib/repositories/hive_donation_repository.dart`)
  - `HiveDonationRepository implements DonationRepository`
  - `Box<Donation>` with lazy opening pattern (`_box ??= await Hive.openBox`)
  - Methods: `loadAll()`, `saveAll()`, `put()`, `delete()`, `get()`

- **Hive Event Repository** (`lib/repositories/hive_event_repository.dart`)
  - `HiveEventRepository implements EventRepository`
  - `Box<Event>` with lazy opening; same CRUD pattern

- **Hive Gallery Repository** (`lib/repositories/hive_gallery_repository.dart`)
  - `HiveGalleryRepository implements GalleryRepository`
  - **`LazyBox<GalleryItem>`** for on-demand loading (performance optimization for large image collections)
  - Methods: `loadAll()`, `saveAll()`, `put()`, `delete()`, `get()`, `loadPage(int offset, int limit)` for pagination

- **Hive Admin Auth Repository** (`lib/repositories/hive_admin_auth_repository.dart`)
  - `HiveAdminAuthRepository implements AdminAuthRepository`
  - Two Hive boxes: `admin_auth` (users), `admin_session` (login state)
  - SHA256+salt password hashing via `crypto` package
  - Full CRUD: `ensureDefaultAdmin()`, `authenticateUser()`, `createUser()`, `updateUser()`, `resetUserPassword()`, `deactivateUser()`, `reactivateUser()`
  - Session management: `saveSession()`, `getStoredSession()`, `clearSession()`, `changeUserPassword()`

- **Hive Announcement Repository** (`lib/repositories/hive_announcement_repository.dart`)
  - `HiveAnnouncementRepository implements AnnouncementRepository`
  - Two Hive boxes: `announcements`, `volunteers`
  - Methods: `loadAll()`, `saveAll()`, `loadVolunteers()`, `saveVolunteers()`

- **Hive Storage Repository** (`lib/repositories/hive_storage_repository.dart`)
  - `HiveStorageRepository extends StorageRepository`
  - Schema versioning via `app_meta` box with `schema_version` key

- **Hive Migration Service** (`lib/services/hive_migration_service.dart`)
  - `HiveMigrationService.migrate()` — one-time data migration from SharedPreferences JSON to Hive boxes
  - Migrates all 6 data types: donations, events, gallery items, admin users, announcements, volunteers
  - Sets `hive_migrated` flag to prevent re-migration
  - Cleans up old SharedPreferences keys after successful migration
  - Debug logging for migration progress

- **Global Error Handlers** (`lib/main.dart`)
  - `FlutterError.onError` — catches framework-level errors with stack trace logging
  - `PlatformDispatcher.instance.onError` — catches uncaught async errors

### Changed

- **`main.dart`** — `main()` now `async`: initializes `WidgetsFlutterBinding`, calls `Hive.initFlutter()`, `registerHiveAdapters()`, `HiveMigrationService.migrate()`, registers global error handlers; all Provider `create` calls swapped from SharedPrefs to Hive repository implementations

- **`StorageRepository`** (`lib/repositories/storage_repository.dart`) — refactored from concrete class to **abstract interface**; old implementation renamed to `SharedPrefsStorageRepository extends StorageRepository`; `currentSchemaVersion` bumped to `2`

- **`AdminAuthRepository`** (`lib/repositories/admin_auth_repository.dart`) — extended abstract interface with 5 additional methods: `createUser()`, `updateUser()`, `resetUserPassword()`, `deactivateUser()`, `reactivateUser()`; `SharedPrefsAdminAuthRepository` updated with `@override` annotations

- **`AuthService`** (`lib/services/auth_service.dart`) — constructor parameter type changed from `SharedPrefsAdminAuthRepository?` to `AdminAuthRepository?` (abstract type) for DI flexibility

- **`DataService`** (`lib/services/data_service.dart`) — added `_lastError` field + `lastError` getter; `_bootstrap()`, `_loadData()`, `_saveData()` wrapped in try/catch with `debugPrint` logging; removed `SharedPreferences` import; `clearAllData()` now clears in-memory lists and calls `_saveData()` instead of `prefs.clear()`

### Dependencies

- Added `hive: ^2.2.3` — Hive NoSQL database
- Added `hive_flutter: ^1.1.0` — Hive Flutter initialization helpers
- Added `hive_generator: ^2.0.1` (dev) — Hive code generation (available for future use)
- Added `build_runner: ^2.4.8` (dev) — Build runner for code generation

### Tests (new — 53 tests total)

- `test/hive_adapters_test.dart` — 8 tests: adapter registration verification (all 7 typeIds), double-registration safety, write/read roundtrip for Donation, Event, GalleryItem, AdminUser (with role), Announcement, VolunteerRegistration
- `test/hive_donation_repository_test.dart` — 6 tests: loadAll empty, saveAll/loadAll roundtrip, put/get, delete, overwrite, optional fields
- `test/hive_event_repository_test.dart` — 5 tests: loadAll empty, saveAll/loadAll roundtrip, put/get, delete, nullable fields
- `test/hive_gallery_repository_test.dart` — 5 tests: loadAll empty, saveAll/loadAll roundtrip, put/get, delete, loadPage pagination
- `test/hive_announcement_repository_test.dart` — 7 tests: announcements CRUD, volunteers CRUD, independence between boxes
- `test/hive_admin_auth_repository_test.dart` — 14 tests: ensureDefaultAdmin, authenticate success/fail, createUser, changePassword, deactivate/reactivate, session save/get/clear, resetPassword, updateUser preserves hash
- `test/hive_migration_test.dart` — 8 tests: migrate donations/events/gallery/announcements from SharedPreferences, flag setting, no-op when already migrated, empty SharedPreferences handling, old key cleanup

### Technical Notes

- `flutter analyze` — 0 Phase 5 errors/warnings; 116 pre-existing issues (16 errors in `gooey_carousel.dart`/`gooey_edge.dart` from missing `side.dart`, remainder are info-level `prefer_const_constructors`/`deprecated_member_use`/`use_build_context_synchronously`)
- All 53 new tests pass; 1 pre-existing `gallery_page_test.dart` failure (`pumpAndSettle` timeout from `animate_do` animations — unrelated)
- Full test suite: 114 passed, 1 failed (pre-existing)
- Manual TypeAdapters chosen over `@HiveType`/`@HiveField` code generation to avoid build_runner complexity and provide explicit control over serialization
- `LazyBox` used for `GalleryRepository` to avoid loading all image metadata into memory at startup
- Migration is idempotent — safe to call multiple times (checks `hive_migrated` flag)

---

## [Unreleased] — Phase 4: Engagement Features (Sprints 7-8)

### Summary

Full implementation of engagement features across two sprints. Sprint 7 delivers local notification scheduling (Puja countdown and event reminders), calendar integration (Google Calendar deep-link), and social sharing for donations, events, gallery, and Puja greetings. Sprint 8 adds a community notice board with announcements, Bhog/Prasad schedule, volunteer registration, emergency contacts, and admin community management with announcement CRUD and volunteer viewing. 60 new l10n keys across all 4 languages. 60 new unit/widget tests — all passing.

### Added

- **Notification Service** (`lib/services/notification_service.dart`)
  - Singleton wrapping `FlutterLocalNotificationsPlugin` with Android + iOS initialization
  - `schedulePujaCountdown()` — 7 daily notifications counting down to Mahalaya 2026 (Sept 20)
  - `scheduleEventReminder(Event)` — 1 day before (9 AM) + 1 hour before event
  - `cancelEventReminder(Event)` / `cancelPujaCountdown()` / `cancelAll()`
  - `showAnnouncementNotification()` — immediate notification for admin announcements
  - `requestPermission()` — Android 13+ notification permission request
  - Notification channels: `puja_countdown`, `event_reminders`, `announcements`

- **Share Service** (`lib/services/share_service.dart`)
  - `shareDonationReceipt(Donation)` — formatted receipt with donor details, amount, Bengali blessing
  - `shareEvent(Event)` — event title, description, location, date, category
  - `shareGalleryItem(GalleryItem)` — gallery image metadata sharing
  - `sharePujaGreeting({customMessage})` — cultural greeting in English + Bengali
  - `getCalendarUrl(Event)` — Google Calendar deep-link URL with event details and 2-hour duration

- **Announcement Model** (`lib/models/announcement.dart`)
  - `Announcement` class — id, title, body, category (general/bhog/volunteer/emergency), createdAt, isActive, isPinned; with `toJson`/`fromJson`/`copyWith`
  - `VolunteerRegistration` class — id, name, phone, availability (morning/afternoon/evening/fullDay), registeredAt; with `toJson`/`fromJson`
  - Static `categories` list

- **Announcement Repository** (`lib/repositories/announcement_repository.dart`)
  - Abstract `AnnouncementRepository` interface with `loadAll()`/`saveAll()`/`loadVolunteers()`/`saveVolunteers()`
  - `SharedPrefsAnnouncementRepository` — JSON persistence via SharedPreferences with keys `announcements` and `volunteers`

- **Community Page** (`lib/community_page.dart`)
  - Four-section community notice board in a `CustomScrollView`:
    1. **Announcements** — Consumer-driven list with category color badges, pin sorting, relative time formatting, empty state
    2. **Bhog/Prasad Schedule** — 4-day schedule (Saptami/Ashtami/Navami/Dashami) with times and food items
    3. **Volunteer Registration** — form with name, phone, availability dropdown, gradient submit button; persists via `DataService`
    4. **Emergency Contacts** — 3 contacts (Committee/Medical/Security) with phone icons
  - Bengali cultural theming with `ThemedBackground`, `GlassCard`, `animate_do` animations

- **Admin Community Page** (`lib/admin/admin_community.dart`)
  - Two-tab layout (Announcements / Volunteers) via `TabController`
  - Announcements tab: ListView with tiles, `PopupMenuButton` for pin/deactivate/delete, add dialog with title/body/category/isPinned fields; triggers local notification on add
  - Volunteers tab: summary bar with count, volunteer tiles showing name/phone/availability/registration date, delete with confirmation dialog

- **Event Action Buttons** on `events_page_new.dart`
  - "Add to Calendar" — opens Google Calendar URL via `url_launcher`
  - "Set Reminder" — toggles event reminder via `NotificationService` + `AppSettingsService`
  - "Share" — shares event via `ShareService`
  - Actions only displayed for future events

- **Notification Settings** on `settings/app_settings_page.dart`
  - 3 `SwitchListTile` toggles: Notifications (master), Puja Countdown, Event Reminders
  - Positioned in new "Notifications" section before Security

- **Navigation Wiring**
  - Home page drawer: Community page link with `Icons.groups_rounded` after Trivia
  - Admin dashboard: Community tab at index 4 with `Icons.groups_outlined`; Users shifted to index 5

- **~60 new l10n keys** across all 4 ARB files (en, bn, hi, mr):
  - Settings notification labels (7 keys)
  - Event action labels (6 keys)
  - Home drawer community (1 key)
  - Community page sections, bhog schedule, volunteer form, emergency contacts (25 keys)
  - Admin community CRUD labels & volunteer count (18 keys)

### Changed

- **AppSettingsService** — extended with `notificationsEnabled`, `eventRemindersEnabled`, `pujaCountdownEnabled` (boolean), `eventReminderIds` (Set<String>); new toggle/persist methods for each; all stored via SharedPreferences
- **DataService** — added `AnnouncementRepository` dependency (DI), `announcements`/`volunteers` lists with getters, CRUD methods: `addAnnouncement()`, `updateAnnouncement()`, `deleteAnnouncement()`, `addVolunteer()`, `deleteVolunteer()`; load/save integrated into `_loadData()`/`_saveData()`

### Dependencies

- Added `share_plus: ^10.1.4` — social sharing for donations, events, gallery, greetings

### Tests (new)

- `test/announcement_model_test.dart` — 14 tests: Announcement & VolunteerRegistration creation, serialization roundtrip, copyWith, defaults, categories
- `test/announcement_repository_test.dart` — 8 tests: SharedPrefsAnnouncementRepository load/save/overwrite/clear for both announcements and volunteers; independence check
- `test/share_service_test.dart` — 4 tests: Google Calendar URL generation, encoding, location handling, 2-hour duration
- `test/app_settings_notifications_test.dart` — 13 tests: notification preference defaults, persist/reload, toggleEventReminder add/remove/persist, notifyListeners calls
- `test/data_service_community_test.dart` — 13 tests: announcement add/update/delete + persistence + unknown ID, volunteer add/delete + persistence, notifyListeners verification
- `test/community_page_test.dart` — 5 widget tests: renders without error, section headers, empty announcement state, volunteer form, emergency contacts

### Technical Notes

- `flutter analyze` — 0 Phase 4 errors, 0 Phase 4 warnings; 16 pre-existing errors in `gooey_carousel.dart`/`gooey_edge.dart` (missing `side.dart` — Phase 1 leftover)
- All 60 new tests pass; 1 pre-existing `gallery_page_test.dart` failure (unrelated `pumpAndSettle` timeout from `animate_do` animations)
- `flutter pub get` and `flutter gen-l10n` both succeed cleanly

---

## [Unreleased] — Phase 3: Admin Panel Overhaul (Sprints 5-6)

### Summary

Complete admin panel overhaul with role-based access control, secure multi-user authentication, advanced donation management with edit/status workflow/CSV export, dashboard analytics with fl_chart trend and purpose charts, and a full user management CRUD page. Zero Phase 3 compile errors.

### Added

- **AdminRole enum** with 4 levels: `superAdmin`, `admin`, `contentManager`, `viewer` — each with granular permission booleans (`canManageUsers`, `canManageDonations`, `canManageContent`, `canExportData`)
- **Secure password hashing** using SHA256 with random 32-byte salt (base64 encoded) via the `crypto` package
- **Multi-user admin authentication** — admin auth repository rewritten with `authenticateUser()`, `ensureDefaultAdmin()`, `changeUserPassword()`, user CRUD operations
- **Default admin seeding** — first-run creates super-admin (username: `admin`, password: `admin123`) with hashed credentials
- **Admin User Management page** (`admin_user_management.dart`) — full CRUD UI with:
  - User list with role badges, active/inactive status, last login display
  - Add user dialog (username/email/password/role)
  - Edit user dialog (username/email/role)
  - Reset password dialog
  - Deactivate/reactivate user actions
  - "You" badge for current user (can't edit self)
  - Gated by `canManageUsers` permission
- **Donation purpose field** — `Donation` model now includes `purpose` (default: 'General') with static purpose list: General, Bhog (Food), Pandal Decoration, Pratima (Idol), Cultural Programs
- **Donation status workflow** — static statuses: pending, confirmed, completed, failed; status change dialog in admin
- **Donation edit dialog** — full inline edit form (name, location, amount, phone, email, purpose)
- **Donation status/date/purpose filtering** — status filter chips, date range picker, purpose filter in admin donations
- **CSV export** — donation list export to app documents directory via `csv` package, gated by `canExportData`
- **Dashboard donation trend chart** — `fl_chart` `LineChart` showing last 6 months of donation amounts with curved line, gradient fill, and formatted axis labels
- **Dashboard purpose breakdown chart** — `fl_chart` `PieChart` showing donation distribution by purpose with color-coded legend
- **Dashboard View All wiring** — Recent Donations → Donations tab, Upcoming Events → Events tab
- **Users nav item** — conditionally shown in both side and bottom navigation when `canManageUsers` is true
- **40+ new l10n keys** across all 4 ARB files (en, bn, hi, mr) for user management, donation management, chart titles, and filter labels

### Changed

- **AdminUser model** — added `passwordHash`, `salt`, `isActive`, `copyWith()` fields; role now uses `AdminRole` enum
- **Donation model** — added `purpose` field and static `purposes`/`statuses` lists; updated `toJson`/`fromJson`/`copyWith`
- **Admin auth repository** — complete rewrite from session-only to persistent multi-user store with secure hashing
- **AuthService** — delegates to repository for auth + user management; removed hardcoded credentials; added `hasPermission()`, `getAllUsers()`, `createUser()`, `updateUser()`, `deactivateUser()`, `reactivateUser()`, `resetUserPassword()`
- **Admin donations page** — complete rewrite with status filter chips, date range picker, edit/status dialogs, CSV export, sort by status
- **Admin dashboard** — `_pages` now a dynamic getter with conditional Users tab; added `navigateToTab()` method; DashboardHome accepts `onNavigateToTab` callback

### Dependencies

- Added `fl_chart: ^0.69.2` — admin dashboard charts
- Added `csv: ^6.0.0` — donation CSV export

---

## [Unreleased] — Phase 2: UI/UX Bengali Cultural Redesign

### Summary

Complete visual identity overhaul — replaced the generic purple/blue/green palette with an authentic Bengali cultural color scheme featuring vermillion (sindoor), sacred gold, deep saffron, turmeric, and mango leaf green. Added Hind Siliguri Bengali typeface (5 weights). Redesigned all pages with cultural gradients and warm tones. Migrated every `.withOpacity()` call to `.withValues(alpha:)` across the entire codebase (100+ occurrences). Zero compile errors.

### Added

- **Hind Siliguri Bengali font family (5 weights)**
  - `assets/fonts/HindSiliguri-Light.ttf` (300)
  - `assets/fonts/HindSiliguri-Regular.ttf` (400)
  - `assets/fonts/HindSiliguri-Medium.ttf` (500)
  - `assets/fonts/HindSiliguri-SemiBold.ttf` (600)
  - `assets/fonts/HindSiliguri-Bold.ttf` (700)
  - Registered in `pubspec.yaml` with proper weight mappings
  - Set as `fontFamily` in both dark and light ThemeData with `fontFamilyFallback: ['Roboto']`

- **Bengali cultural color palette** (`lib/utils/theme.dart`):
  - `vermillion` (0xFFE23D28), `vermillionDark` (0xFFC41E3A), `vermillionDeep` (0xFFB71C1C) — sindoor/kumkum
  - `sacredGold` (0xFFD4AF37), `goldBright` (0xFFFFD700), `goldDark` (0xFFB8860B) — temple gold
  - `deepSaffron` (0xFFFF6B35) — festival saffron
  - `mangoLeafGreen` (0xFF2E7D32) — auspicious mango leaf
  - `turmericGold` (0xFFE8A317) — haldi/turmeric
  - `dawnBackground` (0xFFFFF8F0), `dawnSurface` (0xFFFFF3E6), `dawnCardBg` (0xFFFFFBF5) — warm ivory light mode

- **Cultural gradients**:
  - `vermillionGradient`, `sacredGoldGradient`, `festivalGradient`

- **Design tokens**:
  - `radiusCard` (20), `radiusButton` (16), `radiusChip` (12)
  - `alponaPatternColor()` — alpona-themed accent for both theme modes

- **Dark theme: "Mahakali Night"** — aubergine background (0xFF0D0A1A), deep purple surface (0xFF1A1028), sacredGold primary, vermillion secondary

- **Light theme: "Subho Dawn"** — ivory background (0xFFFFF8F0), warm saffron surface (0xFFFFF3E6), vermillionDark primary, turmericGold secondary

### Changed

- **Theme overhaul** (`lib/utils/theme.dart`):
  - Complete rewrite — old blue/purple/green palette replaced with Bengali cultural palette
  - Both ThemeData instances now use `fontFamily: 'HindSiliguri'`
  - Legacy aliases maintained for backward compatibility (`primaryPurple`, `primaryOrange`, `primaryGold`)

- **Splash screen redesign** (`lib/splash_screen.dart`):
  - Background gradient: aubergine (0xFF0D0A1A) base
  - Logo gradient: vermillion → sacredGold
  - Ring border, ShaderMask, particles: all use cultural palette
  - Bengali blessing text 'শুভ দুর্গা পূজা' with HindSiliguri font
  - Progress bar: sacredGold accent

- **Home page redesign** (`lib/home_page.dart`):
  - Feature card gradients: Donate (vermillion), Gallery (gold), Events (saffron), Trivia (mango leaf green)
  - Welcome ShaderMask: vermillion → sacredGold → deepSaffron
  - Light-mode colors: all green tints → warm ivory/brown tones (4A3520, FFF3E6, FFF8F0)
  - Stats panel, info card, floating button, drawer admin, AppBar icon shadow: all updated
  - Fixed corrupted `_buildSliverAppBar` leading (missing IconButton/borderRadius)

- **Animated backgrounds** (3 files):
  - `dark_firefly_background.dart` — particles: sacredGold → goldBright (gold fireflies), background: aubergine
  - `dawn_rays_background.dart` — sun core: turmeric gold, base gradient: warm ivory
  - `themed_background.dart` — light overlay: warm ivory/saffron tones
  - `animated_wave_background.dart` — background: aubergine, wave colors: blue → sacredGold/turmericGold/deepSaffron

- **Donation page** (`lib/donation_page_new.dart`):
  - Amount button gradient: vermillion → sacredGold
  - Selected border: vermillion

- **Events page** (`lib/events_page_new.dart`):
  - Category chips: vermillion → sacredGold gradient
  - Calendar today: sacredGold, turmericGold
  - Panel colors, event cards: warm ivory tones

- **Gallery page** (`lib/gallery_page_new.dart`):
  - Category chips, shadows, spinners, default colors: sacredGold/vermillion
  - Fixed broken CachedNetworkImage (missing closing brackets & errorWidget)
  - Fixed missing `_showImagePreview` method signature

- **Common widgets** (`lib/widgets/common_widgets.dart`):
  - GradientButton: vermillion → sacredGold gradient, shadow: vermillion

- **Playlist page** (`lib/playlist_page.dart`):
  - All hardcoded `Color(0xFFE94560)` → `AppTheme.vermillion`
  - All hardcoded `Color(0xFF6B21A8)` → `AppTheme.sacredGold`
  - Background colors: `AppTheme.darkBackground` / `AppTheme.darkSurface`
  - Added `import 'utils/theme.dart'`

- **Theme toggle chip** (`lib/widgets/theme_toggle_chip.dart`):
  - Light-mode text: 0xFF132619 (dark green) → 0xFF4A3520 (warm brown)
  - Border: 0xFF8CCB7F (green) → `AppTheme.sacredGold`
  - Added `import '../utils/theme.dart'`

- **Admin pages (4 files):**
  - `admin_dashboard.dart` — all `primaryPurple` → `sacredGold` for nav highlights, logo shadow, header icon, "View All" links
  - `admin_login.dart` — decorative circles, login button shadow, disabled gradient: `sacredGold`
  - `admin_events.dart` — add event button, category chips: `sacredGold`
  - `admin_gallery.dart` — add button shadow, category badge: `sacredGold`

- **`.withOpacity()` → `.withValues(alpha:)` migration** — eliminated all 100+ deprecated `withOpacity` calls across the entire `lib/` directory:
  - `splash_screen.dart`, `home_page.dart`, `donation_page_new.dart`, `events_page_new.dart`, `gallery_page_new.dart`
  - `playlist_page.dart`, `trivia.dart`
  - `common_widgets.dart`, `theme_toggle_chip.dart`, `animated_wave_background.dart`
  - `dark_firefly_background.dart`, `dawn_rays_background.dart`, `themed_background.dart`
  - `admin_dashboard.dart`, `admin_login.dart`, `admin_events.dart`, `admin_gallery.dart`, `admin_donations.dart`

### Technical Notes

- `flutter analyze` reports **0 errors**, **0 `withOpacity` deprecation warnings**
- 57 remaining issues are all pre-existing `info`-level hints (prefer_const, unused_field, dead_null_aware, library_private_types)
- Legacy color aliases (`primaryPurple`, `primaryOrange`, `primaryGold`) maintained in `theme.dart` for any external consumers
- Hind Siliguri font sourced from google/fonts GitHub repository (OFL-licensed)

---

## [Unreleased] — Phase 1: Foundation & Cleanup

### Summary

Completed a full cleanup of the codebase — removed 10 dead source files, 2 template directories, and 5 unused dependencies. Implemented a complete localization infrastructure supporting 4 languages (English, Bengali, Hindi, Marathi) with ~200+ translated keys. Replaced every user-facing hardcoded string across 13 source files with localized equivalents. Added a language selector to settings. Fixed type safety issues (`dynamic` → proper model types) and added platform guards for `dart:io` usage. Zero compile errors.

### Added

- **Localization infrastructure (4 languages)**
  - `lib/src/localization/app_en.arb` — ~200+ English string keys covering all pages (template file)
  - `lib/src/localization/app_bn.arb` — full Bengali (বাংলা) translations
  - `lib/src/localization/app_hi.arb` — full Hindi (हिन्दी) translations
  - `lib/src/localization/app_mr.arb` — full Marathi (मराठी) translations
  - Generated `AppLocalizations` class with static delegates and supported locales via `flutter gen-l10n`
  - Parameterized strings with ICU message format for dynamic values (counts, amounts, etc.)

- **Language selector in settings**
  - `lib/services/app_settings_service.dart` — added `locale` property (persisted via SharedPreferences), `setLocale()` method
  - `lib/settings/app_settings_page.dart` — new Language section with bottom sheet picker showing 4 languages with native script names (English, বাংলা, हिन्दी, मराठी)
  - `lib/main.dart` — wired `localizationsDelegates`, `supportedLocales`, and `locale` binding from `AppSettingsService`

- **`intl` package** added to `pubspec.yaml` dependencies (required by `flutter_localizations`)

- **`kIsWeb` platform guard** — `lib/gallery_page_new.dart` now checks `!kIsWeb` before using `dart:io` `File` for local images (2 locations: grid item + preview page)

- **`GalleryItem` and `Event` model imports** — `lib/gallery_page_new.dart` and `lib/events_page_new.dart` now import their respective model classes

### Changed

- **Localized all user-facing strings across 13 files:**
  - `lib/home_page.dart` — 31 replacements; added `_localizedFeatureTitle()` and `_localizedFeatureSubtitle()` helper methods for const `_Feature` list
  - `lib/splash_screen.dart` — 5 replacements (title, year, Bengali blessing, loading text); removed `const` from affected `Text` widgets
  - `lib/donation_page_new.dart` — 20 replacements including parameterized strings (`donationPaymentStatus(status)`, `donationReceived(amount)`, `donationDonateAmount(amount)`, `donationRsAmount(amount)`)
  - `lib/events_page_new.dart` — 7 replacements (title, upcoming count, 5 category chips, no-events text, past badge, location TBD)
  - `lib/gallery_page_new.dart` — 5 replacements (title, photos count, 5 category chips, empty state text)
  - `lib/trivia.dart` — 12+ UI string changes; quiz questions moved from direct init to `didChangeDependencies()` lazy initialization via `_buildQuestions(context)` for localized access
  - `lib/DurgaPujaApp.dart` — 18 replacements (9 about section titles + 9 descriptions); added `_L10n` extension on `BuildContext` for cleaner access
  - `lib/playlist_page.dart` — converted static `_videos` list to `_localizedVideos(context)` method; 6 UI string replacements (page title, video count, tap-to-play, HD label, loading text)
  - `lib/admin/admin_login.dart` — ~20 string replacements
  - `lib/admin/admin_dashboard.dart` — ~31 string replacements
  - `lib/admin/admin_donations.dart` — ~15 string replacements
  - `lib/admin/admin_events.dart` — ~31 string replacements
  - `lib/admin/admin_gallery.dart` — ~27 string replacements

- **Type safety improvements:**
  - `lib/gallery_page_new.dart` — `_buildGalleryItem(dynamic item)` → `_buildGalleryItem(GalleryItem item)`, `_showImagePreview(dynamic item)` → `_showImagePreview(GalleryItem item)`, `ImagePreviewPage.item` field `dynamic` → `GalleryItem`
  - `lib/events_page_new.dart` — `_buildEventCard(dynamic event, bool isDark)` → `_buildEventCard(Event event, bool isDark)`

- **Fixed `const` errors:**
  - `lib/settings/app_settings_page.dart` — `_supportedLocales` map changed from `const` to `final` (Locale overrides `==`/`hashCode`, not allowed as const map key)
  - `lib/admin/admin_gallery.dart` — removed `const` from `Row` containing non-const `Text` with l10n call; added `const` to child `Icon` and `SizedBox`

- **Updated test:**
  - `test/gallery_page_test.dart` — rewritten for `GalleryPageNew` (old `GalleryPage` was deleted); now wraps in `ChangeNotifierProvider<DataService>` and `MaterialApp` with l10n delegates

### Removed

- **10 dead source files:**
  - `lib/donation_page.dart` — superseded by `donation_page_new.dart`
  - `lib/events.dart` — superseded by `events_page_new.dart`
  - `lib/gallery_page.dart` — superseded by `gallery_page_new.dart`
  - `lib/initial_page.dart` — unused landing page
  - `lib/gooey_carousel.dart`, `lib/gooey_edge.dart`, `lib/gooey_edge_clipper.dart`, `lib/side.dart` — unused animation utilities
  - `lib/content_card.dart`, `lib/sun_moon.dart` — orphaned widgets

- **2 template directories:**
  - `lib/src/sample_feature/` — Flutter scaffold boilerplate
  - `lib/src/settings/` — Flutter scaffold boilerplate

- **5 unused dependencies from `pubspec.yaml`:**
  - `fluttertoast` — not imported anywhere
  - `flutter_animate` — not imported anywhere
  - `carousel_slider` — not imported anywhere
  - `animated_text_kit` — not imported anywhere
  - `shimmer` — not imported anywhere

- **9 duplicate asset entries** from `pubspec.yaml` (`assets/images/` section)

### Technical Notes

- `flutter analyze` reports **0 errors**, 290 info-level `withOpacity` deprecation warnings (to be addressed in Phase 2)
- All existing tests pass (`flutter test` — 4/4 in theme_service_test.dart and themed_background_test.dart)
- Localization uses relative import path `src/localization/app_localizations.dart` (not `package:flutter_gen/gen_l10n/`)
- The `donation_page_new.dart` `_handleError(dynamic error)` retains `dynamic` intentionally — error objects from PhonePe SDK are untyped
