import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../classes/note_manager.dart';

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
                  color: Colors.white,
                  fontFamily: 'Roboto Mono',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
                decoration: const InputDecoration(
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
