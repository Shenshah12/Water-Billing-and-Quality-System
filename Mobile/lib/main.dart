import 'dart:async';
import 'package:customer/Usage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'splash_screen.dart';
import 'About.dart';
import 'Contact.dart';
import 'Home.dart';
import 'Logout.dart';
import 'Profile.dart';
import 'forgot.dart';
import 'Billing.dart';
import 'History.dart';
import 'LiveFlow.dart';
import 'dart:io';
import 'splash_screen2.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await initializeFirebase();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Run the app
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const SplashScreen(),
    routes: {
      'Sign_in': (context) => const MyLogin(),
      'forgot': (context) => const ForgotScreen(),
      'home': (context) => const HomeScreen(),
      'about': (context) => const AboutScreen(),
      'profile': (context) => const BioScreen(),
      'contact': (context) => const ContactScreen(),
      'usage': (context) => const DailyUsageTracker(),
      'bill': (context) => const BillingScreen(),
      'history': (context) => const HistoryScreen(),
      'Flow': (context) => const LiveFlowScreen(),
      'logout': (context) => const LogoutScreen(),
    },
  ));
}

Future<void> initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "Your Credentials",
        authDomain: "Your Credentials",
        projectId: "Your Credentials",
        storageBucket: "Your Credentials",
        messagingSenderId: "Your Credentials",
        appId: "Your Credentials",
        measurementId: "Your Credentials",
      ),
    );
  }

  else {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'Your Credentials',
          appId: 'Your Credentials',
          messagingSenderId: 'Your Credentials',
          projectId: 'Your Credentials',
          storageBucket: 'Your Credentials',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  }
}

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _signIn(BuildContext context) async {
    bool emailEmpty = _emailController.text.isEmpty;
    bool passwordEmpty = _passwordController.text.isEmpty;

    if (emailEmpty || passwordEmpty) {
      // Show alert dialog for empty fields
      _showAlertDialog(
        'Please Fill Required Fields',
        '${emailEmpty ? 'Email field is empty.\n' : ''}'
            '${passwordEmpty ? 'Password field is empty.' : ''}',
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String userId = userCredential.user!.uid;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userSnapshot.exists) {
        String roleType = userSnapshot['roleType'];
        if (roleType == 'Customer') {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  SplashScreen2(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = 0.0;
                const end = 1.0;
                const curve = Curves.easeInOut;

                final tween = Tween(begin: begin, end: end);
                final curvedAnimation = CurvedAnimation(
                  parent: animation,
                  curve: curve,
                );

                return FadeTransition(
                  opacity: tween.animate(curvedAnimation),
                  child: child,
                );
              },
              transitionDuration: const Duration(seconds: 1),
            ),
          );

        } else {
          _showAlertDialog('Access Denied', 'You do not have permission to log in.');
          await FirebaseAuth.instance.signOut();
        }
      } else {
        _showAlertDialog('User Not Found', 'User not found in database.');
        await FirebaseAuth.instance.signOut();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showAlertDialog('Incorrect Credentials', 'Incorrect credentials for email.');
      } else if (e.code == 'wrong-password') {
        _showAlertDialog('Incorrect Credentials', 'Incorrect credentials for password.');
      } else {
        _showAlertDialog('Incorrect Credentials', 'Please enter the correct credentials.');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const SizedBox(height: 100),
            Container(
              height: MediaQuery.of(context).size.height * .24,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/back.png'), // Path to your image asset
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          errorStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _passwordController,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Password',
                          errorStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            icon: Icon(
                              _isObscure ? Icons.visibility_off : Icons.visibility,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'forgot');
                            },
                            child: const Text(
                              'Forgot Password',
                              style: TextStyle(
                                fontFamily: 'Jost',
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF000BFF),
                                color: Color(0xFF000BFF),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _signIn(context);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.indigoAccent),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(color: Colors.indigoAccent),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Login',
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
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
}
