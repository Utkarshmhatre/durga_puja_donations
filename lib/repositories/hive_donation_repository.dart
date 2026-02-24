import 'package:hive/hive.dart';
import '../models/donation.dart';
import 'donation_repository.dart';

class HiveDonationRepository implements DonationRepository {
  static const String boxName = 'donations';

  Box<Donation>? _box;

  Future<Box<Donation>> get _openBox async {
    _box ??= await Hive.openBox<Donation>(boxName);
    return _box!;
  }

  @override
  Future<List<Donation>> loadAll() async {
    final box = await _openBox;
    return box.values.toList();
  }

  @override
  Future<void> saveAll(List<Donation> donations) async {
    final box = await _openBox;
    await box.clear();
    final map = {for (var d in donations) d.id: d};
    await box.putAll(map);
  }

  Future<void> put(Donation donation) async {
    final box = await _openBox;
    await box.put(donation.id, donation);
  }

  Future<void> delete(String id) async {
    final box = await _openBox;
    await box.delete(id);
  }

  Future<Donation?> get(String id) async {
    final box = await _openBox;
    return box.get(id);
  }
}
