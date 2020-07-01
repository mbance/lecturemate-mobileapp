/// Import third-party packages
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lecturemate/bloc/bloc_record.dart';
import 'package:provider/provider.dart';

class PlayVoice extends StatefulWidget {
  /// Define variables for the purpose of audio playback
  final String pathAudioUrl;
  final String duration;

  const PlayVoice({Key key, this.pathAudioUrl, this.duration})
      : super(key: key);

  @override
  _PlayVoiceState createState() => _PlayVoiceState();
}

class _PlayVoiceState extends State<PlayVoice> {
  /// Create instance of [audioPlayer] and its associated variables
  AudioPlayer audioPlayer;
  bool _isPlaying = false;
  Duration duration;

  ///Initialise [AudioPlayer]
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  /// Dispose of (/stop) audio playback
  @override
  void dispose() {
    super.dispose();
    audioPlayer?.dispose();
  }

  /// Build UI
  @override
  Widget build(BuildContext context) {
    final blocData = Provider.of<MuRecordBloc>(context);
    Orientation orien = MediaQuery.of(context).orientation;
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    bool screen = orien == Orientation.portrait ? true : false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('LectureMate | Playback Recording'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              decoration: /// Center position on screen
                  BoxDecoration(borderRadius: BorderRadius.circular(100)),
              width: screen ? w * .5 : h * .5,
              child: MaterialButton(
                onPressed: () {
                  if (_isPlaying) {
                    setState(() {
                      _isPlaying = false;
                      audioPlayer.pause();
                    });
                  } else {
                    setState(() {
                      /// Set [_isPLaying] to true and play audio recording retrieved from path
                      _isPlaying = true;
                      audioPlayer.play(
                          blocData.recordingDone != null
                              ? blocData.recordingDone.path
                              : widget.pathAudioUrl,
                          isLocal:
                              blocData.recordingDone != null ? true : false);
                      audioPlayer.onAudioPositionChanged.listen((Duration d) {
                        print('Max duration: $d'); /// Show duration of recording
                        setState(() => duration = d);
                        if (duration != null &&
                            duration.toString().substring(0, 7) ==
                                (blocData.recordingDone != null
                                    ? blocData.recordingDone?.duration /// Once complete, append final duration
                                        .toString()
                                        .substring(0, 7)
                                    : widget.duration)) {
                          setState(() {
                            duration = null;
                            _isPlaying = false;
                            audioPlayer.stop(); /// Stop recording
                          });
                        }
                      });
                    });
                  }
                },
                child: Icon(
                  _isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  size: 50,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}