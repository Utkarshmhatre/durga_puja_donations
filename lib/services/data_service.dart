import 'package:flutter/material.dart';
import '../models/announcement.dart';
import '../models/donation.dart';
import '../models/event.dart';
import '../models/feedback.dart';
import '../models/gallery_item.dart';
import '../repositories/announcement_repository.dart';
import '../repositories/donation_repository.dart';
import '../repositories/event_repository.dart';
import '../repositories/feedback_repository.dart';
import '../repositories/gallery_repository.dart';
import '../repositories/storage_repository.dart';

class DataService extends ChangeNotifier {
  final DonationRepository _donationRepository;
  final EventRepository _eventRepository;
  final GalleryRepository _galleryRepository;
  final StorageRepository _storageRepository;
  final AnnouncementRepository _announcementRepository;
  final FeedbackRepository _feedbackRepository;

  List<Donation> _donations = [];
  List<Event> _events = [];
  List<GalleryItem> _galleryItems = [];
  List<Announcement> _announcements = [];
  List<VolunteerRegistration> _volunteers = [];
  List<UserFeedback> _feedbackList = [];

  /// Last error encountered during data operations, if any.
  String? _lastError;
  String? get lastError => _lastError;

  List<Donation> get donations => _donations;
  List<Event> get events => _events;
  List<GalleryItem> get galleryItems => _galleryItems;
  List<Announcement> get announcements => _announcements;
  List<VolunteerRegistration> get volunteers => _volunteers;
  List<UserFeedback> get feedbackList => _feedbackList;
  int get feedbackCount => _feedbackList.length;
  double get averageRating {
    if (_feedbackList.isEmpty) return 0;
    return _feedbackList.fold(0.0, (sum, f) => sum + f.rating) /
        _feedbackList.length;
  }

  // Stats getters
  double get totalDonations => _donations.fold(0, (sum, d) => sum + d.amount);
  double get totalAmount => totalDonations; // Alias
  int get donationCount => _donations.length;
  int get activeEventsCount => _events.where((e) => e.isActive).length;
  int get upcomingEventsCount =>
      _events.where((e) => e.isActive && e.date.isAfter(DateTime.now())).length;
  int get galleryCount => _galleryItems.where((g) => g.isActive).length;

