import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'repositories/hive_adapters.dart';
import 'repositories/hive_admin_auth_repository.dart';
import 'repositories/hive_announcement_repository.dart';
import 'repositories/hive_donation_repository.dart';
import 'repositories/hive_event_repository.dart';
import 'repositories/hive_gallery_repository.dart';
import 'repositories/hive_storage_repository.dart';
import 'services/auth_service.dart';
import 'services/data_service.dart';
import 'services/app_settings_service.dart';
import 'services/hive_migration_service.dart';
import 'services/theme_service.dart';
import 'splash_screen.dart';
import 'src/localization/app_localizations.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  registerHiveAdapters();

  // Migrate existing SharedPreferences data to Hive (one-time)
  await HiveMigrationService.migrate();

  // Global error handler
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('[FlutterError] ${details.exceptionAsString()}');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('[PlatformError] $error\n$stack');
    return true;
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()..load()),
        ChangeNotifierProvider(create: (_) => AppSettingsService()..load()),
        ChangeNotifierProvider(
          create: (_) => AuthService(
            authRepository: HiveAdminAuthRepository(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DataService(
            donationRepository: HiveDonationRepository(),
            eventRepository: HiveEventRepository(),
            galleryRepository: HiveGalleryRepository(),
            storageRepository: HiveStorageRepository(),
            announcementRepository: HiveAnnouncementRepository(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();
    final settings = context.watch<AppSettingsService>();
    return MaterialApp(
      title: 'Durga Puja Donations',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeService.themeMode,
      locale: settings.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const BallBounceIndex(),
    );
  }
}
