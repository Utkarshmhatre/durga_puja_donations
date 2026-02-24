import 'package:flutter_test/flutter_test.dart';
import 'package:durga_puja_donations/services/share_service.dart';
import 'package:durga_puja_donations/models/event.dart';

void main() {
  group('ShareService', () {
    group('getCalendarUrl', () {
      test('generates valid Google Calendar URL', () {
        final event = Event(
          id: 'e1',
          title: 'Ashtami Puja',
          description: 'Main puja ceremony',
          date: DateTime.utc(2026, 9, 27, 10, 0),
          location: 'Pandal Ground',
        );

        final url = ShareService.getCalendarUrl(event);

        expect(url, contains('https://www.google.com/calendar/render'));
        expect(url, contains('action=TEMPLATE'));
        expect(url, contains('text='));
        expect(url, contains(Uri.encodeComponent('Ashtami Puja')));
        expect(url, contains(Uri.encodeComponent('Main puja ceremony')));
        expect(url, contains(Uri.encodeComponent('Pandal Ground')));
      });

      test('handles event without location', () {
        final event = Event(
          id: 'e2',
          title: 'Cultural Program',
          description: 'Dance performance',
          date: DateTime.utc(2026, 9, 28, 18, 0),
        );

        final url = ShareService.getCalendarUrl(event);

        expect(url, contains('https://www.google.com/calendar/render'));
        expect(url, contains(Uri.encodeComponent('Cultural Program')));
        expect(url, contains('location='));
      });

      test('encodes special characters in title', () {
        final event = Event(
          id: 'e3',
          title: 'Sandhi Puja & Aarti',
          description: 'Special ceremony',
          date: DateTime.utc(2026, 9, 27, 23, 0),
        );

        final url = ShareService.getCalendarUrl(event);

        expect(url, contains(Uri.encodeComponent('Sandhi Puja & Aarti')));
      });

      test('sets 2-hour duration', () {
        final event = Event(
          id: 'e4',
          title: 'Test Event',
          description: 'Test',
          date: DateTime.utc(2026, 9, 25, 10, 0),
        );

        final url = ShareService.getCalendarUrl(event);

        // The URL should contain both start and end dates separated by /
        expect(url, contains('dates='));
        // Start: 20260925T100000Z, End: 20260925T120000Z (2 hours later)
        expect(url, contains('20260925T100000Z'));
        expect(url, contains('20260925T120000Z'));
      });
    });
  });
}
