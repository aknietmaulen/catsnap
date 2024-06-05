import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class FullImage extends StatefulWidget {
  final String photoGrapher_name;
  final String imageUrl;
  final bool isLocal;

  FullImage({Key? key, required this.imageUrl, required this.photoGrapher_name, this.isLocal = false}) : super(key: key);

  @override
  _FullImageState createState() => _FullImageState();
}

class _FullImageState extends State<FullImage> {
  bool isDownloaded = false;
  late String filePath;

  @override
  void initState() {
    super.initState();
    checkIfDownloaded();
  }

  Future<void> checkIfDownloaded() async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = Uri.parse(widget.imageUrl).pathSegments.last;
    filePath = '${directory.path}/$fileName';

    if (await File(filePath).exists()) {
      setState(() {
        isDownloaded = true;
      });
    }
  }

  Future<void> downloadImage(BuildContext context) async {
    // Check if permission is granted
    PermissionStatus status = await Permission.storage.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Storage permission is required to download the image.'),
        ),
      );
      return;
    }

    try {
      final response = await http.get(Uri.parse(widget.imageUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        await File(filePath).writeAsBytes(bytes);
        setState(() {
          isDownloaded = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image downloaded to: $filePath'),
          ),
        );
      } else {
        print('Download failed with status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image download failed!'),
          ),
        );
      }
    } catch (error) {
      print('Error downloading image: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while downloading the image.'),
        ),
      );
    }
  }

  Future<void> setWallpaper(BuildContext context) async {
    PermissionStatus status = await Permission.storage.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Storage permission is required to set wallpaper.'),
        ),
      );
      return;
    }

    try {
      if (!widget.isLocal && !isDownloaded) {
        final response = await http.get(Uri.parse(widget.imageUrl));
        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;
          await File(filePath).writeAsBytes(bytes);
          setState(() {
            isDownloaded = true;
          });
        } else {
          print('Download failed with status code: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image download failed!'),
            ),
          );
          return;
        }
      }

      final result = await WallpaperManager.setWallpaperFromFile(filePath, WallpaperManager.HOME_SCREEN);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wallpaper set successfully!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to set wallpaper!'),
          ),
        );
      }
    } catch (error) {
      print('Error setting wallpaper: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while setting the wallpaper.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Center(
          child: Text('Photo by ${widget.photoGrapher_name}'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              child: widget.isLocal
                  ? Image.file(File(widget.imageUrl), fit: BoxFit.fill)
                  : Image.network(widget.imageUrl, fit: BoxFit.fill),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isDownloaded
                    ? null
                    : () {
                        downloadImage(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDownloaded ? const Color.fromARGB(255, 168, 243, 170) : const Color.fromARGB(255, 152, 207, 252),
                ),
                child: Row(
                  children: [
                    Icon(Icons.download, color: Colors.black),
                    SizedBox(width: 5),
                    Text(isDownloaded ? 'Downloaded' : 'Download', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  setWallpaper(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.wallpaper, color: Colors.black),
                    SizedBox(width: 5),
                    Text('Set as Wallpaper', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
