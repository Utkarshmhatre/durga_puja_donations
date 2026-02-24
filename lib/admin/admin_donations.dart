import 'dart:ui';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:io';
import '../models/donation.dart';
import '../services/auth_service.dart';
import '../services/data_service.dart';
import '../src/localization/app_localizations.dart';
import '../utils/theme.dart';

class AdminDonationsPage extends StatefulWidget {
  const AdminDonationsPage({super.key});

  @override
  State<AdminDonationsPage> createState() => _AdminDonationsPageState();
}

class _AdminDonationsPageState extends State<AdminDonationsPage> {
  String _searchQuery = '';
  String _sortBy = 'date';
  bool _sortAscending = false;
  String _statusFilter = 'all';
  final String _purposeFilter = 'all';
  DateTime? _dateStart;
  DateTime? _dateEnd;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        var donations = List<Donation>.from(dataService.donations);

        // Filter by search
        if (_searchQuery.isNotEmpty) {
          donations = donations
              .where((d) =>
                  d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  d.location.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();
        }

        // Filter by status
        if (_statusFilter != 'all') {
          donations =
              donations.where((d) => d.status == _statusFilter).toList();
        }

        // Filter by purpose
        if (_purposeFilter != 'all') {
          donations =
              donations.where((d) => d.purpose == _purposeFilter).toList();
        }

        // Filter by date range
        if (_dateStart != null) {
          donations =
              donations.where((d) => !d.date.isBefore(_dateStart!)).toList();
        }
        if (_dateEnd != null) {
          final endOfDay = _dateEnd!.add(const Duration(days: 1));
          donations =
              donations.where((d) => d.date.isBefore(endOfDay)).toList();
        }

        // Sort
        donations.sort((a, b) {
          int comparison;
          switch (_sortBy) {
            case 'name':
              comparison = a.name.compareTo(b.name);
              break;
            case 'amount':
              comparison = a.amount.compareTo(b.amount);
              break;
            case 'status':
              comparison = a.status.compareTo(b.status);
              break;
            case 'date':
            default:
              comparison = a.date.compareTo(b.date);
          }
          return _sortAscending ? comparison : -comparison;
        });

        final size = MediaQuery.of(context).size;
        final isSmall = size.width < 360;

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(isSmall ? 16 : 24),
                child: FadeInDown(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Export Button
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.donationsTitle,
                              style: TextStyle(
                                fontSize: isSmall ? 24 : 32,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.dynamicTextPrimary(context),
                              ),
                            ),
                          ),
                          if (context
                                  .read<AuthService>()
                                  .currentUser
                                  ?.role
                                  .canExportData ??
                              false)
                            GestureDetector(
                              onTap: () => _exportCsv(context, donations),
                              child: Container(
                                padding: EdgeInsets.all(isSmall ? 10 : 12),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentGreen
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color: AppTheme.accentGreen
                                          .withValues(alpha: 0.3)),
                                ),
                                child: Icon(Icons.download_rounded,
                                    color: AppTheme.accentGreen,
                                    size: isSmall ? 20 : 22),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Stats Chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildStatChip(
                            AppLocalizations.of(context)!.donationsStatTotal,
                            '₹${_formatAmount(dataService.totalDonations)}',
                            AppTheme.accentGreen,
                            isSmall,
                          ),
                          _buildStatChip(
                            AppLocalizations.of(context)!.donationsStatCount,
                            '${dataService.donationCount}',
                            AppTheme.accentCyan,
                            isSmall,
                          ),
                          _buildStatChip(
                            AppLocalizations.of(context)!.donationsStatFiltered,
                            '${donations.length}',
                            AppTheme.sacredGold,
                            isSmall,
                          ),
                        ],
                      ),

                      SizedBox(height: isSmall ? 12 : 16),

                      // Search Row
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() => _searchQuery = value);
                              },
                              style: TextStyle(
                                color: AppTheme.dynamicTextPrimary(context),
                                fontSize: isSmall ? 13 : 14,
                              ),
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!
                                    .donationsSearchHint,
                                hintStyle: TextStyle(
                                  color: AppTheme.dynamicTextHint(context),
                                  fontSize: isSmall ? 13 : 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: AppTheme.dynamicTextMuted(context),
                                  size: isSmall ? 20 : 22,
                                ),
                                filled: true,
                                fillColor: AppTheme.dynamicOverlay(context,
                                    alpha: 0.1),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: isSmall ? 12 : 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              HapticFeedback.selectionClick();
                              setState(() {
                                if (_sortBy == value) {
                                  _sortAscending = !_sortAscending;
                                } else {
                                  _sortBy = value;
                                  _sortAscending = false;
                                }
                              });
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'date',
                                child: Text(AppLocalizations.of(context)!
                                    .donationsSortByDate),
                              ),
                              PopupMenuItem(
                                value: 'amount',
                                child: Text(AppLocalizations.of(context)!
                                    .donationsSortByAmount),
                              ),
                              PopupMenuItem(
                                value: 'name',
                                child: Text(AppLocalizations.of(context)!
                                    .donationsSortByName),
                              ),
                              PopupMenuItem(
                                value: 'status',
                                child: Text(AppLocalizations.of(context)!
                                    .donationsSortByStatus),
                              ),
                            ],
                            child: Container(
                              padding: EdgeInsets.all(isSmall ? 12 : 14),
                              decoration: BoxDecoration(
                                color: AppTheme.dynamicOverlay(context,
                                    alpha: 0.1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                _sortAscending
                                    ? Icons.arrow_upward_rounded
                                    : Icons.arrow_downward_rounded,
                                color: AppTheme.dynamicTextMuted(context),
                                size: isSmall ? 20 : 22,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Filter chips row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Status filter
                            _buildFilterChip(
                                AppLocalizations.of(context)!
                                    .donationsFilterAll,
                                _statusFilter == 'all',
                                () => setState(() => _statusFilter = 'all'),
                                isSmall),
                            const SizedBox(width: 6),
                            ...Donation.statuses.map((s) => Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: _buildFilterChip(
                                      s,
                                      _statusFilter == s,
                                      () => setState(() => _statusFilter = s),
                                      isSmall),
                                )),
                            const SizedBox(width: 8),
                            // Date range
                            GestureDetector(
                              onTap: () => _showDateRangePicker(context),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: isSmall ? 8 : 10,
                                    vertical: isSmall ? 6 : 8),
                                decoration: BoxDecoration(
                                  color:
                                      (_dateStart != null || _dateEnd != null)
                                          ? AppTheme.sacredGold
                                              .withValues(alpha: 0.2)
                                          : AppTheme.dynamicOverlay(context,
                                              alpha: 0.08),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        (_dateStart != null || _dateEnd != null)
                                            ? AppTheme.sacredGold
                                                .withValues(alpha: 0.4)
                                            : AppTheme.dynamicDivider(context),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.date_range_rounded,
                                        color: (_dateStart != null ||
                                                _dateEnd != null)
                                            ? AppTheme.sacredGold
                                            : AppTheme.dynamicTextMuted(
                                                context),
                                        size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      (_dateStart != null || _dateEnd != null)
                                          ? '${_dateStart != null ? _formatDate(_dateStart!) : '...'} - ${_dateEnd != null ? _formatDate(_dateEnd!) : '...'}'
                                          : AppLocalizations.of(context)!
                                              .donationsDateRange,
                                      style: TextStyle(
                                        color: (_dateStart != null ||
                                                _dateEnd != null)
                                            ? AppTheme.sacredGold
                                            : AppTheme.dynamicTextMuted(
                                                context),
                                        fontSize: isSmall ? 10 : 11,
                                      ),
                                    ),
                                    if (_dateStart != null ||
                                        _dateEnd != null) ...[
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () => setState(() {
                                          _dateStart = null;
                                          _dateEnd = null;
                                        }),
                                        child: Icon(Icons.close,
                                            color: AppTheme.dynamicTextMuted(
                                                context),
                                            size: 14),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Donations List
              Expanded(
                child: donations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.volunteer_activism_outlined,
                              size: 80,
                              color: AppTheme.dynamicTextHint(context),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty && _statusFilter == 'all'
                                  ? AppLocalizations.of(context)!
                                      .donationsNoDonationsYet
                                  : AppLocalizations.of(context)!
                                      .donationsNoDonationsFound,
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
                        itemCount: donations.length,
                        itemBuilder: (context, index) {
                          final donation = donations[index];
                          return FadeInUp(
                            delay: Duration(milliseconds: index * 50),
                            child: _buildDonationCard(context, donation),
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

  Widget _buildFilterChip(
      String label, bool selected, VoidCallback onTap, bool isSmall) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: isSmall ? 8 : 10, vertical: isSmall ? 6 : 8),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.sacredGold.withValues(alpha: 0.2)
              : AppTheme.dynamicOverlay(context, alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppTheme.sacredGold.withValues(alpha: 0.4)
                : AppTheme.dynamicDivider(context),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? AppTheme.sacredGold
                : AppTheme.dynamicTextMuted(context),
            fontSize: isSmall ? 10 : 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color, bool isSmall) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 10 : 14,
        vertical: isSmall ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
              fontSize: isSmall ? 11 : 12,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: isSmall ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }

  Widget _buildDonationCard(BuildContext context, Donation donation) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;
    final statusColor = _getStatusColor(donation.status);
    final canEdit =
        context.read<AuthService>().currentUser?.role.canManageDonations ??
            false;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(isSmall ? 12 : 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.dynamicOverlay(context, alpha: 0.1),
                AppTheme.dynamicOverlay(context, alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.dynamicDivider(context)),
          ),
          child: Row(
            children: [
              // Initial avatar
              Container(
                padding: EdgeInsets.all(isSmall ? 10 : 14),
                decoration: BoxDecoration(
                  gradient: AppTheme.orangeGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  donation.name[0].toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isSmall ? 16 : 20,
                  ),
                ),
              ),
              SizedBox(width: isSmall ? 10 : 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      donation.name,
                      style: TextStyle(
                        color: AppTheme.dynamicTextPrimary(context),
                        fontWeight: FontWeight.w600,
                        fontSize: isSmall ? 13 : 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded,
                            size: isSmall ? 12 : 14,
                            color: AppTheme.dynamicTextMuted(context)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            donation.location,
                            style: TextStyle(
                              color: AppTheme.dynamicTextMuted(context),
                              fontSize: isSmall ? 11 : 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            donation.status,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: isSmall ? 9 : 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (donation.purpose != 'General') ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.sacredGold.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              donation.purpose,
                              style: TextStyle(
                                color: AppTheme.sacredGold,
                                fontSize: isSmall ? 9 : 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmall ? 8 : 10,
                      vertical: isSmall ? 4 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '₹${donation.amount.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: AppTheme.accentGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: isSmall ? 12 : 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatDate(donation.date),
                    style: TextStyle(
                      color: AppTheme.dynamicTextMuted(context),
                      fontSize: isSmall ? 9 : 10,
                    ),
                  ),
                ],
              ),
              SizedBox(width: isSmall ? 4 : 8),
              if (canEdit)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditDialog(context, donation);
                    } else if (value == 'status') {
                      _showStatusDialog(context, donation);
                    } else if (value == 'delete') {
                      _showDeleteDialog(context, donation);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_rounded,
                              color: AppTheme.accentCyan, size: 18),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.edit),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'status',
                      child: Row(
                        children: [
                          const Icon(Icons.sync_rounded,
                              color: AppTheme.sacredGold, size: 18),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!
                              .donationsChangeStatus),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_rounded,
                              color: AppTheme.accentRed),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.delete),
                        ],
                      ),
                    ),
                  ],
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: AppTheme.dynamicTextMuted(context),
                    size: isSmall ? 18 : 22,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppTheme.accentGreen;
      case 'confirmed':
        return AppTheme.accentCyan;
      case 'pending':
        return AppTheme.sacredGold;
      case 'failed':
        return AppTheme.accentRed;
      default:
        return AppTheme.dynamicTextMuted(context);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _dateStart != null && _dateEnd != null
          ? DateTimeRange(start: _dateStart!, end: _dateEnd!)
          : null,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: AppTheme.sacredGold,
                    onPrimary: Colors.white,
                    surface: AppTheme.cardBackground,
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: AppTheme.sacredGold,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Color(0xFF1A1A2E),
                  ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateStart = picked.start;
        _dateEnd = picked.end;
      });
    }
  }

  void _showEditDialog(BuildContext context, Donation donation) {
    final nameController = TextEditingController(text: donation.name);
    final locationController = TextEditingController(text: donation.location);
    final amountController =
        TextEditingController(text: donation.amount.toStringAsFixed(0));
    final phoneController = TextEditingController(text: donation.phone ?? '');
    final emailController = TextEditingController(text: donation.email ?? '');
    String selectedPurpose = donation.purpose;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.dynamicCardBg(context),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentCyan.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.edit_rounded,
                    color: AppTheme.accentCyan, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.donationsEditTitle,
                style: TextStyle(
                    color: AppTheme.dynamicTextPrimary(context),
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogTextField(
                    controller: nameController,
                    label: AppLocalizations.of(context)!.donorNameLabel,
                    icon: Icons.person_outline,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  _dialogTextField(
                    controller: locationController,
                    label: AppLocalizations.of(context)!.donorLocationLabel,
                    icon: Icons.location_on_outlined,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  _dialogTextField(
                    controller: amountController,
                    label: AppLocalizations.of(context)!.donationAmountLabel,
                    icon: Icons.currency_rupee,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (double.tryParse(v) == null) {
                        return 'Invalid amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _dialogTextField(
                    controller: phoneController,
                    label: AppLocalizations.of(context)!.donorPhoneLabel,
                    icon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: 12),
                  _dialogTextField(
                    controller: emailController,
                    label: AppLocalizations.of(context)!.donorEmailLabel,
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedPurpose,
                    dropdownColor: AppTheme.dynamicCardBg(context),
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.donationPurposeLabel,
                      labelStyle:
                          TextStyle(color: AppTheme.dynamicTextMuted(context)),
                      filled: true,
                      fillColor: AppTheme.dynamicOverlay(context, alpha: 0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style:
                        TextStyle(color: AppTheme.dynamicTextPrimary(context)),
                    items: Donation.purposes
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(() => selectedPurpose = v);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(AppLocalizations.of(context)!.cancel,
                  style: TextStyle(color: AppTheme.dynamicTextMuted(context))),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final updated = donation.copyWith(
                    name: nameController.text.trim(),
                    location: locationController.text.trim(),
                    amount: double.parse(amountController.text),
                    phone: phoneController.text.isNotEmpty
                        ? phoneController.text.trim()
                        : null,
                    email: emailController.text.isNotEmpty
                        ? emailController.text.trim()
                        : null,
                    purpose: selectedPurpose,
                  );
                  context.read<DataService>().updateDonation(updated);
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(AppLocalizations.of(context)!
                            .donationsUpdatedSnackbar)),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentCyan,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(AppLocalizations.of(context)!.save,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusDialog(BuildContext context, Donation donation) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.dynamicCardBg(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.sacredGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.sync_rounded,
                  color: AppTheme.sacredGold, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              AppLocalizations.of(context)!.donationsChangeStatus,
              style: TextStyle(
                  color: AppTheme.dynamicTextPrimary(context),
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Donation.statuses
              .map((status) => ListTile(
                    leading: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: Text(status,
                        style: TextStyle(
                            color: AppTheme.dynamicTextPrimary(context))),
                    trailing: donation.status == status
                        ? const Icon(Icons.check_rounded,
                            color: AppTheme.sacredGold)
                        : null,
                    onTap: () {
                      final updated = donation.copyWith(status: status);
                      context.read<DataService>().updateDonation(updated);
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(AppLocalizations.of(context)!
                                .donationsStatusUpdated(status))),
                      );
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Donation donation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.dynamicCardBg(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(AppLocalizations.of(context)!.donationsDeleteDialogTitle),
        content: Text(AppLocalizations.of(context)!
            .donationsDeleteConfirmMessage(donation.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<DataService>().deleteDonation(donation.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(AppLocalizations.of(context)!
                        .donationsDeletedSnackbar)),
              );
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

  Future<void> _exportCsv(
      BuildContext context, List<Donation> donations) async {
    if (donations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context)!.donationsNoDataToExport)),
      );
      return;
    }

    final header = [
      'ID',
      'Name',
      'Location',
      'Amount',
      'Date',
      'Phone',
      'Email',
      'Status',
      'Payment Method',
      'Purpose',
    ];

    final rows = donations.map((d) => [
          d.id,
          d.name,
          d.location,
          d.amount.toStringAsFixed(2),
          d.date.toIso8601String(),
          d.phone ?? '',
          d.email ?? '',
          d.status,
          d.paymentMethod,
          d.purpose,
        ]);

    final csvData = const ListToCsvConverter().convert([header, ...rows]);

    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final file = File('${directory.path}/donations_$timestamp.csv');
      await file.writeAsString(csvData);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!
                .donationsExportSuccess(file.path)),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.donationsExportFailed)),
        );
      }
    }
  }

  Widget _dialogTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style:
          TextStyle(color: AppTheme.dynamicTextPrimary(context), fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            TextStyle(color: AppTheme.dynamicTextMuted(context), fontSize: 13),
        prefixIcon:
            Icon(icon, color: AppTheme.dynamicTextMuted(context), size: 20),
        filled: true,
        fillColor: AppTheme.dynamicOverlay(context, alpha: 0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}
