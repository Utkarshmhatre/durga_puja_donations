import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import '../models/feedback.dart';
import '../services/data_service.dart';
import '../src/localization/app_localizations.dart';
import '../utils/theme.dart';

class AdminFeedbackPage extends StatelessWidget {
  const AdminFeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;

    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final feedback = dataService.getRecentFeedback(limit: 100);
        final avgRating = dataService.averageRating;

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
                                  AppLocalizations.of(context)!
                                      .adminFeedbackTitle,
                                  style: TextStyle(
                                    fontSize: isSmall ? 24 : 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.dynamicTextPrimary(context),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizations.of(context)!
                                      .adminFeedbackSubtitle,
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
                              Icons.feedback_outlined,
                              color: AppTheme.sacredGold,
                              size: isSmall ? 22 : 26,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isSmall ? 16 : 24),

                    // Stats row
                    FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      child: _buildStatsRow(
                          context, feedback.length, avgRating, isSmall),
                    ),

                    SizedBox(height: isSmall ? 16 : 24),

                    // Feedback list
                    if (feedback.isEmpty)
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: _buildEmptyState(context),
                      )
                    else
                      ...feedback.asMap().entries.map((entry) {
                        return FadeInUp(
                          delay: Duration(milliseconds: 200 + (entry.key * 50)),
                          child: _buildFeedbackTile(
                              context, entry.value, isSmall, dataService),
                        );
                      }),

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

  Widget _buildStatsRow(
      BuildContext context, int count, double avgRating, bool isSmall) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(isSmall ? 12 : 16),
          decoration: BoxDecoration(
            color: AppTheme.dynamicOverlay(context, alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.dynamicDivider(context)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Icon(Icons.rate_review_outlined,
                        color: AppTheme.accentCyan, size: isSmall ? 22 : 28),
                    const SizedBox(height: 8),
                    Text(
                      '$count',
                      style: TextStyle(
                        color: AppTheme.dynamicTextPrimary(context),
                        fontSize: isSmall ? 18 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.adminFeedbackTotalLabel,
                      style: TextStyle(
                        color: AppTheme.dynamicTextMuted(context),
                        fontSize: isSmall ? 10 : 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                width: 1,
                color: AppTheme.dynamicDivider(context),
              ),
              Expanded(
                child: Column(
                  children: [
                    Icon(Icons.star_rounded,
                        color: AppTheme.sacredGold, size: isSmall ? 22 : 28),
                    const SizedBox(height: 8),
                    Text(
                      avgRating > 0 ? avgRating.toStringAsFixed(1) : '-',
                      style: TextStyle(
                        color: AppTheme.dynamicTextPrimary(context),
                        fontSize: isSmall ? 18 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.adminFeedbackAvgRating,
                      style: TextStyle(
                        color: AppTheme.dynamicTextMuted(context),
                        fontSize: isSmall ? 10 : 12,
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

  Widget _buildEmptyState(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: AppTheme.dynamicOverlay(context, alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.dynamicDivider(context)),
          ),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.feedback_outlined,
                  color: AppTheme.dynamicTextHint(context),
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.adminFeedbackEmpty,
                  style: TextStyle(
                    color: AppTheme.dynamicTextMuted(context),
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

  Widget _buildFeedbackTile(BuildContext context, UserFeedback feedback,
      bool isSmall, DataService dataService) {
    final categoryColor = _getCategoryColor(feedback.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(isSmall ? 12 : 16),
            decoration: BoxDecoration(
              color: AppTheme.dynamicOverlay(context, alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.dynamicDivider(context)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Stars
                    ...List.generate(5, (i) {
                      return Icon(
                        i < feedback.rating
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 18,
                        color: i < feedback.rating
                            ? AppTheme.sacredGold
                            : AppTheme.dynamicTextHint(context),
                      );
                    }),
                    const Spacer(),
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        feedback.category.toUpperCase(),
                        style: TextStyle(
                          color: categoryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Delete button
                    GestureDetector(
                      onTap: () =>
                          _showDeleteDialog(context, feedback, dataService),
                      child: Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: AppTheme.accentRed.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  feedback.message,
                  style: TextStyle(
                    color: AppTheme.dynamicTextPrimary(context),
                    fontSize: isSmall ? 12 : 14,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.person_outline,
                        size: 14, color: AppTheme.dynamicTextMuted(context)),
                    const SizedBox(width: 4),
                    Text(
                      feedback.name,
                      style: TextStyle(
                        color: AppTheme.dynamicTextSecondary(context),
                        fontSize: isSmall ? 10 : 12,
                      ),
                    ),
                    if (feedback.email.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      Icon(Icons.email_outlined,
                          size: 14, color: AppTheme.dynamicTextMuted(context)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          feedback.email,
                          style: TextStyle(
                            color: AppTheme.dynamicTextMuted(context),
                            fontSize: isSmall ? 10 : 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      _formatDate(feedback.createdAt),
                      style: TextStyle(
                        color: AppTheme.dynamicTextHint(context),
                        fontSize: isSmall ? 9 : 10,
                      ),
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

  void _showDeleteDialog(
      BuildContext context, UserFeedback feedback, DataService dataService) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.dynamicCardBg(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          AppLocalizations.of(context)!.adminFeedbackDeleteTitle,
          style: TextStyle(color: AppTheme.dynamicTextPrimary(context)),
        ),
        content: Text(
          AppLocalizations.of(context)!.adminFeedbackDeleteConfirm,
          style: TextStyle(color: AppTheme.dynamicTextSecondary(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(color: AppTheme.dynamicTextMuted(context)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              dataService.deleteFeedback(feedback.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'suggestion':
        return AppTheme.accentCyan;
      case 'bug':
        return AppTheme.accentRed;
      case 'praise':
        return AppTheme.accentGreen;
      default:
        return AppTheme.primaryOrange;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
