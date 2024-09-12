import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'my_drawer.dart';

class DailyUsageTracker extends StatefulWidget {
  const DailyUsageTracker({super.key});

  @override
  _DailyUsageTrackerState createState() => _DailyUsageTrackerState();
}

class _DailyUsageTrackerState extends State<DailyUsageTracker> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late User? _user;
  late FirebaseFirestore _firestore;
  List<String> _months = [];
  List<Map<String, dynamic>> _monthData = [];
  String _selectedTitle = 'Usage';
  String? _selectedMonth; // Track the selected month
  late String _selectedScreen = 'Daily'; // Track the selected screen

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      // _checkUserDocument();
      // _resetDailyUsage();
      // _checkAndCalculateMonthlyTotals();
      _loadMonthsFromFirestore();
    } else {
      // Handle scenario where no user is signed in
    }
  }


  // Future<void> _checkUserDocument() async {
  //   DocumentSnapshot userDoc =
  //   await _firestore.collection('users').doc(_user!.uid).get();
  //
  //   if (!userDoc.exists) {
  //     await _createUserDocument();
  //   } else {
  //     // Check and add missing fields (daily_usage, monthly_usage)
  //     Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
  //     bool documentUpdated = false;
  //
  //     if (!userData.containsKey('daily_usage')) {
  //       userData['daily_usage'] = {};
  //       documentUpdated = true;
  //     }
  //
  //     if (!userData.containsKey('monthly_usage')) {
  //       userData['monthly_usage'] = {};
  //       documentUpdated = true;
  //     }
  //
  //     // Update the document if any fields were added
  //     if (documentUpdated) {
  //       await userDoc.reference.update(userData);
  //     }
  //   }
  // }
  //
  // Future<void> _createUserDocument() async {
  //   await _firestore.collection('users').doc(_user!.uid).set({
  //     'total': 0.0,
  //     'daily_usage': {}, // Initialize with empty map
  //     'monthly_usage': {}, // Initialize with empty map
  //   });
  // }
  //



  // void _checkAndCalculateMonthlyTotals() {
  //   DateTime now = DateTime.now();
  //   DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
  //
  //   if (now.day == lastDayOfMonth.day) {
  //     calculateMonthlyTotals();
  //   }
  // }
  //
  //
  // Future<void> calculateMonthlyTotals() async {
  //   try {
  //     DateTime now = DateTime.now();
  //     String currentMonthYear = '${now.year}-${now.month.toString().padLeft(2, '0')}';
  //
  //     // Retrieve user document from Firestore
  //     DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(_user!.uid);
  //     DocumentSnapshot userDoc = await userRef.get();
  //
  //     if (userDoc.exists) {
  //       // Retrieve existing monthly usage data or initialize an empty map
  //       Map<String, dynamic> monthlyUsage = userDoc.get('monthly_usage') ?? {};
  //       monthlyUsage[currentMonthYear] ??= {};
  //
  //       // Initialize monthly total
  //       double monthlyTotal = 0.0;
  //
  //       // Retrieve daily usage data for the current month (April 2024)
  //       Map<String, dynamic>? dailyUsage = userDoc.get('daily_usage');
  //       if (dailyUsage != null && dailyUsage.containsKey('4-2024')) {
  //         // Retrieve daily usage data for April 2024
  //         Map<String, dynamic> aprilDailyUsage = dailyUsage['4-2024'];
  //
  //         // Calculate monthly total by summing up daily usage values
  //         aprilDailyUsage.forEach((day, usage) {
  //           if (usage is num) {
  //             monthlyTotal += usage.toDouble(); // Accumulate daily usage into monthly total
  //             if (kDebugMode) {
  //               print('Added $usage to monthlyTotal. Current monthlyTotal: $monthlyTotal');
  //             }
  //           }
  //         });
  //
  //         // Round monthly total to two decimal places
  //         monthlyTotal = double.parse(monthlyTotal.toStringAsFixed(2));
  //
  //         // Calculate monthly bill assuming a rate of 8 per unit
  //         double monthlyBill = monthlyTotal * 8;
  //
  //         // Update monthly usage data with calculated totals
  //         monthlyUsage[currentMonthYear]['monthly_total'] = monthlyTotal;
  //         monthlyUsage[currentMonthYear]['monthly_bill'] = monthlyBill;
  //
  //         // Update Firestore document with the updated monthly usage data
  //         await userRef.update({
  //           'monthly_usage': monthlyUsage,
  //         });
  //
  //         // Log success message and updated monthly usage
  //         if (kDebugMode) {
  //           print('Monthly totals updated successfully for $currentMonthYear:');
  //         }
  //         if (kDebugMode) {
  //           print('Monthly Usage After Update: $monthlyUsage');
  //         }
  //       } else {
  //         if (kDebugMode) {
  //           print('No daily usage data found for $currentMonthYear');
  //         }
  //       }
  //     } else {
  //       if (kDebugMode) {
  //         print('User document does not exist for $_user!.uid');
  //       }
  //     }
  //   } catch (e, stackTrace) {
  //     if (kDebugMode) {
  //       print('Error calculating and updating monthly totals: $e');
  //     }
  //     if (kDebugMode) {
  //       print(stackTrace);
  //     } // Print stack trace for detailed error analysis
  //   }
  // }
  //



  // void _resetDailyUsage() async {
  //   try {
  //     DateTime now = DateTime.now();
  //
  //     // Retrieve current date (e.g., '2022-04-01')
  //     String currentDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  //
  //     // Retrieve current 'total' value
  //     double? currentTotal = await getDailyUsage();
  //
  //     if (currentTotal != null) {
  //       // Update 'daily_usage' map with current day's usage value
  //       String monthYearKey = '${now.month}-${now.year}';
  //
  //       // Get existing daily usage data for the month-year combination
  //       Map<String, dynamic> monthlyUsage = (await _firestore.collection('users').doc(_user!.uid).get()).get('daily_usage') ?? {};
  //
  //       // Update or create the month-year entry
  //       monthlyUsage.putIfAbsent(monthYearKey, () => {});
  //
  //       // Round and format the currentTotal to two decimal places
  //       String formattedCurrentTotal = currentTotal.toStringAsFixed(2);
  //       monthlyUsage[monthYearKey][currentDate] = double.parse(formattedCurrentTotal);
  //
  //       // Update the Firestore document with the modified 'daily_usage'
  //       await _firestore.collection('users').doc(_user!.uid).update({
  //         'daily_usage': monthlyUsage,
  //       });
  //
  //       // Check and calculate monthly totals if it's the last day of the month
  //       if (now.day == DateTime(now.year, now.month + 1, 0).day) {
  //         calculateMonthlyTotals();
  //       }
  //     } else {
  //       if (kDebugMode) {
  //         print('Error: Failed to retrieve daily usage.');
  //       }
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error resetting daily total: $e');
  //     }
  //   }
  //   _resetDailyUsage();
  // }

  Future<void> _loadMonthsFromFirestore() async {
    try {
      final userDoc = await _firestore.collection('users').doc(_user!.uid).get();

      if (userDoc.exists) {
        final dailyUsage = userDoc.data()?['daily_usage'] ?? {};

        _months = dailyUsage.keys.map((key) => key.toString()).toList().cast<String>();
        setState(() {});
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading months: $e');
      }
    }
  }

  void _fetchMonthData(String selectedMonth) async {
    try {
      final userDoc = await _firestore.collection('users').doc(_user!.uid).get();

      if (userDoc.exists) {
        final dailyUsage = userDoc.data()?['daily_usage'] ?? {};

        // Retrieve daily usage data for the selected month
        final selectedMonthData = dailyUsage[selectedMonth] ?? {};

        // Prepare the month data list to populate the DataTable
        List<Map<String, dynamic>> monthDataList = [];

        // Iterate over the entries in selectedMonthData map
        selectedMonthData.forEach((date, amount) {
          // Add each date-amount pair to monthDataList
          monthDataList.add({
            'date': date,
            'amount': amount,
          });
        });

        // Update _monthData to trigger DataTable rebuild
        setState(() {
          _monthData = monthDataList;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching month data: $e');
      }
    }
  }





  Future<dynamic> getDailyUsage() async {
    try {
      var userDoc = await _firestore.collection('users').doc(_user!.uid).get();

      if (userDoc.exists) {
        dynamic decodedPayload = userDoc.data()?['decoded_payload'];
        // Initialize total to zero if it's null
        dynamic total = userDoc.data()?['total'] ?? 0.0;

        // Add decodedPayload to total
        total += decodedPayload;

        return total;
            }
    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving daily usage: $e');
      }
    }

    return null;
  }


  @override
  void dispose() {
    // Cancel any timers, animations, or listeners here
    super.dispose();
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedScreen = 'Daily';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedScreen == 'Daily' ? Colors.blue : Colors.white,
                    ),
                    child: const Text('Daily',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Jost',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedScreen = 'Monthly';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedScreen == 'Monthly' ? Colors.blue : Colors.white,
                    ),
                    child: const Text('Monthly',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Jost',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _selectedScreen == 'Daily' ? _buildDailyView() : _buildMonthlyView(),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDailyView() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .snapshots(),
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

          // Sorting _monthData based on the date
          _monthData.sort((a, b) {
            // Convert date strings to DateTime objects
            DateTime dateA = DateTime.parse(a['date']);
            DateTime dateB = DateTime.parse(b['date']);
            // Compare dates
            return dateA.compareTo(dateB);
          });

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16.0),
                DropdownButton<String>(
                  value: _selectedMonth, // Track the selected month
                  hint: const Text(
                    'Select Month',
                    style: TextStyle(
                      fontFamily: 'Playfair',
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  items: _months.map((month) {
                    return DropdownMenuItem<String>(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                  onChanged: (selectedMonth) {
                    setState(() {
                      _selectedMonth = selectedMonth; // Update the selected month
                    });
                    _fetchMonthData(selectedMonth!); // Fetch data for the selected month
                  },
                ),
                const SizedBox(height: 16.0),
                if (_monthData.isNotEmpty)
                  DataTable(
                    headingRowColor: MaterialStateColor.resolveWith((states) => Colors.black),
                    dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Date',
                          style: TextStyle(
                            color: Colors.white, // Text color for column label
                            fontFamily: 'Playfair',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Amount (litres)',
                          style: TextStyle(
                            color: Colors.white, // Text color for column label
                            fontFamily: 'Playfair',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    rows: _monthData.map((entry) {
                      final date = entry['date'];
                      final amount = entry['amount'];
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              date,
                              style: const TextStyle(
                                color: Colors.black, // Text color for data cell
                                fontFamily: 'Jost',
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataCell(
                            Text(
                              amount.toString(),
                              style: const TextStyle(
                                color: Colors.black, // Text color for data cell
                                fontFamily: 'Jost',
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildMonthlyView() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final data = snapshot.data?.data() as Map<String, dynamic>?;

          if (data == null) {
            return Center(
              child: Text('Data not available'),
            );
          }

          final monthlyUsage = data['monthly_usage'] as Map<String, dynamic>?;

          if (monthlyUsage == null || monthlyUsage.isEmpty) {
            return Center(
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

          // Sort monthlyUsage by keys (months)
          final sortedMonthlyUsage = Map.fromEntries(
            monthlyUsage.entries.toList()
              ..sort((a, b) => a.key.compareTo(b.key)),
          );

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Monthly Total will be calculated daily and bill will be paid at the end of the month.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.0),
                DataTable(
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
                        'Total Usage (litres)',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Playfair',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  rows: sortedMonthlyUsage.entries.map((entry) {
                    final month = entry.key;
                    final monthData = entry.value as Map<String, dynamic>;
                    final totalUsage = monthData['monthly_total'] ?? 0.0;
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            month,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Jost',
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        DataCell(
                          Text(
                            totalUsage.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Jost',
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }
      },
    );
  }

}