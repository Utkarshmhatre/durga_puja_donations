import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/donation.dart';

abstract class DonationRepository {
  Future<List<Donation>> loadAll();
  Future<void> saveAll(List<Donation> donations);
}

class SharedPrefsDonationRepository implements DonationRepository {
  static const String _donationsKey = 'donations';

  @override
  Future<List<Donation>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final donationsJson = prefs.getString(_donationsKey);
    if (donationsJson == null || donationsJson.isEmpty) {
      return [];
    }

    final List<dynamic> donationsList = jsonDecode(donationsJson);
    return donationsList.map((d) => Donation.fromJson(d)).toList();
  }

  @override
  Future<void> saveAll(List<Donation> donations) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _donationsKey,
      jsonEncode(donations.map((d) => d.toJson()).toList()),
    );
  }
}
