import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:igclonemobile/Providers/appProvider.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String currentUser;
  final String peerUser;
  const ChatScreen({Key key,this.currentUser,this.peerUser}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String id='';
  //creating a key for the form
  final formKey = GlobalKey<FormState>();

  createid(){
    if (widget.currentUser.hashCode <= widget.peerUser.hashCode){
      id = widget.currentUser + '-' + widget.peerUser;
    }
    else{
      id = widget.peerUser + '-' + widget.currentUser;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createid();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    String message='';
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('chats').doc(id).collection('messages').orderBy(
                  'created At',descending: false
                ).snapshots(),
                builder: (context,snapshots){
                  return Container(
                    height: 500,
                    child: ListView.builder(
                        itemCount: snapshots.data.docs.length,
                        itemBuilder: (context,index){
                          DocumentSnapshot data = snapshots.data.docs[index];
                              return Card(
                                child: Container(
                                  alignment: data['send by'] == appProvider.user  ? Alignment.bottomRight : Alignment.bottomLeft,
                                  child: Text(
                                    data['message']
                                  ),
                                ),
                              );
                        }
                    ),
                  );
                }),
            
            Form(
              //key will store the data of current state of whatever is written in form
              key: formKey,
              child: Row(
                children: [
                  Container(
                      width: 300,
                      child: TextFormField(
                        onSaved: (value){
                          message = value;
                        },
                      )),
                  IconButton(onPressed: (){
                    //as sson as send button is pressed message will be saved and on saving it is stored in message variable
                    formKey.currentState.save();
        FirebaseFirestore.instance.collection('chats').doc(id).set({
          'id' :id

        });
                    FirebaseFirestore.instance.collection('chats').doc(id).collection('messages').doc().set({
                      'message' : message,
                      'send by' : appProvider.user,
                      'created At' : DateTime.now()

                    });
                  }, icon: Icon(Icons.send))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
