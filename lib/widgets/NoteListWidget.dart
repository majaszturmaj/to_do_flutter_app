import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../classes/Note.dart';

class NoteListWidget extends StatefulWidget {
  @override
  _NoteListWidgetState createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends State<NoteListWidget> {
  List _notes = [];
  // NoteManager noteManager = NoteManager('lib/assets/notes.json');

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('lib/assets/notes.json');
    final data = await json.decode(response);
    setState(() {
      _notes = data["notes"];
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   loadNotes();
  // }
  @override
  void initState() {
    super.initState();
    // Call the readJson method when the app starts
    readJson();
  }

  // Future<void> loadNotes() async {
  //   noteManager.loadNotesFromFile();
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: readJson,
              child: const Text('Load Data'),
            ),

            // Display the data loaded from sample.json
            _notes.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(10),
                    color: Colors.amber.shade100,
                    child: ListTile(
                      title: Text(_notes[index]["title"]),
                      subtitle: Text(_notes[index]["text"]),
                    ),
                  );
                },
              ),
            )
                : Container()
          ],
        ),
      ),
    );
  }
}

  // @override
  // Widget build(BuildContext context) {
  //   List<Note> notes = noteManager.notes;
  //
  //   if (notes.isEmpty) {
  //     return Center(
  //       child: Text(
  //         'No notes here: add one by clicking "+" button',
  //         style: TextStyle(fontSize: 18.0),
  //       ),
  //     );
  //   }
  //
  //   return ListView.builder(
  //     itemCount: notes.length,
  //     itemBuilder: (context, index) {
  //       final note = notes[index];
  //
  //       return Container(
  //         margin: EdgeInsets.symmetric(vertical: 8.0),
  //         padding: EdgeInsets.all(16.0),
  //         decoration: BoxDecoration(
  //           color: Colors.grey[200],
  //           borderRadius: BorderRadius.circular(8.0),
  //         ),
  //         child: Text(note.title),
  //       );
  //     },
  //   );
  // }

