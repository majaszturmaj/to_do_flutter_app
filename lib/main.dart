import 'package:flutter/material.dart';
import 'package:to_do_app/widgets/ActionButton.dart';
import 'package:to_do_app/widgets/NoteListWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: NoteListWidget(),
    );
  }
}


class MainLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NoteListWidget(),
            ActionButton(),
          ],
        ),
      ),
    );
  }
}
