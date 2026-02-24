import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import 'models/announcement.dart';
import 'services/data_service.dart';
import 'services/share_service.dart';
import 'src/localization/app_localizations.dart';
import 'utils/theme.dart';
import 'widgets/backgrounds/themed_background.dart';
import 'widgets/common_widgets.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedAvailability = 'fullDay';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF2E1A0D);

    return Scaffold(
      body: ThemedBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.white : Colors.black)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.arrow_back, color: titleColor),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  AppLocalizations.of(context)!.communityTitle,
                  style: TextStyle(color: titleColor),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(Icons.share_outlined, color: titleColor),
                    onPressed: () => ShareService.sharePujaGreeting(context),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Announcements Section
                    FadeInDown(
                      child: _buildSectionHeader(
                        AppLocalizations.of(context)!.communityAnnouncements,
                        Icons.campaign_outlined,
                        titleColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Consumer<DataService>(
                      builder: (context, dataService, _) {
                        final announcements = dataService.announcements
                            .where((a) => a.isActive)
                            .toList()
                          ..sort((a, b) {
                            if (a.isPinned != b.isPinned) {
                              return a.isPinned ? -1 : 1;
                            }
                            return b.createdAt.compareTo(a.createdAt);
                          });
                        if (announcements.isEmpty) {
                          return FadeInUp(
                            child: _buildEmptyCard(
                              AppLocalizations.of(context)!
                                  .communityNoAnnouncements,
                              Icons.campaign_outlined,
                              isDark,
                            ),
                          );
                        }
                        return Column(
                          children: announcements
                              .asMap()
                              .entries
                              .map((entry) => FadeInUp(
                                    delay:
                                        Duration(milliseconds: entry.key * 80),
                                    child: _buildAnnouncementCard(
                                        entry.value, isDark),
                                  ))
                              .toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    // Bhog/Prasad Schedule
                    FadeInDown(
                      delay: const Duration(milliseconds: 200),
                      child: _buildSectionHeader(
                        AppLocalizations.of(context)!.communityBhogSchedule,
                        Icons.restaurant_outlined,
                        titleColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeInUp(
                      delay: const Duration(milliseconds: 250),
                      child: _buildBhogSchedule(isDark),
                    ),

                    const SizedBox(height: 28),

                    // Volunteer Registration
                    FadeInDown(
                      delay: const Duration(milliseconds: 300),
                      child: _buildSectionHeader(
                        AppLocalizations.of(context)!.communityVolunteer,
                        Icons.people_outline,
                        titleColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeInUp(
                      delay: const Duration(milliseconds: 350),
                      child: _buildVolunteerForm(isDark),
                    ),

                    const SizedBox(height: 28),

                    // Emergency Contacts
                    FadeInDown(
                      delay: const Duration(milliseconds: 400),
                      child: _buildSectionHeader(
                        AppLocalizations.of(context)!.communityEmergency,
                        Icons.emergency_outlined,
                        titleColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeInUp(
                      delay: const Duration(milliseconds: 450),
                      child: _buildEmergencyContacts(isDark),
                    ),

                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCard(String message, IconData icon, bool isDark) {
    return GlassCard(
      child: Center(
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: (isDark ? Colors.white : const Color(0xFF4A3520))
                  .withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                color: isDark ? Colors.white54 : const Color(0xFF5C3D2A),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard(Announcement announcement, bool isDark) {
    final categoryColor = _getAnnouncementColor(announcement.category);
    final titleColor = isDark ? Colors.white : const Color(0xFF2E1A0D);
    final bodyColor = isDark ? Colors.white70 : const Color(0xFF4A3520);
    final metaColor = isDark ? Colors.white38 : const Color(0xFF5C3D2A);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  categoryColor.withValues(alpha: 0.15),
                  (isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : const Color(0xFFFFF8F0).withValues(alpha: 0.85)),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: categoryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (announcement.isPinned)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Icon(Icons.push_pin,
                            size: 14, color: categoryColor),
                      ),
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
                    const Spacer(),
                    Text(
                      _formatDate(announcement.createdAt),
                      style: TextStyle(color: metaColor, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  announcement.title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  announcement.body,
                  style: TextStyle(
                    color: bodyColor,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBhogSchedule(bool isDark) {
    final titleColor = isDark ? Colors.white : const Color(0xFF2E1A0D);
    final bodyColor = isDark ? Colors.white70 : const Color(0xFF4A3520);

    final schedule = [
      {
        'day': AppLocalizations.of(context)!.communityBhogSaptami,
        'time': '12:00 PM',
        'items': AppLocalizations.of(context)!.communityBhogSaptamiItems,
      },
      {
        'day': AppLocalizations.of(context)!.communityBhogAshtami,
        'time': '1:00 PM',
        'items': AppLocalizations.of(context)!.communityBhogAshtamiItems,
      },
      {
        'day': AppLocalizations.of(context)!.communityBhogNavami,
        'time': '12:30 PM',
        'items': AppLocalizations.of(context)!.communityBhogNavamiItems,
      },
      {
        'day': AppLocalizations.of(context)!.communityBhogDashami,
        'time': '11:00 AM',
        'items': AppLocalizations.of(context)!.communityBhogDashamiItems,
      },
    ];

    return GlassCard(
      child: Column(
        children: schedule.asMap().entries.map((entry) {
          final item = entry.value;
          final isLast = entry.key == schedule.length - 1;
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.deepSaffron.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.restaurant,
                        color: AppTheme.deepSaffron, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                item['day']!,
                                style: TextStyle(
                                  color: titleColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Text(
                              item['time']!,
                              style: const TextStyle(
                                color: AppTheme.deepSaffron,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['items']!,
                          style: TextStyle(
                            color: bodyColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Divider(
                    color: (isDark ? Colors.white : AppTheme.sacredGold)
                        .withValues(alpha: 0.15),
                    height: 1,
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVolunteerForm(bool isDark) {
    final titleColor = isDark ? Colors.white : const Color(0xFF2E1A0D);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.communityVolunteerSubtitle,
            style: TextStyle(
              color: isDark ? Colors.white60 : const Color(0xFF5C3D2A),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            style: TextStyle(color: titleColor),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.communityVolunteerName,
              prefixIcon: const Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: titleColor),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.communityVolunteerPhone,
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedAvailability,
            dropdownColor: isDark ? AppTheme.cardBackground : Colors.white,
            style: TextStyle(color: titleColor, fontSize: 14),
            decoration: InputDecoration(
              labelText:
                  AppLocalizations.of(context)!.communityVolunteerAvailability,
              prefixIcon: const Icon(Icons.schedule_outlined),
            ),
            items: [
              DropdownMenuItem(
                  value: 'morning',
                  child: Text(
                      AppLocalizations.of(context)!.communityAvailMorning)),
              DropdownMenuItem(
                  value: 'afternoon',
                  child: Text(
                      AppLocalizations.of(context)!.communityAvailAfternoon)),
              DropdownMenuItem(
                  value: 'evening',
                  child: Text(
                      AppLocalizations.of(context)!.communityAvailEvening)),
              DropdownMenuItem(
                  value: 'fullDay',
                  child: Text(
                      AppLocalizations.of(context)!.communityAvailFullDay)),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedAvailability = value);
              }
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              text: AppLocalizations.of(context)!.communityVolunteerRegister,
              icon: Icons.how_to_reg_outlined,
              onPressed: () => _submitVolunteerForm(),
            ),
          ),
        ],
      ),
    );
  }

  void _submitVolunteerForm() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(AppLocalizations.of(context)!.communityVolunteerValidation),
        ),
      );
      return;
    }
    final volunteer = VolunteerRegistration(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      phone: phone,
      availability: _selectedAvailability,
      registeredAt: DateTime.now(),
    );
    context.read<DataService>().addVolunteer(volunteer);
    _nameController.clear();
    _phoneController.clear();
    setState(() => _selectedAvailability = 'fullDay');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.communityVolunteerSuccess),
        backgroundColor: AppTheme.accentGreen,
      ),
    );
  }

  Widget _buildEmergencyContacts(bool isDark) {
    final titleColor = isDark ? Colors.white : const Color(0xFF2E1A0D);
    final bodyColor = isDark ? Colors.white70 : const Color(0xFF4A3520);

    final contacts = [
      {
        'name': AppLocalizations.of(context)!.communityEmergencyCommittee,
        'phone': '+91 98765 43210',
        'icon': Icons.groups_outlined,
      },
      {
        'name': AppLocalizations.of(context)!.communityEmergencyMedical,
        'phone': '+91 98765 43211',
        'icon': Icons.local_hospital_outlined,
      },
      {
        'name': AppLocalizations.of(context)!.communityEmergencySecurity,
        'phone': '+91 98765 43212',
        'icon': Icons.security_outlined,
      },
    ];

    return GlassCard(
      child: Column(
        children: contacts.map((contact) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.accentRed.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(contact['icon'] as IconData,
                      color: AppTheme.accentRed, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact['name'] as String,
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        contact['phone'] as String,
                        style: TextStyle(
                          color: bodyColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Phone call would be handled by url_launcher
                  },
                  icon: const Icon(
                    Icons.phone,
                    color: AppTheme.accentGreen,
                    size: 20,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getAnnouncementColor(String category) {
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) {
      if (diff.inHours == 0) return '${diff.inMinutes}m ago';
      return '${diff.inHours}h ago';
    }
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}
