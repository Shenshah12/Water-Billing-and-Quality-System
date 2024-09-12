import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'my_drawer.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  _LogoutScreenState createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedTitle = 'LogOut';

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamed(context, 'Sign_in');
    } catch (e) {
      if (kDebugMode) {
        print("Error logging out: $e");
      }
      // Handle error logging out
    }
  }

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
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.indigo,
                  width: 4.0,
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
            _selectedTitle = title;
          });
          Navigator.pop(context);
        },
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFAAB5C6), // Moonstone color
              Color(0xFFB0C2D8),
              Color(0xFFCAD0DC),
              Color(0xFFE6E9ED),
            ],
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            height: 200,
            width: 400,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(40.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sentiment_dissatisfied,
                        size: 48.0,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        'Would you like to log out?',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32.0),
                ElevatedButton.icon(
                  onPressed: _logout, // Call the _logout function when the button is pressed
                  icon: const Icon(
                    Icons.logout,
                    size: 24.0,
                  ),
                  label: const Text(
                    'Log out',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Playfair',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
