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
    loadNotes();
  }

  void loadNotes() async {
    await noteManager.loadNotesFromFile();
    setState(() {}); // Trigger a rebuild after notes are loaded
  }

  void addNote() {
    setState(() {
      noteManager.addNote();
      toggleAddingNote();
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
                  if (noteManager.isListNotEmpty())
                    NoteListView(noteManager: noteManager, deleteNote: deleteNote),
                  if (!noteManager.isListNotEmpty()) // Show centered message if there are no notes
                    Center(
                      child: Text(
                        'No notes here: add one by clicking "+" button',
                        style: TextStyle(
                          color: Color(0xFF337397),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (isAddingNote)
                    Align(
                      alignment: Alignment.center,
                      child: NoteEdit(noteManager: noteManager),
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
  }}