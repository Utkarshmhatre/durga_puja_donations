import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import 'models/feedback.dart';
import 'services/data_service.dart';
import 'src/localization/app_localizations.dart';
import 'utils/theme.dart';
import 'widgets/backgrounds/themed_background.dart';
import 'widgets/common_widgets.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  int _rating = 0;
  String _category = 'general';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (!_formKey.currentState!.validate()) return;
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.feedbackSelectRating),
          backgroundColor: AppTheme.accentRed,
        ),
      );
      return;
    }

    final feedback = UserFeedback(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      rating: _rating,
      message: _messageController.text.trim(),
      category: _category,
    );

    context.read<DataService>().addFeedback(feedback);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.feedbackSubmitSuccess),
        backgroundColor: AppTheme.accentGreen,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF2E1A0D);
    final subtitleColor = isDark ? Colors.white54 : const Color(0xFF5C3D2A);

    return Scaffold(
      body: ThemedBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                leading: Semantics(
                  button: true,
                  label: 'Go back',
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.arrow_back, color: titleColor),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context)!.feedbackPageTitle,
                  style: TextStyle(color: titleColor),
                ),
                centerTitle: true,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    FadeInDown(
                      child: Text(
                        AppLocalizations.of(context)!.feedbackSubtitle,
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Rating stars
                    FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      child: GlassCard(
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .feedbackRateExperience,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: titleColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                return Semantics(
                                  button: true,
                                  label:
                                      '${index + 1} star${index == 0 ? '' : 's'}',
                                  selected: _rating == index + 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() => _rating = index + 1);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: Icon(
                                        index < _rating
                                            ? Icons.star_rounded
                                            : Icons.star_border_rounded,
                                        size: 44,
                                        color: index < _rating
                                            ? AppTheme.sacredGold
                                            : (isDark
                                                ? Colors.white30
                                                : const Color(0xFFD4C5B2)),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            if (_rating > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  _getRatingLabel(_rating),
                                  style: const TextStyle(
                                    color: AppTheme.sacredGold,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Form
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: GlassCard(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: _nameController,
                                label: AppLocalizations.of(context)!
                                    .feedbackNameLabel,
                                icon: Icons.person_outline,
                                isDark: isDark,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .feedbackNameRequired;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              _buildTextField(
                                controller: _emailController,
                                label: AppLocalizations.of(context)!
                                    .feedbackEmailLabel,
                                icon: Icons.email_outlined,
                                isDark: isDark,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 12),

                              // Category selector
                              DropdownButtonFormField<String>(
                                initialValue: _category,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!
                                      .feedbackCategoryLabel,
                                  prefixIcon: Icon(Icons.category_outlined,
                                      color: isDark
                                          ? AppTheme.textSecondary
                                          : const Color(0xFF5C3D2A)),
                                  filled: true,
                                  fillColor: isDark
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : Colors.white.withValues(alpha: 0.6),
                                ),
                                dropdownColor: isDark
                                    ? AppTheme.cardBackground
                                    : Colors.white,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF2E1A0D),
                                ),
                                items: UserFeedback.categories
                                    .map((c) => DropdownMenuItem(
                                          value: c,
                                          child: Text(_categoryLabel(c)),
                                        ))
                                    .toList(),
                                onChanged: (v) {
                                  if (v != null) setState(() => _category = v);
                                },
                              ),
                              const SizedBox(height: 12),

                              _buildTextField(
                                controller: _messageController,
                                label: AppLocalizations.of(context)!
                                    .feedbackMessageLabel,
                                icon: Icons.message_outlined,
                                isDark: isDark,
                                maxLines: 4,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .feedbackMessageRequired;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: GradientButton(
                        text: AppLocalizations.of(context)!.feedbackSubmit,
                        icon: Icons.send_rounded,
                        width: double.infinity,
                        height: 56,
                        onPressed: _submitFeedback,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF2E1A0D)),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon,
            color: isDark ? AppTheme.textSecondary : const Color(0xFF5C3D2A)),
        filled: true,
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.6),
      ),
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return AppLocalizations.of(context)!.feedbackRating1;
      case 2:
        return AppLocalizations.of(context)!.feedbackRating2;
      case 3:
        return AppLocalizations.of(context)!.feedbackRating3;
      case 4:
        return AppLocalizations.of(context)!.feedbackRating4;
      case 5:
        return AppLocalizations.of(context)!.feedbackRating5;
      default:
        return '';
    }
  }

  String _categoryLabel(String category) {
    switch (category) {
      case 'general':
        return AppLocalizations.of(context)!.feedbackCatGeneral;
      case 'suggestion':
        return AppLocalizations.of(context)!.feedbackCatSuggestion;
      case 'bug':
        return AppLocalizations.of(context)!.feedbackCatBug;
      case 'praise':
        return AppLocalizations.of(context)!.feedbackCatPraise;
      default:
        return category;
    }
  }
}
