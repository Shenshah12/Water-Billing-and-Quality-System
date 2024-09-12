import 'package:flutter/material.dart';
import 'griddashboard.dart';
import 'my_drawer.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedTitle = 'Dashboard'; // Initialize selected title

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Aqua Finance & Quality',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Text Me One',
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        backgroundColor: Colors.white54,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.indigo,
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // Adjust the height of the bottom border
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.indigo, // Color of the bottom border
                  width: 4.0, // Width of the bottom border
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: MyDrawer(
        selectedItem: _selectedTitle,
        onItemTapped: (title) {
          setState(() {
            _selectedTitle = title; // Update selected title
          });
          Navigator.pop(context); // Close drawer after item tapped
        },
      ),
      body: const GridDashboard(),
    );
  }
}
