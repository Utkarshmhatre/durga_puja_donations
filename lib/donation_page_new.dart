import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:provider/provider.dart';

import 'models/donation.dart';
import 'services/data_service.dart';
import 'src/localization/app_localizations.dart';
import 'utils/theme.dart';
import 'widgets/backgrounds/themed_background.dart';
import 'widgets/common_widgets.dart';

class DonationPageNew extends StatefulWidget {
  const DonationPageNew({super.key});

  @override
  State<DonationPageNew> createState() => _DonationPageNewState();
}

class _DonationPageNewState extends State<DonationPageNew>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _customAmountController = TextEditingController();

  int? _selectedAmount;
  bool _isProcessing = false;
  String _result = '';
  final String environmentValue = 'SANDBOX';
  final String appId = '';
  final String merchantId = 'PGTESTPAYUAT115';
  final bool enableLogging = true;
  final String saltKey = 'f94f0bb9-bcfb-4077-adc0-3f8408a17bf7';
  final String saltIndex = '1';
  final String apiEndPoint = "/pg/v1/pay";
  String body = '';
  String callback = '';
  String checksum = '';
  String packageName = '';

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _initPayment();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _customAmountController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initPayment() async {
    try {
      await PhonePePaymentSdk.init(
        environmentValue,
        appId,
        merchantId,
        enableLogging,
      );
    } catch (error) {
      _handleError(error);
    }
  }

  String _buildEncodedBody(int amount) {
    final reqData = {
      "merchantId": merchantId,
      "merchantTransactionId": "MT${DateTime.now().millisecondsSinceEpoch}",
      "merchantUserId": "MUID${DateTime.now().millisecondsSinceEpoch}",
      "amount": amount * 100,
      "callbackUrl": callback,
      "mobileNumber": _phoneController.text.isNotEmpty
          ? _phoneController.text
          : "9999999999",
      "paymentInstrument": {"type": "PAY_PAGE"}
    };

    final base64body = base64.encode(utf8.encode(json.encode(reqData)));
    checksum =
        '${sha256.convert(utf8.encode(base64body + apiEndPoint + saltKey))}###$saltIndex';
    return base64body;
  }

  Future<void> _startTransaction(int amount) async {
    if (_nameController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty) {
      _showSnackBar(AppLocalizations.of(context)!.donationFillNameLocation,
          isError: true);
      return;
    }

    setState(() {
      _isProcessing = true;
      _result = '';
    });

    body = _buildEncodedBody(amount);

    try {
      final response = await PhonePePaymentSdk.startTransaction(
        body,
        callback,
        checksum,
        packageName,
      );

      if (!mounted) return;
      setState(() {
        _isProcessing = false;
      });

      if (response != null) {
        final status = response['status'].toString();
        if (status == 'SUCCESS') {
          _result = AppLocalizations.of(context)!.donationPaymentSuccessful;
          _saveDonation(amount.toDouble());
          _showSuccessDialog(amount);
        } else {
          _result = AppLocalizations.of(context)!.donationPaymentStatus(status);
          _showSnackBar(_result, isError: true);
        }
      }
    } catch (error) {
      _handleError(error);
    }
  }

  void _handleError(dynamic error) {
    if (!mounted) return;
    setState(() {
      _isProcessing = false;
      _result = error.toString();
    });
  }

  void _saveDonation(double amount) {
    final donation = Donation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      location: _locationController.text.trim(),
      amount: amount,
      date: DateTime.now(),
      phone: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
      email: _emailController.text.trim().isNotEmpty
          ? _emailController.text.trim()
          : null,
    );
    context.read<DataService>().addDonation(donation);
  }

  void _showSuccessDialog(int amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.accentGreen.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppTheme.accentGreen,
                size: 56,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.donationThankYou,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.donationReceived(amount),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppTheme.accentRed : AppTheme.accentGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                title: Text(AppLocalizations.of(context)!.donationPageTitle),
                centerTitle: true,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    GlassCard(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _nameController,
                              label: AppLocalizations.of(context)!
                                  .donationFullName,
                              icon: Icons.person_outline,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .donationNameValidation;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _locationController,
                              label: AppLocalizations.of(context)!
                                  .donationLocation,
                              icon: Icons.location_on_outlined,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .donationLocationValidation;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _phoneController,
                              label:
                                  AppLocalizations.of(context)!.donationPhone,
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _emailController,
                              label:
                                  AppLocalizations.of(context)!.donationEmail,
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.donationChooseAmount,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [101, 251, 501, 1001, 2001, 5001]
                                .map(_buildAmountButton)
                                .toList(),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: _customAmountController,
                                  label: AppLocalizations.of(context)!
                                      .donationCustomAmount,
                                  icon: Icons.currency_rupee,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      setState(() => _selectedAmount = null);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              GradientButton(
                                text: AppLocalizations.of(context)!
                                    .donationDonate,
                                icon: Icons.volunteer_activism,
                                isLoading: _isProcessing,
                                onPressed: _isProcessing
                                    ? null
                                    : () {
                                        final amount = int.tryParse(
                                          _customAmountController.text.trim(),
                                        );
                                        if (amount == null || amount <= 0) {
                                          _showSnackBar(
                                            AppLocalizations.of(context)!
                                                .donationEnterValidAmount,
                                            isError: true,
                                          );
                                          return;
                                        }
                                        _startTransaction(amount);
                                      },
                                colors: const [
                                  AppTheme.accentGreen,
                                  AppTheme.accentCyan,
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_selectedAmount != null)
                      GradientButton(
                        text: AppLocalizations.of(context)!
                            .donationDonateAmount(_selectedAmount!),
                        icon: Icons.volunteer_activism,
                        isLoading: _isProcessing,
                        width: double.infinity,
                        height: 56,
                        onPressed: _isProcessing
                            ? null
                            : () => _startTransaction(_selectedAmount!),
                        colors: const [
                          AppTheme.accentGreen,
                          AppTheme.accentCyan
                        ],
                      ),
                    if (_result.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _result.contains('Success')
                                ? AppTheme.accentGreen.withValues(alpha: 0.2)
                                : AppTheme.accentRed.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _result,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _result.contains('Success')
                                  ? AppTheme.accentGreen
                                  : AppTheme.accentRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.textSecondary),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
      ),
    );
  }

  Widget _buildAmountButton(int amount) {
    final isSelected = _selectedAmount == amount;
    return Semantics(
      button: true,
      selected: isSelected,
      label: 'Donate Rs. $amount${isSelected ? ', selected' : ''}',
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedAmount = amount;
            _customAmountController.clear();
          });
        },
        child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppTheme.vermillion, AppTheme.sacredGold],
                )
              : null,
          color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppTheme.vermillion
                : Colors.white.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.donationRsAmount(amount),
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    );
  }
}
