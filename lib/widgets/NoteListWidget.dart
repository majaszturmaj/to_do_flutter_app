import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../classes/Note.dart';

String newNoteTitle = '';
String newNoteText = '';

class NoteListWidget extends StatefulWidget {
  @override
  _NoteListWidgetState createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends State<NoteListWidget> {
  List _notes = [];
  bool isAddingNote = false;

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

  void onNoteAdded(String title, String text) {
    setState(() {
      _notes.add(Note(title, text));
    });
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
            Expanded(
              child: _notes.isNotEmpty
                  ? ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];

                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
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
              )
                  : Container(),
            ),
            if (isAddingNote)
              Container(
                width: 315,
                height: 510,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: Color.fromRGBO(217, 217, 217, 0.07800000160932541),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 22),
                      child: Text(
                        'Title',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto Mono',
                          fontSize: 28,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 10, right: 25),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            newNoteTitle = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Start writing your note...',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto Mono',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            height: 1,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(101, 151, 201, 1),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            newNoteText = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Text',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto Mono',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            height: 1,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(101, 151, 201, 1),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ActionButton(
                  isOnNoteEdit: isAddingNote,
                  onNoteAdded: (isNoteAdded) {
                    if (isNoteAdded) {
                      onNoteAdded(newNoteTitle, newNoteText);
                      addNote();
                    } else {
                      toggleAddingNote();
                    }
                  },
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
  final bool isOnNoteEdit;
  final Function(bool) onNoteAdded;

  ActionButton({required this.isOnNoteEdit, required this.onNoteAdded});

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isOnNoteEdit) {
          // Dodaj nową notatkę tylko w trybie edycji
          widget.onNoteAdded(newNoteTitle.isNotEmpty && newNoteText.isNotEmpty);;
        } else {
          // Przełącz tryb edycji
          widget.onNoteAdded(false);
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
                      widget.isOnNoteEdit
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
    );
  }
}