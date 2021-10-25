import 'dart:io';
import 'package:igclonemobile/Screens/feedScreen.dart';
import 'package:igclonemobile/Screens/homeScreen.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:igclonemobile/Providers/appProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Details extends StatefulWidget {
  const Details({Key key}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String description = '';
  Uuid uuid = Uuid();

  File _pickedImage;

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
                key: formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Expanded(child: TextFormField(

                        onChanged: (value){
                          description = value;
                        },

                      )),
                    ],
                  ),
                )),

            MaterialButton(onPressed: (){
              ImagePicker().getVideo(source: ImageSource.gallery).then((value){

                _pickedImage = File(value.path);

                Reference reference = FirebaseStorage.instance.ref().child('posts').child(uuid.v4().toString());

                UploadTask task = reference.putFile(_pickedImage);

                task.whenComplete((){
                  reference.getDownloadURL().then((url){

                    FirebaseFirestore.instance.collection('posts').doc(description).set({
                      'imageUrl': url,
                      'type':'video',
                      'description':description,
                      'username':appProvider.user,
                      'comments':[],
                      'likes':0
                    });
                  });

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>FeedScreen()));

                });
              });
            },
            child: Text('Upload Video'),),

            SizedBox(height: 20,),

            MaterialButton(onPressed: (){
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
                    FirebaseFirestore.instance.collection('posts').doc(description).set({
                      'imageUrl': url,
                      'type':'image',
                      'description':description,
                      'username':appProvider.user,
                      'comments':[],
                      'likes':0
                    });
                  });
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>FeedScreen()));

                });
              });
            },
            child: Text('Upload Image'),
            ),

          ],
        ),
      ),
    );
  }
}
