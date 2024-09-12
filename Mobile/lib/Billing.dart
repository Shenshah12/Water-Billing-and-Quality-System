import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'my_drawer.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  _BillingScreenState createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedTitle = 'Bill';

  // Function to fetch previous month's billing data from Firestore
  Future<dynamic> fetchPreviousMonthBill() async {
    try {
      // Get the current user from FirebaseAuth
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Calculate the date for the previous month
        DateTime now = DateTime.now();
        DateTime previousMonth = DateTime(now.year, now.month - 1, now.day);

        // Format the previous month as "YYYY-MM"
        String previousMonthFormatted = '${previousMonth.year}-${previousMonth.month.toString().padLeft(2, '0')}';

        // Access Firestore and fetch the user's billing data for the previous month
        DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
            .collection('users') // Your Firestore collection name
            .doc(user.uid) // Document ID based on user's unique ID
            .get();

        // Check if the snapshot contains the required data
        if (snapshot.exists) {
          // Access the monthly_bill field for the previous month from Firestore document
          dynamic previousMonthBill = snapshot.data()?['monthly_usage']?[previousMonthFormatted]?['monthly_bill'] ?? 0.0;
          return previousMonthBill;
        }
      }
      // Return 0.0 if user not found or data not available
      return 0.0;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching previous month bill: $e');
      }
      return 0.0;
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
      body:Container(
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
      child: Center(
        child: FutureBuilder<dynamic>(
          future: fetchPreviousMonthBill(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Display loading indicator while fetching data
            } else {
              dynamic previousMonthBill = snapshot.data ?? 0.0;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  MonthlyBill(
                    containerColor: Colors.white,
                    borderColor: Colors.white,
                    text: Colors.black,
                    text_field: Colors.black,
                    labelText: "Previous  Bill (pkr):",
                    hintText: previousMonthBill.toStringAsFixed(2),
                    assetPath: 'assets/bank.png',
                  ),
                  const SizedBox(height: 20),
                  const History(),
                ],
              );
            }
          },
        ),
      ),
      ),
    );
  }
}

class MonthlyBill extends StatelessWidget {
  final Color containerColor;
  final Color borderColor;
  final Color text;
  final Color text_field;
  final String labelText;
  final String hintText;
  final String? assetPath;

  const MonthlyBill({super.key,
    required this.containerColor,
    required this.borderColor,
    required this.text,
    required this.text_field,
    required this.labelText,
    required this.hintText,
    this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 230,
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: containerColor,
        border: Border.all(color: borderColor, width: 8.0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 22,
            child: Text(
              labelText,
              style: TextStyle(
                fontFamily: 'Playfair',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: text,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 25,
            child: SizedBox(
              width: 200,
              child: TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontFamily: 'Jost',
                    color: text_field,
                    fontSize: 20,
                  ),
                  border: InputBorder.none,
                  alignLabelWithHint: true,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            left: -25,
            child: Container(
              width: 360,
              height: 2,
              color: Colors.black,
            ),
          ),
          Positioned(
            bottom: -16,
            left: -5,
            child: assetPath != null
                ? Image.asset(
              assetPath!,
              width: 150,
              height: 150,
            )
                : const SizedBox(), // Conditionally display image if assetPath is provided
          ),
        ],
      ),
    );
  }
}

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 350,
          height: 280,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 15),
                    alignment: Alignment.topCenter,
                    child: const Text(
                      "Billing History",
                      style: TextStyle(
                        fontFamily: 'Playfair',
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    alignment: Alignment.topCenter,
                    child: const Text(
                      "All of your Bills",
                      style: TextStyle(
                        fontFamily: 'Jost',
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 38),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'history');
                      },
                      child: const Text(
                        'Tap here for more details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Playfair",
                          color: Colors.indigo,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 160,
                left: 8,
                right: 8,
                child: Container(
                  width: 360,
                  height: 2,
                  color: Colors.black,
                ),
              ),
              Positioned(
                bottom: -20,
                left: 0,
                child: Image.asset(
                  'assets/history.png',
                  width: 110,
                  height: 110,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}

