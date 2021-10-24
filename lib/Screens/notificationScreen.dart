import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:igclonemobile/Providers/appProvider.dart';
import 'package:provider/provider.dart';
//provider gets data only once after that it's connection from server stops
//but stream builder works in real time fetching data in continuously in real time
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                //stream means source of continuous data flow

              //we want to get friend requests of only those users which have name field same as current user
              stream: FirebaseFirestore.instance.collection('temporaryfriendlist').where('name',
              isEqualTo:appProvider.user).snapshots(),
                builder: (context,snapshots){
                //snapshots here has all the snapshots got from stream
                  return Container(
                    height: 500,
                    width: 400,
                    child: ListView(
                      children: snapshots.data.docs.map((DocumentSnapshot snapshot){
                        //getting only friends field
                        List data = snapshot.data()['friends'];
                        
                        return Container(
                          height: 300,
                          width: 400,
                          child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context,index){
                                return ListTile(
                                  leading: Text(data[index] + '\n has requested to follow you') ,
                                  trailing: Container(
                                    //wrppped in container ro avoid interfering with other widgets
                                    width: 190,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: MaterialButton(onPressed: () {
                                            //adding user2 as friend of user1
                                            FirebaseFirestore.instance.collection('users').doc(appProvider.user).set({
                                              'Friends': FieldValue.arrayUnion([data[index]])
                                            },SetOptions(merge:true));

                                            //adding user1 as friend of user2
                                            FirebaseFirestore.instance.collection('users').doc(data[index]).set({
                                              //storing in list form
                                              'Friends': FieldValue.arrayUnion([appProvider.user])
                                            },SetOptions(merge:true));

                                            //deleting from friend requests
                                            FirebaseFirestore.instance.collection('temporaryfriendlist').doc(appProvider.user)
                                            .update({
                                              'friends' : FieldValue.arrayRemove([data[index]])
                                            });
                                          },


                                          child: Text('Accept'),
                                            color: Colors.blue,
                                          ),
                                        ),
                                        Expanded(
                                          child: MaterialButton(onPressed: () {},
                                          child: Text('Decline'),
                                            color: Colors.red,
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                );
                              }),
                        );
                      }).toList(),
                    ),
                  );
                })
          ],
        ),

  ),
    );
  }
}
