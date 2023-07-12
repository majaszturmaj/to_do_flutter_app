import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool isOnNoteEdit = false;

  void toggleButtonState() {
    setState(() {
      isOnNoteEdit = !isOnNoteEdit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isOnNoteEdit) {
          // Perform action for onNoteEdit state
          print('Save button clicked!');
        } else {
          // Perform action for onMain state
          print('Main button clicked!');
        }
      },
      child: Container(
          width: 75,
          height: 75,
          child: Stack(
              children: <Widget>[
                Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          boxShadow : [BoxShadow(
                              color: Color.fromRGBO(163, 154, 196, 0.8999999761581421),
                              offset: Offset(1,1),
                              blurRadius: 3
                          )],
                          gradient : LinearGradient(
                              begin: Alignment(0.5,0.5),
                              end: Alignment(-0.5,0.5),
                              colors: [Color.fromRGBO(45, 110, 126, 1),Color.fromRGBO(10, 83, 160, 1)]
                          ),
                          borderRadius : BorderRadius.all(Radius.elliptical(75, 75)),
                        )
                    )
                ),Positioned(
                    top: 11,
                    left: 10,
                    child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          image : DecorationImage(
                              image: AssetImage(
                                isOnNoteEdit ? 'lib/assets/images/save.png' : 'lib/assets/images/plusmath.png',
                              ),
                              fit: BoxFit.fitWidth,
                              colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.8),
                                                            BlendMode.srcIn,
                              ),
                          ),
                        )
                    )
                ),
              ]
          )
      ),
    );
  }
}
