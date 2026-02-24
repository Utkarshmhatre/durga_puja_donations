# Plan: Durga Puja App Comprehensive Upgrade (Revised)

**TL;DR:** A 6-month phased roadmap (12 sprints, 2 updates/month) transforming the app into a polished, culturally authentic, multilingual Durga Puja platform. Persistence migrates from SharedPreferences to **Hive**. Supports **English, Bengali, Hindi, and Marathi**. UI/UX redesign centers on traditional Bengali visual identity — vermillion, gold, *alpona* motifs, and Durga Maa iconography — while retaining the existing glassmorphism system.

---

## Phase 1: Foundation & Cleanup (Month 1)

### Sprint 1 — Codebase Cleanup & Localization Infrastructure

1. **Remove dead code & unused deps:**
   - Delete legacy files: `lib/donation_page.dart`, `lib/events.dart`, `lib/gallery_page.dart`, `lib/initial_page.dart`, `lib/gooey_carousel.dart`, `lib/gooey_edge.dart`, `lib/gooey_edge_clipper.dart`, `lib/side.dart`
   - Delete `lib/src/sample_feature/` and `lib/src/settings/` (Flutter template boilerplate)
   - Remove unused pubspec deps: `flutter_animate`, `carousel_slider`, `animated_text_kit`, `shimmer`, `fluttertoast`
   - Fix duplicate asset entries in `pubspec.yaml`

2. **Wire up l10n for 4 languages:** In `lib/main.dart`, add `localizationsDelegates: AppLocalizations.localizationsDelegates` and `supportedLocales: AppLocalizations.supportedLocales` to `MaterialApp`. Update `l10n.yaml` to support `en`, `bn`, `hi`, `mr`. Create ARB files:
   - `lib/src/localization/app_bn.arb` (Bengali)
   - `lib/src/localization/app_hi.arb` (Hindi)
   - `lib/src/localization/app_mr.arb` (Marathi)

3. **Extract all hardcoded strings** into `app_en.arb`. Key string-heavy files: `lib/home_page.dart` (~40 strings: "Durga Puja 2026", "Total Donations", "Welcome", feature titles, drawer items), `lib/donation_page_new.dart` (~25 strings: form labels, validation, "Thank You!"), `lib/events_page_new.dart`, `lib/gallery_page_new.dart`, `lib/trivia.dart` (17 questions × 5 strings each = ~85 strings), all 5 admin pages, `lib/splash_screen.dart`, `lib/DurgaPujaApp.dart`. Replace with `AppLocalizations.of(context)!.keyName`.

4. **Add language selector to settings:** Extend `lib/services/app_settings_service.dart` with a persisted `locale` property. Add a language picker widget (4 options with script names: English, বাংলা, हिन्दी, मराठी) to `lib/settings/app_settings_page.dart`. Wire into `MaterialApp.locale`.

### Sprint 2 — Translations & Type Safety

5. **Complete all translations:**
   - Bengali (`app_bn.arb`) — primary community language, ~200 keys
   - Hindi (`app_hi.arb`) — broad reach
   - Marathi (`app_mr.arb`) — for Maharashtrian Bengali diaspora and Navratri overlap communities
   - Trivia quiz: translate all 17 questions, 4 options each, hints into all 3 languages
   - Run `flutter gen-l10n` and fix any missing key errors

6. **Fix type safety & platform issues:**
   - Replace `dynamic` → `GalleryItem` in `lib/gallery_page_new.dart` `_buildGalleryItem`
   - Replace `dynamic` → `Event` in `lib/events_page_new.dart` `_buildEventCard`
   - Add `kIsWeb` guard around `dart:io` `File` usage in gallery
   - Fix hardcoded `Color(0xFF173022)` in `lib/home_page.dart` `_buildUpcomingEvents` — use `AppTheme.dynamicTextPrimary(context)`

---

## Phase 2: UI/UX Bengali Cultural Redesign (Month 2)

### Sprint 3 — Visual Identity Overhaul

