import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cource_todo_2/controllers/auth_controller.dart';
import 'package:flutter_cource_todo_2/controllers/item_controller.dart';
import 'package:flutter_cource_todo_2/models/item.dart';
import 'package:flutter_cource_todo_2/screens/second_screen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookWidget {
  static const route = '/HomePage';
  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.bodyText2!;
    final List<Widget> aboutBoxChildren = <Widget>[
      SizedBox(height: 24),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                style: textStyle,
                text: "Flutter is Google's UI toolkit for building beautiful, "
                    'natively compiled applications for mobile, web, and desktop '
                    'from a single codebase. Learn more about Flutter at '),
            TextSpan(
                style: textStyle.copyWith(color: Theme.of(context).accentColor),
                text: 'https://flutter.dev'),
            TextSpan(style: textStyle, text: '.'),
          ],
        ),
      ),
    ];

    final authControllerState = useProvider(authControllerProvider.state);

    return Scaffold(
      appBar: AppBar(
        title: Text('appBar'),
        leading: authControllerState != null
            ? IconButton(
                icon: Icon(Icons.login),
                onPressed: () {
                  context.read(authControllerProvider).signOut();
                })
            : null,
      ),
      drawer: Drawarx(aboutBoxChildren: aboutBoxChildren),
      body: Container(
        color: Colors.amber,
        child: Text(''),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddItemDialog.show(
          context,
          Item.empty(),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddItemDialog extends HookWidget {
  static void show(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (context) {
        return AddItemDialog(
          item: item,
        );
      },
    );
  }

  final Item item;
  const AddItemDialog({Key? key, required this.item});
  bool get isUpdating => item.id != null;
  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController(text: item.name);
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              autofocus: true,
              decoration: InputDecoration(hintText: 'item name'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: isUpdating
                      ? Colors.orange
                      : Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  isUpdating
                      ? context.read(itemListControllerProvider).updateItem(
                            updatedItem: item.copyWith(
                                name: textController.text.trim(),
                                obtainded: item.obtainded),
                          )
                      : context
                          .read(itemListControllerProvider)
                          .createItem(name: textController.text.trim());
                  Navigator.pop(context);
                },
                child: Text(isUpdating ? 'Update' : 'Add'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Drawarx extends StatelessWidget {
  const Drawarx({
    Key? key,
    required this.aboutBoxChildren,
  }) : super(key: key);

  final List<Widget> aboutBoxChildren;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: SafeArea(
          child: AboutListTile(
            icon: Icon(Icons.info),
            applicationIcon: FlutterLogo(),
            applicationName: 'Show About Example',
            applicationVersion: 'August 2019',
            applicationLegalese: '\u{a9} 2014 The Flutter Authors',
            aboutBoxChildren: aboutBoxChildren,
          ),
        ),
      ),
    );
  }
}
