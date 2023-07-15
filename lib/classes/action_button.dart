import 'package:flutter/material.dart';

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