7. **Bengali-inspired color palette:** Redesign `lib/utils/theme.dart` `AppTheme`:

   **Dark Theme — "Mahakali Night" (revised):**
   | Role | Current | New | Reasoning |
   |------|---------|-----|-----------|
   | Background | `#060A14` (near-black) | `#0D0A1A` (deep aubergine) | Warmer, evokes twilight *sandhya aarti* |
   | Surface/Card | `#0B1D3A` / `#101B2F` | `#1A1028` / `#231538` | Purple-tinted, cohesive with Mahakali motif |
   | Primary | `#2D7BFF` (electric blue) | `#D4AF37` (gold) | Gold is the sacred color — *sindoor dana*, ornaments |
   | Secondary | `#63A6FF` | `#E23D28` (vermillion) | *Sindoor*, *alta*, the defining Durga Puja color |
   | Accent | `#EC4899` (pink) | `#FF6B35` (deep saffron) | *Dhunuchi* fire, marigold garlands |
   | Gradient stops | `#1E1B4B → #581C87 → #9333EA` | `#0D0A1A → #2D1040 → #4A1A6B` | Deeper, more regal |

   **Light Theme — "Subho Dawn" (revised):**
   | Role | Current | New | Reasoning |
   |------|---------|-----|-----------|
   | Background | `#FFFDF7` (warm white) | `#FFF8F0` (ivory cream) | Warmer, *shola-pith* white |
   | Surface | `#F1F9EB` (pistachio) | `#FFF3E6` (light saffron wash) | Harmonizes with vermillion accents |
   | Primary | `#8CCB7F` (leaf green) | `#C41E3A` (crimson/sindoor) | Iconic Durga Puja red |
   | Secondary | `#F26A6A` (warm red) | `#E8A317` (turmeric gold) | *Haldi*, *gada* (mace), sacred gold |
   | Accent | — | `#2E7D32` (mango leaf green) | *Aam pata* torana, auspicious décor |
   | Card bg | `white@0.85` | `#FFFAF5@0.90` | Slightly warmer card tone |

8. **Bengali typography:** Add **Hind Siliguri** (for Bengali/Hindi/Marathi — all Devanagari + Bengali script) as font asset:
   - In `pubspec.yaml`: add `google_fonts` package or bundle font files under `assets/fonts/`
   - In `lib/utils/theme.dart`: set `fontFamily: 'HindSiliguri'` with `fontFamilyFallback: ['Roboto']` in `ThemeData.textTheme`
   - Title text (h1-h3): weight 700, letter-spacing -0.5
   - Body text: weight 400, letter-spacing 0.15, height 1.5 for Bengali readability
   - Bengali script needs ~15% more line-height than Latin

9. **Cultural design tokens — new additions to `AppTheme`:**
   - `vermillionGradient`: `#E23D28 → #C41E3A → #8B1A1A` (for primary CTAs)
   - `sacredGoldGradient`: `#FFD700 → #D4AF37 → #B8860B` (keep existing `goldGradient`)
   - `alponaPatternColor(context)`: `white@0.06` (dark) / `#C41E3A@0.04` (light) — for subtle background patterns
   - `festivalGradient`: `#E23D28 → #D4AF37 → #FF6B35` (tri-color festive for banners)
   - Border radius standard: 20px (cards), 16px (buttons/inputs), 12px (chips) — codified as `AppTheme.radiusCard`, `AppTheme.radiusButton`, `AppTheme.radiusChip`

### Sprint 4 — Page-Level UI/UX Redesign

10. **Splash screen redesign** — `lib/splash_screen.dart`:
    - Replace `FlutterLogo` (currently a 140×140 gradient circle with `temple_hindu` icon) with one of the provided Durga Maa vector illustrations as `Image.asset`
    - Update particle colors from `#E94560 → #6B21A8` to `#E23D28 → #D4AF37` (vermillion → gold)
    - Update expanding ring color from `#6B21A8@0.3` to `#D4AF37@0.3` (gold rings)
    - Update title `ShaderMask` gradient from `#E94560→#FFD700→#E94560` to `#E23D28→#FFD700→#E23D28`
    - Keep the Bengali blessing `"॥ শুভ দুর্গা পূজা ॥"` — now rendered in Hind Siliguri font
    - Add a subtle *dhak* beat haptic pattern on load (3 short vibrations)
    - Consolidate 6 `AnimationController`s into a single `Stagger` using `flutter_animate` intervals (simplifies lifecycle management)

