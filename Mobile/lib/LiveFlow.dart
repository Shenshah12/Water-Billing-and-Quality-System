import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'my_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveFlowScreen extends StatefulWidget {
  const LiveFlowScreen({super.key});

  @override
  _LiveFlowScreenState createState() => _LiveFlowScreenState();
}

class _LiveFlowScreenState extends State<LiveFlowScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedTitle = 'flow';
  String _flowRate = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .listen((DocumentSnapshot snapshot) {
          if (snapshot.exists) {
            // Cast the data to Map<String, dynamic>
            Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

            // Extract the flowRate from the document
            dynamic flowRate = data?['decoded_payload'] as dynamic;
            if (flowRate != null) {
              setState(() {
                _flowRate = flowRate.toString();
              });
            }
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user data: $e");
      }
    }
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
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            height: 200,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0),
                  child: Text(
                    'Flow Rate (Litre/min)',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PlayFair'
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child:TextFormField(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    initialValue: _flowRate,
                    decoration: InputDecoration(
                      enabled: false,
                      hintText: _flowRate.isNotEmpty ? _flowRate : "0",
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Jost',
                        fontSize: 20,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
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
