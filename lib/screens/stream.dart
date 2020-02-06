import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'package:url_audio_stream/url_audio_stream.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StreamingScreen extends StatefulWidget {
  @override
  _StreamingScreenState createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  String _platformVersion = 'Unknown';
  bool _isSongStarted = false;

  @override
  void initState() {
    super.initState();
    songsplaying();
  }

  Future<void> songsplaying() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool("_isSongStarted", false);
  }

  static AudioStream stream =
      new AudioStream("https://firebasestorage.googleapis.com/v0/b/music-player-54308.appspot.com/o/audio%2F01%20-%20Tujh%20Mein%20Rab%20Dikhta%20Hai.mp3?alt=media&token=ba95a7ae-7f4c-4630-b490-0ab882255413");
  Future<void> callAudio(String action) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSongStarted = prefs.getBool('_isSongStarted');
    if (action == "start") {
      if (!_isSongStarted) {
        prefs.setBool("_isSongStarted", true);

        stream.start();
      } else {
        prefs.setBool("_isSongStarted", true);

        Toast.show("Song Started", context);
      }
    } else if (action == "stop") {
      prefs.setBool("_isSongStarted", false);

      stream.stop();
    } else if (action == "pause") {
      stream.pause();
    } else {
      stream.resume();
    }
  }

  void getFirebaseImageFolder() {
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child('Songs');
    storageRef.listAll().then((result) {
      print("result is $result");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                side: BorderSide(color: Colors.black)),
            padding: EdgeInsets.only(left: 50, right: 50),
            textColor: Colors.black,
            child: Text('Start'),
            onPressed: () {
              // callAudio("start");
              // _getImageUrl();
              getFirebaseImageFolder();
            },
          ),
          FlatButton(
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                side: BorderSide(color: Colors.black)),
            padding: EdgeInsets.only(left: 50, right: 50),
            textColor: Colors.black,
            child: Text('Stop'),
            onPressed: () {
              callAudio("stop");
            },
          ),
          FlatButton(
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                side: BorderSide(color: Colors.black)),
            padding: EdgeInsets.only(left: 50, right: 50),
            textColor: Colors.black,
            child: Text('Pause'),
            onPressed: () {
              callAudio("pause");
            },
          ),
          FlatButton(
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                side: BorderSide(color: Colors.black)),
            padding: EdgeInsets.only(left: 50, right: 50),
            textColor: Colors.black,
            child: Text('Resume'),
            onPressed: () {
              callAudio("resume");
            },
          ),
        ],
      )),
    );
  }
}
