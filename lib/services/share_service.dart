import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/donation.dart';
import '../models/event.dart';
import '../models/gallery_item.dart';

class ShareService {
  /// Share a donation receipt as formatted text
  static Future<void> shareDonationReceipt(
    BuildContext context,
    Donation donation,
  ) async {
    final dateStr = DateFormat('dd MMM yyyy, hh:mm a').format(donation.date);
    final text = '''
🙏 Durga Puja Donation Receipt

Donor: ${donation.name}
Location: ${donation.location}
Amount: ₹${donation.amount.toStringAsFixed(0)}
Purpose: ${donation.purpose}
Date: $dateStr
Status: ${donation.status}
Transaction ID: ${donation.id}

Thank you for your generous contribution!
॥ শুভ দুর্গা পূজা ॥

— Durga Puja Committee
''';
    await Share.share(text);
  }

  /// Share an event as formatted text
  static Future<void> shareEvent(BuildContext context, Event event) async {
    final dateStr = DateFormat('EEEE, dd MMM yyyy').format(event.date);
    final text = '''
📅 Durga Puja Event

${event.title}
${event.description}

📍 ${event.location ?? 'TBD'}
🗓️ $dateStr
🏷️ ${event.category.toUpperCase()}

Join us for the celebrations!
॥ শুভ দুর্গা পূজা ॥
''';
    await Share.share(text);
  }

  /// Share a gallery image (text description with URL if available)
  static Future<void> shareGalleryItem(
    BuildContext context,
    GalleryItem item,
  ) async {
    final title = item.title ?? 'Durga Puja Gallery';
    final desc = item.description ?? '';
    final text = '''
📸 $title
${desc.isNotEmpty ? '\n$desc\n' : ''}
Category: ${item.category}

From the Durga Puja Gallery
॥ শুভ দুর্গা পূজা ॥
''';
    await Share.share(text);
  }

  /// Share a Puja greeting
  static Future<void> sharePujaGreeting(
    BuildContext context, {
    String? customMessage,
  }) async {
    final text = customMessage ??
        '''
🙏 শুভ দুর্গা পূজা 🙏

May Goddess Durga bless you and your family with happiness, prosperity, and good health.

Wishing you a wonderful Durga Puja 2026!

দেবী দুর্গা আপনার জীবনে সুখ, সমৃদ্ধি ও শান্তি নিয়ে আসুন।

🪔 শুভ বিজয়া দশমী 🪔
''';
    await Share.share(text);
  }

  /// Generate "Add to Calendar" URL for an event using url_launcher
  static String getCalendarUrl(Event event) {
    final start = event.date.toUtc();
    final end = start.add(const Duration(hours: 2));
    final dateFormat = DateFormat("yyyyMMdd'T'HHmmss'Z'");
    return 'https://www.google.com/calendar/render?action=TEMPLATE'
        '&text=${Uri.encodeComponent(event.title)}'
        '&dates=${dateFormat.format(start)}/${dateFormat.format(end)}'
        '&details=${Uri.encodeComponent(event.description)}'
        '&location=${Uri.encodeComponent(event.location ?? '')}'
        '&sf=true&output=xml';
  }
}
