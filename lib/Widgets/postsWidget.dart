import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:igclonemobile/Models/postModel.dart';
import 'package:igclonemobile/Providers/appProvider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class PostWidget extends StatefulWidget {
  //creating instance of postModel
  final PostModel postModel;
  const PostWidget({Key key,this.postModel}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {

  VideoPlayerController videoPlayerController;

  List temporaryfriendlist = [];

  videoPlayer(){
  if (widget.postModel.type == 'video'){
    videoPlayerController  = VideoPlayerController.network(widget.postModel.url);
    setState(() {
      videoPlayerController.initialize();
      videoPlayerController.play();
    });
  }else
    return null;

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //we want videoPlayer to initialise as soon as widget is loaded
    videoPlayer();
  }
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return Container(
      child: Column(
        children: [
          ListTile(
              leading: Text(widget.postModel.username),

            trailing: widget.postModel.username == appProvider.user ? null :
            GestureDetector(child: Text('Add friend'),
            onTap: (){
              String temporaryfriend = appProvider.user;
              temporaryfriendlist.add(temporaryfriend);
              //getting user of that widget
              FirebaseFirestore.instance.collection('temporaryfriendlist').doc(widget.postModel.username).set({
              //user who sent request will be added in friends list via temporaryfriendslist of the user to whom request has been sent

               //.set has capability to create new doc but it overrides existing doc
                //.update cannot create new doc...it can only update existing one
                'friends':FieldValue.arrayUnion(temporaryfriendlist),
                'name': widget.postModel.username
              },SetOptions(merge: true));  //to prevent overwriting
            },
            )
            ,
          ),
          Text(appProvider.user),

          widget.postModel.type == 'image' ? Image.network(widget.postModel.url) :
              Container(
                child: AspectRatio(
                  aspectRatio: 16/9,
                  child: VideoPlayer(videoPlayerController),
                ),
              )
        ],
      ),
    );
  }
}
