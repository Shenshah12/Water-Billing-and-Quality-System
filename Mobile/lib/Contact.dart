import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'my_drawer.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedTitle = 'Contact';

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
      body: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Contact our team',
                      style: TextStyle(
                        fontFamily: 'PlayFair',
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Contact Methods',
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: 18.0,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: [
                    ChatItem.email(
                      title: 'Chat to Support',
                      icon: Icons.message,
                      email: 'Your Mail',
                    ),
                    ChatItem.googleMap(
                      title: 'Visit Us',
                      icon: Icons.location_on,
                      mapLink:
                      "Your Link",
                    ),
                    const CallUsItem(
                      title: 'Call Us',
                      icon: Icons.phone,
                      phoneNumber: '1234567890',
                      hours: 'Monday-Friday \n 8:AM to 5:PM',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? email;
  final String? mapLink;

  const ChatItem({
    super.key,
    required this.title,
    required this.icon,
    this.email,
    this.mapLink,
  });

  factory ChatItem.email({
    required String title,
    required IconData icon,
    required String email,
  }) {
    return ChatItem(
      title: title,
      icon: icon,
      email: email,
    );
  }

  factory ChatItem.googleMap({
    required String title,
    required IconData icon,
    required String mapLink,
  }) {
    return ChatItem(
      title: title,
      icon: icon,
      mapLink: mapLink,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0), // Adjust padding as needed
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Playfair',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (email != null) ...[
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _launchEmail(email!);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email, size: 20, color: Colors.blue),
                      SizedBox(width: 5),
                      Text(
                        'Email',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (mapLink != null) ...[
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _launchURL(mapLink!);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, size: 20, color: Colors.blue),
                      SizedBox(width: 5),
                      Text(
                        'Location',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
  }

  void _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri.parse('mailto:$email');

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch $email';
    }
  }


  void _launchURL(String url) async {
    final Uri launchUri = Uri.parse(url);

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $url';
    }
  }

}

class CallUsItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String phoneNumber;
  final String hours;

  const CallUsItem({
    super.key,
    required this.title,
    required this.icon,
    required this.phoneNumber,
    required this.hours,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      // Adjust bottom padding as needed
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 50),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Playfair',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    hours,
                    style: const TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      _launchPhone(phoneNumber);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.phone, size: 20, color: Colors.blue),
                        const SizedBox(width: 5),
                        Text(
                          phoneNumber,
                          style: const TextStyle(
                            fontFamily: 'Jost',
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  void _launchPhone(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri.parse('tel:$phoneNumber');

    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

}
