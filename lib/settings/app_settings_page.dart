import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_settings_service.dart';
import '../services/theme_service.dart';
import '../src/localization/app_localizations.dart';
import '../utils/theme.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  static final _supportedLocales = <Locale, String>{
    const Locale('en'): 'English',
    const Locale('bn'): 'বাংলা',
    const Locale('hi'): 'हिन्दी',
    const Locale('mr'): 'मराठी',
  };

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsService>();
    final themeService = context.watch<ThemeService>();
    final isDark = themeService.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle(AppLocalizations.of(context)!.settingsLanguage),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text(AppLocalizations.of(context)!.settingsLanguage),
              subtitle: Text(
                _supportedLocales[settings.locale] ??
                    _supportedLocales.values.first,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showLanguagePicker(context, settings),
            ),
          ),
          const SizedBox(height: 16),
          _sectionTitle(AppLocalizations.of(context)!.settingsAppearance),
          Card(
            child: SwitchListTile(
              title: Text(AppLocalizations.of(context)!.settingsDarkTheme),
              subtitle: Text(isDark
                  ? AppLocalizations.of(context)!.enabled
                  : AppLocalizations.of(context)!.disabled),
              value: isDark,
              onChanged: (_) => themeService.toggleTheme(),
            ),
          ),
          Card(
            child: SwitchListTile(
              title: Text(AppLocalizations.of(context)!.settingsReducedMotion),
              subtitle: Text(
                  AppLocalizations.of(context)!.settingsReducedMotionSubtitle),
              value: themeService.reducedMotion,
              onChanged: (value) => themeService.setReducedMotion(value),
            ),
          ),
          const SizedBox(height: 16),
          _sectionTitle(AppLocalizations.of(context)!.settingsNotifications),
          Card(
            child: SwitchListTile(
              title: Text(
                  AppLocalizations.of(context)!.settingsNotificationsToggle),
              subtitle: Text(
                AppLocalizations.of(context)!.settingsNotificationsSubtitle,
              ),
              value: settings.notificationsEnabled,
              onChanged: (value) => settings.setNotificationsEnabled(value),
            ),
          ),
          Card(
            child: SwitchListTile(
              title: Text(AppLocalizations.of(context)!.settingsPujaCountdown),
              subtitle: Text(
                AppLocalizations.of(context)!.settingsPujaCountdownSubtitle,
              ),
              value: settings.pujaCountdownEnabled,
              onChanged: settings.notificationsEnabled
                  ? (value) => settings.setPujaCountdownEnabled(value)
                  : null,
            ),
          ),
          Card(
            child: SwitchListTile(
              title: Text(AppLocalizations.of(context)!.settingsEventReminders),
              subtitle: Text(
                AppLocalizations.of(context)!.settingsEventRemindersSubtitle,
              ),
              value: settings.eventRemindersEnabled,
              onChanged: settings.notificationsEnabled
                  ? (value) => settings.setEventRemindersEnabled(value)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          _sectionTitle(AppLocalizations.of(context)!.settingsSecurity),
          Card(
            child: SwitchListTile(
              title: Text(AppLocalizations.of(context)!.settingsBiometricLogin),
              subtitle:
                  Text(AppLocalizations.of(context)!.settingsBiometricSubtitle),
              value: settings.biometricEnabled,
              onChanged: (value) => settings.setBiometricEnabled(value),
            ),
          ),
          Card(
            child: SwitchListTile(
              title: Text(AppLocalizations.of(context)!.settingsPinLogin),
              subtitle: Text(
                settings.hasPin
                    ? AppLocalizations.of(context)!.settingsPinSubtitleActive
                    : AppLocalizations.of(context)!.settingsPinSubtitleSetFirst,
              ),
              value: settings.pinEnabled,
              onChanged: (value) async {
                if (value && !settings.hasPin) {
                  final pin = await _askForPin(context,
                      title: AppLocalizations.of(context)!.settingsSetPin);
                  if (pin == null) return;
                  await settings.setPin(pin);
                }
                await settings.setPinEnabled(value);
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.pin),
              title: Text(AppLocalizations.of(context)!.settingsChangePin),
              subtitle:
                  Text(AppLocalizations.of(context)!.settingsChangePinSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final pin = await _askForPin(context,
                    title: AppLocalizations.of(context)!.settingsEnterNewPin);
                if (pin == null) return;
                await settings.setPin(pin);
                if (!settings.pinEnabled) {
                  await settings.setPinEnabled(true);
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            AppLocalizations.of(context)!.settingsPinUpdated)),
                  );
                }
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.lock_reset, color: AppTheme.accentRed),
              title: Text(AppLocalizations.of(context)!.settingsDisablePin),
              subtitle: Text(
                  AppLocalizations.of(context)!.settingsDisablePinSubtitle),
              onTap: () async {
                await settings.clearPin();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            AppLocalizations.of(context)!.settingsPinRemoved)),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Future<String?> _askForPin(BuildContext context,
      {required String title}) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.settingsPinHint),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final pin = controller.text.trim();
                if (pin.length == 4 && RegExp(r'^\d{4}$').hasMatch(pin)) {
                  Navigator.pop(dialogContext, pin);
                }
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        );
      },
    );
    return result;
  }

  void _showLanguagePicker(BuildContext context, AppSettingsService settings) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  AppLocalizations.of(context)!.settingsLanguage,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              const Divider(height: 1),
              ..._supportedLocales.entries.map((entry) {
                final isSelected =
                    settings.locale.languageCode == entry.key.languageCode;
                return ListTile(
                  leading: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: isSelected ? AppTheme.primaryOrange : null,
                  ),
                  title: Text(
                    entry.value,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    settings.setLocale(entry.key);
                    Navigator.pop(sheetContext);
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
