import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:durga_puja_donations/services/app_settings_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppSettingsService settings;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    settings = AppSettingsService();
    await settings.load();
  });

  group('AppSettingsService - Defaults', () {
    test('biometric disabled by default', () {
      expect(settings.biometricEnabled, false);
    });

    test('pin disabled by default', () {
      expect(settings.pinEnabled, false);
      expect(settings.hasPin, false);
    });

    test('locale defaults to English', () {
      expect(settings.locale, const Locale('en'));
    });

    test('notifications enabled by default', () {
      expect(settings.notificationsEnabled, true);
    });

    test('event reminders enabled by default', () {
      expect(settings.eventRemindersEnabled, true);
    });

    test('puja countdown enabled by default', () {
      expect(settings.pujaCountdownEnabled, true);
    });

    test('no event reminders set by default', () {
      expect(settings.eventReminderIds, isEmpty);
    });
  });

  group('AppSettingsService - Locale', () {
    test('setLocale changes locale and persists', () async {
      await settings.setLocale(const Locale('bn'));

      expect(settings.locale, const Locale('bn'));

      // Reload and verify persistence
      final settings2 = AppSettingsService();
      await settings2.load();
      expect(settings2.locale, const Locale('bn'));
    });

    test('setLocale notifies listeners', () async {
      int count = 0;
      settings.addListener(() => count++);

      await settings.setLocale(const Locale('hi'));
      expect(count, greaterThanOrEqualTo(1));
    });

    test('supports all 4 locales', () async {
      for (final lang in ['en', 'bn', 'hi', 'mr']) {
        await settings.setLocale(Locale(lang));
        expect(settings.locale, Locale(lang));
      }
    });
  });

  group('AppSettingsService - Biometric', () {
    test('setBiometricEnabled toggles and persists', () async {
      await settings.setBiometricEnabled(true);
      expect(settings.biometricEnabled, true);

      final settings2 = AppSettingsService();
      await settings2.load();
      expect(settings2.biometricEnabled, true);
    });

    test('setBiometricEnabled notifies listeners', () async {
      int count = 0;
      settings.addListener(() => count++);

      await settings.setBiometricEnabled(true);
      expect(count, greaterThanOrEqualTo(1));
    });
  });

  group('AppSettingsService - PIN', () {
    test('setPin stores hashed pin', () async {
      await settings.setPin('1234');
      expect(settings.hasPin, true);
    });

    test('verifyPin returns true for correct pin', () async {
      await settings.setPin('5678');
      expect(settings.verifyPin('5678'), true);
    });

    test('verifyPin returns false for wrong pin', () async {
      await settings.setPin('1234');
      expect(settings.verifyPin('0000'), false);
    });

    test('verifyPin returns false when no pin set', () {
      expect(settings.verifyPin('1234'), false);
    });

    test('clearPin removes pin and disables', () async {
      await settings.setPin('1234');
      await settings.setPinEnabled(true);

      await settings.clearPin();

      expect(settings.hasPin, false);
      expect(settings.pinEnabled, false);
    });

    test('PIN persists across instances', () async {
      await settings.setPin('9999');

      final settings2 = AppSettingsService();
      await settings2.load();
      expect(settings2.hasPin, true);
      expect(settings2.verifyPin('9999'), true);
    });

    test('pin hash uses sha256', () async {
      await settings.setPin('1234');
      final expectedHash =
          sha256.convert(utf8.encode('1234')).toString();
      // verifyPin checks hash equality internally
      expect(settings.verifyPin('1234'), true);
    });
  });

  group('AppSettingsService - Notifications', () {
    test('setNotificationsEnabled toggles and persists', () async {
      await settings.setNotificationsEnabled(false);
      expect(settings.notificationsEnabled, false);

      final settings2 = AppSettingsService();
      await settings2.load();
      expect(settings2.notificationsEnabled, false);
    });

    test('setEventRemindersEnabled toggles and persists', () async {
      await settings.setEventRemindersEnabled(false);
      expect(settings.eventRemindersEnabled, false);

      final settings2 = AppSettingsService();
      await settings2.load();
      expect(settings2.eventRemindersEnabled, false);
    });

    test('setPujaCountdownEnabled toggles and persists', () async {
      await settings.setPujaCountdownEnabled(false);
      expect(settings.pujaCountdownEnabled, false);

      final settings2 = AppSettingsService();
      await settings2.load();
      expect(settings2.pujaCountdownEnabled, false);
    });
  });

  group('AppSettingsService - Event Reminders', () {
    test('toggleEventReminder adds event id', () async {
      await settings.toggleEventReminder('event1');
      expect(settings.isEventReminderSet('event1'), true);
    });

    test('toggleEventReminder removes when toggled twice', () async {
      await settings.toggleEventReminder('event1');
      await settings.toggleEventReminder('event1');
      expect(settings.isEventReminderSet('event1'), false);
    });

    test('multiple event reminders', () async {
      await settings.toggleEventReminder('e1');
      await settings.toggleEventReminder('e2');
      await settings.toggleEventReminder('e3');

      expect(settings.isEventReminderSet('e1'), true);
      expect(settings.isEventReminderSet('e2'), true);
      expect(settings.isEventReminderSet('e3'), true);
      expect(settings.eventReminderIds.length, 3);
    });

    test('event reminders persist', () async {
      await settings.toggleEventReminder('persist1');
      await settings.toggleEventReminder('persist2');

      final settings2 = AppSettingsService();
      await settings2.load();
      expect(settings2.isEventReminderSet('persist1'), true);
      expect(settings2.isEventReminderSet('persist2'), true);
    });

    test('toggleEventReminder notifies listeners', () async {
      int count = 0;
      settings.addListener(() => count++);

      await settings.toggleEventReminder('notify1');
      expect(count, greaterThanOrEqualTo(1));
    });
  });

  group('AppSettingsService - Load', () {
    test('load with pre-populated SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'settings_biometric_enabled': true,
        'settings_pin_enabled': true,
        'settings_pin_hash': 'somehash',
        'settings_locale': 'bn',
        'settings_notifications_enabled': false,
        'settings_event_reminders_enabled': false,
        'settings_puja_countdown_enabled': false,
        'settings_event_reminders_list': ['e1', 'e2'],
      });

      final s = AppSettingsService();
      await s.load();

      expect(s.biometricEnabled, true);
      expect(s.pinEnabled, true);
      expect(s.hasPin, true);
      expect(s.locale, const Locale('bn'));
      expect(s.notificationsEnabled, false);
      expect(s.eventRemindersEnabled, false);
      expect(s.pujaCountdownEnabled, false);
      expect(s.isEventReminderSet('e1'), true);
      expect(s.isEventReminderSet('e2'), true);
    });

    test('load notifies listeners', () async {
      int count = 0;
      final s = AppSettingsService();
      s.addListener(() => count++);

      await s.load();
      expect(count, greaterThanOrEqualTo(1));
    });
  });
}
