import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'full_image_screen.dart';  // Make sure the import path is correct

class Downloaded extends StatefulWidget {
  const Downloaded({Key? key});

  @override
  State<Downloaded> createState() => _DownloadedState();
}

class _DownloadedState extends State<Downloaded> {
  List<File> downloadedImages = []; // List to store downloaded images

  @override
  void initState() {
    super.initState();
    loadDownloadedImages(); // Load downloaded images when the screen initializes
  }

  Future<void> loadDownloadedImages() async {
    // Directory path where images are downloaded
    Directory directory = Directory('/data/user/0/com.example.catsnap/app_flutter/');
    if (!await directory.exists()) {
      return; // Return if directory doesn't exist
    }
    // Get list of files in the directory
    List<FileSystemEntity> files = directory.listSync();
    // Filter out only image files (you can customize the check based on file extensions)
    List<File> images = files.where((file) => file.path.endsWith('.jpeg')).map<File>((file) => File(file.path)).toList();
    setState(() {
      downloadedImages = images; // Update the state with downloaded images
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Downloaded Wallpapers'),
      ),
      body: downloadedImages.isEmpty
          ? Center(child: Text('No images downloaded yet', style: TextStyle(color: Colors.white)))
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
              itemCount: downloadedImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to full screen view
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FullImage(imageUrl: downloadedImages[index].path, photoGrapher_name: "Unknown", isLocal: true),
                      ),
                    );
                  },
                  child: Image.file(downloadedImages[index]), // Display downloaded images
                );
              },
            ),
    );
  }
}
