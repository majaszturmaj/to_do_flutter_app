import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class Note {
  String title = '';
  String text = '';

  Note(String title, String text) {
    this.title = title;
    this.text = text;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'text': text,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      json['title'] as String,
      json['text'] as String,
    );
  }
}

class NoteManager {
  List<Note> notes;
  String fileName;

  NoteManager(this.fileName) : notes = <Note>[] {
    loadNotesFromFile();
  }

  void addNote(String title, String text) {
    Note note = Note(title, text);
    notes.add(note);
    saveNotesToFile();
  }

  void deleteNote(int index) {
    if (index >= 0 && index < notes.length) {
      notes.removeAt(index);
      saveNotesToFile();
    }
  }

  Future<bool> saveNotesToFile() async {
    try {
      File file = File(fileName);
      List<Map<String, dynamic>> jsonList = notes.map((note) => note.toJson()).toList();
      String jsonString = jsonEncode(jsonList);
      await file.writeAsString(jsonString);
      return true; // Zwracamy true, jeśli zapis do pliku był udany
    } catch (e) {
      print('Błąd podczas zapisywania notatek do pliku: $e');
      return false; // Zwracamy false w przypadku błędu zapisu
    }
  }

  void loadNotesFromFile() {
    File file = File(fileName);
    if (!file.existsSync()) {
      print('Plik $fileName nie istnieje.');
      return;
    }

    String jsonString = file.readAsStringSync();
    List<dynamic> jsonList = jsonDecode(jsonString);
    List<Note> loadedNotes = jsonList.map((json) => Note.fromJson(json)).toList();

    if (loadedNotes.isNotEmpty) {
      notes = loadedNotes;
    }
  }
}