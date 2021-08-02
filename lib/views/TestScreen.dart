/*
import 'dart:io';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class TestScreen extends StatefulWidget {
  TestScreenState createState() => TestScreenState();
}

class TestScreenState extends State<TestScreen> {
  CachedVideoPlayerController controller;
  File file;
  @override
  void initState() {
    // TODO: implement initState
//    getDownloads();
    super.initState();
    controller = CachedVideoPlayerController.file(File('/data/user/0/com.construction.oneroof/cache/libCachedImageData/06d2f900-f11c-11eb-af6f-f318943ea4fb.mp4'));
    controller.initialize().then((_) {
      setState(() {});
      controller.play();
    });
  }

  void getDownloads() async {
    var directory = await getTemporaryDirectory();
    DefaultCacheManager().getSingleFile('http://oneroofcm.com/e_learning/uploads/testing.mp4', key: 'test').then((value) {
      setState(() {
        file = File(value.path);
      });
      print("PPPPPPPPPPPPP ${value.path}");
    });
    print("PATH ${DefaultCacheManager().getSingleFile('http://oneroofcm.com/e_learning/uploads/testing.mp4', key: 'test')}");
    // print("PATH ${path.join(directory.path, 'test')}");
    */
/*controller = CachedVideoPlayerController.file(file);
    controller.initialize().then((_) {
      setState(() {});
      controller.play();
    });*/ /*

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          RaisedButton(onPressed: () {
            Stream<FileResponse> fileStream;
            setState(() {
              fileStream = DefaultCacheManager().getFileStream('http://oneroofcm.com/e_learning/uploads/testing.mp4', withProgress: true, key: 'test');
              getDownloads();
            });
          }),
          SizedBox(
            height: 50,
          ),
          Container(
              height: 400,
              width: 300,
              child: file != null
                  ? controller.value != null && controller.value.initialized
                      ? AspectRatio(
                          child: CachedVideoPlayer(controller),
                          aspectRatio: controller.value.aspectRatio,
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        )
                  : Container())
        ],
      )),
    );
  }
}
*/
