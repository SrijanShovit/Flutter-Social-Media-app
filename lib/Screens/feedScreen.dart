import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:igclonemobile/Providers/appProvider.dart';
import 'package:igclonemobile/Screens/chatFriendList.dart';
import 'package:igclonemobile/Widgets/postsWidget.dart';
import 'package:image_picker/image_picker.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Feeds'),
        actions: [
          IconButton(onPressed: (){
            ImagePicker().getVideo(source: ImageSource.gallery).then((value){

              _pickedImage = File(value.path);

              Reference reference = FirebaseStorage.instance.ref().child('posts').child(uuid.v4().toString());

              UploadTask task = reference.putFile(_pickedImage);

              task.whenComplete((){
                reference.getDownloadURL().then((url){

                  FirebaseFirestore.instance.collection('posts').doc().set({
                    'imageUrl': url,
                    'type':'video',
                    'description':'good video',
                    'username':appProvider.user
                  });
                });

              });
            });
          }, icon: Icon(Icons.video_call)),

          IconButton(onPressed: (){
            ImagePicker().getImage(source: ImageSource.gallery).then((value){
              //value has that Image now
              //using path we get path in our phone
              _pickedImage = File(value.path);

              //creating reference of posts folder in Firebase
              //child has the path of folder
              //uuid to generate random name of file
              Reference reference = FirebaseStorage.instance.ref().child('posts').child(uuid.v4().toString());

              UploadTask task = reference.putFile(_pickedImage);

              //thing to do once upload is done
              task.whenComplete((){
                reference.getDownloadURL().then((url){
                  //now url has the url of uploaded image
                  FirebaseFirestore.instance.collection('posts').doc().set({
                    'imageUrl': url,
                    'type':'image',
                    'description':'good image',
                    'username':appProvider.user
                  });
                });

              });
            });
          }, icon: Icon(Icons.upload_file)),

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
