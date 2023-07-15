import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class Note {
  String title = "";
  String text = "";

  Note(this.title, this.text);

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
  List<Note> _notes;
  final String _fileName = "lib/assets/notes.json";
  String _newNoteTitle = "";
  String _newNoteText = "";

  NoteManager() : _notes = <Note>[] {
    loadNotesFromFile();
  }

  int getLength() {
    return _notes.length;
  }

  int getIndex(note) {
    return _notes.indexOf(note);
  }

  Note getReversedNote(int index) {
    return _notes.reversed.toList()[index];
  }

  void setNewNoteTitle(String title){
    _newNoteTitle = title;
  }

  void setNewNoteText(String text){
    _newNoteText = text;
  }

  void clearNote(){
    _newNoteTitle = "";
    _newNoteText = "";
  }

  bool isNoteNotEmpty(){
    if (_newNoteText.isNotEmpty && _newNoteTitle.isNotEmpty) return true;
    else return false;
  }

  void addNote() {
    if (isNoteNotEmpty()) {
      Note note = Note(_newNoteTitle, _newNoteText);
      _notes.add(note);
      saveNotesToFile();
    }
  }

  void deleteNote(int index) {
    if (index >= 0 && index < _notes.length) {
      _notes.removeAt(index);
      saveNotesToFile();
    }
  }

  Future<bool> saveNotesToFile() async {
    try {
      File file = File(_fileName);
      List<Map<String, dynamic>> jsonList = _notes.map((note) => note.toJson()).toList();
      String jsonString = jsonEncode(jsonList);
      await file.writeAsString(jsonString);
      return true; // Zwracamy true, jeśli zapis do pliku był udany
    } catch (e) {
      //print('Błąd podczas zapisywania notatek do pliku: $e');
      return false; // Zwracamy false w przypadku błędu zapisu
    }
  }

  void loadNotesFromFile() {
    File file = File(_fileName);
    if (!file.existsSync()) {
      //print('Plik $_fileName nie istnieje.');
      return;
    }
    String jsonString = file.readAsStringSync();
    List<dynamic> jsonList = jsonDecode(jsonString);
    _notes = jsonList.map((json) => Note.fromJson(json)).toList();
  }
}