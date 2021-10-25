import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CommentScreen extends StatefulWidget {
  final List comments;
  final String description;
  const CommentScreen({Key key,this.comments,this.description}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final formKey = GlobalKey<FormState>();
  List sendcomments= [];
  String comment ='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 800,
              width: 200,
              child: ListView(
                //to prevent interference of scrolling of ListView and SingleCh....
                physics: NeverScrollableScrollPhysics(),
                children: widget.comments.map((result) => Text(result)).toList(),
              ),
            ),
            ListTile(
              leading: Form(
                key: formKey,
                child: Container(
                  width: 200,
                  child: TextFormField(
                    onSaved: (value){
                      comment = value;
                    },

                  ),
                ),
              ),

              trailing: IconButton(onPressed: (){
                formKey.currentState.save();
                sendcomments.add(comment);
                
                FirebaseFirestore.instance.collection('posts').doc(widget.description).update({
                  'comments' : FieldValue.arrayUnion(sendcomments)
                });

              },
                  icon: Icon(MdiIcons.send)),
            ),
          ],
        ),
      ),
    );
  }
}
