import 'package:flutter/material.dart';
import 'firebase_listen.dart'; // Import the firebase service
import 'package:flutter/foundation.dart';

class MyDrawer extends StatefulWidget {
  final Function(String) onItemTapped;
  final String selectedItem;

  const MyDrawer({
    super.key,
    required this.onItemTapped,
    required this.selectedItem,
  });

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late String accountName = 'Account Name';
  late String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    // Fetch user data when the widget is initialized
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    // Obtain the stream of user data
    Stream<Map<String, dynamic>> userDataStream = Firebase_Service.streamUserData();

    // Listen to the stream to handle data as it arrives
    userDataStream.listen((userData) {
      setState(() {
        // Update state variables based on received data
        accountName = userData['name'] ?? 'Account Name';
        profileImageUrl = userData['profileImageUrl'] ?? '';
      });
    }, onError: (error) {
      // Handle stream errors
      if (kDebugMode) {
        print('Error fetching user data: $error');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              accountName,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Jost',
                fontSize: 20,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: profileImageUrl.isNotEmpty
                    ? Image.network(
                  profileImageUrl,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                )
                    : Container(
                  width: 90,
                  height: 90,
                  color: Colors.indigo,
                  child: const Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            otherAccountsPictures: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ],
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
            accountEmail: null,
          ),
          _buildDrawerItem(
            title: 'Dashboard',
            icon: Icons.dashboard_customize_rounded,
            onTap: () {
              widget.onItemTapped('Dashboard');
              Navigator.pushNamed(context, 'home');
            },
            selected: widget.selectedItem == 'Dashboard',
          ),
          _buildDrawerItem(
            title: 'My Account',
            icon: Icons.face,
            onTap: () {
              widget.onItemTapped('Profile');
              Navigator.pushNamed(context, 'profile');
            },
            selected: widget.selectedItem == 'Profile',
          ),
          _buildDrawerItem(
            title: 'Live Flow',
            icon: Icons.water,
            onTap: () {
              widget.onItemTapped('flow');
              Navigator.pushNamed(context, 'Flow');
            },
            selected: widget.selectedItem == 'flow',
          ),
          _buildDrawerItem(
            title: 'Water Usage',
            icon: Icons.water_drop_sharp,
            onTap: () {
              widget.onItemTapped('Usage');
              Navigator.pushNamed(context, 'usage');
            },
            selected: widget.selectedItem == 'Usage',
          ),
          _buildDrawerItem(
            title: 'Billing History',
            icon: Icons.monetization_on,
            onTap: () {
              widget.onItemTapped('Bill');
              Navigator.pushNamed(context, 'bill');
            },
            selected: widget.selectedItem == 'Bill',
          ),
          _buildDrawerItem(
            title: 'Contact Us',
            icon: Icons.call,
            onTap: () {
              widget.onItemTapped('Contact');
              Navigator.pushNamed(context, 'contact');
            },
            selected: widget.selectedItem == 'Contact',
          ),
          _buildDrawerItem(
            title: 'About',
            icon: Icons.info,
            onTap: () {
              widget.onItemTapped('About');
              Navigator.pushNamed(context, 'about');
            },
            selected: widget.selectedItem == 'About',
          ),
          _buildDrawerItem(
            title: 'Log Out',
            icon: Icons.logout_sharp,
            onTap: () {
              widget.onItemTapped('LogOut');
              Navigator.pushNamed(context, 'logout');
            },
            selected: widget.selectedItem == 'LogOut',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required bool selected,
  }) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: selected ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: selected ? Colors.white : Colors.black,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Jost',
            color: selected ? Colors.white : Colors.black,
          ),
        ),
        onTap: onTap,
        tileColor: selected ? Colors.white : Colors.transparent,
      ),
    );
  }
}
