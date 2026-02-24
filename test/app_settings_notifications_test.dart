import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:durga_puja_donations/services/app_settings_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppSettingsService - Notification Preferences', () {
    late AppSettingsService settings;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      settings = AppSettingsService();
      await settings.load();
    });

    test('defaults: notifications enabled', () {
      expect(settings.notificationsEnabled, true);
    });

    test('defaults: event reminders enabled', () {
      expect(settings.eventRemindersEnabled, true);
    });

    test('defaults: puja countdown enabled', () {
      expect(settings.pujaCountdownEnabled, true);
    });

    test('defaults: no event reminders set', () {
      expect(settings.eventReminderIds, isEmpty);
    });

    test('setNotificationsEnabled persists value', () async {
      await settings.setNotificationsEnabled(false);
      expect(settings.notificationsEnabled, false);

      // Reload from prefs
      final settings2 = AppSettingsService();
      await settings2.load();
      expect(settings2.notificationsEnabled, false);
    });

    test('setEventRemindersEnabled persists value', () async {
      await settings.setEventRemindersEnabled(false);
      expect(settings.eventRemindersEnabled, false);

      final settings2 = AppSettingsService();
      await settings2.load();
      expect(settings2.eventRemindersEnabled, false);
    });

    test('setPujaCountdownEnabled persists value', () async {
      await settings.setPujaCountdownEnabled(false);
      expect(settings.pujaCountdownEnabled, false);

      final settings2 = AppSettingsService();
      await settings2.load();
      expect(settings2.pujaCountdownEnabled, false);
    });

    test('isEventReminderSet returns false for unset event', () {
      expect(settings.isEventReminderSet('event123'), false);
    });

    test('toggleEventReminder adds event id', () async {
      await settings.toggleEventReminder('event1');
      expect(settings.isEventReminderSet('event1'), true);
    });

    test('toggleEventReminder removes already set event id', () async {
      await settings.toggleEventReminder('event1');
      expect(settings.isEventReminderSet('event1'), true);

      await settings.toggleEventReminder('event1');
      expect(settings.isEventReminderSet('event1'), false);
    });

    test('toggleEventReminder persists across loads', () async {
      await settings.toggleEventReminder('event1');
      await settings.toggleEventReminder('event2');

      final settings2 = AppSettingsService();
      await settings2.load();
      expect(settings2.isEventReminderSet('event1'), true);
      expect(settings2.isEventReminderSet('event2'), true);
    });

    test('load reads persisted notification preferences', () async {
      SharedPreferences.setMockInitialValues({
        'settings_notifications_enabled': false,
        'settings_event_reminders_enabled': false,
        'settings_puja_countdown_enabled': false,
        'settings_event_reminders_list': ['e1', 'e2'],
      });

      final service = AppSettingsService();
      await service.load();

      expect(service.notificationsEnabled, false);
      expect(service.eventRemindersEnabled, false);
      expect(service.pujaCountdownEnabled, false);
      expect(service.isEventReminderSet('e1'), true);
      expect(service.isEventReminderSet('e2'), true);
    });

    test('notifyListeners called on notification toggle', () async {
      int callCount = 0;
      settings.addListener(() => callCount++);

      await settings.setNotificationsEnabled(false);
      expect(callCount, 1);

      await settings.setEventRemindersEnabled(false);
      expect(callCount, 2);

      await settings.setPujaCountdownEnabled(false);
      expect(callCount, 3);

      await settings.toggleEventReminder('e1');
      expect(callCount, 4);
    });
  });
}
