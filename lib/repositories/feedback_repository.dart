import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/feedback.dart';

abstract class FeedbackRepository {
  Future<List<UserFeedback>> loadAll();
  Future<void> saveAll(List<UserFeedback> items);
}

class SharedPrefsFeedbackRepository implements FeedbackRepository {
  static const _key = 'user_feedback';

  @override
  Future<List<UserFeedback>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final list = json.decode(raw) as List;
    return list
        .map((e) => UserFeedback.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveAll(List<UserFeedback> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      json.encode(items.map((e) => e.toJson()).toList()),
    );
  }
}
