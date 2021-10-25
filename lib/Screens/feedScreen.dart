import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:igclonemobile/Providers/appProvider.dart';
import 'package:igclonemobile/Screens/chatFriendList.dart';
import 'package:igclonemobile/Screens/details.dart';
import 'package:igclonemobile/Widgets/postsWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  Uuid uuid = Uuid();

  File _pickedImage;

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: NewGradientAppBar(
        automaticallyImplyLeading: false,
          gradient: LinearGradient(colors: [Colors.blue, Colors.purple, Colors.red]),
        title: Text('Feeds'),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=> Details())
            );
          },
              icon: Icon(Icons.add)),

          IconButton(onPressed: (){
            Navigator.push(context,
            MaterialPageRoute(builder: (context)=> ChatFriendList())
            );
          },
              icon: Icon(Icons.message ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              //mapping through the list of all posts

              //in result we ll get one by one the posts and PostWidget will create them as they will be passed
              children: appProvider.posts.map((result) => PostWidget(postModel: result)).toList(),
            )
          ],
        ),
      ),
    );
  }
}
