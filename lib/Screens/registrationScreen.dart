import 'package:flutter/material.dart';
import 'package:igclonemobile/Providers/appProvider.dart';
import 'package:igclonemobile/Screens/homeScreen.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    //creating an instance of appProvider
    final appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: (){
            appProvider.signInWithGoogle().then((value){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
            });

          },
          child: Text('Login with google'),
        ),
      ),
    );
  }
}
