import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late User? _user;
  late FirebaseFirestore _firestore;



  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
    } else {
      // Handle scenario where no user is signed in
    }
  }


  Widget _buildMonthlyView(User? user) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final data = snapshot.data?.data() as Map<String, dynamic>?;

          if (data == null) {
            return const Center(
              child: Text('Data not available'),
            );
          }

          final monthlyUsage = data['monthly_usage'] as Map<String, dynamic>?;

          if (monthlyUsage == null || monthlyUsage.isEmpty) {
            return const Center(
              child: Text(
                'No monthly data available',
                style: TextStyle(
                  fontFamily: 'Playfair',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Monthly bill will be calculated daily and paid at the end of the month.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith((states) => Colors.black),
                    dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Month',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Playfair',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Monthly Bill (Rs.)',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Playfair',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    rows: monthlyUsage.entries.map((entry) {
                      final month = entry.key;
                      final monthData = entry.value as Map<String, dynamic>;
                      final monthlyBill = monthData['monthly_bill'] ?? 0.0;

                      return DataRow(
                        cells: [
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                month,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Jost',
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                monthlyBill.toStringAsFixed(2),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Jost',
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
            icon: const Icon(Icons.arrow_back),
            color: Colors.indigo,
            onPressed: () {
              Navigator.pop(context); // Navigate back when the back arrow icon is pressed
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
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: _buildMonthlyView(_user),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
