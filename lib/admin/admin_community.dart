import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import '../models/announcement.dart';
import '../services/data_service.dart';
import '../services/notification_service.dart';
import '../src/localization/app_localizations.dart';
import '../utils/theme.dart';

class AdminCommunityPage extends StatefulWidget {
  const AdminCommunityPage({super.key});

  @override
  State<AdminCommunityPage> createState() => _AdminCommunityPageState();
}

class _AdminCommunityPageState extends State<AdminCommunityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: FadeInDown(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.adminCommunityTitle,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.dynamicTextPrimary(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)!.adminCommunitySubtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.dynamicTextMuted(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _showAddAnnouncementDialog,
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          const Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Tab Bar
          FadeInDown(
            delay: const Duration(milliseconds: 100),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppTheme.dynamicOverlay(context, alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: AppTheme.dynamicTextMuted(context),
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    text: AppLocalizations.of(context)!
                        .adminCommunityAnnouncements,
                  ),
                  Tab(
                    text:
                        AppLocalizations.of(context)!.adminCommunityVolunteers,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAnnouncementsTab(),
                _buildVolunteersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsTab() {
    return Consumer<DataService>(
      builder: (context, dataService, _) {
        final announcements = dataService.announcements.toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        if (announcements.isEmpty) {
          return Center(
            child: FadeInUp(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.campaign_outlined,
                      size: 60, color: AppTheme.dynamicTextHint(context)),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.adminCommunityNoAnnouncements,
                    style: TextStyle(
                        color: AppTheme.dynamicTextMuted(context),
                        fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: _showAddAnnouncementDialog,
                    icon: const Icon(Icons.add, color: AppTheme.sacredGold),
                    label: Text(
                      AppLocalizations.of(context)!.adminCommunityAddFirst,
                      style: const TextStyle(color: AppTheme.sacredGold),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const BouncingScrollPhysics(),
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            final announcement = announcements[index];
            return FadeInUp(
              delay: Duration(milliseconds: index * 60),
              child: _buildAnnouncementTile(announcement),
            );
          },
        );
      },
    );
  }

  Widget _buildAnnouncementTile(Announcement announcement) {
    final categoryColor = _getCategoryColor(announcement.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.dynamicOverlay(context, alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.dynamicDivider(context),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        announcement.category.toUpperCase(),
                        style: TextStyle(
                          color: categoryColor,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (announcement.isPinned)
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Icon(Icons.push_pin,
                            size: 14,
                            color: AppTheme.dynamicTextMuted(context)),
                      ),
                    if (!announcement.isActive)
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.accentRed.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!
                                .adminCommunityInactive,
                            style: const TextStyle(
                              color: AppTheme.accentRed,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),
                    const Spacer(),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert,
                          color: AppTheme.dynamicTextMuted(context), size: 18),
                      color: AppTheme.dynamicCardBg(context),
                      onSelected: (value) =>
                          _handleAnnouncementAction(value, announcement),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'toggle_pin',
                          child: Row(
                            children: [
                              Icon(
                                announcement.isPinned
                                    ? Icons.push_pin_outlined
                                    : Icons.push_pin,
                                size: 16,
                                color: AppTheme.dynamicTextSecondary(context),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                announcement.isPinned
                                    ? AppLocalizations.of(context)!
                                        .adminCommunityUnpin
                                    : AppLocalizations.of(context)!
                                        .adminCommunityPin,
                                style: TextStyle(
                                    color: AppTheme.dynamicTextPrimary(context),
                                    fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'toggle_active',
                          child: Row(
                            children: [
                              Icon(
                                announcement.isActive
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 16,
                                color: AppTheme.dynamicTextSecondary(context),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                announcement.isActive
                                    ? AppLocalizations.of(context)!
                                        .adminCommunityDeactivate
                                    : AppLocalizations.of(context)!
                                        .adminCommunityActivate,
                                style: TextStyle(
                                    color: AppTheme.dynamicTextPrimary(context),
                                    fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(Icons.delete_outline,
                                  size: 16, color: AppTheme.accentRed),
                              const SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(context)!
                                    .adminCommunityDelete,
                                style: const TextStyle(
                                    color: AppTheme.accentRed, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  announcement.title,
                  style: TextStyle(
                    color: AppTheme.dynamicTextPrimary(context),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  announcement.body,
                  style: TextStyle(
                    color: AppTheme.dynamicTextSecondary(context),
                    fontSize: 12,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDate(announcement.createdAt),
                  style: TextStyle(
                      color: AppTheme.dynamicTextHint(context), fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleAnnouncementAction(String action, Announcement announcement) {
    final dataService = context.read<DataService>();
    switch (action) {
      case 'toggle_pin':
        dataService.updateAnnouncement(
          announcement.copyWith(isPinned: !announcement.isPinned),
        );
        break;
      case 'toggle_active':
        dataService.updateAnnouncement(
          announcement.copyWith(isActive: !announcement.isActive),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(announcement);
        break;
    }
  }

  void _showDeleteConfirmation(Announcement announcement) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.dynamicCardBg(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          AppLocalizations.of(context)!.adminCommunityDeleteConfirm,
          style: TextStyle(color: AppTheme.dynamicTextPrimary(context)),
        ),
        content: Text(
          announcement.title,
          style: TextStyle(color: AppTheme.dynamicTextSecondary(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.cancel,
                style: TextStyle(color: AppTheme.dynamicTextMuted(context))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<DataService>().deleteAnnouncement(announcement.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(AppLocalizations.of(context)!.adminCommunityDelete,
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildVolunteersTab() {
    return Consumer<DataService>(
      builder: (context, dataService, _) {
        final volunteers = dataService.volunteers.toList()
          ..sort((a, b) => b.registeredAt.compareTo(a.registeredAt));

        if (volunteers.isEmpty) {
          return Center(
            child: FadeInUp(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_outline,
                      size: 60, color: AppTheme.dynamicTextHint(context)),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.adminCommunityNoVolunteers,
                    style: TextStyle(
                        color: AppTheme.dynamicTextMuted(context),
                        fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            // Summary bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FadeInDown(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.accentGreen.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.people,
                              color: AppTheme.accentGreen, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context)!
                                .adminCommunityVolunteerCount(
                                    volunteers.length),
                            style: const TextStyle(
                                color: AppTheme.accentGreen,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                itemCount: volunteers.length,
                itemBuilder: (context, index) {
                  final volunteer = volunteers[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: index * 60),
                    child: _buildVolunteerTile(volunteer),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVolunteerTile(VolunteerRegistration volunteer) {
    final availabilityColor = _getAvailabilityColor(volunteer.availability);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.dynamicOverlay(context, alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.dynamicDivider(context)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: availabilityColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.person, color: availabilityColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        volunteer.name,
                        style: TextStyle(
                          color: AppTheme.dynamicTextPrimary(context),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        volunteer.phone,
                        style: TextStyle(
                            color: AppTheme.dynamicTextMuted(context),
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: availabilityColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _formatAvailability(volunteer.availability),
                        style: TextStyle(
                          color: availabilityColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(volunteer.registeredAt),
                      style: TextStyle(
                          color: AppTheme.dynamicTextHint(context),
                          fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddAnnouncementDialog() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    String selectedCategory = 'general';
    bool isPinned = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.dynamicCardBg(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.campaign,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    AppLocalizations.of(context)!.adminCommunityNewAnnouncement,
                    style: TextStyle(
                        color: AppTheme.dynamicTextPrimary(context),
                        fontSize: 16),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      style: TextStyle(
                          color: AppTheme.dynamicTextPrimary(context)),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!
                            .adminCommunityTitleField,
                        labelStyle: TextStyle(
                            color: AppTheme.dynamicTextMuted(context)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: AppTheme.dynamicDivider(context)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppTheme.sacredGold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: bodyController,
                      style: TextStyle(
                          color: AppTheme.dynamicTextPrimary(context)),
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!
                            .adminCommunityBodyField,
                        labelStyle: TextStyle(
                            color: AppTheme.dynamicTextMuted(context)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: AppTheme.dynamicDivider(context)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppTheme.sacredGold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      dropdownColor: AppTheme.dynamicCardBg(context),
                      style: TextStyle(
                          color: AppTheme.dynamicTextPrimary(context),
                          fontSize: 14),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!
                            .adminCommunityCategoryField,
                        labelStyle: TextStyle(
                            color: AppTheme.dynamicTextMuted(context)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: AppTheme.dynamicDivider(context)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppTheme.sacredGold),
                        ),
                      ),
                      items: Announcement.categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(cat[0].toUpperCase() + cat.substring(1)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => selectedCategory = value);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      value: isPinned,
                      onChanged: (val) => setDialogState(() => isPinned = val),
                      title: Text(
                        AppLocalizations.of(context)!.adminCommunityPinned,
                        style: TextStyle(
                            color: AppTheme.dynamicTextSecondary(context),
                            fontSize: 13),
                      ),
                      activeThumbColor: AppTheme.sacredGold,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(AppLocalizations.of(context)!.cancel,
                      style:
                          TextStyle(color: AppTheme.dynamicTextMuted(context))),
                ),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final body = bodyController.text.trim();
                    if (title.isEmpty || body.isEmpty) return;

                    final announcement = Announcement(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: title,
                      body: body,
                      category: selectedCategory,
                      createdAt: DateTime.now(),
                      isPinned: isPinned,
                    );
                    context.read<DataService>().addAnnouncement(announcement);

                    // Trigger notification for new announcement
                    NotificationService().showAnnouncementNotification(
                      title: title,
                      body: body,
                    );

                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!
                            .adminCommunityAnnouncementAdded),
                        backgroundColor: AppTheme.accentGreen,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.sacredGold,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.adminCommunityPublish,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'bhog':
        return AppTheme.deepSaffron;
      case 'volunteer':
        return AppTheme.accentGreen;
      case 'emergency':
        return AppTheme.accentRed;
      default:
        return AppTheme.sacredGold;
    }
  }

  Color _getAvailabilityColor(String availability) {
    switch (availability) {
      case 'morning':
        return AppTheme.sacredGold;
      case 'afternoon':
        return AppTheme.deepSaffron;
      case 'evening':
        return AppTheme.accentCyan;
      case 'fullDay':
        return AppTheme.accentGreen;
      default:
        return AppTheme.dynamicTextMuted(context);
    }
  }

  String _formatAvailability(String availability) {
    final l10n = AppLocalizations.of(context)!;
    switch (availability) {
      case 'morning':
        return l10n.communityAvailMorning;
      case 'afternoon':
        return l10n.communityAvailAfternoon;
      case 'evening':
        return l10n.communityAvailEvening;
      case 'fullDay':
        return l10n.communityAvailFullDay;
      default:
        return availability;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
