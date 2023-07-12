import 'dart:convert';
import 'dart:io';

class Note {
  String title;
  String text;

  Note({
    required this.title,
    required this.text,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'text': text,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      title: json['title'],
      text: json['text'],
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
    Note note = Note(title: title, text: text);
    notes.add(note);
    saveNotesToFile();
  }

  void deleteNote(int index) {
    if (index >= 0 && index < notes.length) {
      notes.removeAt(index);
      saveNotesToFile();
    }
  }

  void saveNotesToFile() {
    File file = File(fileName);
    List<Map<String, dynamic>> jsonList = notes.map((note) => note.toJson()).toList();
    String jsonString = jsonEncode(jsonList);
    file.writeAsStringSync(jsonString);
  }

  void loadNotesFromFile() {
    File file = File(fileName);
    if (file.existsSync()) {
      String jsonString = file.readAsStringSync();
      List<dynamic> jsonList = jsonDecode(jsonString);
      notes = jsonList.map((json) => Note.fromJson(json)).toList();
    }
  }
}