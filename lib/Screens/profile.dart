import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  const ProfileScreen({Key key,this.name}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').where('name',isEqualTo:widget.name ).snapshots(),
                builder: (context,snapshots){
                  return Column(
                    children: snapshots.data.docs.map((result){
                      return Column(
                        children: [
                          Text(result['name']),
                          Text(result['email']),
                          Container(
                            height: 400,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('posts').where('username',isEqualTo:
                              widget.name).snapshots(),
                              builder: (context,snapshots){
                                return GridView(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 20
                                  ),
                                  children:  snapshots.data.docs.map((result)=>Image.network(result['imageUrl'])
                                  ).toList(),

                                );
                              },
                            ),
                          )
                        ],
                      );
                    }).toList(),
                  );
                })
          ],
        ),
      ),
    );
  }
}
