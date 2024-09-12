import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GridDashboard extends StatelessWidget {
  const GridDashboard({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: Column(
              children: [
                StreamBuilder<Map<String, dynamic>>(
                  stream: fetchMonthlyUsageStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Loading indicator
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    // Extract monthly bill from snapshot data
                    dynamic monthlyBill = snapshot.data?['monthly_bill'] ?? 0.0;
                    dynamic monthlyTotal = snapshot.data?['monthly_total'] ?? 0.0;

                    return Column(
                      children: [
                        MonthlyBill(
                          containerColor: Colors.white,
                          borderColor: Colors.white,
                          text: Colors.black,
                          text_field: Colors.black,
                          line: Colors.black,
                          labelText: 'Current Bill:',
                          hintText: monthlyBill.toStringAsFixed(2),
                          assetPath: 'assets/bank.png',
                          bottom: -15,
                          left: -5,
                          width: 150,
                          height: 150,
                        ),
                        const SizedBox(height: 20),
                        MonthlyBill(
                          containerColor: Colors.white,
                          borderColor: Colors.white,
                          text: Colors.black,
                          text_field: Colors.black,
                          line: Colors.black,
                          labelText: 'Current Usage (Litres):',
                          hintText: monthlyTotal.toString(),
                          assetPath: 'assets/usage.png',
                          bottom: -55,
                          left: -20,
                          width: 220,
                          height: 220,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stream<Map<String, dynamic>> fetchMonthlyUsageStream() async* {
    // Retrieve the current authenticated user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Calculate the previous month in YYYY-MM format
      String previousMonth = getPreviousMonth();

      // Reference to the Firestore document for the current user
      DocumentReference<Map<String, dynamic>> userDocRef =
      FirebaseFirestore.instance.collection('users').doc(user.uid);

      try {
        // Listen to changes on the user document
        Stream<DocumentSnapshot<Map<String, dynamic>>> stream =
        userDocRef.snapshots();

        await for (DocumentSnapshot<Map<String, dynamic>> userSnapshot in stream) {
          // Extract the monthly usage map from the user document
          Map<String, dynamic> monthlyUsageData =
              userSnapshot.data()?['monthly_usage'] ?? {};

          // Extract the monthly bill for the previous month
          dynamic monthlyBill =
              monthlyUsageData[previousMonth]?['monthly_bill'] ?? 0.0;
          dynamic monthlyTotal =
              monthlyUsageData[previousMonth]?['monthly_total'] ?? 0.0;

          yield {'monthly_bill': monthlyBill, 'monthly_total': monthlyTotal};
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching monthly usage data: $e');
        }
        yield {'monthly_bill': 0.0, 'monthly_total': 0.0};
      }
    }

    yield {'monthly_bill': 0.0, 'monthly_total': 0.0};
  }

  String getPreviousMonth() {
    DateTime now = DateTime.now();
    DateTime previousMonth = DateTime(now.year, now.month);

    // Format the date as YYYY-MM
    return '${previousMonth.year}-${previousMonth.month.toString().padLeft(2, '0')}';
  }
}

Widget MonthlyBill({
  Color containerColor = Colors.white,
  Color borderColor = Colors.white,
  Color text = Colors.white,
  Color text_field = Colors.white,
  Color line = Colors.white,
  double borderWidth = 8.0,
  required String labelText,
  required String hintText,
  double bottom = 20,
  double left = 20,
  double width = 20,
  double height = 20,
  String? assetPath, // Updated parameter to allow null values
}) {
  return Column(
    children: [
      Container(
        width: 350,
        height: 230,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: containerColor,
          border: Border.all(color: borderColor, width: borderWidth),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 20,
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
              left: 10,
              child: SizedBox(
                width: 200,
                child: TextFormField(
                  enabled: false,
                  initialValue: hintText,
                  style: TextStyle(
                    fontFamily: 'Jost',
                    color: text_field,
                    fontSize: 20,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 9.2,
                      horizontal: 10,
                    ),
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
                color: line,
              ),
            ),
            Positioned(
              bottom: bottom,
              left: left,
              child: assetPath != null
                  ? Image.asset(
                assetPath,
                width: width,
                height: height,
              )
                  : const SizedBox(), // Conditionally display image if assetPath is provided
            ),
          ],
        ),
      ),
      const SizedBox(height: 5),
      // Add more widgets for previous container as needed
    ],
  );
}
