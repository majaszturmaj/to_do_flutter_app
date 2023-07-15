import 'package:flutter/material.dart';

import '../classes/note_manager.dart';
import 'classes/action_button.dart';
import 'classes/note_edit.dart';
import 'classes/note_listview.dart';

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