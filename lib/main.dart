import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../classes/Note.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MainLayout(),
    );
  }
}



String newNoteTitle = '';
String newNoteText = '';

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  List _notes = [];
  bool isAddingNote = false;

  NoteManager noteManager = new NoteManager("lib/assets/notes.json");

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString(
        'lib/assets/notes.json');
    final data = await json.decode(response);

    if (data is List) {
      setState(() {
        _notes = data.map((json) => Note.fromJson(json)).toList();
      });
    } else {
      print(
          'Nieprawidłowy format danych JSON. Oczekiwano listy obiektów "notes".');
    }
  }

  void toggleAddingNote() {
    setState(() {
      isAddingNote = !isAddingNote;
    });
  }

  void addNote() {
    if (newNoteTitle.isNotEmpty && newNoteText.isNotEmpty) {
      noteManager.addNote(newNoteTitle,
          newNoteText); // Dodaj nową notatkę do listy w NoteManager

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

  void onNoteDismissed(int index) {
    setState(() {
      _notes.removeAt(index);
      noteManager.deleteNote(index); // Usuń notatkę z pliku JSON
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
      backgroundColor: const Color(0xFF022A50),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final note = _notes.reversed.toList()[index];

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Container(
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(37),
                            color: Color.fromRGBO(217, 217, 217, 0.161),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  'lib/assets/images/notegradient.svg',
                                  semanticsLabel: 'notegradient',
                                  height: 95, // Dodano wysokość dla poprawnego wyświetlania SVG
                                ),
                              ),
                              Expanded(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 280), // Ustawienie maksymalnej szerokości
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          note.title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Roboto Mono',
                                            fontSize: 15,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.normal,
                                            height: 1,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8),
                                        Expanded(
                                          child: Text(
                                            note.text,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Roboto Mono',
                                              fontSize: 12,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                              height: 1,
                                            ),
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  onNoteDismissed(_notes.indexOf(note));
                                },
                                child: Container(
                                  width: 40,
                                  height: 24,
                                  child: Image.asset(
                                    'lib/assets/images/close.png',
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  if (isAddingNote)
                    Align(
                      alignment: Alignment.center,
                      child: GlassmorphicContainer(
                        width: 315,
                        height: 510,
                        borderRadius: 40,
                        blur: 7,
                        alignment: Alignment.bottomCenter,
                        border: 2,
                        linearGradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.centerLeft,
                            colors: [
                              Color(0xFFffffff).withOpacity(0.15),
                              Color(0xFFFFFFFF).withOpacity(0.05),
                            ],
                            stops: [
                              0.1,
                              1,
                            ]),
                        borderGradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xB4DDEA).withOpacity(0.8),
                            Color((0xB4DDEA)).withOpacity(0),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 25, top: 10, right: 25),
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    newNoteTitle = value;
                                  });
                                },
                                maxLength: 30,
                                style: TextStyle(
                                  color: Colors.white, // Biały kolor tekstu
                                  fontFamily: 'Roboto Mono',
                                  fontSize: 24, // Zwiększona wielkość czcionki
                                  fontWeight: FontWeight.normal,
                                  height: 1,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Title',
                                  hintStyle: TextStyle(
                                    color: Colors.white, // Biały kolor tekstu sugerującego
                                    fontFamily: 'Roboto Mono',
                                    fontSize: 28, // Zwiększona wielkość czcionki
                                    fontWeight: FontWeight.normal,
                                    height: 1,
                                  ),
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
                                buildCounter: (BuildContext context, { int? currentLength, int? maxLength, bool? isFocused }) {
                                  return Text(
                                    '$currentLength / $maxLength',
                                    style: TextStyle(
                                      color: Colors.white, // Biały kolor tekstu liczby znaków
                                      fontFamily: 'Roboto Mono',
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal,
                                      height: 1,
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 11),
                            Padding(
                              padding: const EdgeInsets.only(left: 25, right: 25),
                              child: Container(
                                height: 380,
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      newNoteText = value;
                                    });
                                  },
                                  maxLines: null,
                                  style: TextStyle(
                                    color: Colors.white, // Biały kolor tekstu
                                    fontFamily: 'Roboto Mono',
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    height: 1,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Start writing your note',
                                    hintStyle: TextStyle(
                                      color: Colors.white, // Biały kolor tekstu sugerującego
                                      fontFamily: 'Roboto Mono',
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      height: 1,
                                    ),
                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto Mono',
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      height: 1,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent, // Usunięcie podkreślenia pola tekstowego
                                        width: 0,
                                      ),
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
              top: 16,
              left: 16,
              child: Container(
                width: 44,
                height: 44,
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

class NoteEdit extends StatefulWidget {
  @override
  _NoteEditState createState() => _NoteEditState();
}

class _NoteEditState extends State<NoteEdit> {
  String newNoteText = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            newNoteText = value;
          });
        },
        maxLines: null,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Roboto Mono',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1,
        ),
        decoration: InputDecoration(
          hintText: 'Start writing your note',
          hintStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto Mono',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            height: 1,
          ),
          alignLabelWithHint: true,
          labelStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto Mono',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            height: 1,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 0,
            ),
          ),
        ),
      ),
    );
  }
}
