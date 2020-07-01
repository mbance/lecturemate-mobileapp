/// Import third-party packages
import 'package:flutter/material.dart';
import 'package:lecturemate/database.dart';

/// Abstract class [EditNote]
class EditNote extends StatefulWidget {
  /// Define final variables
  final unique;
  final title;
  final body;
  final Function updateFunction;

  /// Create instance of [EditNote] using variables
  EditNote({this.unique, this.title, this.body, this.updateFunction});

  /// Create new State [_EditNoteState]
  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  /// Define variables to assign to [TextEditingController] and [_form]
  final title = new TextEditingController();
  final body = new TextEditingController();
  final _form = GlobalKey<FormState>();

  /// Delete Dialog Popup
  Future<void> deleteDialog(ctx) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, /// User required to tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this note?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Database().deleteNote(widget.unique); /// Upon button press, delete note from Database referencing unique ID
                Navigator.pop(ctx);
                Navigator.of(context).pop();
                widget.updateFunction();
              },
            ),
          ],
        );
      },
    );
  }

  /// Build UI
  @override
  Widget build(BuildContext context) {
    title.text = widget.title;
    body.text = widget.body;

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
                onPressed: () { /// Obtain [title] and [body] values from database for editing
                  if (_form.currentState.validate()) {
                    Database().editNote(widget.unique, title.text, body.text);
                    Navigator.pop(context);
                    widget.updateFunction();
                  }
                },
                label: Text(
                  "Save",
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
                  deleteDialog(context);
                },
                label: Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
                icon: Icon(Icons.delete, color: Colors.red),
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
        title: const Text('LectureMate | Edit Note'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _form,
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
                    ),
                    validator: (s) {
                      if (s.isEmpty) return "Required*";
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Submit edited and overwrite exising Note
  submit() {
    Database().uploadingNote(title.text, body.text);
    Navigator.pop(context);
  }

  /// Delete Note
  deleteData(uid) {
    Database().deleteNote(uid);
    Navigator.pop(context);
  }
}