11. **Home page cultural makeover** — `lib/home_page.dart`:

    **App Bar:**
    - Replace `Icons.temple_hindu` + "Durga Puja" title with Durga Maa face icon asset (small, 40×40) + stylized committee name
    - Add a theme-aware `vermillionGradient` / `sacredGoldGradient` underline

    **Welcome Section (`_buildWelcomeSection`):**
    - Add a **Puja countdown widget** below the title: days/hours/minutes to Mahalaya (auto-calculated from device date to Bengali calendar Puja dates)
    - Countdown cards in `GlassCard` with gold border, each unit (days/hrs/min) in a separate rounded container
    - Below countdown: animated greeting text cycling through English → Bengali → Hindi → Marathi using `AnimatedSwitcher`

    **Quick Stats (`_buildQuickStats`):**
    - Current: 3 stats in glass row. Redesign: individual `StatCard`s in a horizontal scroll with cultural icons (🪔 for donations, 💰 for amount, 📅 for events)
    - Add warm gradient tint: vermillion for donation count, gold for amount, saffron for events

    **Features Grid (`_buildFeaturesGrid`):**
    - Current: 2×2 `Wrap` with gradient cards. Redesign: keep grid but add *alpona*-inspired decorative border to each card using a `CustomPainter` that draws a thin paisley/lotus corner motif in `alponaPatternColor`
    - Gradient updates: Donate (vermillion gradient), Gallery (gold gradient), Events (saffron gradient), Trivia (deep aubergine + gold)
    - Add subtle entrance animation stagger: 100ms delay between cards using `AnimatedListItem` (already exists in `lib/widgets/common_widgets.dart`)

    **New section — "Shareable Greetings" banner:**
    - Below features grid: a horizontally scrollable row of 3-4 pre-designed Puja greeting card templates
    - Tap to preview + share via `share_plus`
    - Templates use the provided Durga Maa artwork overlaid with festival text

    **Drawer redesign:**
    - Current header: `primaryGradient` with temple icon. New: gradient from vermillion→gold with Durga Maa illustration as background
    - Menu items: add icon tint matching cultural palette
    - Add language quick-switch row at bottom of drawer (4 flag/script buttons: EN, বা, हि, म)

12. **Donation page UX improvements** — `lib/donation_page_new.dart`:
    - **Donation purpose selector:** Add a category `ChoiceChip` row above amount selection: *Bhog (Food)*, *Pandal Decoration*, *Pratima (Idol)*, *Cultural Programs*, *General* — stored in `Donation` model's new `purpose` field
    - **UPI QR code:** Move `qr_flutter` from `dev_dependencies` to `dependencies`. After successful payment, show QR receipt in a `GlassCard` dialog
    - **PDF receipt:** Use existing `pdf` package to generate a branded receipt (committee name, date, amount, donor name, purpose, transaction ID)
    - **Share receipt:** `share_plus` to share PDF or screenshot
    - **Amount buttons styling:** Current `AnimatedContainer` with gradient toggle — update selected gradient to `vermillionGradient`, unselected to `glassmorphism` style
    - **Success dialog redesign:** Replace generic green check with a festive animation — *pranam* hands icon + gold confetti particles + "ধন্যবাদ" / "Thank You" based on locale

13. **Gallery page improvements** — `lib/gallery_page_new.dart`:
    - **Year filter tabs:** Add year-based `TabBar` (2024, 2025, 2026) above category chips
    - **Staggered grid:** Replace uniform grid with `flutter_staggered_grid_view` for Pinterest-style layout — vary tile heights for visual interest
    - **Image sharing:** Long-press or share icon on full-screen preview → `share_plus`
    - **Cultural frame overlay:** Optional *alpona*-style thin decorative frame rendered around images in grid view using `CustomPainter`

