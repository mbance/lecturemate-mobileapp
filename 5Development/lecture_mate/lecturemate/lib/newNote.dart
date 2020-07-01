///import packages - material for UI and
///database to access the database helper

/// Import third-party packages
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

/// Import classes from package
import 'package:lecturemate/database.dart';
import 'package:lecturemate/voice_message.dart';
import 'bloc/bloc_record.dart';
import 'playback.dart';

/// New Abstract class [CreateNote]
class CreateNote extends StatefulWidget {
  @override
  _CreateNoteState createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  /// Final variables assigned to new instances of TextEditingControllers
  final title = new TextEditingController();
  final body = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String statusText = "";
  bool isComplete = false;
  bool uploading = false;
  bool _validate = false;

  /// Confirmation dialog for cancelling note
  Future<void> cancelDialog(ctx) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,

      /// User required to tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to cancel?'), //Confirmation text
              ],
            ),
          ),
          actions: <Widget>[
            //Action buttons
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<MuRecordBloc>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 30, bottom: 30),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                heroTag: null,
                backgroundColor: Colors.white,
                onPressed: uploading
                    ? null
                    : () {
                        if (_formKey.currentState.validate()) {
                          submit(bloc);
                        }
                      },
                label: Text(
                  uploading ? "Loading..." : "Save",
                  style: TextStyle(color: Colors.green),
                ),
                icon: Icon(Icons.save, color: Colors.green),
                elevation: 20.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 70, bottom: 30),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton.extended(
                heroTag: null,
                backgroundColor: Colors.white,
                onPressed: () {
                  cancelDialog(context);
                },
                label: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
                icon: Icon(Icons.cancel, color: Colors.red),
                elevation: 20.0,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.red,
          height: 50,
        ),
      ),
      appBar: AppBar(
        title: const Text('LectureMate | New Note'),
        centerTitle: true,
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        color: Color(0xa1ffffff)),
                    child: TextFormField(
                      controller: title,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Title',
                          errorText: _validate ? 'Value Can\'t Be Empty' : null,
                          fillColor: Colors.white,
                          focusColor: Colors.white),
                      validator: (s) {
                        if (s.isEmpty) return "Required*";
                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(9)),
                      color: Color(0xa1ffffff),
                    ),
                    child: TextFormField(
                      maxLines: 15,
                      controller: body,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Note',
                        errorText: _validate ? 'Value Can\'t Be Empty' : null,
                      ),
                      validator: (s) {
                        if (s.isEmpty) return "Required*";
                        return null;
                      },
                    ),
                  ),
                ),
                bloc.recordingDone == null
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.3),
                                  borderRadius: BorderRadius.circular(100)),
                              child: IconButton(
                                icon: Icon(
                                  Icons.audiotrack,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PlayVoice()));
                                },
                              ),
                            ),
                            Text(bloc.recordingDone.path

                                /// Display audio file name (path as String)
                                .toString()
                                .split('/')
                                .toList()
                                .elementAt(bloc.recordingDone.path
                                        .toString()
                                        .split('/')
                                        .toList()
                                        .length -
                                    1)
                                .toString()),
                            SizedBox(width: 185),
                            Text(bloc.recordingDone.duration

                                /// Duration of recording
                                .toString()
                                .substring(0, 7))
                          ],
                        ),
                      ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            height: 48.0,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(18.0)),
                            child: Center(
                              child: Icon(Icons.mic_none,
                                  color: Colors.white, size: 36),
//                            child: Icon(RecordMp3.instance.status == RecordStatus.PAUSE ? Icons.play_arrow : Icons.pause, color: Colors.white, size: 40,),
                            ),
                          ),
                          onTap: () {
//                          pauseRecord();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VoiceMessage()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  submit(blocc) async {
    /// Set state used to update uploading state boolean to true
    setState(() {
      uploading = true;
    });

    /// Stop synchronous execution and wait for result to return from Database
    await Database()
        //Upload title, body and audio recording to database
        .uploadingNote(title.text, body.text, voiceFile: blocc.recordingDone);
    //Upon completion, set state to false
    setState(() {
      uploading = false;
    });

    /// Clear recording from UI once uploaded and return to home
    blocc.clear();
    Navigator.pop(context);
  }
}
