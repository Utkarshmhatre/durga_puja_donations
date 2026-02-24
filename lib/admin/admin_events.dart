import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../models/event.dart';
import '../services/data_service.dart';
import '../src/localization/app_localizations.dart';
import '../utils/theme.dart';

class AdminEventsPage extends StatefulWidget {
  const AdminEventsPage({super.key});

  @override
  State<AdminEventsPage> createState() => _AdminEventsPageState();
}

class _AdminEventsPageState extends State<AdminEventsPage> {
  String _selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        var events = dataService.events;

        if (_selectedCategory != 'all') {
          events =
              events.where((e) => e.category == _selectedCategory).toList();
        }

        events.sort((a, b) => a.date.compareTo(b.date));

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: FadeInDown(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.adminEventsTitle,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.dynamicTextPrimary(context),
                                ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showAddEventDialog(context),
                            icon: const Icon(Icons.add),
                            label: Text(AppLocalizations.of(context)!
                                .adminEventsAddEvent),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.sacredGold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildCategoryChip('all',
                                AppLocalizations.of(context)!.categoryAll),
                            _buildCategoryChip(
                                'religious',
                                AppLocalizations.of(context)!
                                    .categoryReligious),
                            _buildCategoryChip('cultural',
                                AppLocalizations.of(context)!.categoryCultural),
                            _buildCategoryChip('service',
                                AppLocalizations.of(context)!.categoryService),
                            _buildCategoryChip(
                                'celebration',
                                AppLocalizations.of(context)!
                                    .categoryCelebration),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Events List
              Expanded(
                child: events.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: 80,
                              color: AppTheme.dynamicTextHint(context),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!
                                  .adminEventsNoEventsFound,
                              style: TextStyle(
                                color: AppTheme.dynamicTextMuted(context),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return FadeInUp(
                            delay: Duration(milliseconds: index * 50),
                            child: _buildEventCard(context, event),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(String value, String label) {
    final isSelected = _selectedCategory == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = value;
          });
        },
        backgroundColor: AppTheme.dynamicOverlay(context, alpha: 0.1),
        selectedColor: AppTheme.sacredGold.withValues(alpha: 0.3),
        labelStyle: TextStyle(
          color: isSelected
              ? AppTheme.sacredGold
              : AppTheme.dynamicTextMuted(context),
        ),
        side: BorderSide(
          color: isSelected
              ? AppTheme.sacredGold
              : AppTheme.dynamicDivider(context),
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    final isPast = event.date.isBefore(DateTime.now());
    final categoryColor = _getCategoryColor(event.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            categoryColor.withValues(alpha: 0.2),
            AppTheme.dynamicOverlay(context, alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: categoryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Badge
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        event.date.day.toString(),
                        style: TextStyle(
                          color: categoryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        _getMonth(event.date.month),
                        style: TextStyle(
                          color: categoryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        event.date.year.toString(),
                        style: TextStyle(
                          color: categoryColor.withValues(alpha: 0.7),
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
                                color: AppTheme.dynamicTextPrimary(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          if (isPast)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.dynamicOverlay(context,
                                    alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.pastBadge,
                                style: TextStyle(
                                  color: AppTheme.dynamicTextMuted(context),
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
                        style: TextStyle(
                          color: AppTheme.dynamicTextSecondary(context),
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (event.location != null) ...[
                            Icon(Icons.location_on,
                                size: 14, color: categoryColor),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                event.location!,
                                style: TextStyle(
                                  color: AppTheme.dynamicTextMuted(context),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.dynamicOverlay(context, alpha: 0.05),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showEditEventDialog(context, event),
                  icon: const Icon(Icons.edit, size: 18),
                  label: Text(AppLocalizations.of(context)!.edit),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _showDeleteDialog(context, event),
                  icon: const Icon(Icons.delete,
                      size: 18, color: AppTheme.accentRed),
                  label: Text(AppLocalizations.of(context)!.delete,
                      style: const TextStyle(color: AppTheme.accentRed)),
                ),
              ],
            ),
          ),
        ],
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

  void _showAddEventDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final locationController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String selectedCategory = 'general';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppTheme.dynamicCardBg(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title:
              Text(AppLocalizations.of(context)!.adminEventsAddNewEventTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.adminEventsFieldTitle),
                  style: TextStyle(color: AppTheme.dynamicTextPrimary(context)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!
                          .adminEventsFieldDescription),
                  maxLines: 3,
                  style: TextStyle(color: AppTheme.dynamicTextPrimary(context)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!
                          .adminEventsFieldLocation),
                  style: TextStyle(color: AppTheme.dynamicTextPrimary(context)),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title:
                      Text(AppLocalizations.of(context)!.adminEventsFieldDate),
                  subtitle: Text(_formatDate(selectedDate)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!
                          .adminEventsFieldCategory),
                  items: [
                    'general',
                    'religious',
                    'cultural',
                    'service',
                    'celebration'
                  ]
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descController.text.isNotEmpty) {
                  final event = Event(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    description: descController.text,
                    date: selectedDate,
                    location: locationController.text.isNotEmpty
                        ? locationController.text
                        : null,
                    category: selectedCategory,
                  );
                  context.read<DataService>().addEvent(event);
                  Navigator.pop(context);
                }
              },
              child: Text(AppLocalizations.of(context)!.add),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditEventDialog(BuildContext context, Event event) {
    final titleController = TextEditingController(text: event.title);
    final descController = TextEditingController(text: event.description);
    final locationController =
        TextEditingController(text: event.location ?? '');
    DateTime selectedDate = event.date;
    String selectedCategory = event.category;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppTheme.dynamicCardBg(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(AppLocalizations.of(context)!.adminEventsEditEventTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.adminEventsFieldTitle),
                  style: TextStyle(color: AppTheme.dynamicTextPrimary(context)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!
                          .adminEventsFieldDescription),
                  maxLines: 3,
                  style: TextStyle(color: AppTheme.dynamicTextPrimary(context)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!
                          .adminEventsFieldLocation),
                  style: TextStyle(color: AppTheme.dynamicTextPrimary(context)),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title:
                      Text(AppLocalizations.of(context)!.adminEventsFieldDate),
                  subtitle: Text(_formatDate(selectedDate)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!
                          .adminEventsFieldCategory),
                  items: [
                    'general',
                    'religious',
                    'cultural',
                    'service',
                    'celebration'
                  ]
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedEvent = event.copyWith(
                  title: titleController.text,
                  description: descController.text,
                  date: selectedDate,
                  location: locationController.text.isNotEmpty
                      ? locationController.text
                      : null,
                  category: selectedCategory,
                );
                context.read<DataService>().updateEvent(updatedEvent);
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDeleteDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.dynamicCardBg(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(AppLocalizations.of(context)!.adminEventsDeleteDialogTitle),
        content: Text(AppLocalizations.of(context)!
            .adminEventsDeleteConfirmMessage(event.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<DataService>().deleteEvent(event.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
            ),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }
}
