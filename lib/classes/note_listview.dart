import 'package:flutter/material.dart';
import '../classes/note_manager.dart';

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