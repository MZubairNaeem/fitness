import 'dart:io';

import 'package:coachingapp/models/videos.dart';
import 'package:coachingapp/utils/colors.dart';
import 'package:coachingapp/viewmodels/auth.dart';
import 'package:coachingapp/widgets/large_button_blue.dart';
import 'package:coachingapp/widgets/snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class UploadVideo extends StatefulWidget {
  const UploadVideo({Key? key}) : super(key: key);

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}
// Necessary variables

class _UploadVideoState extends State<UploadVideo> {
  // String? _path;
  // Map<String, String>? _paths;
  // String? _extension = 'mp4,avi,mov,mkv,flv,wmv';
  // FileType? _pickType;
  // bool _multiPick = true;
  // String filneCount = "";
  // GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  // List<UploadTask> _tasks = <UploadTask>[];

  // Future<bool> openFileExplorer() async {
  //   try {
  //     _path = null;
  //     final files = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowMultiple: true,
  //       allowedExtensions: (_extension?.isNotEmpty ?? false)
  //           ? _extension?.replaceAll(' ', '').split(',')
  //           : null,
  //     );
  //     if (files != null) {
  //       setState(() {
  //         _paths = Map.from(files.paths as Map);
  //       });
  //       log(_paths.toString());
  //       filneCount = _paths!.length.toString();
  //       log(filneCount.toString());
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } on PlatformException catch (e) {
  //     log("Unsupported operation $e");
  //     return false;
  //   }
  // }

  // void uploadToFirebase() {
  //   log(_paths.toString());
  //   _paths!.forEach((fileName, filePath) => {upload(fileName, filePath)});
  // }

  // void upload(fileName, filePath) {
  //   log(fileName);
  //   log(filePath);
  //   // Reference ref = FirebaseStorage.instance.ref().child(fileName);
  //   // UploadTask uploadTask = ref.putFile(File(filePath));
  //   // _tasks.add(uploadTask);
  // }
  final title = TextEditingController();
  final description = TextEditingController();
  List<File> videosforupload = [];
  Uint8List? thumbnail;
  bool _isLoading = false;
  Future<List<File>> pickFiles() async {
    List<File> videos = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: true,
    );

    if (result != null) {
      for (PlatformFile file in result.files) {
        String? path = file.path;
        if (path != null) {
          thumbnail = await VideoThumbnail.thumbnailData(
            video: path,
            imageFormat: ImageFormat.JPEG,
            maxWidth:
                128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
            quality: 25,
          );
          videos.add(File(path));
        }
      }
    }

    return videos;
  }

  Future<List<Video>> uploadVideos(List<File> videos) async {
    List<Video> downloadURLs = [];
    FirebaseStorage storage = FirebaseStorage.instance;

    for (int i = 0; i < videos.length; i++) {
      File videoFile = videos[i];
      String fileName = videoFile.path.split('/').last;
      Reference storageRef = storage.ref().child('videos/$fileName');
      UploadTask uploadTask = storageRef.putFile(videoFile);
      await uploadTask;
      String downloadURL = await storageRef.getDownloadURL();
      //String thumbnailPath = videoFile.path.replaceAll('.mp4', '.jpg');
      //File thumbnail = await generateThumbnail(videoFile.path, thumbnailPath);
      Video video = Video(
          videoId: DateTime.now().millisecondsSinceEpoch.toString(),
          videoTitle: title.text,
          videoDescription: description.text,
          videoUrl: downloadURL,
          videoThumbnail: downloadURL);

      Auth().StoreVideos(video);
      downloadURLs.add(video);
    }

    return downloadURLs;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Add Workout",

            style: TextStyle(color: AppColors().darKShadowColor),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.04, horizontal: screenWidth * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Title",
                  style: TextStyle(
                      color: AppColors().darKShadowColor, fontSize: 20),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              TextField(
                controller: title,
                decoration: InputDecoration(
                  hintText: 'Add a title eg: Warm up',
                  hintStyle: TextStyle(color: AppColors().darKShadowColor),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Upload Video",
                  style: TextStyle(
                      color: AppColors().darKShadowColor, fontSize: 20),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              thumbnail != null
                  ? Image.memory(
                      thumbnail!,
                      height: screenHeight * 0.2,
                      width: screenWidth * 0.2,
                    )
                  : Container(),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  // hintText: filneCount == ""
                  //     ? 'Select a video'
                  //     : 'You have selected $filneCount videos',
                  hintText: 'Select a video',
                  hintStyle: TextStyle(color: AppColors().darKShadowColor),
                  suffixIcon: GestureDetector(
                    onTap: () async {
                      List<File> videos = await pickFiles();
                      setState(() {
                        videosforupload = videos;
                      });
                    },
                    child: Icon(
                      Icons.play_circle,
                      color: AppColors().primaryColor,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Description",
                  style: TextStyle(
                      color: AppColors().darKShadowColor, fontSize: 20),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              TextField(
                controller: description,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'What training are you doing',
                  hintStyle: TextStyle(color: AppColors().darKShadowColor),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.1,
              ),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : LargeButton(
                      name: "Upload",
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        List<Video> downloadURLs =
                            await uploadVideos(videosforupload);

                        if (downloadURLs.length == videosforupload.length) {
                          setState(() {
                            _isLoading = false;
                          });
                          title.clear();
                          description.clear();
                          showSnackBar(context, "Upload complete");
                        }
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }
}