14. **Events page polish** — `lib/events_page_new.dart`:
    - **Calendar header:** Style `TableCalendar` markers with vermillion dots for religious events, gold for cultural, green for service
    - **Event cards:** Add left-side color stripe matching category (consistent with calendar dot colors)
    - **Add to Calendar:** Use `url_launcher` to create calendar intent
    - **Share event:** `share_plus` with formatted text

15. **Animated backgrounds update:**
    - `lib/widgets/backgrounds/dark_firefly_background.dart`: Change particle color blend from `#2D7BFF → #63A6FF` (blue) to `#D4AF37 → #FFD700` (gold fireflies) — evokes *diya* flames at night pandal
    - `lib/widgets/backgrounds/dawn_rays_background.dart`: Update base gradient from `#C7EFAE → #FFF7E8 → #F48A8A` to `#FFF3E6 → #FFF8F0 → #FDDCDC` (softer, warmer dawn matching new light palette). Sun core gradient: white → `#E8A317` (turmeric gold)

---

## Phase 3: Admin Panel Overhaul (Month 3)

### Sprint 5 — Admin Auth & User Management

16. **Replace hardcoded credentials:** In `lib/repositories/admin_auth_repository.dart`:
    - Store admin credentials as Hive box entries (after Phase 5 migration; initially keep SharedPreferences but hash password using existing `crypto` SHA256)
    - Support multiple admin users with roles: `superAdmin`, `contentManager`, `viewer`
    - Implement working "Change Password" — currently calls `_saveSettings()` but settings map excludes password

17. **Admin user management page:** New `lib/admin/admin_user_management.dart`:
    - List all admin users with role badges
    - Super Admin can add/edit/delete other admins
    - Content Manager: can manage events, gallery, donations — cannot manage admins
    - Viewer: read-only dashboard access
    - Extend `lib/models/admin_user.dart` with `role` (enum), `createdAt`, `lastLoginAt` fields

### Sprint 6 — Donation Management & Reporting

18. **Enhanced donation tracking** — `lib/admin/admin_donations.dart`:
    - **Edit donation:** Add `_showEditDialog` (currently only delete exists)
    - **Status workflow:** New `status` field on `Donation` model: `pending → confirmed → receipted`. Filterable by status
    - **Date range filter:** Two `DatePicker` inputs for start/end date filtering
    - **Category breakdown:** Pie chart showing donation by purpose (use `fl_chart` package)
    - **CSV export:** `csv` package → generate downloadable CSV file
    - **PDF report:** Summary report using `pdf` package — committee header, date range, totals, per-category breakdown

19. **Dashboard improvements** — `lib/admin/admin_dashboard.dart`:
    - Wire empty `onPressed: () {}` on "View All" buttons → navigate to `AdminDonations`, `AdminEvents`, `AdminGallery` tabs
    - Add donation trend line chart (`fl_chart`)
    - Add recent activity feed (last 10 actions: donation added, event created, etc.)
    - Wrap in `ThemedBackground` (currently uses plain `Container(color: Color(0xFF0A0A12))`)
    - Apply admin color accent: deep gold + vermillion header gradient

---

## Phase 4: Engagement Features (Month 4)

### Sprint 7 — Notifications & Calendar

20. **Implement notifications:** Wire up existing `flutter_local_notifications` dependency:
    - New `lib/services/notification_service.dart`
    - Schedule Puja countdown (daily from Mahalaya - 7 days)
    - Event reminders: 1 day before + 1 hour before
    - Admin-triggered announcements (admin publishes → scheduled local notification)
    - Notification preferences toggle in `lib/settings/app_settings_page.dart`

21. **Event calendar integration:**
    - "Add to Calendar" button on each event card → `add_2_calendar` package or `url_launcher` calendar intent
    - "Set Reminder" toggle per event → schedules local notification
    - Event sharing: formatted text + deep link

### Sprint 8 — Social & Community

22. **Social sharing service:** New `lib/services/share_service.dart`:
    - Share donation receipt (PDF or formatted text)
    - Share gallery images
    - Share events
    - Share Puja greetings (image + text template)
    - Configure Android deep links in `android/app/src/main/AndroidManifest.xml`

