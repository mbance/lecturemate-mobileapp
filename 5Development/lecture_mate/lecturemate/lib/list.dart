/// Import third-party packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Import classes from package
import 'package:lecturemate/bloc/bloc_record.dart';
import 'package:lecturemate/database.dart';
import 'package:lecturemate/editNote.dart';
import 'playback.dart';

/// New abstract class [ListNotes]
class ListNotes extends StatefulWidget {
  @override
  /// New state [_ListNotesState]
  _ListNotesState createState() => _ListNotesState();
}

class _ListNotesState extends State<ListNotes> {
  /// New list data structure containing snapshot of documents from Firebase Database as an array
  List<DocumentSnapshot> notes = [];

  @override
  void initState() {
    super.initState();
    /// Retrieve notes
    Database().getNotes().then((onValue) {
      setState(() {
        notes = onValue;
      });
    });
    super.initState();
  }

  /// Update list of notes
  updateList() {
    Database().getNotes().then((onValue) {
      setState(() {
        notes = onValue;
      });
    });
  }

  /// Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('LectureMate | View Notes'),
          centerTitle: true,
          backgroundColor: Colors.grey,
        ),
        body: new ListView.builder(
            itemCount: notes.length,
            itemBuilder: (BuildContext context, int index) {
              //return notes[index];
              var title = notes[index].data["title"];
              var body = notes[index].data["body"];
              var pathVoice = notes[index].data["audio_file_url"];
              var duration = notes[index].data["audio_duration"];
              var uid = notes[index].documentID;
              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new ListTile(
                      title: Text(title),
                      subtitle: Text(body),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('EDIT'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditNote(
                                        title: title,
                                        body: body,
                                        unique: uid,
                                        updateFunction: updateList,
                                      )),
                            );
                          },
                        ),
                        FlatButton(
                          child: const Text('LISTEN'),
                          onPressed: () {
                            /* ... */
                            Provider.of<MuRecordBloc>(context, listen: false)
                                .clear();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (contex) => PlayVoice(
                                          pathAudioUrl: pathVoice,
                                          duration: duration,
                                        )));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }));
  }
}
