import 'package:flutter/material.dart';
import 'package:igclonemobile/Providers/appProvider.dart';
import 'package:igclonemobile/Screens/registrationScreen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    //we need to define all Providers here and they will available in entire app
    //we just have to create their instance and access their functions in the screen where they are required

    MultiProvider(
      providers:[
        ChangeNotifierProvider.value(value: AppProvider())
      ],
      child: MyApp())
    );


}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistrationScreen(),
    );
  }
}
