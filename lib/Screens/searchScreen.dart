import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:igclonemobile/Screens/profile.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              height: 450,
              child: buildFloatingSearchBar())
        ],
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (result) {
        // Call your model, bloc, controller here.
        query = result;
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        //this will contain the results
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').where('name',
              isEqualTo : query
              ).snapshots(),
              builder: (context,snapshots){
                return Column(
                  children: snapshots.data.docs.map((result) => GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      ProfileScreen(
                        name: result['name'].toString(),

                      )));
                    },
                      child: Text(result['name'].toString()))).toList(),
                );
              },

            )
          ),
        );
      },
    );
  }
}
