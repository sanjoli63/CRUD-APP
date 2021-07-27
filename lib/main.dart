import 'dart:io';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'splash.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      home: AnimatedSplashScreen(
        splash: Splash(),
        nextScreen: MyHomePage(),
        splashTransition: SplashTransition.decoratedBoxTransition,
        backgroundColor: Colors.redAccent,
        duration: 2000,
        splashIconSize: double.maxFinite,
      ),
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
              return friends.isEmpty
                  ? LayoutBuilder(builder: (ctx, constraints) {
                      return Column(
                        children: <Widget>[
                          Text(
                            'No Data added yet!',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                              height: constraints.maxHeight * 0.4,
                              child: SvgPicture.asset(
                                'assets/undraw_No_data_re_kwbl.svg',
                                fit: BoxFit.cover,
                              )),
                        ],
                      );
                    })
                  : ListView.separated(
                      itemCount: friends.keys.toList().length,
                      itemBuilder: (context, index) {
                        final key = friendsBox!.keys.toList()[index];
                        final value = friends.get(key);
                        return Container(
                          child: ListTile(
                            title: Text(
                              value!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                            subtitle: Text(
                              key,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                            trailing: TextButton.icon(
                              icon: const Icon(Icons.delete),
                              label: const Text('Delete'),
                              onPressed: () {
                                friendsBox!.delete(key);
                              },
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, index) => Divider(),
                    );
            },
          )),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  child: Text("Add New"),
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
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.account_circle),
                                      hintText: 'Id',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  TextField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.attribution_outlined),
                                      hintText: 'Name',
                                      border: OutlineInputBorder(),
                                    ),
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
                                      _idController.clear();
                                      _nameController.clear();
                                    },
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.teal),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ),
                ElevatedButton(
                  child: Text("Update"),
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
                          ),
                        );
                      },
                    );
                  },
                ),
                ElevatedButton(
                  child: Text("Delete"),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: Container(
                                padding: EdgeInsets.all(32),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _idController,
                                      ),
                                      SizedBox(height: 16),
                                      ElevatedButton(
                                        child: Text("submit"),
                                        onPressed: () {
                                          final key = _idController.text;

                                          friendsBox!.delete(key);
                                          Navigator.pop(context);
                                        },
                                      )
                                    ])),
                          );
                        });
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
