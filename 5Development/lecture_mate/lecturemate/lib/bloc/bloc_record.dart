/// Import third-party packages
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';

class MuRecordBloc extends ChangeNotifier {
  /// Define private variable, [_recordingDone]
  Recording _recordingDone;

  /// Create instance of [recordingDone]
  Recording get recordingDone => _recordingDone;

  ///
  void voiceMessage(Recording recording) {
    /// Set [_recordingDone] status to recording
    _recordingDone = recording;
    notifyListeners();
    /// Print the [path] to be displayed in the UI, once recording is complete
    print(_recordingDone.path
        .toString()
        .split('/')
        .toList()
        .elementAt(
            _recordingDone.path.toString().split('/').toList().length - 1)
        .toString());
  }

  /// Clear recording
  clear() {
    _recordingDone = null;
  }
}
