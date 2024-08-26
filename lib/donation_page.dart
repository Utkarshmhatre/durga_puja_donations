import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

class DonationPage extends StatefulWidget {
  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make a Donation'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Enter your name'),
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Enter your location'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String name = nameController.text;
                  String location = locationController.text;
                  if (name.isNotEmpty && location.isNotEmpty) {
                    bool success = await _generateImage(name, location);
                    if (success) {
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Invitation image generated."),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Failed to generate image."),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please fill in your details."),
                      ),
                    );
                  }
                },
                child: Text('Generate Invitation'),
              ),
              SizedBox(height: 20),
              if (imageBytes != null)
                Image.memory(imageBytes!)
              else
                Text('No image generated yet.'),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _generateImage(String name, String location) async {
    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, 600, 800));

      // Create a gradient background
      final gradient = ui.Gradient.linear(
        Offset(0, 0),
        Offset(600, 800),
        [Colors.blueAccent, Colors.purpleAccent],
      );
      final paint = Paint()..shader = gradient;
      canvas.drawRect(Rect.fromLTWH(0, 0, 600, 800), paint);

      // Draw top image
      final imageProvider = AssetImage('assets/events.jpg');
      final image = await _loadImage(imageProvider);
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromLTWH(0, 0, 600, 200),
        Paint(),
      );

      // Draw text
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'Invitation to Durga Puja\n\n'
              'Dear $name,\n\n'
              'We are delighted to invite you to our Durga Puja celebrations.\n'
              'Your presence will make the event even more special.\n\n'
              'Location: $location\n\n'
              'Thank you for your support and we look forward to celebrating with you!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily:
                'Arial', // Ensure this font is available or use the default system font
          ),
        ),
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(maxWidth: 580);
      textPainter.paint(canvas, Offset(10, 210));

      final picture = recorder.endRecording();
      final img = await picture.toImage(600, 800);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      imageBytes = byteData!.buffer.asUint8List();

      return true;
    } catch (e) {
      print("Error generating image: $e");
      return false;
    }
  }

  Future<ui.Image> _loadImage(ImageProvider imageProvider) async {
    final completer = Completer<ui.Image>();
    final imageStream = imageProvider.resolve(ImageConfiguration.empty);
    final listener =
        ImageStreamListener((ImageInfo image, bool synchronousCall) {
      completer.complete(image.image);
    });
    imageStream.addListener(listener);
    return completer.future;
  }
}
