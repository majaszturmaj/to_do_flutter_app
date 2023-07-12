import 'package:flutter/material.dart';

import '../classes/Note.dart';

class NoteListWidget extends StatefulWidget {
  @override
  _NoteListWidgetState createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends State<NoteListWidget> {
  NoteManager noteManager = NoteManager('assets/notes.json');

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    noteManager.loadNotesFromFile();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Note> notes = noteManager.notes;

    if (notes.isEmpty) {
      return Center(
        child: Text(
          'No notes here: add one by clicking "+" button',
          style: TextStyle(fontSize: 18.0),
        ),
      );
    }

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(note.title),
        );
      },
    );
  }
}
