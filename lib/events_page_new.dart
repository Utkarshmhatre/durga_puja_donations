import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/event.dart';
import 'services/data_service.dart';
import 'services/app_settings_service.dart';
import 'services/notification_service.dart';
import 'services/share_service.dart';
import 'src/localization/app_localizations.dart';
import 'utils/theme.dart';
import 'widgets/backgrounds/themed_background.dart';

class EventsPageNew extends StatefulWidget {
  const EventsPageNew({super.key});

  @override
  State<EventsPageNew> createState() => _EventsPageNewState();
}

class _EventsPageNewState extends State<EventsPageNew> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF2E1A0D);
    final subtitleColor = isDark ? Colors.white54 : const Color(0xFF5C3D2A);
    final glassColor = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.white.withValues(alpha: 0.82);
    final calendarPanel = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : const Color(0xFFFFF3E6).withValues(alpha: 0.86);
    final panelBorder = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : AppTheme.sacredGold.withValues(alpha: 0.35);

    return Scaffold(
      body: ThemedBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: FadeInDown(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        tooltip: 'Go back',
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: glassColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.arrow_back, color: titleColor),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.eventsPageTitle,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: titleColor,
                              ),
                            ),
                            Consumer<DataService>(
                              builder: (context, dataService, _) {
                                return Text(
                                  AppLocalizations.of(context)!
                                      .eventsUpcomingCount(
                                          dataService.activeEventsCount),
                                  style: TextStyle(
                                    color: subtitleColor,
                                    fontSize: 14,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryChip(
                            'all', AppLocalizations.of(context)!.categoryAll),
                        _buildCategoryChip('religious',
                            AppLocalizations.of(context)!.categoryReligious),
                        _buildCategoryChip('cultural',
                            AppLocalizations.of(context)!.categoryCultural),
                        _buildCategoryChip('service',
                            AppLocalizations.of(context)!.categoryService),
                        _buildCategoryChip('celebration',
                            AppLocalizations.of(context)!.categoryCelebration),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInDown(
                delay: const Duration(milliseconds: 200),
                child: Consumer<DataService>(
                  builder: (context, dataService, child) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: calendarPanel,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: panelBorder,
                        ),
                      ),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                        eventLoader: (day) {
                          return dataService.events
                              .where((e) =>
                                  e.date.year == day.year &&
                                  e.date.month == day.month &&
                                  e.date.day == day.day)
                              .toList();
                        },
                        calendarStyle: CalendarStyle(
                          defaultTextStyle: TextStyle(
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF3B2714),
                          ),
                          weekendTextStyle:
                              const TextStyle(color: AppTheme.accentPink),
                          todayDecoration: BoxDecoration(
                            color: (isDark
                                    ? AppTheme.sacredGold
                                    : AppTheme.turmericGold)
                                .withValues(alpha: 0.32),
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: const BoxDecoration(
                            gradient: AppTheme.orangeGradient,
                            shape: BoxShape.circle,
                          ),
                          markerDecoration: const BoxDecoration(
                            color: AppTheme.accentCyan,
                            shape: BoxShape.circle,
                          ),
                          outsideDaysVisible: false,
                        ),
                        headerStyle: HeaderStyle(
                          titleTextStyle: TextStyle(
                            color: titleColor,
                            fontWeight: FontWeight.bold,
                          ),
                          formatButtonTextStyle: TextStyle(
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF3B2714),
                          ),
                          formatButtonDecoration: BoxDecoration(
                            border: Border.fromBorderSide(
                              BorderSide(color: panelBorder),
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          leftChevronIcon: Icon(
                            Icons.chevron_left,
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF3B2714),
                          ),
                          rightChevronIcon: Icon(
                            Icons.chevron_right,
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF3B2714),
                          ),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            color: isDark
                                ? Colors.white54
                                : const Color(0xFF5C3D2A),
                          ),
                          weekendStyle:
                              const TextStyle(color: AppTheme.accentPink),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer<DataService>(
                  builder: (context, dataService, child) {
                    var events = dataService.events;
                    if (_selectedCategory != 'all') {
                      events = events
                          .where((e) => e.category == _selectedCategory)
                          .toList();
                    }
                    events.sort((a, b) => a.date.compareTo(b.date));

                    if (events.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: 60,
                              color: (isDark
                                      ? Colors.white
                                      : const Color(0xFF4A3520))
                                  .withValues(alpha: 0.35),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.noEventsFound,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white54
                                    : const Color(0xFF5C3D2A),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return FadeInUp(
                          delay: Duration(milliseconds: index * 50),
                          child: _buildEventCard(event, isDark),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String value, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _selectedCategory == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Semantics(
        button: true,
        selected: isSelected,
        label: '$label category filter${isSelected ? ', selected' : ''}',
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategory = value;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [AppTheme.vermillion, AppTheme.sacredGold],
                    )
                  : null,
              color: isSelected
                  ? null
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.78)),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppTheme.vermillion
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.2)
                        : AppTheme.sacredGold.withValues(alpha: 0.35)),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white60 : const Color(0xFF3B2714)),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(Event event, bool isDark) {
    final categoryColor = _getCategoryColor(event.category);
    final isPast = event.date.isBefore(DateTime.now());
    final titleColor = isDark ? Colors.white : const Color(0xFF2E1A0D);
    final secondaryColor = isDark ? Colors.white70 : const Color(0xFF4A3520);
    final mutedColor = isDark ? Colors.white54 : const Color(0xFF5C3D2A);
    final locationText = event.location?.isNotEmpty == true
        ? event.location!
        : AppLocalizations.of(context)!.locationTbd;

    return Semantics(
      label:
          '${event.title}, ${event.category} event on ${_getMonth(event.date.month)} ${event.date.day}',
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              categoryColor.withValues(alpha: 0.2),
              (isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : const Color(0xFFFFF8F0).withValues(alpha: 0.82)),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: categoryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(
                      event.date.day.toString(),
                      style: TextStyle(
                        color: categoryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      _getMonth(event.date.month),
                      style: TextStyle(
                        color: categoryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: TextStyle(
                              color: titleColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (isPast)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: (isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : const Color(0xFFFFF3E6)
                                      .withValues(alpha: 0.9)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.pastBadge,
                              style: TextStyle(
                                color: mutedColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: categoryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            locationText,
                            style: TextStyle(
                              color: mutedColor,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: categoryColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            event.category.toUpperCase(),
                            style: TextStyle(
                              color: categoryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Action buttons row
                    _buildEventActions(event, isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'religious':
        return AppTheme.primaryOrange;
      case 'cultural':
        return AppTheme.accentPink;
      case 'service':
        return AppTheme.accentGreen;
      case 'celebration':
        return AppTheme.primaryGold;
      default:
        return AppTheme.accentCyan;
    }
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  Widget _buildEventActions(Event event, bool isDark) {
    final settings = context.watch<AppSettingsService>();
    final isReminderSet = settings.isEventReminderSet(event.id);
    final isPast = event.date.isBefore(DateTime.now());
    final actionColor = isDark ? Colors.white54 : const Color(0xFF5C3D2A);

    return Row(
      children: [
        if (!isPast)
          _buildActionButton(
            icon: Icons.calendar_month_outlined,
            label: AppLocalizations.of(context)!.eventAddToCalendar,
            color: actionColor,
            onTap: () async {
              final url = Uri.parse(ShareService.getCalendarUrl(event));
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
          ),
        if (!isPast)
          _buildActionButton(
            icon: isReminderSet
                ? Icons.notifications_active
                : Icons.notifications_none_outlined,
            label: isReminderSet
                ? AppLocalizations.of(context)!.eventReminderOn
                : AppLocalizations.of(context)!.eventSetReminder,
            color: isReminderSet ? AppTheme.sacredGold : actionColor,
            onTap: () async {
              final notificationService = NotificationService();
              await notificationService.initialize();
              if (isReminderSet) {
                await notificationService.cancelEventReminder(event);
              } else {
                await notificationService.scheduleEventReminder(event);
              }
              await settings.toggleEventReminder(event.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isReminderSet
                        ? AppLocalizations.of(context)!.eventReminderRemoved
                        : AppLocalizations.of(context)!.eventReminderSet),
                  ),
                );
              }
            },
          ),
        _buildActionButton(
          icon: Icons.share_outlined,
          label: AppLocalizations.of(context)!.eventShare,
          color: actionColor,
          onTap: () => ShareService.shareEvent(context, event),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 3),
              Text(
                label,
                style: TextStyle(color: color, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
