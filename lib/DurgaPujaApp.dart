import 'package:flutter/material.dart';
import 'src/localization/app_localizations.dart';

class DurgaPujaApp extends StatelessWidget {
  const DurgaPujaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const DurgaPujaWebsite();
  }
}

extension _L10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

class DurgaPujaWebsite extends StatelessWidget {
  const DurgaPujaWebsite({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildSection(
              context,
              context.l10n.aboutMainTitle,
              context.l10n.aboutMainDesc,
              'assets/images/durga_mata_image.jpg',
              animationType: AnimationType.slideInLeft,
            ),
            _buildSection(
              context,
              context.l10n.aboutOriginTitle,
              context.l10n.aboutOriginDesc,
              'assets/images/history_image.png',
              animationType: AnimationType.fadeIn,
            ),
            _buildSection(
              context,
              context.l10n.aboutSignificanceTitle,
              context.l10n.aboutSignificanceDesc,
              'assets/images/durga_maa_significance.png',
              animationType: AnimationType.slideInRight,
            ),
            _buildSection(
              context,
              context.l10n.aboutPreparationTitle,
              context.l10n.aboutPreparationDesc,
              'assets/images/preparation_celebration.png',
              animationType: AnimationType.fadeIn,
            ),
            _buildSection(
              context,
              context.l10n.aboutRitualsTitle,
              context.l10n.aboutRitualsDesc,
              'assets/images/rituals_customs.png',
              animationType: AnimationType.slideInLeft,
            ),
            _buildSection(
              context,
              context.l10n.aboutPandalsTitle,
              context.l10n.aboutPandalsDesc,
              'assets/images/pandals_idols.png',
              animationType: AnimationType.slideInRight,
            ),
            _buildSection(
              context,
              context.l10n.aboutProcessionsTitle,
              context.l10n.aboutProcessionsDesc,
              'assets/images/procession_immersion.png',
              animationType: AnimationType.fadeIn,
            ),
            _buildSection(
              context,
              context.l10n.aboutBengaliCultureTitle,
              context.l10n.aboutBengaliCultureDesc,
              'assets/images/bengali_culture.png',
              animationType: AnimationType.slideInLeft,
            ),
            _buildSection(
              context,
              context.l10n.aboutConclusionTitle,
              context.l10n.aboutConclusionDesc,
              'assets/images/conclusion.png',
              animationType: AnimationType.slideInRight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String description,
    String imagePath, {
    AnimationType animationType = AnimationType.fadeIn,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedText(
            text: title,
            animationType: animationType,
            textStyle: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
            ),
          ),
          const SizedBox(height: 20),
          ParallaxImage(imagePath: imagePath),
          const SizedBox(height: 20),
          AnimatedText(
            text: description,
            animationType: animationType,
            textStyle: TextStyle(
              fontSize: 18,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}

enum AnimationType { fadeIn, slideInLeft, slideInRight }

class AnimatedText extends StatelessWidget {
  final String text;
  final AnimationType animationType;
  final TextStyle textStyle;

  const AnimatedText({
    super.key,
    required this.text,
    required this.animationType,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      transitionBuilder: (Widget child, Animation<double> animation) {
        switch (animationType) {
          case AnimationType.slideInLeft:
            return SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
                      .animate(animation),
              child: child,
            );
          case AnimationType.slideInRight:
            return SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                      .animate(animation),
              child: child,
            );
          case AnimationType.fadeIn:
            return FadeTransition(opacity: animation, child: child);
        }
      },
      child: Text(
        text,
        key: ValueKey<String>(text),
        style: textStyle,
      ),
    );
  }
}

class ParallaxImage extends StatelessWidget {
  final String imagePath;

  const ParallaxImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
    );
  }
}
