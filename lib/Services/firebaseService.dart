//all function for getting data from Firebase are here

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:igclonemobile/Models/postModel.dart';

class FirebaseServices{

  //Future used bcz this function instantaneously doesn't know how much data is there in backend
  Future<List<PostModel>> getPosts(){

   return FirebaseFirestore.instance.collection('posts').get().then((result){
      //in result we have all the documents of posts collection

      List <PostModel>posts = [];
      //documents come in form of DocumentSnapshot and not in readable form
      //so we create models to convert our DocumentSnapshot in actual readable form

      for (DocumentSnapshot snapshot in result.docs){
        posts.add(PostModel.fromSnapshot(snapshot));

      }
      return posts;
    });
  }
}