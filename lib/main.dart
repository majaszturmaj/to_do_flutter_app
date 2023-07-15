import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter/services.dart';

import '../classes/note_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool isAddingNote = false;
  NoteManager noteManager = NoteManager();

  @override
  void initState() {
    super.initState();
  }

  void addNote() {
    setState(() {
      noteManager.addNote();
      toggleAddingNote(); // zamknij pole do wpisywania nowej notatki
    });
    }

  void deleteNote(int index) {
    setState(() {
      noteManager.deleteNote(index);
    });
  }

  void toggleAddingNote() { // przełącza pole do wpisywania nowej notatki
    setState(() {
      isAddingNote = !isAddingNote;
    });
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
                  NoteListView(noteManager: noteManager, deleteNote: deleteNote),
                  if (isAddingNote)
                    Align(
                      alignment: Alignment.center,
                      child: NoteEdit(noteManager: noteManager,)
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

  const ActionButton({super.key, required this.isOnNoteEdit, required this.onNoteAdded});

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isOnNoteEdit) {
          widget.onNoteAdded(true);
        } else {
          // Przełącz tryb edycji
          widget.onNoteAdded(false);
        }
      },
      child: SizedBox(
        width: 75,
        height: 75,
        child: Stack(
          children: <Widget>[
            Container(
              width: 75,
              height: 75,
              decoration: const BoxDecoration(
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


class NoteEdit extends StatelessWidget {
  final NoteManager noteManager;

  const NoteEdit({super.key, required this.noteManager});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
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
            const Color(0xFFffffff).withOpacity(0.15),
            const Color(0xFFFFFFFF).withOpacity(0.05),
          ],
          stops: const [0.1, 1,]),
      borderGradient: LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.bottomLeft,
        colors: [
          const Color(0xB4DDEA).withOpacity(0.8),
          const Color((0xB4DDEA)).withOpacity(0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 10, right: 25),
            child: TextFormField(
              onChanged: (value) {
                noteManager.setNewNoteTitle(value);
              },
              maxLength: 30,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto Mono',
                fontSize: 24,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto Mono',
                  fontSize: 28,
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
                return Text( // liczba użytych znaków na 30 dostępnych
                  '$currentLength / $maxLength',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Roboto Mono',
                    fontSize: 11,
                    fontWeight: FontWeight.normal,
                    height: 1,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 11),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: SizedBox(
              height: 380,
              child: TextFormField(
                onChanged: (value) {
                    noteManager.setNewNoteText(value);
                },
                maxLines: null,
                style: const TextStyle(
                  color: Colors.white, // Biały kolor tekstu
                  fontFamily: 'Roboto Mono',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
                decoration: const InputDecoration(
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
    );
  }
}

class NoteListView extends StatelessWidget {
  final NoteManager noteManager;
  final void Function(int) deleteNote;

  const NoteListView({super.key, required this.noteManager, required this.deleteNote});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: noteManager.getLength(),
      itemBuilder: (context, index) {
        final note = noteManager.getReversedNote(index);
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Container(
            height: 110,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x2c6cddff), width: 0.3),
              gradient: const RadialGradient(
                radius: 2.7,
                center: Alignment.bottomRight,
                colors: [Color(0xff66d6ff), Color(0xB2385A7C)],
              ),
              borderRadius: BorderRadius.circular(37),
              color: const Color.fromRGBO(217, 217, 217, 0.161),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: const TextStyle(
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
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            note.text,
                            style: const TextStyle(
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
                GestureDetector(
                  onTap: () {
                    deleteNote(noteManager.getIndex(note));
                  },
                  child: SizedBox(
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
    );
  }
}