import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  static const route = '/secondScreen';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ElevatedButton(
          child: Text('go back'),
          onPressed: () {
            Navigator.pop(context, 'thanks');
          },
        ),
      ),
    );
  }
}
