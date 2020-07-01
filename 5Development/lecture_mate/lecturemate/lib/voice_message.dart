/// Import third-party packages
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

/// Import class
import 'bloc/bloc_record.dart';

/// Initialise Voice Message State function
class VoiceMessage extends StatefulWidget {
  @override
  _VoiceMessageState createState() => _VoiceMessageState();
}

class _VoiceMessageState extends State<VoiceMessage> {
  /// Declare (private) variables
  bool _checkForStop = false;
  Random random = new Random();
  LocalFileSystem localFileSystem = LocalFileSystem();
  FlutterAudioRecorder _recorder;
  Timer _t;
  Recording _recording;

  /// Initialise state as the prepare function
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _prepare();
    });
  }

  /// Prepare audio recording prior, checking if the correct permissions have been allowed
  Future _prepare() async {
    var hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      await _init();
      var result = await _recorder.current();
      setState(() {
        _recording = result;
      });
      /// If so, begin recording
      await _startRecording();
    }
  }

  /// Begin recording, Flutter Audio Recorder start
  Future _startRecording() async {
    await _recorder.start();
    var current = await _recorder.current();
    setState(() {
      _recording = current;
    });
    _t = Timer.periodic(Duration(milliseconds: 10), (Timer t) async {
      var current = await _recorder.current();
      if (mounted)
        setState(() {
          _recording = current;
          _t = t;
        });
    });
  }

  /// Stop recording
  Future _stopRecording() async {
    var result = await _recorder.stop();
    _t.cancel();
    setState(() {
      _recording = result;
      _checkForStop = false;
    });
  }

  /// Save audio recording to local storage
  Future _init() async {
    String customPath = '/';
    Directory appDocDirectory;
    if (Platform.isIOS) {
      appDocDirectory = await getApplicationSupportDirectory();
    } else {
      print("android");
      appDocDirectory = await getExternalStorageDirectory();
      print(appDocDirectory.path);
    }
    // can add extension like ".mp4" ".wav" ".m4a" ".aac"
    customPath = appDocDirectory.path +
        customPath +
        DateTime.now().millisecondsSinceEpoch.toString();
    // .wav <---> AudioFormat.WAV
    // .mp4 .m4a .aac <---> AudioFormat.AAC
    // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
    _recorder = FlutterAudioRecorder(customPath,
        audioFormat: AudioFormat.AAC, sampleRate: 22050);
    await _recorder.initialized;
  }

  /// Build (UI)
  @override
  Widget build(BuildContext context) {
    final blocData = Provider.of<MuRecordBloc>(context);
    Orientation orien = MediaQuery.of(context).orientation;
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    bool screen = orien == Orientation.portrait ? true : false;
    return Scaffold(
      body: Container(
        width: w,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: screen ? w * .3 : h * .3,
                child: Icon(
                  Icons.mic,
                  color: Colors.red,
                ),
              ),
              Text("Recording..."),
              Text(
                '${_recording == null ? " " : _recording?.duration.toString().substring(0, 7) ?? "-"}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.stop,
                          color: Colors.red,
                        ),
                        onPressed: _checkForStop
                            ? null
                            : () async {
                                setState(() {
                                  _checkForStop = true;
                                });
                                await _stopRecording();
                                if (_checkForStop == false) {
                                  blocData.voiceMessage(_recording);
                                  Navigator.pop(context);
                                }
                              },
                      ),
                      Text("Stop"),
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(
                          Icons.bookmark_border,
                          color: Colors.yellow,
                        ),
                        onPressed: () {},
                      ),
                      Text("Bookmark"),
                    ]),
              ),
            ]),
      ),
    );
  }
}