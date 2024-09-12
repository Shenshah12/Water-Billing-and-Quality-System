import 'package:flutter/material.dart';
import 'my_drawer.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedTitle = 'About';

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
            _selectedTitle = title;
          });
          Navigator.pop(context);
        },
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
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
            ),
            const Positioned(
              top: 40, // Adjusted top position for better alignment
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'About Us',
                    style: TextStyle(
                      fontFamily: 'Concert One',
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // Added some spacing between title and content
                ],
              ),
            ),
            Positioned.fill(
              top: 100, // Adjusted top position for better alignment
              left: 20,
              right: 20,
              bottom: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6.0,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Aqua-Control is a pioneering conglomerate dedicated to revolutionizing water financing and quality assessment, providing cutting-edge solutions to water management challenges.',
                        style: TextStyle(
                          fontFamily: "Abel",
                          fontSize: 17, // Increased font size for better readability
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildInfoRow('Parent Organization:', 'Rise-Tech'),
                      const SizedBox(height: 10),
                      _buildInfoRow('Headquarter Locations:', 'College of Electrical and Mechanical Engineering (CEME), Rawalpindi'),
                      const SizedBox(height: 20),
                      const Text(
                        'We have strove to redefine water management through innovative solutions. Our mission is to make water billing and quality assessment accessible, efficient, and environmentally sustainable.',
                        style: TextStyle(
                          fontFamily: "Abel",
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: "Text Me One",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          content,
          style: const TextStyle(
            color: Colors.deepPurple,
            fontFamily: "Abel",
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
