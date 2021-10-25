// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
//
// class CallPage extends StatefulWidget {
//   final String username;
//   final String channelname;
//   const CallPage({Key key,this.username,this.channelname}) : super(key: key);
//
//   @override
//   _CallPageState createState() => _CallPageState();
// }
//
// class _CallPageState extends State<CallPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:Stack(
//         children: <Widget>[
//           VideoCall(widget.channelname),
//           Positioned(
//             bottom: 10,
//             left: 60,
//             child: StatusBar(),
//           )
//
//         ],
//       )
//     );
//   }
//   Future<void> _capturePng() async{
//     String path = await NativeScreenshot.takeScreenshot();
//     print(path);
//
//   }
// }
