/// *Database Helper using Google Firebase*

/// Import third-party packages for access to Google Firebase and Firebase Storage
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Database {
  /// Create [notesCollection] to reference to [notes] collection in Firebase
  final CollectionReference notesCollection =
      Firestore.instance.collection('notes');

  /// Function to add notes comprising of title, body and audio file to database
  Future<void> uploadingNote(String title, String body, {voiceFile}) async {
    if (voiceFile == null) {
      /// Add the components of the note with the date and timestamp
      await notesCollection.add({
        'body': body,
        'title': title,
        "timeStamp": DateFormat.yMMMd().format(DateTime.now())
      });
    } else {
      /// Define local variable [ref] to create an instance in Firebase Storage
      StorageReference ref = FirebaseStorage.instance
      /// Reference [audio_file] and the filename
          .ref()
          .child("audio_file")
          .child(DateTime.now().millisecondsSinceEpoch.toString() + ".m4a");
      /// Upload the audio file
      StorageUploadTask uploadTask = ref.putFile(File(voiceFile.path));
      /// Upon completion
      await (await uploadTask.onComplete)
          .ref
          /// Obtain download URL from Firebase storage, then
          .getDownloadURL()
          .then((voiceFileUrl) async {
        /// Add this URL to the notes collection in the Firebase Database
        await notesCollection.add({
          'body': body,
          'title': title,
          "audio_file_url": voiceFileUrl.toString(),
          "audio_duration": voiceFile?.duration.toString().substring(0, 7)
        });
      });
    }
  }

  /// Retrieve notes stored in database
  Future getNotes() async {
    List<DocumentSnapshot> notes = [];
    QuerySnapshot querySnapshot = await notesCollection.getDocuments();
    /// For statement to display notes based on however many exist in the database
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      notes.add(a);
    }
    return notes;
  }

  /// Function to update notes stored in the database
  Future editNote(uid, title, body) async {
    await notesCollection
        /// Refer to note to be updated by the unique ID
        .document(uid)
        .updateData({'title': title, 'body': body});
  }

  /// Delete note from database
  Future deleteNote(uid) async {
    /// Delete referencing the unique ID
    await notesCollection.document(uid).delete();
  }
}
