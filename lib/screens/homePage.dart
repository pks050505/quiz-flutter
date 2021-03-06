import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cource_todo_2/controllers/auth_controller.dart';
import 'package:flutter_cource_todo_2/screens/second_screen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookWidget {
  static const route = '/HomePage';
  @override
  Widget build(BuildContext context) {
    // final User? user = useProvider(authControllerProvider.state);
    var user;
    return Scaffold(
      appBar: AppBar(
          leading: user == null
              ? IconButton(
                  icon: Icon(Icons.account_box_outlined),
                  onPressed: () =>
                      context.read(authControllerProvider).signOut(),
                )
              : null),
      body: Container(
        color: Colors.amber,
        child: OutlinedButton(
          onPressed: () async {
            var data = await Navigator.pushNamed(context, SecondScreen.route);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(data as String)));
          },
          child: Text('Go'),
        ),
      ),
    );
  }
}
