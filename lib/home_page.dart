import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import 'services/theme_service.dart';
import 'services/data_service.dart';
import 'utils/theme.dart';
import 'admin/admin_login.dart';
import 'donation_page_new.dart';
import 'gallery_page_new.dart';
import 'events_page_new.dart';
import 'trivia.dart';
import 'playlist_page.dart' show PlaylistsPage;
import 'community_page.dart';
import 'feedback_page.dart';
import 'DurgaPujaApp.dart';
import 'settings/app_settings_page.dart';
import 'widgets/backgrounds/themed_background.dart';
import 'models/event.dart';
import 'src/localization/app_localizations.dart';

/// Strong, typed model to avoid fragile dynamic casts in _features
class _Feature {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final int route;
  const _Feature({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.route,
  });
}

Widget _buildFeatureCard({
  required String title,
  required String subtitle,
  required IconData icon,
  required List<Color> gradient,
  required double width,
  required double height,
  required Color titleColor,
  required Color subtitleColor,
  required Color glassTopColor,
  required Color glassBottomColor,
  required Color borderColor,
  required bool enableBlur,
  required VoidCallback onTap,
}) {
  final cardContent = Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [glassTopColor, glassBottomColor],
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: borderColor),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  return GestureDetector(
    onTap: () {
      HapticFeedback.lightImpact();
      onTap();
    },
    child: Semantics(
      button: true,
      label: '$title, $subtitle',
      child: SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: enableBlur
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: cardContent,
                )
              : cardContent,
        ),
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  final ScrollController _scrollController = ScrollController();

  // Strongly-typed features (no dynamic)
  final List<_Feature> _features = const [
    _Feature(
      title: 'Donate',
      subtitle: 'Support the celebration',
      icon: Icons.volunteer_activism,
      gradient: [Color(0xFFE23D28), Color(0xFFC41E3A)],
      route: 1,
    ),
    _Feature(
      title: 'Gallery',
      subtitle: 'Explore memories',
      icon: Icons.photo_library,
      gradient: [Color(0xFFD4AF37), Color(0xFFB8860B)],
      route: 2,
    ),
    _Feature(
      title: 'Events',
      subtitle: 'Upcoming celebrations',
      icon: Icons.event,
      gradient: [Color(0xFFFF6B35), Color(0xFFEA580C)],
      route: 3,
    ),
    _Feature(
      title: 'Trivia',
      subtitle: 'Test your knowledge',
      icon: Icons.quiz,
      gradient: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
      route: 4,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Load data after first frame (ensures context and providers are available)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Make sure DataService is provided above this widget.
      context.read<DataService>().loadData();
    });
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final isDark = context.watch<ThemeService>().themeMode == ThemeMode.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark
          ? SystemUiOverlayStyle.light
          : const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
              statusBarColor: Colors.transparent,
            ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        drawer: _buildDrawer(context),
        body: ThemedBackground(
          child: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildSliverAppBar(size),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12 : 20,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: 20),
                        _buildWelcomeSection(isSmallScreen),
                        const SizedBox(height: 24),
                        _buildQuickStats(isSmallScreen),
                        const SizedBox(height: 28),
                        _buildFeaturesGrid(isSmallScreen),
                        const SizedBox(height: 28),
                        _buildUpcomingEvents(isSmallScreen),
                        const SizedBox(height: 28),
                        _buildInfoCard(),
                        const SizedBox(height: 100),
                      ]),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 24,
                right: 20,
                child: _buildFloatingButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(Size size) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Builder(
        builder: (context) => FadeInLeft(
          duration: const Duration(milliseconds: 600),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
      ),
      actions: [
        FadeInRight(
          duration: const Duration(milliseconds: 600),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.music_note_rounded, color: Colors.white),
              onPressed: () => _navigateTo(context, const PlaylistsPage()),
            ),
          ),
        ),
        FadeInRight(
          delay: const Duration(milliseconds: 100),
          duration: const Duration(milliseconds: 600),
          child: Container(
            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.info_outline_rounded, color: Colors.white),
              onPressed: () => _navigateTo(context, const DurgaPujaApp()),
            ),
          ),
        ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.3),
              Colors.transparent,
            ],
          ),
        ),
      ),
      title: FadeInDown(
        duration: const Duration(milliseconds: 800),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.deepSaffron.withValues(alpha: 0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.temple_hindu,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
            Text(
              AppLocalizations.of(context)!.splashTitle,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildWelcomeSection(bool isSmall) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headingColor = isDark ? Colors.white60 : const Color(0xFF4A3520);
    final subtitleColor = isDark ? Colors.white70 : const Color(0xFF5C3D2A);

    return FadeInLeft(
      duration: const Duration(milliseconds: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.homeWelcomeTo,
            style: TextStyle(
              color: headingColor,
              fontSize: isSmall ? 14 : 16,
            ),
          ),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                AppTheme.vermillion,
                AppTheme.sacredGold,
                AppTheme.deepSaffron,
              ],
            ).createShader(bounds),
            child: Text(
              AppLocalizations.of(context)!.homeTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmall ? 28 : 36,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.homeSubtitle,
            style: TextStyle(
              color: subtitleColor,
              fontSize: isSmall ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(bool isSmall) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final panelTop = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.white.withValues(alpha: 0.80);
    final panelBottom = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : const Color(0xFFFFF3E6).withValues(alpha: 0.82);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.2)
        : AppTheme.sacredGold.withValues(alpha: 0.35);

    return Consumer<DataService>(
      builder: (context, dataService, child) {
        // Use safe defaults if DataService fields start as null
        final donationCount = (dataService.donationCount ?? 0);
        final totalAmount = (dataService.totalAmount ?? 0);
        final upcomingEventsCount = (dataService.upcomingEventsCount ?? 0);

        return FadeInUp(
          delay: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 800),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(isSmall ? 12 : 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [panelTop, panelBottom]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.favorite_rounded,
                        value: '$donationCount',
                        label: AppLocalizations.of(context)!.homeStatDonations,
                        color: AppTheme.primaryOrange,
                        isSmall: isSmall,
                        isDark: isDark,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: isDark
                          ? Colors.white24
                          : AppTheme.sacredGold.withValues(alpha: 0.35),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.currency_rupee_rounded,
                        value: _formatAmount(totalAmount),
                        label: AppLocalizations.of(context)!.homeStatCollected,
                        color: AppTheme.primaryGold,
                        isSmall: isSmall,
                        isDark: isDark,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: isDark
                          ? Colors.white24
                          : AppTheme.sacredGold.withValues(alpha: 0.35),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.event_rounded,
                        value: '$upcomingEventsCount',
                        label: AppLocalizations.of(context)!.homeStatEvents,
                        color: AppTheme.accentTeal,
                        isSmall: isSmall,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required bool isSmall,
    required bool isDark,
  }) {
    final valueColor = isDark ? Colors.white : const Color(0xFF2E1A0D);
    final labelColor = isDark ? Colors.white60 : const Color(0xFF5C3D2A);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(isSmall ? 6 : 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: isSmall ? 18 : 22),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: isSmall ? 14 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: isSmall ? 10 : 11,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesGrid(bool isSmall) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF2E1A0D);
    final cardTitleColor = isDark ? Colors.white : const Color(0xFF2E1A0D);
    final cardSubtitleColor = isDark ? Colors.white60 : const Color(0xFF5C3D2A);
    final glassTop = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.white.withValues(alpha: 0.83);
    final glassBottom = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : const Color(0xFFFFF8F0).withValues(alpha: 0.85);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInLeft(
          delay: const Duration(milliseconds: 300),
          child: Row(
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
              Text(
                AppLocalizations.of(context)!.homeQuickActions,
                style: TextStyle(
                  color: titleColor,
                  fontSize: isSmall ? 18 : 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 16) / 2;
            final cardHeight = cardWidth * 0.85;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(_features.length, (index) {
                final feature = _features[index];
                return FadeInUp(
                  delay: Duration(milliseconds: 400 + (index * 100)),
                  duration: const Duration(milliseconds: 600),
                  child: _buildFeatureCard(
                    title: _localizedFeatureTitle(context, feature.route),
                    subtitle: _localizedFeatureSubtitle(context, feature.route),
                    icon: feature.icon,
                    gradient: feature.gradient,
                    width: cardWidth,
                    height: cardHeight,
                    titleColor: cardTitleColor,
                    subtitleColor: cardSubtitleColor,
                    glassTopColor: glassTop,
                    glassBottomColor: glassBottom,
                    borderColor: feature.gradient[0]
                        .withValues(alpha: isDark ? 0.3 : 0.45),
                    enableBlur: isDark,
                    onTap: () => _openFeatureRoute(context, feature.route),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }

  Widget _buildUpcomingEvents(bool isSmall) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        // Use empty list if events not yet loaded
        final allEvents = (dataService.events ?? const <Event>[]);
        // Filter robustly (guard null fields)
        final upcomingEvents = allEvents
            .where((e) =>
                (e.isActive == true) &&
                (e.date != null) &&
                e.date.isAfter(DateTime.now()))
            .take(3)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInLeft(
              delay: const Duration(milliseconds: 600),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
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
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context)!.homeUpcomingEvents,
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF2E1A0D),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        _navigateTo(context, const EventsPageNew()),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.homeViewAll,
                          style: const TextStyle(
                            color: AppTheme.primaryOrange,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppTheme.primaryOrange,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (upcomingEvents.isEmpty)
              FadeInUp(
                delay: const Duration(milliseconds: 700),
                child: _buildEmptyEventsCard(),
              )
            else
              ...upcomingEvents.asMap().entries.map((entry) {
                final index = entry.key;
                final event = entry.value;
                return FadeInUp(
                  delay: Duration(milliseconds: 700 + (index * 100)),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildEventCard(event, isSmall),
                  ),
                );
              }),
          ],
        );
      },
    );
  }

  Widget _buildEmptyEventsCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: 0.84),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : AppTheme.sacredGold.withValues(alpha: 0.35),
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.event_busy_rounded,
                  color: isDark ? Colors.white54 : const Color(0xFF5C3D2A),
                  size: 40,
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.homeNoUpcomingEvents,
                  style: TextStyle(
                    color: isDark ? Colors.white54 : const Color(0xFF5C3D2A),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(Event? event, bool isSmall) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF2E1A0D);
    final subtitleColor = isDark ? Colors.white60 : const Color(0xFF5C3D2A);

    // Null/type checks
    if (event == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          AppLocalizations.of(context)!.homeInvalidEventData,
          style: const TextStyle(color: Colors.red, fontSize: 14),
        ),
      );
    }

    // Safely fallback if model fields are nullable
    final date = event.date ?? DateTime.now();
    final title =
        event.title ?? AppLocalizations.of(context)!.homeUntitledEvent;
    final location =
        event.location ?? AppLocalizations.of(context)!.locationTbd;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _navigateTo(context, const EventsPageNew());
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(isSmall ? 12 : 16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.84),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : AppTheme.sacredGold.withValues(alpha: 0.30),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmall ? 10 : 14,
                    vertical: isSmall ? 8 : 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isSmall ? 16 : 20,
                        ),
                      ),
                      Text(
                        _getMonthShort(date.month),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: isSmall ? 10 : 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.w600,
                          fontSize: isSmall ? 13 : 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: subtitleColor,
                            size: isSmall ? 12 : 14,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: isSmall ? 11 : 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark ? Colors.white38 : const Color(0xFF5C3D2A),
                  size: isSmall ? 14 : 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return FadeInUp(
      delay: const Duration(milliseconds: 900),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.vermillionDark.withValues(alpha: 0.6),
                  AppTheme.deepSaffron.withValues(alpha: 0.4),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.homeLearnAbout,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.homeDiscoverHistory,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Floating icon
                // ignore: prefer_const_constructors
                // (we keep AnimatedBuilder for smooth floating)
                // (left as is for visual polish)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingButton() {
    return FadeInUp(
      delay: const Duration(milliseconds: 1000),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.vermillion.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  _navigateTo(context, const DonationPageNew());
                },
                tooltip: 'Make a donation',
                backgroundColor: AppTheme.vermillion,
                elevation: 0,
                icon: const Icon(Icons.favorite_rounded, color: Colors.white),
                label: Text(
                  AppLocalizations.of(context)!.homeDonate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.surfaceColor.withValues(alpha: 0.95),
                  AppTheme.cardColor.withValues(alpha: 0.95),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.temple_hindu,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          AppLocalizations.of(context)!.homeDrawerTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.homeDrawerSubtitle,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      children: [
                        _buildDrawerItem(
                            Icons.home_rounded,
                            AppLocalizations.of(context)!.homeDrawerHome,
                            () => Navigator.pop(context)),
                        _buildDrawerItem(Icons.volunteer_activism_rounded,
                            AppLocalizations.of(context)!.homeDrawerDonate, () {
                          Navigator.pop(context);
                          _navigateTo(context, const DonationPageNew());
                        }),
                        _buildDrawerItem(Icons.event_rounded,
                            AppLocalizations.of(context)!.homeDrawerEvents, () {
                          Navigator.pop(context);
                          _navigateTo(context, const EventsPageNew());
                        }),
                        _buildDrawerItem(Icons.photo_library_rounded,
                            AppLocalizations.of(context)!.homeDrawerGallery,
                            () {
                          Navigator.pop(context);
                          _navigateTo(context, const GalleryPageNew());
                        }),
                        _buildDrawerItem(Icons.quiz_rounded,
                            AppLocalizations.of(context)!.homeDrawerTrivia, () {
                          Navigator.pop(context);
                          _navigateTo(context, const TriviaPage());
                        }),
                        _buildDrawerItem(Icons.groups_rounded,
                            AppLocalizations.of(context)!.homeDrawerCommunity,
                            () {
                          Navigator.pop(context);
                          _navigateTo(context, const CommunityPage());
                        }),
                        _buildDrawerItem(Icons.feedback_outlined,
                            AppLocalizations.of(context)!.homeDrawerFeedback,
                            () {
                          Navigator.pop(context);
                          _navigateTo(context, const FeedbackPage());
                        }),
                        _buildDrawerItem(Icons.music_note_rounded,
                            AppLocalizations.of(context)!.homeDrawerPlaylist,
                            () {
                          Navigator.pop(context);
                          _navigateTo(context, const PlaylistsPage());
                        }),
                        _buildDrawerItem(Icons.info_rounded,
                            AppLocalizations.of(context)!.homeDrawerAbout, () {
                          Navigator.pop(context);
                          _navigateTo(context, const DurgaPujaApp());
                        }),
                        _buildDrawerItem(Icons.settings_rounded,
                            AppLocalizations.of(context)!.homeDrawerSettings,
                            () {
                          Navigator.pop(context);
                          _navigateTo(context, const AppSettingsPage());
                        }),
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: Divider(color: Colors.white24),
                        ),
                        _buildDrawerItem(
                          Icons.admin_panel_settings_rounded,
                          AppLocalizations.of(context)!.homeDrawerAdmin,
                          () {
                            Navigator.pop(context);
                            _navigateTo(context, const AdminLoginPage());
                          },
                          color: AppTheme.primaryOrange,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      AppLocalizations.of(context)!.homeCopyright,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap,
      {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.white70, size: 22),
        title: Text(
          title,
          style: TextStyle(
            color: color ?? Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String _localizedFeatureTitle(BuildContext context, int route) {
    final l10n = AppLocalizations.of(context)!;
    switch (route) {
      case 1:
        return l10n.homeFeatureDonate;
      case 2:
        return l10n.homeFeatureGallery;
      case 3:
        return l10n.homeFeatureEvents;
      case 4:
        return l10n.homeFeatureTrivia;
      default:
        return '';
    }
  }

  String _localizedFeatureSubtitle(BuildContext context, int route) {
    final l10n = AppLocalizations.of(context)!;
    switch (route) {
      case 1:
        return l10n.homeFeatureDonateSubtitle;
      case 2:
        return l10n.homeFeatureGallerySubtitle;
      case 3:
        return l10n.homeFeatureEventsSubtitle;
      case 4:
        return l10n.homeFeatureTriviaSubtitle;
      default:
        return '';
    }
  }

  void _openFeatureRoute(BuildContext context, int route) {
    switch (route) {
      case 1:
        _navigateTo(context, const DonationPageNew());
        break;
      case 2:
        _navigateTo(context, const GalleryPageNew());
        break;
      case 3:
        _navigateTo(context, const EventsPageNew());
        break;
      case 4:
        _navigateTo(context, const TriviaPage());
        break;
      case 5:
        _navigateTo(context, const PlaylistsPage());
        break;
      default:
        // Avoid pushing HomePage again; show a friendly message instead
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.homeFeatureComingSoon)),
        );
    }
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                  parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  /// Accepts nullable and formats safely
  String _formatAmount(num? amount) {
    final a = (amount ?? 0).toDouble();
    if (a >= 100000) {
      return '₹${(a / 100000).toStringAsFixed(1)}L';
    } else if (a >= 1000) {
      return '₹${(a / 1000).toStringAsFixed(1)}K';
    }
    return '₹${a.toStringAsFixed(0)}';
  }

  /// Guarded short month
  String _getMonthShort(int month) {
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
    if (month < 1 || month > 12) return '???';
    return months[month - 1];
  }
}