  DataService({
    DonationRepository? donationRepository,
    EventRepository? eventRepository,
    GalleryRepository? galleryRepository,
    StorageRepository? storageRepository,
    AnnouncementRepository? announcementRepository,
    FeedbackRepository? feedbackRepository,
  })  : _donationRepository =
            donationRepository ?? SharedPrefsDonationRepository(),
        _eventRepository = eventRepository ?? SharedPrefsEventRepository(),
        _galleryRepository =
            galleryRepository ?? SharedPrefsGalleryRepository(),
        _storageRepository =
            storageRepository ?? SharedPrefsStorageRepository(),
        _announcementRepository =
            announcementRepository ?? SharedPrefsAnnouncementRepository(),
        _feedbackRepository =
            feedbackRepository ?? SharedPrefsFeedbackRepository() {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      await _storageRepository.ensureSchemaVersion();
      await _loadData();
      await _initializeSampleData();
    } catch (e, stack) {
      _lastError = 'Failed to initialize data: $e';
      debugPrint('[DataService] Bootstrap error: $e\n$stack');
      notifyListeners();
    }
  }

  // Public method to reload data
  Future<void> loadData() async {
    await _loadData();
  }

  Future<void> _loadData() async {
    try {
      _lastError = null;
      _donations = await _donationRepository.loadAll();
      _events = await _eventRepository.loadAll();
      _galleryItems = await _galleryRepository.loadAll();
      _announcements = await _announcementRepository.loadAll();
      _volunteers = await _announcementRepository.loadVolunteers();
      _feedbackList = await _feedbackRepository.loadAll();
      notifyListeners();
    } catch (e, stack) {
      _lastError = 'Failed to load data: $e';
      debugPrint('[DataService] Load error: $e\n$stack');
      notifyListeners();
    }
  }

  Future<void> _initializeSampleData() async {
    bool changed = false;

    if (_events.isEmpty) {
      _events = [
        Event(
          id: '1',
          title: 'Durga Puja Mahalaya',
          description:
              'The auspicious beginning of Durga Puja festivities with Mahalaya',
          date: DateTime(2026, 9, 20),
          location: 'Community Hall',
          category: 'religious',
        ),
        Event(
          id: '2',
          title: 'Cultural Night',
          description: 'An evening of traditional dance and music performances',
          date: DateTime(2026, 9, 25),
          location: 'Main Pandal',
          category: 'cultural',
        ),
        Event(
          id: '3',
          title: 'Community Service Day',
          description:
              'Join us in serving the community through various charitable activities',
          date: DateTime(2026, 9, 22),
          location: 'Local School',
          category: 'service',
        ),
        Event(
          id: '4',
          title: 'Dashami Visarjan',
          description: 'The grand immersion ceremony of Goddess Durga',
          date: DateTime(2026, 9, 30),
          location: 'River Ghat',
          category: 'religious',
        ),
      ];
      changed = true;
    }

    if (_galleryItems.isEmpty) {
      _galleryItems = [
        GalleryItem(
          id: '1',
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/4/49/Shades_of_Maa_Durga.jpg',
          title: 'Maa Durga',
          category: 'idol',
          uploadedAt: DateTime.now(),
        ),
        GalleryItem(
          id: '2',
          imageUrl:
              'https://i.pinimg.com/736x/5f/5f/f5/5f5ff50d5e8303e77fa182c6599cf2cd.jpg',
          title: 'Durga Puja Celebration',
          category: 'celebration',
          uploadedAt: DateTime.now(),
        ),
      ];
      changed = true;
    }

    if (changed) {
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> _saveData() async {
    try {
      await _donationRepository.saveAll(_donations);
      await _eventRepository.saveAll(_events);
      await _galleryRepository.saveAll(_galleryItems);
      await _announcementRepository.saveAll(_announcements);
      await _announcementRepository.saveVolunteers(_volunteers);
    } catch (e, stack) {
      _lastError = 'Failed to save data: $e';
      debugPrint('[DataService] Save error: $e\n$stack');
      notifyListeners();
    }
  }

  // Donation methods
  Future<void> addDonation(Donation donation) async {
    _donations.insert(0, donation);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateDonation(Donation donation) async {
    final index = _donations.indexWhere((d) => d.id == donation.id);
    if (index != -1) {
      _donations[index] = donation;
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> deleteDonation(String id) async {
    _donations.removeWhere((d) => d.id == id);
    await _saveData();
    notifyListeners();
  }

  List<Donation> getRecentDonations({int limit = 10}) {
    final sorted = List<Donation>.from(_donations)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }

  Map<String, double> getDonationsByMonth() {
    final Map<String, double> result = {};
    for (var donation in _donations) {
      final key =
          '${donation.date.year}-${donation.date.month.toString().padLeft(2, '0')}';
      result[key] = (result[key] ?? 0) + donation.amount;
    }
    return result;
  }

  // Event methods
  Future<void> addEvent(Event event) async {
    _events.add(event);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateEvent(Event event) async {
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String id) async {
    _events.removeWhere((e) => e.id == id);
    await _saveData();
    notifyListeners();
  }

  List<Event> getUpcomingEvents({int limit = 5}) {
    final now = DateTime.now();
    final upcoming = _events
        .where((e) => e.date.isAfter(now) && e.isActive)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return upcoming.take(limit).toList();
  }

  // Gallery methods
  Future<void> addGalleryItem(GalleryItem item) async {
    _galleryItems.add(item);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateGalleryItem(GalleryItem item) async {
    final index = _galleryItems.indexWhere((g) => g.id == item.id);
    if (index != -1) {
      _galleryItems[index] = item;
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> deleteGalleryItem(String id) async {
    _galleryItems.removeWhere((g) => g.id == id);
    await _saveData();
    notifyListeners();
  }

  List<GalleryItem> getGalleryByCategory(String category) {
    if (category == 'all') {
      return _galleryItems.where((g) => g.isActive).toList();
    }
    return _galleryItems
        .where((g) => g.category == category && g.isActive)
        .toList();
  }

  // Announcement methods
  Future<void> addAnnouncement(Announcement announcement) async {
    _announcements.insert(0, announcement);
    await _announcementRepository.saveAll(_announcements);
    notifyListeners();
  }

  Future<void> updateAnnouncement(Announcement announcement) async {
    final index = _announcements.indexWhere((a) => a.id == announcement.id);
    if (index != -1) {
      _announcements[index] = announcement;
      await _announcementRepository.saveAll(_announcements);
      notifyListeners();
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    _announcements.removeWhere((a) => a.id == id);
    await _announcementRepository.saveAll(_announcements);
    notifyListeners();
  }

  // Volunteer methods
  Future<void> addVolunteer(VolunteerRegistration volunteer) async {
    _volunteers.insert(0, volunteer);
    await _announcementRepository.saveVolunteers(_volunteers);
    notifyListeners();
  }

  Future<void> deleteVolunteer(String id) async {
    _volunteers.removeWhere((v) => v.id == id);
    await _announcementRepository.saveVolunteers(_volunteers);
    notifyListeners();
  }

  // Clear all data (for development)
  Future<void> clearAllData() async {
    _donations.clear();
    _events.clear();
    _galleryItems.clear();
    _announcements.clear();
    _volunteers.clear();
    _feedbackList.clear();
    await _saveData();
    await _storageRepository.ensureSchemaVersion();
    notifyListeners();
  }

  // Feedback methods
  Future<void> addFeedback(UserFeedback feedback) async {
    _feedbackList.insert(0, feedback);
    await _feedbackRepository.saveAll(_feedbackList);
    notifyListeners();
  }

  Future<void> deleteFeedback(String id) async {
    _feedbackList.removeWhere((f) => f.id == id);
    await _feedbackRepository.saveAll(_feedbackList);
    notifyListeners();
  }

  List<UserFeedback> getRecentFeedback({int limit = 10}) {
    final sorted = List<UserFeedback>.from(_feedbackList)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(limit).toList();
  }
}
