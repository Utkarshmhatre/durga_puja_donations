import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsService extends ChangeNotifier {
  static const String _biometricKey = 'settings_biometric_enabled';
  static const String _pinEnabledKey = 'settings_pin_enabled';
  static const String _pinHashKey = 'settings_pin_hash';
  static const String _localeKey = 'settings_locale';
  static const String _notificationsKey = 'settings_notifications_enabled';
  static const String _eventRemindersKey = 'settings_event_reminders_enabled';
  static const String _pujaCountdownKey = 'settings_puja_countdown_enabled';
  static const String _eventRemindersListKey = 'settings_event_reminders_list';

  bool _biometricEnabled = false;
  bool _pinEnabled = false;
  String? _pinHash;
  Locale _locale = const Locale('en');
  bool _notificationsEnabled = true;
  bool _eventRemindersEnabled = true;
  bool _pujaCountdownEnabled = true;
  Set<String> _eventReminderIds = {};

  bool get biometricEnabled => _biometricEnabled;
  bool get pinEnabled => _pinEnabled;
  bool get hasPin => (_pinHash ?? '').isNotEmpty;
  Locale get locale => _locale;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get eventRemindersEnabled => _eventRemindersEnabled;
  bool get pujaCountdownEnabled => _pujaCountdownEnabled;
  Set<String> get eventReminderIds => _eventReminderIds;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _biometricEnabled = prefs.getBool(_biometricKey) ?? false;
    _pinEnabled = prefs.getBool(_pinEnabledKey) ?? false;
    _pinHash = prefs.getString(_pinHashKey);
    _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
    _eventRemindersEnabled = prefs.getBool(_eventRemindersKey) ?? true;
    _pujaCountdownEnabled = prefs.getBool(_pujaCountdownKey) ?? true;
    final remindersList = prefs.getStringList(_eventRemindersListKey);
    if (remindersList != null) {
      _eventReminderIds = remindersList.toSet();
    }
    final localeCode = prefs.getString(_localeKey);
    if (localeCode != null) {
      _locale = Locale(localeCode);
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  Future<void> setBiometricEnabled(bool value) async {
    _biometricEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricKey, value);
  }

  Future<void> setPinEnabled(bool value) async {
    _pinEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pinEnabledKey, value);
  }

  Future<void> setPin(String pin) async {
    final hashedPin = _hash(pin);
    _pinHash = hashedPin;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinHashKey, hashedPin);
  }

  Future<void> clearPin() async {
    _pinHash = null;
    _pinEnabled = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pinHashKey);
    await prefs.setBool(_pinEnabledKey, false);
  }

  bool verifyPin(String pin) {
    if (!hasPin) return false;
    return _hash(pin) == _pinHash;
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, value);
  }

  Future<void> setEventRemindersEnabled(bool value) async {
    _eventRemindersEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_eventRemindersKey, value);
  }

  Future<void> setPujaCountdownEnabled(bool value) async {
    _pujaCountdownEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pujaCountdownKey, value);
  }

  bool isEventReminderSet(String eventId) => _eventReminderIds.contains(eventId);

  Future<void> toggleEventReminder(String eventId) async {
    if (_eventReminderIds.contains(eventId)) {
      _eventReminderIds.remove(eventId);
    } else {
      _eventReminderIds.add(eventId);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_eventRemindersListKey, _eventReminderIds.toList());
  }

  String _hash(String value) {
    return sha256.convert(utf8.encode(value)).toString();
  }
}
