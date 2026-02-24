import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:io';

import 'package:durga_puja_donations/repositories/hive_adapters.dart';
import 'package:durga_puja_donations/repositories/hive_donation_repository.dart';
import 'package:durga_puja_donations/models/donation.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_donation_test_');
    Hive.init(tempDir.path);
    registerHiveAdapters();
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  setUp(() async {
    // Clean up any open boxes between tests
    if (Hive.isBoxOpen(HiveDonationRepository.boxName)) {
      await Hive.box<Donation>(HiveDonationRepository.boxName).clear();
    }
  });

  group('HiveDonationRepository', () {
    test('loadAll returns empty list when no data', () async {
      final repo = HiveDonationRepository();
      final result = await repo.loadAll();
      expect(result, isEmpty);
    });

    test('saveAll and loadAll roundtrip', () async {
      final repo = HiveDonationRepository();
      final donations = [
        Donation(
          id: 'd1',
          name: 'Bikash',
          location: 'Kolkata',
          amount: 500,
          date: DateTime(2026, 9, 20),
          purpose: 'Bhog (Food)',
          status: 'confirmed',
        ),
        Donation(
          id: 'd2',
          name: 'Anjali',
          location: 'Mumbai',
          amount: 1000,
          date: DateTime(2026, 9, 21),
          purpose: 'Pandal Decoration',
          status: 'completed',
        ),
      ];

      await repo.saveAll(donations);
      final loaded = await repo.loadAll();

      expect(loaded.length, 2);
      expect(loaded[0].id, 'd1');
      expect(loaded[0].name, 'Bikash');
      expect(loaded[0].amount, 500);
      expect(loaded[0].purpose, 'Bhog (Food)');
      expect(loaded[1].id, 'd2');
      expect(loaded[1].name, 'Anjali');
      expect(loaded[1].amount, 1000);
    });

    test('put adds individual donation', () async {
      final repo = HiveDonationRepository();
      final donation = Donation(
        id: 'd3',
        name: 'Ravi',
        location: 'Delhi',
        amount: 750,
        date: DateTime(2026, 9, 22),
      );

      await repo.put(donation);
      final result = await repo.get('d3');

      expect(result, isNotNull);
      expect(result!.name, 'Ravi');
      expect(result.amount, 750);
    });

    test('delete removes a donation by id', () async {
      final repo = HiveDonationRepository();
      await repo.put(Donation(
        id: 'del1',
        name: 'Test',
        location: 'Test',
        amount: 100,
        date: DateTime.now(),
      ));

      await repo.delete('del1');
      final result = await repo.get('del1');
      expect(result, isNull);
    });

    test('saveAll overwrites previous data', () async {
      final repo = HiveDonationRepository();
      await repo.saveAll([
        Donation(
            id: 'old',
            name: 'Old',
            location: 'A',
            amount: 1,
            date: DateTime.now()),
      ]);
      await repo.saveAll([
        Donation(
            id: 'new',
            name: 'New',
            location: 'B',
            amount: 2,
            date: DateTime.now()),
      ]);

      final loaded = await repo.loadAll();
      expect(loaded.length, 1);
      expect(loaded[0].id, 'new');
    });

    test('preserves optional fields (phone, email)', () async {
      final repo = HiveDonationRepository();
      final donation = Donation(
        id: 'opt1',
        name: 'Test',
        location: 'Here',
        amount: 500,
        date: DateTime(2026, 9, 25),
        phone: '9876543210',
        email: 'test@example.com',
      );

      await repo.put(donation);
      final result = await repo.get('opt1');

      expect(result!.phone, '9876543210');
      expect(result.email, 'test@example.com');
    });
  });
}