23. **Community notice board:** New `lib/community_page.dart`:
    - Committee announcements (admin-published, stored in Hive)
    - Volunteer registration form (name, phone, availability)
    - Bhog/Prasad distribution schedule
    - Emergency contacts during Puja
    - Follow existing pattern: `ThemedBackground` → `CustomScrollView` → `GlassCard` sections, `Consumer<DataService>` for data
    - Add corresponding admin section in `lib/admin/admin_community.dart`

---

## Phase 5: Data Layer — Hive Migration (Month 5)

### Sprint 9 — Hive Setup & Migration

24. **Add Hive to project:**
    - Add `hive: ^2.2.3`, `hive_flutter: ^1.1.0` to `dependencies`
    - Add `hive_generator: ^2.0.1`, `build_runner` to `dev_dependencies`
    - Initialize Hive in `lib/main.dart` `main()`: `await Hive.initFlutter()`
    - Register adapters for all models

25. **Create Hive model adapters:** Annotate each model with `@HiveType` and `@HiveField`:
    - `lib/models/donation.dart` — `typeId: 0`, fields: id, name, location, phone, email, amount, date, purpose (new), status (new)
    - `lib/models/event.dart` — `typeId: 1`, fields: id, title, description, date, location, category, isActive
    - `lib/models/gallery_item.dart` — `typeId: 2`, fields: id, title, imagePath, category, isLocal, isActive, addedDate
    - `lib/models/admin_user.dart` — `typeId: 3`, fields: id, username, passwordHash, role, createdAt, lastLoginAt
    - New `lib/models/announcement.dart` — `typeId: 4`, for community notice board

26. **Create Hive repository implementations:**
    - `HiveDonationRepository implements DonationRepository` — Box name `'donations'`
    - `HiveEventRepository implements EventRepository` — Box name `'events'`
    - `HiveGalleryRepository implements GalleryRepository` — Box name `'gallery'`
    - `HiveAdminAuthRepository implements AdminAuthRepository` — Box name `'admin_auth'`
    - Make `StorageRepository` abstract first (currently concrete), then create `HiveStorageRepository`
    - Each repo: `loadAll()` → `box.values.toList()`, `saveAll()` → `box.clear()` + `box.addAll()`. Individual CRUD methods: `box.put(id, item)`, `box.delete(id)` — **much more efficient than the current pattern** where `_saveData()` serializes ALL entities on every mutation

27. **Data migration utility:** One-time migration from SharedPreferences → Hive:
    - Read existing JSON from SharedPreferences keys (`"donations"`, `"events"`, `"gallery"`, `"admin_user"`)
    - Parse and write to corresponding Hive boxes
    - Set migration flag in SharedPreferences: `"hive_migrated": true`
    - Delete old SharedPreferences keys after successful migration
    - Run in `main()` before `DataService` initialization

28. **Swap DI in main.dart:** Change repository constructor arguments in `DataService(...)` and `AuthService(...)` from `SharedPrefs*` to `Hive*` implementations. The abstract interfaces ensure zero changes to `DataService` business logic.

### Sprint 10 — Reliability & Performance

29. **Error handling:**
    - Wrap `DataService._loadData()` in try/catch — currently if JSON is malformed the app crashes
    - Add `HiveError` handling in all Hive repository methods
    - Global error handler in `lib/main.dart`: `FlutterError.onError` + `PlatformDispatcher.instance.onError`
    - User-friendly error snackbars instead of silent failures

30. **Performance optimizations:**
    - **Hive lazy boxes** for large datasets (gallery images list) — `Hive.openLazyBox()` for on-demand loading
    - Pagination for donation/gallery lists (load 20 at a time)
    - Image compression before local storage (`flutter_image_compress`)
    - Use `ShimmerEffect` (from `lib/widgets/common_widgets.dart`) consistently as loading placeholder on all data-fetching pages
    - Audit `reducedMotion` compliance: ensure all 3 animated backgrounds + splash + home page animations respect the setting

---

## Phase 6: Polish & Launch (Month 6)

### Sprint 11 — Testing & Accessibility

