import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel{

  String _description;
  String _url;
  String _type;
  String _username;
  List _comments;
  int _likes;

  //the above variables can't be directly used
//so we use get
  get description=>_description;
  get url=>_url;
  get type=> _type;
  get username=> _username;
  get comments=> _comments;
  get likes=> _likes;

  PostModel.fromSnapshot(DocumentSnapshot snapshot){
    _description = snapshot.data()['description'];
    _url = snapshot.data()['imageUrl'];
    _type = snapshot.data()['type'];
    _username = snapshot.data()['username'];
    _comments = snapshot.data()['comments'];
    _likes = snapshot.data()['likes'];

  }
}