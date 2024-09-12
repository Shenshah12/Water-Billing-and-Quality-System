
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Show success message or navigate to a success screen
      print('Password reset email sent to $email');
    } catch (e) {
      // Handle errors (e.g., invalid email, user not found)
      print('Failed to send password reset email: $e');
      // Show error message to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('User not Found.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double fem = 1.0; // Replace with your desired factor
    double ffem = 1.0; // Replace with your desired factor

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(top: 16 * fem, left: 16 * fem),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_sharp),
            onPressed: () {
              Navigator.pushNamed(context, 'Sign_in');
            },
          ),
        ),
      ),
      body: Stack(
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
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(18 * fem, 40 * fem, 18 * fem, 16 * fem),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * fem, 50 * fem, 0 * fem, 94 * fem),
                    child: Text(
                      'Forgot Password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        height: 0.78 * ffem / fem,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  SizedBox(height: 20 * fem), // Adding space between the title and the container
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Enter your email address:',
                            style: const TextStyle(
                              fontFamily: 'PlayFair',
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _emailController, // Your TextEditingController
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              filled: true,
                              fillColor: Colors.white, // Set field color to white
                              prefixIcon: Icon(Icons.email),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.indigoAccent),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(color: Colors.indigoAccent),
                                ),
                              ),
                            ),
                            onPressed: () {
                              String email = _emailController.text.trim();
                              if (email.isNotEmpty) {
                                _resetPassword(email);
                              } else {
                                // Show error if email field is empty
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Error'),
                                    content: Text('Please enter your email address.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context); // Close the dialog
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Reset Password',
                              style: TextStyle(
                                fontFamily: 'Jost',
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