31. **Expand test coverage** (currently only 3 test files):
    - **Unit tests:** `DataService` CRUD operations, `AuthService` login/logout, `AppSettingsService` locale persistence, all Hive repository implementations with mock boxes
    - **Widget tests:** `DonationPageNew` form validation + submission, `EventsPageNew` category filtering, `HomePage` countdown timer logic
    - **Integration test:** Full donation flow: fill form → select amount → mock payment → verify in DataService
    - Follow existing patterns from `test/theme_service_test.dart` (well-structured mock setup with `SharedPreferences.setMockInitialValues`)

32. **Accessibility audit:**
    - Add `Semantics` widgets to all interactive elements (buttons, cards, images)
    - Ensure contrast ratio ≥ 4.5:1 for body text, ≥ 3:1 for large text — verify against new vermillion/gold palette on both themes
    - Test Bengali/Hindi/Marathi text rendering at various font sizes
    - All gallery images: add `semanticLabel`
    - Test with TalkBack (Android) screen reader

### Sprint 12 — Final Polish & Launch

33. **User feedback mechanism:**
    - New `lib/feedback_page.dart`: simple form (rating 1-5 stars, text comment, optional contact)
    - Store in Hive box `'feedback'`
    - Show feedback list in admin panel (`lib/admin/admin_feedback.dart`)
    - Prompt for feedback after 3rd successful donation (non-intrusive bottom sheet)

34. **App store preparation:**
    - Update app icon to Durga Maa branding (use the provided vector artwork)
    - Proper version bumps in `android/app/build.gradle`
    - Onboarding carousel for first-time users: 3 screens — (1) Welcome + language selection, (2) Features overview, (3) Committee info. Use the cultural design tokens. Store `onboarding_complete` in Hive
    - Final regression across all 4 languages + both themes + all screen sizes

---

## Affected Files

### Core architecture
- `lib/main.dart` — Hive init, l10n delegates, locale binding, global error handler, swap DI to Hive repos
- `lib/utils/theme.dart` — Full color palette overhaul (vermillion/gold/saffron), Bengali font, design tokens
- `lib/widgets/common_widgets.dart` — Reuse `GlassCard`, `GradientButton`, `ShimmerEffect`, `StatCard`, `AnimatedListItem`; add *alpona* border painter
- `lib/widgets/backgrounds/themed_background.dart` — Ensure all new pages use this
- `lib/widgets/backgrounds/dark_firefly_background.dart` — Gold particle recolor
- `lib/widgets/backgrounds/dawn_rays_background.dart` — Warm dawn palette update

### Pages (UI/UX redesign)
- `lib/splash_screen.dart` — Durga Maa artwork, vermillion/gold particles, animation consolidation
- `lib/home_page.dart` — Cultural header, countdown, greeting banner, drawer redesign, fix hardcoded color
- `lib/donation_page_new.dart` — Purpose category, QR receipt, PDF, share, success animation
- `lib/events_page_new.dart` — Color-coded calendar, category stripes, fix `dynamic` typing
- `lib/gallery_page_new.dart` — Year tabs, staggered grid, sharing, fix `dynamic` typing + `dart:io` guard
- `lib/main_scaffold.dart` — Minimal, no changes needed

### Admin
- `lib/admin/admin_login.dart` — Hashed credentials, multi-user
- `lib/admin/admin_dashboard.dart` — Wire "View All", charts, `ThemedBackground`
- `lib/admin/admin_donations.dart` — Edit, status, export, charts
- `lib/admin/admin_events.dart` — Minor polish
- `lib/admin/admin_gallery.dart` — Minor polish

### Data layer (Hive migration)
- `lib/models/donation.dart` — Add `@HiveType`, `purpose`, `status` fields
- `lib/models/event.dart` — Add `@HiveType`
- `lib/models/gallery_item.dart` — Add `@HiveType`
- `lib/models/admin_user.dart` — Add `@HiveType`, `role`, `createdAt`, `lastLoginAt`
- `lib/repositories/donation_repository.dart` — Add `HiveDonationRepository`
- `lib/repositories/event_repository.dart` — Add `HiveEventRepository`
- `lib/repositories/gallery_repository.dart` — Add `HiveGalleryRepository`
- `lib/repositories/admin_auth_repository.dart` — Add `HiveAdminAuthRepository`
- `lib/repositories/storage_repository.dart` — Make abstract, add `HiveStorageRepository`
- `lib/services/data_service.dart` — Add error handling; CRUD efficiency improves automatically with Hive (no more full-list serialization)
- `lib/services/app_settings_service.dart` — Add locale persistence

