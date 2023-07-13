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
  bool isAddingNote = false;
  String newNoteTitle = '';
  String newNoteText = '';
  NoteManager noteManager = new NoteManager("lib/assets/notes.json");

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('lib/assets/notes.json');
    final data = await json.decode(response);

    if (data is List) {
      setState(() {
        _notes = data.map((json) => Note.fromJson(json)).toList();
      });
    } else {
      print('Nieprawidłowy format danych JSON. Oczekiwano listy obiektów "notes".');
    }
  }

  void toggleAddingNote() {
    setState(() {
      isAddingNote = !isAddingNote;
    });
  }

  void addNote() {
    if (newNoteTitle.isNotEmpty && newNoteText.isNotEmpty) {
      noteManager.addNote(newNoteTitle, newNoteText); // Dodaj nową notatkę do listy w NoteManager

      // Zapisz notatki do pliku JSON
      noteManager.saveNotesToFile().then((success) {
        if (success) {
          print('Dodano nową notatkę: Tytuł=$newNoteTitle, Treść=$newNoteText');

          // Wyczyść zmienne przechowujące wartość notatki
          newNoteTitle = '';
          newNoteText = '';

          // Zamknij pole wprowadzania notatki
          toggleAddingNote();

          // Odśwież listę notatek
          setState(() {});
        } else {
          print('Błąd podczas zapisywania notatek do pliku.');
        }
      });
    }
  }



  @override
  void initState() {
    super.initState();
    // Call the readJson method when the app starts
    readJson();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            if (isAddingNote)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          newNoteTitle = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          newNoteText = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Text',
                      ),
                    ),
                  ],
                ),
              ),
            if (_notes.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final note = _notes[index];

                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        setState(() {
                          noteManager.deleteNote(index);
                          _notes.removeAt(index);
                        });
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 16),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Card(
                        margin: const EdgeInsets.all(10),
                        color: Colors.amber.shade100,
                        child: ListTile(
                          title: Text(note.title),
                          subtitle: Text(note.text),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Container(),
            GestureDetector(
              onTap: () {
                if (isAddingNote) {
                  addNote();
                } else {
                  toggleAddingNote();
                }
              },
              child: Container(
                width: 75,
                height: 75,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(163, 154, 196, 0.8999999761581421),
                            offset: Offset(1, 1),
                            blurRadius: 3,
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment(0.5, 0.5),
                          end: Alignment(-0.5, 0.5),
                          colors: [
                            Color.fromRGBO(45, 110, 126, 1),
                            Color.fromRGBO(10, 83, 160, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.elliptical(75, 75)),
                      ),
                    ),
                    Positioned(
                      top: 11,
                      left: 10,
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              isAddingNote
                                  ? 'lib/assets/images/save.png'
                                  : 'lib/assets/images/plusmath.png',
                            ),
                            fit: BoxFit.fitWidth,
                            colorFilter: ColorFilter.mode(
                              Colors.white.withOpacity(0.8),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}

class ActionButton extends StatefulWidget {
  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool isOnNoteEdit = false;

  void toggleButtonState() {
    setState(() {
      isOnNoteEdit = !isOnNoteEdit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isOnNoteEdit) {
          // Perform action for onNoteEdit state
          print('Save button clicked!');
        } else {
          // Perform action for onMain state
          print('Main button clicked!');
        }
      },
      child: Container(
          width: 75,
          height: 75,
          child: Stack(
              children: <Widget>[
                Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      boxShadow : [BoxShadow(
                          color: Color.fromRGBO(163, 154, 196, 0.8999999761581421),
                          offset: Offset(1,1),
                          blurRadius: 3
                      )],
                      gradient : LinearGradient(
                          begin: Alignment(0.5,0.5),
                          end: Alignment(-0.5,0.5),
                          colors: [Color.fromRGBO(45, 110, 126, 1),Color.fromRGBO(10, 83, 160, 1)]
                      ),
                      borderRadius : BorderRadius.all(Radius.elliptical(75, 75)),
                    )
                ),
                Positioned(
                    top: 11,
                    left: 10,
                    child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          image : DecorationImage(
                            image: AssetImage(
                              isOnNoteEdit ? 'lib/assets/images/save.png' : 'lib/assets/images/plusmath.png',
                            ),
                            fit: BoxFit.fitWidth,
                            colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.8),
                              BlendMode.srcIn,
                            ),
                          ),
                        )
                    )
                ),
              ]
          )
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

