import 'dart:io';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox<String>("Friends");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(primary: Colors.deepOrangeAccent),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.greenAccent,
            shadowColor: Colors.amber,
            onPrimary: Colors.black,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              primary: Colors.black, backgroundColor: Colors.deepOrangeAccent),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Box<String>? friendsBox;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    friendsBox = Hive.box<String>("Friends");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD APP"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ValueListenableBuilder(
            valueListenable: friendsBox!.listenable(),
            builder: (context, Box<String> friends, _) {
              return ListView.separated(
                itemBuilder: (context, index) {
                  final key = friendsBox!.keys.toList()[index];
                  final value = friends.get(key);
                  return ListTile(
                    title: Text(
                      value!,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    subtitle: Text(
                      key,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  );
                },
                separatorBuilder: (_, index) => Divider(),
                itemCount: friends.keys.toList().length,
              );
            },
          )),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                              child: Container(
                            padding: EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextField(
                                  controller: _idController,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                TextField(
                                  controller: _nameController,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final key = _idController.text;
                                    final value = _nameController.text;
                                    friendsBox!.put(key, value);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(color: Colors.teal),
                                  ),
                                ),
                              ],
                            ),
                          ));
                        });
                  },
                  child: Text("Add New"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Update"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Delete"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
