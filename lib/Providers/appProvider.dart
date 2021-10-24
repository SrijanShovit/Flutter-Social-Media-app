import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:igclonemobile/Models/postModel.dart';
import 'package:igclonemobile/Services/firebaseService.dart';

class AppProvider with ChangeNotifier{

  String user;

  List<PostModel> posts = [];

  AppProvider(){
//getPosts function is called as soon as Provider is called and initialized
  getPosts();
  }

  FirebaseServices firebaseServices = FirebaseServices();
  //with the above instance we'll access getPosts of that file

  //Future added to give time to function to get data
  Future signInWithGoogle()async{
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleUser.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken:  googleSignInAuthentication.idToken
  );

  //value will have data of authenticated user
  return await FirebaseAuth.instance.signInWithCredential(credential).then((value){

    user = value.user.displayName;

    FirebaseFirestore.instance.collection('users').doc(value.user.displayName).set({
      "id":value.user.uid,
      "name":value.user.displayName,
      "email":value.user.email
    });
  });

  }

  getPosts() async{

    posts = await firebaseServices.getPosts();

  }
}