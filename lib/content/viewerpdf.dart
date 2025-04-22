import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class PDFViewerPage extends StatelessWidget {
  final String url;

  PDFViewerPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: downloadAndSavePdf(url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading PDF: ${snapshot.error}",
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          } else if (snapshot.hasData) {
            final filePath = snapshot.data!;
            print("FilePath: " + filePath);
            return PDFView(
              filePath: filePath,
              enableSwipe: true,
              swipeHorizontal: false, // false for vertical swipe
              autoSpacing: true,
              pageFling: true,
              fitPolicy: FitPolicy.WIDTH, // Try different fit policies
              onRender: (pages) {
                print("PDF Rendered with $pages pages");
              },
              onViewCreated: (controller) {
                controller.setPage(0); // Start at the first page
              },
              onError: (error) {
                print("PDFView Error: $error");
              },
              onPageChanged: (page, total) {
                print("Page changed: $page / $total");
              },
            );
          } else {
            return Center(child: Text("Unknown error occurred"));
          }
        },
      );
  }

  String convertToDirectDownloadLink(String googleDriveViewLink) {
    // If the link is a Google Drive link, handle it accordingly
    return googleDriveViewLink;
  }

  Future<String> downloadAndSavePdf(String url) async {
    try {
      url = convertToDirectDownloadLink(url);
      print("URL: " + url);
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/downloaded.pdf');

        print("Saving PDF to: ${file.path}");
        await file.writeAsBytes(bytes);
        print("PDF saved successfully.");
        return file.path;
      } else {
        throw Exception("Failed to download PDF. HTTP Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error downloading PDF: $e");
      rethrow;
    }
  }
}
