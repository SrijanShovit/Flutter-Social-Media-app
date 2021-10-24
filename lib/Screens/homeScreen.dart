import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:igclonemobile/Screens/feedScreen.dart';
import 'package:igclonemobile/Screens/notificationScreen.dart';
import 'package:igclonemobile/Screens/searchScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController;
  int _currIndex = 0;

  //this onTap will get index and jump between pages
  onTap(index){
    setState(() {
      pageController.animateToPage(index, duration: Duration(milliseconds: 10), curve: Curves.bounceInOut);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initialising page controller as soon as this fn runs just after loading of page
    pageController = PageController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: PageView(
        onPageChanged: (index){
          setState(() {
            //giving page index to bottom navigation bar index
            _currIndex = index;
          });
        },
        controller: pageController,
        children: [
          FeedScreen(),
          SearchScreen(),
          NotificationScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currIndex,
        onTap: (index){
          //this onTap will get page index and pass to other onTap
          setState(() {
              onTap(index);
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),title: Text('Feed')),
          BottomNavigationBarItem(icon: Icon(Icons.search),title: Text('Search')),
          BottomNavigationBarItem(icon: Icon(Icons.notification_important),title: Text('Notification')),

        ],
      ),
    );
  }
}
