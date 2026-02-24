import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../services/auth_service.dart';
import '../services/data_service.dart';
import '../src/localization/app_localizations.dart';
import '../utils/theme.dart';
import 'admin_donations.dart';
import 'admin_events.dart';
import 'admin_gallery.dart';
import 'admin_community.dart';
import 'admin_login.dart';
import 'admin_user_management.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _backgroundController;

  List<Widget> get _pages {
    final canManageUsers =
        context.read<AuthService>().currentUser?.role.canManageUsers ?? false;
    return [
      DashboardHome(onNavigateToTab: navigateToTab),
      const AdminDonationsPage(),
      const AdminEventsPage(),
      const AdminGalleryPage(),
      const AdminCommunityPage(),
      if (canManageUsers) const AdminUserManagementPage(),
    ];
  }

  void navigateToTab(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Stack(
          children: [
            // Animated Background
            AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                final bgColors = AppTheme.dynamicGradientBg(context);
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        bgColors[0],
                        Color.lerp(
                          bgColors[1],
                          bgColors[2],
                          _backgroundController.value,
                        )!,
                      ],
                    ),
                  ),
                );
              },
            ),

            // Content
            isMobile
                ? _pages[_selectedIndex]
                : Row(
                    children: [
                      // Side Navigation for Desktop
                      _buildSideNavigation(),

                      // Divider
                      Container(
                        width: 1,
                        color: AppTheme.dynamicDivider(context),
                      ),

                      // Main Content
                      Expanded(
                        child: _pages[_selectedIndex],
                      ),
                    ],
                  ),
          ],
        ),
        // Mobile Bottom Navigation
        bottomNavigationBar: isMobile ? _buildBottomNavigation() : null,
      ),
    );
  }

  Widget _buildSideNavigation() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.2)
            : Colors.white.withValues(alpha: 0.6),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Logo
          FadeInDown(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.sacredGold.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.temple_hindu,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.adminNavLabel,
            style: TextStyle(
              color: AppTheme.dynamicTextMuted(context),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 30),

          // Navigation Items
          _buildNavItem(0, Icons.dashboard_outlined, Icons.dashboard,
              AppLocalizations.of(context)!.adminNavDashboard),
          _buildNavItem(
              1,
              Icons.volunteer_activism_outlined,
              Icons.volunteer_activism,
              AppLocalizations.of(context)!.adminNavDonations),
          _buildNavItem(2, Icons.event_outlined, Icons.event,
              AppLocalizations.of(context)!.adminNavEvents),
          _buildNavItem(3, Icons.photo_library_outlined, Icons.photo_library,
              AppLocalizations.of(context)!.adminNavGallery),
          _buildNavItem(4, Icons.groups_outlined, Icons.groups,
              AppLocalizations.of(context)!.adminNavCommunity),
          if (context.read<AuthService>().currentUser?.role.canManageUsers ??
              false)
            _buildNavItem(5, Icons.people_outline, Icons.people,
                AppLocalizations.of(context)!.adminNavUsers),

          const Spacer(),

          // Logout Button
          FadeInUp(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: IconButton(
                onPressed: () => _showLogoutDialog(context),
                icon: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.accentRed.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: AppTheme.accentRed,
                    size: 20,
                  ),
                ),
                tooltip: AppLocalizations.of(context)!.adminLogoutTooltip,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _selectedIndex == index;
    return FadeInLeft(
      delay: Duration(milliseconds: 100 * index),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _selectedIndex = index);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.sacredGold.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: AppTheme.sacredGold.withValues(alpha: 0.3))
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected
                    ? AppTheme.sacredGold
                    : AppTheme.dynamicTextMuted(context),
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? AppTheme.sacredGold
                      : AppTheme.dynamicTextMuted(context),
                  fontSize: 9,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppTheme.cardBackground.withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.85),
            border: Border(
              top: BorderSide(
                color: AppTheme.dynamicDivider(context),
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildBottomNavItem(
                        0,
                        Icons.dashboard_outlined,
                        Icons.dashboard,
                        AppLocalizations.of(context)!.adminNavDashboard),
                    _buildBottomNavItem(
                        1,
                        Icons.volunteer_activism_outlined,
                        Icons.volunteer_activism,
                        AppLocalizations.of(context)!.adminNavDonations),
                    _buildBottomNavItem(2, Icons.event_outlined, Icons.event,
                        AppLocalizations.of(context)!.adminNavEvents),
                    _buildBottomNavItem(
                        3,
                        Icons.photo_library_outlined,
                        Icons.photo_library,
                        AppLocalizations.of(context)!.adminNavGallery),
                    _buildBottomNavItem(4, Icons.groups_outlined, Icons.groups,
                        AppLocalizations.of(context)!.adminNavCommunity),
                    if (context
                            .read<AuthService>()
                            .currentUser
                            ?.role
                            .canManageUsers ??
                        false)
                      _buildBottomNavItem(5, Icons.people_outline, Icons.people,
                          AppLocalizations.of(context)!.adminNavUsers),
                    _buildLogoutNavItem(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
      int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedIndex = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.sacredGold.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? AppTheme.sacredGold
                  : AppTheme.dynamicTextMuted(context),
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppTheme.sacredGold
                    : AppTheme.dynamicTextMuted(context),
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutNavItem() {
    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.logout_rounded,
              color: AppTheme.accentRed.withValues(alpha: 0.8),
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context)!.logout,
              style: TextStyle(
                color: AppTheme.accentRed.withValues(alpha: 0.8),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.dynamicCardBg(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentRed.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: AppTheme.accentRed,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              AppLocalizations.of(context)!.logoutDialogTitle,
              style: TextStyle(
                color: AppTheme.dynamicTextPrimary(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          AppLocalizations.of(context)!.logoutDialogMessage,
          style: TextStyle(color: AppTheme.dynamicTextSecondary(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(color: AppTheme.dynamicTextMuted(context)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<AuthService>().logout();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminLoginPage(),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.logout,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key, required this.onNavigateToTab});

  final void Function(int index) onNavigateToTab;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;
    final isMobile = size.width < 600;

    return Consumer<DataService>(
      builder: (context, dataService, child) {
        return SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(isSmall ? 16 : 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Header
                    FadeInDown(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.dashboardTitle,
                                  style: TextStyle(
                                    fontSize: isSmall ? 24 : 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.dynamicTextPrimary(context),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizations.of(context)!
                                      .dashboardWelcome,
                                  style: TextStyle(
                                    fontSize: isSmall ? 12 : 14,
                                    color: AppTheme.dynamicTextMuted(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(isSmall ? 10 : 12),
                            decoration: BoxDecoration(
                              color: AppTheme.sacredGold.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.admin_panel_settings,
                              color: AppTheme.sacredGold,
                              size: isSmall ? 22 : 26,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isSmall ? 20 : 28),

                    // Stats Grid
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: _buildStatsGrid(
                          context, dataService, isSmall, isMobile),
                    ),

                    SizedBox(height: isSmall ? 20 : 28),

                    // Donation Trend Chart
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: _buildDonationTrendChart(
                          context, dataService, isSmall),
                    ),

                    SizedBox(height: isSmall ? 16 : 24),

                    // Purpose Breakdown Pie Chart
                    FadeInUp(
                      delay: const Duration(milliseconds: 350),
                      child:
                          _buildPurposeBreakdown(context, dataService, isSmall),
                    ),

                    SizedBox(height: isSmall ? 16 : 24),

                    // Recent Donations
                    FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      child:
                          _buildRecentDonations(context, dataService, isSmall),
                    ),

                    SizedBox(height: isSmall ? 16 : 24),

                    // Upcoming Events
                    FadeInUp(
                      delay: const Duration(milliseconds: 600),
                      child:
                          _buildUpcomingEvents(context, dataService, isSmall),
                    ),

                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsGrid(BuildContext context, DataService dataService,
      bool isSmall, bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 700 ? 4 : 2;
        final cardWidth =
            (constraints.maxWidth - (isSmall ? 12 : 16)) / crossAxisCount;
        final cardHeight = isSmall ? 100.0 : 120.0;

        return Wrap(
          spacing: isSmall ? 12 : 16,
          runSpacing: isSmall ? 12 : 16,
          children: [
            _buildStatCard(
              context: context,
              width: cardWidth - (isSmall ? 6 : 8),
              height: cardHeight,
              title: AppLocalizations.of(context)!.dashboardTotalDonations,
              value: '₹${_formatAmount(dataService.totalDonations)}',
              icon: Icons.currency_rupee_rounded,
              color: AppTheme.accentGreen,
              subtitle: AppLocalizations.of(context)!
                  .dashboardDonorsCount(dataService.donationCount),
              isSmall: isSmall,
            ),
            _buildStatCard(
              context: context,
              width: cardWidth - (isSmall ? 6 : 8),
              height: cardHeight,
              title: AppLocalizations.of(context)!.dashboardActiveEvents,
              value: '${dataService.activeEventsCount}',
              icon: Icons.event_rounded,
              color: AppTheme.accentCyan,
              subtitle: AppLocalizations.of(context)!.dashboardSubtitleUpcoming,
              isSmall: isSmall,
            ),
            _buildStatCard(
              context: context,
              width: cardWidth - (isSmall ? 6 : 8),
              height: cardHeight,
              title: AppLocalizations.of(context)!.dashboardGalleryItems,
              value: '${dataService.galleryCount}',
              icon: Icons.photo_library_rounded,
              color: AppTheme.primaryOrange,
              subtitle: AppLocalizations.of(context)!.dashboardSubtitlePhotos,
              isSmall: isSmall,
            ),
            _buildStatCard(
              context: context,
              width: cardWidth - (isSmall ? 6 : 8),
              height: cardHeight,
              title: AppLocalizations.of(context)!.dashboardThisMonth,
              value: '₹${_formatAmount(_getThisMonthDonations(dataService))}',
              icon: Icons.trending_up_rounded,
              color: AppTheme.accentPink,
              subtitle:
                  AppLocalizations.of(context)!.dashboardSubtitleCollected,
              isSmall: isSmall,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required double width,
    required double height,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
    required bool isSmall,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: width,
          // Remove fixed height, let content dictate height
          padding: EdgeInsets.all(isSmall ? 12 : 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.2),
                AppTheme.dynamicOverlay(context, alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: AppTheme.dynamicTextSecondary(context),
                        fontSize: isSmall ? 10 : 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(isSmall ? 6 : 8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: isSmall ? 14 : 18,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: AppTheme.dynamicTextPrimary(context),
                        fontSize: isSmall ? 18 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: color,
                      fontSize: isSmall ? 9 : 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentDonations(
      BuildContext context, DataService dataService, bool isSmall) {
    final recentDonations = dataService.getRecentDonations(limit: 5);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(isSmall ? 14 : 20),
          decoration: BoxDecoration(
            color: AppTheme.dynamicOverlay(context, alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.dynamicDivider(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.dashboardRecentDonations,
                      style: TextStyle(
                        color: AppTheme.dynamicTextPrimary(context),
                        fontSize: isSmall ? 16 : 18,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () => onNavigateToTab.call(1),
                    child: Text(
                      AppLocalizations.of(context)!.dashboardViewAll,
                      style: TextStyle(
                        color: AppTheme.sacredGold,
                        fontSize: isSmall ? 11 : 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (recentDonations.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.volunteer_activism_outlined,
                          color: AppTheme.dynamicTextHint(context),
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.dashboardNoDonationsYet,
                          style: TextStyle(
                            color: AppTheme.dynamicTextMuted(context),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...recentDonations.map((donation) =>
                    _buildDonationTile(context, donation, isSmall)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDonationTile(
      BuildContext context, dynamic donation, bool isSmall) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(isSmall ? 10 : 14),
      decoration: BoxDecoration(
        color: AppTheme.dynamicOverlay(context, alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isSmall ? 8 : 10),
            decoration: BoxDecoration(
              color: AppTheme.accentGreen.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.currency_rupee_rounded,
              color: AppTheme.accentGreen,
              size: isSmall ? 16 : 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  donation.name,
                  style: TextStyle(
                    color: AppTheme.dynamicTextPrimary(context),
                    fontWeight: FontWeight.w500,
                    fontSize: isSmall ? 12 : 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  donation.location,
                  style: TextStyle(
                    color: AppTheme.dynamicTextMuted(context),
                    fontSize: isSmall ? 10 : 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${donation.amount.toStringAsFixed(0)}',
                style: TextStyle(
                  color: AppTheme.accentGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: isSmall ? 12 : 14,
                ),
              ),
              Text(
                _formatDate(donation.date),
                style: TextStyle(
                  color: AppTheme.dynamicTextMuted(context),
                  fontSize: isSmall ? 9 : 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents(
      BuildContext context, DataService dataService, bool isSmall) {
    final upcomingEvents = dataService.getUpcomingEvents(limit: 3);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(isSmall ? 14 : 20),
          decoration: BoxDecoration(
            color: AppTheme.dynamicOverlay(context, alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.dynamicDivider(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.dashboardUpcomingEvents,
                      style: TextStyle(
                        color: AppTheme.dynamicTextPrimary(context),
                        fontSize: isSmall ? 16 : 18,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () => onNavigateToTab.call(2),
                    child: Text(
                      AppLocalizations.of(context)!.dashboardViewAll,
                      style: TextStyle(
                        color: AppTheme.sacredGold,
                        fontSize: isSmall ? 11 : 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (upcomingEvents.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.event_busy_rounded,
                          color: AppTheme.dynamicTextHint(context),
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!
                              .dashboardNoUpcomingEvents,
                          style: TextStyle(
                            color: AppTheme.dynamicTextMuted(context),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...upcomingEvents
                    .map((event) => _buildEventTile(context, event, isSmall)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventTile(BuildContext context, dynamic event, bool isSmall) {
    final categoryColor = _getCategoryColor(event.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(isSmall ? 10 : 14),
      decoration: BoxDecoration(
        color: AppTheme.dynamicOverlay(context, alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmall ? 10 : 12,
              vertical: isSmall ? 8 : 10,
            ),
            decoration: BoxDecoration(
              color: AppTheme.accentCyan.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  event.date.day.toString(),
                  style: TextStyle(
                    color: AppTheme.accentCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: isSmall ? 14 : 18,
                  ),
                ),
                Text(
                  _getMonth(event.date.month),
                  style: TextStyle(
                    color: AppTheme.accentCyan,
                    fontSize: isSmall ? 9 : 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: TextStyle(
                    color: AppTheme.dynamicTextPrimary(context),
                    fontWeight: FontWeight.w500,
                    fontSize: isSmall ? 12 : 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  event.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppTheme.dynamicTextMuted(context),
                    fontSize: isSmall ? 10 : 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmall ? 8 : 10,
              vertical: isSmall ? 4 : 6,
            ),
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              event.category,
              style: TextStyle(
                color: categoryColor,
                fontSize: isSmall ? 9 : 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationTrendChart(
      BuildContext context, DataService dataService, bool isSmall) {
    final monthlyData = dataService.getDonationsByMonth();
    if (monthlyData.isEmpty) return const SizedBox.shrink();

    // Sort by date and take the last 6 months
    final sortedKeys = monthlyData.keys.toList()..sort();
    final recentKeys = sortedKeys.length > 6
        ? sortedKeys.sublist(sortedKeys.length - 6)
        : sortedKeys;

    final spots = <FlSpot>[];
    final labels = <String>[];
    for (var i = 0; i < recentKeys.length; i++) {
      spots.add(FlSpot(i.toDouble(), monthlyData[recentKeys[i]]!));
      final parts = recentKeys[i].split('-');
      labels.add(_getMonth(int.parse(parts[1])));
    }

    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(isSmall ? 14 : 20),
          decoration: BoxDecoration(
            color: AppTheme.dynamicOverlay(context, alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.dynamicDivider(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.donationsTrendTitle,
                style: TextStyle(
                  color: AppTheme.dynamicTextPrimary(context),
                  fontSize: isSmall ? 16 : 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: maxY / 4,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: AppTheme.dynamicDivider(context),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 44,
                          getTitlesWidget: (value, meta) => Text(
                            '₹${_formatAmount(value)}',
                            style: TextStyle(
                              color: AppTheme.dynamicTextMuted(context),
                              fontSize: isSmall ? 8 : 10,
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx < 0 || idx >= labels.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                labels[idx],
                                style: TextStyle(
                                  color: AppTheme.dynamicTextMuted(context),
                                  fontSize: isSmall ? 9 : 11,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: AppTheme.sacredGold,
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                            radius: 4,
                            color: AppTheme.sacredGold,
                            strokeColor: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppTheme.sacredGold.withValues(alpha: 0.15),
                        ),
                      ),
                    ],
                    minY: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPurposeBreakdown(
      BuildContext context, DataService dataService, bool isSmall) {
    if (dataService.donations.isEmpty) return const SizedBox.shrink();

    final purposeMap = <String, double>{};
    for (var d in dataService.donations) {
      final purpose = d.purpose;
      purposeMap[purpose] = (purposeMap[purpose] ?? 0) + d.amount;
    }

    final colors = [
      AppTheme.primaryOrange,
      AppTheme.accentGreen,
      AppTheme.accentCyan,
      AppTheme.accentPink,
      AppTheme.sacredGold,
    ];

    final sections = <PieChartSectionData>[];
    final total = purposeMap.values.fold(0.0, (a, b) => a + b);
    var colorIndex = 0;
    final legendItems = <MapEntry<String, Color>>[];

    purposeMap.forEach((purpose, amount) {
      final percentage = (amount / total * 100);
      final color = colors[colorIndex % colors.length];
      sections.add(PieChartSectionData(
        value: amount,
        title: '${percentage.toStringAsFixed(0)}%',
        color: color,
        radius: isSmall ? 50 : 60,
        titleStyle: TextStyle(
          color: Colors.white,
          fontSize: isSmall ? 10 : 12,
          fontWeight: FontWeight.bold,
        ),
      ));
      legendItems.add(MapEntry(purpose, color));
      colorIndex++;
    });

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(isSmall ? 14 : 20),
          decoration: BoxDecoration(
            color: AppTheme.dynamicOverlay(context, alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.dynamicDivider(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.donationsPurposeBreakdown,
                style: TextStyle(
                  color: AppTheme.dynamicTextPrimary(context),
                  fontSize: isSmall ? 16 : 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: PieChart(
                        PieChartData(
                          sections: sections,
                          centerSpaceRadius: isSmall ? 30 : 40,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: legendItems
                            .map((entry) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: entry.value,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          entry.key,
                                          style: TextStyle(
                                            color:
                                                AppTheme.dynamicTextSecondary(
                                                    context),
                                            fontSize: isSmall ? 9 : 11,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }

  double _getThisMonthDonations(DataService dataService) {
    final now = DateTime.now();
    return dataService.donations
        .where((d) => d.date.month == now.month && d.date.year == now.year)
        .fold(0, (sum, d) => sum + d.amount);
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'religious':
        return AppTheme.primaryOrange;
      case 'cultural':
        return AppTheme.accentPink;
      case 'service':
        return AppTheme.accentGreen;
      default:
        return AppTheme.accentCyan;
    }
  }
}
