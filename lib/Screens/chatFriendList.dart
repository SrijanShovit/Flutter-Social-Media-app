import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:igclonemobile/Providers/appProvider.dart';
import 'package:igclonemobile/Screens/chatScreen.dart';
import 'package:provider/provider.dart';

class ChatFriendList extends StatefulWidget {
  const ChatFriendList({Key key}) : super(key: key);

  @override
  _ChatFriendListState createState() => _ChatFriendListState();
}

class _ChatFriendListState extends State<ChatFriendList> {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body:Container(
        child: StreamBuilder<QuerySnapshot>(
            stream : FirebaseFirestore.instance.collection('users')
                .where('name',isEqualTo: appProvider.user).snapshots(),
          builder: (context,snapshots){
              return ListView(
                children: snapshots.data.docs.map((DocumentSnapshot snapshot){
                  List data = snapshot.data()['Friends'] as List;

                  return Column(
                    children: data.map((result) => GestureDetector(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=> ChatScreen(
                          currentUser: appProvider.user,
                            peerUser: result,
                        )));
                      },
                        child: Text('Chat with --- ' + result.toString()))).toList(),
                  );
                 }).toList(),

              );
          },
        ),
      )

    );
  }
}