### Localization
- `lib/src/localization/app_en.arb` — Expand to ~200 keys
- `lib/src/localization/app_bn.arb` — New (Bengali)
- `lib/src/localization/app_hi.arb` — New (Hindi)
- `lib/src/localization/app_mr.arb` — New (Marathi)
- `l10n.yaml` — Add `bn`, `hi`, `mr` support

### New packages to add to `pubspec.yaml`
- `hive: ^2.2.3`, `hive_flutter: ^1.1.0` (persistence)
- `hive_generator: ^2.0.1`, `build_runner` (dev, code gen)
- `share_plus` (social sharing)
- `fl_chart` (admin charts)
- `csv` (donation export)
- `flutter_image_compress` (gallery optimization)
- `flutter_staggered_grid_view` (gallery layout)
- `google_fonts` (Hind Siliguri for Bengali/Hindi/Marathi)

---

## Verification

1. **Localization:** Switch to each of the 4 locales (EN / BN / HI / MR) — verify every screen renders correctly with no missing keys or fallbacks. Run `flutter gen-l10n` with zero errors
2. **Bengali/Marathi text rendering:** Verify Hind Siliguri font renders correctly for বাংলা and मराठी scripts at all text sizes (title, body, caption)
3. **Theme — dark:** Toggle to Mahakali Night → verify gold firefly particles, aubergine backgrounds, vermillion accents, no blue remnants from old palette
4. **Theme — light:** Toggle to Subho Dawn → verify warm ivory backgrounds, crimson/gold accents, sun rays with turmeric gold core
5. **Hive migration:** Pre-populate SharedPreferences with test data → run migration → verify all data accessible in Hive boxes → verify old SharedPreferences keys deleted
6. **Hive CRUD:** Add 50 donations → force-close → reopen → verify all 50 present. Delete #25 → verify only #25 gone (not full re-serialization)
7. **Admin auth:** Create 3 admin users with different roles → verify role-based access restrictions
8. **Donation flow:** End-to-end: fill form → select purpose → choose amount → mock payment → verify QR receipt → export CSV from admin → verify entry
9. **Notifications:** Schedule event reminder → verify fires at correct time. Toggle off → verify suppressed
10. **Run tests:** `flutter test` — existing 3 tests + new coverage targets >60% on services/repos
11. **Performance:** Scroll 100+ gallery items in staggered grid — verify smooth 60fps with lazy Hive box loading
12. **Accessibility:** `flutter analyze` zero warnings. TalkBack can navigate all screens. Contrast ratios meet WCAG AA

---

## Decisions

- **Hive over SQLite:** Hive is faster for Flutter (no native bridge), simpler API, supports type adapters with code generation, and handles the app's key-value + list-based data patterns naturally. `sqflite` is better for relational queries, which this app doesn't need
- **4 languages:** English (default), Bengali (primary community), Hindi (broad reach), Marathi (Navratri overlap communities, Maharashtrian Bengali diaspora)
- **No cloud backend this cycle:** All data stays local (SharedPreferences → Hive). Cloud sync deferred to future roadmap
- **PhonePe stays primary payment:** Move from SANDBOX to PRODUCTION when merchant credentials are available
- **Old page versions deleted:** `donation_page.dart`, `events.dart`, `gallery_page.dart` are dead code
- **`src/` boilerplate removed:** Template code from Flutter scaffold provides no value
- **Hive model annotations require `build_runner`:** Run `flutter pub run build_runner build` after annotating models — generates `.g.dart` adapter files
- **If behind schedule:** Phase 1 (l10n) + Phase 2 (UI/UX) + Phase 3 (admin) are non-negotiable. Phase 4 Sprint 8 (community features) and Phase 5 (Hive migration) can be deferred — the app works fine on SharedPreferences in the interim
