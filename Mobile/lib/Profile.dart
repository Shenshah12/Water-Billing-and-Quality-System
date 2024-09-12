import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'my_drawer.dart';
import 'firebase_listen.dart';

class BioScreen extends StatefulWidget {
  const BioScreen({super.key});

  @override
  _BioScreenState createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedTitle = 'Profile';
  File? _image;
  late String _name = '';
  late String _idNumber = '';
  late String _email = '';
  late String _phoneNumber = '';
  late String _roleType = '';
  late String _profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    // Obtain the stream of user data
    Stream<Map<String, dynamic>> userDataStream = Firebase_Service.streamUserData();

    // Listen to the stream to handle data as it arrives
    userDataStream.listen((userData) {
      setState(() {
        // Update state variables based on received data
        _name = userData['name'] ?? '';
        _idNumber = userData['idNumber'] ?? '';
        _email = userData['email'] ?? '';
        _phoneNumber = userData['phoneNumber'] ?? '';
        _roleType = userData['roleType'] ?? '';
        _profileImageUrl = userData['profileImageUrl'] ?? '';
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
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 50.0),
                child: ClipOval(
                  child: GestureDetector(
                    onTap: () {
                      if (_profileImageUrl.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: SizedBox(
                                width: 200,
                                height: 200,
                                child: Image.network(_profileImageUrl, fit: BoxFit.cover),
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      color: Colors.indigo,
                      child: _image == null
                          ? (_profileImageUrl.isNotEmpty
                          ? CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(_profileImageUrl),
                      )
                          : const Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.white,
                      ))
                          : Image.file(_image!, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 100), // Adjust horizontal padding as needed
                child: ElevatedButton.icon(
                  onPressed: _getImage,
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blueAccent,
                  ),
                  label: const Text(
                    'Edit Photo',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontFamily: "Jost",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blueAccent,
                      decorationThickness: 2.0,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 200, // Adjust width as needed
                padding: const EdgeInsets.symmetric(horizontal: 90), // Adjust horizontal padding as needed
                child: ElevatedButton.icon(
                  onPressed: _updateProfile,
                  icon: const Icon(
                    Icons.update,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'Profile Update',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: "Jost",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.red,
                      decorationThickness: 2.0,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Container(
                width: 200,
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: ElevatedButton.icon(
                  onPressed: () { // Wrap _showBottomSheet(context) inside a function
                    _showBottomSheet(context);
                  },
                  icon: const Icon(
                    Icons.info_rounded,
                  ),
                  label: const Text(
                    'Show Profile Credentials',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Jost",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.deepPurple,
                      decorationThickness: 2.0,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ),
              )
              ,
              SizedBox(height: MediaQuery.of(context).padding.bottom), // Ensure bottom padding for safe area
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              border: Border.all(
                color: Colors.grey, // Change border color here
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField('$_name (Name)', Icons.person, Colors.black),
                _buildTextField('$_idNumber (Id Number)', Icons.numbers_sharp, Colors.black),
                _buildTextField('$_email (Email)', Icons.email, Colors.black),
                _buildTextField('$_phoneNumber (Phone Number)', Icons.phone, Colors.black),
                _buildTextField('$_roleType (Role Type)', Icons.assignment_ind_rounded, Colors.black),
                // Add more TextFields here if needed
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Select Image",
            style: TextStyle(
              fontFamily: 'Jost',
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text(
                  'Pick from Gallery',
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: 20,
                  ),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text(
                  'Take a Picture',
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: 20,
                  ),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  final pickedFile = await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateProfile() async {
    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Updating profile...',
              style: TextStyle(fontSize: 15,
              fontFamily: 'Jost',
              color: Colors.black
              ),
              ),
            ],
          ),
        );
      },
    );

    try {
      // Get current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'name': _name,
          'idNumber': _idNumber,
          'email': _email,
          'phoneNumber': _phoneNumber,
          'roleType': _roleType,
        });

        // If a new image is selected, upload it to Firebase Storage
        if (_image != null) {
          String imagePath = 'users/${user.uid}/profile_image.jpg';
          Reference storageReference = FirebaseStorage.instance.ref().child(imagePath);
          UploadTask uploadTask = storageReference.putFile(_image!);
          await uploadTask.whenComplete(() async {
            // Get the download URL of the uploaded image
            String imageUrl = await storageReference.getDownloadURL();

            // Update profile image URL in Firestore
            await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
              'profileImageUrl': imageUrl,
            });
          });
        }

        // Dismiss the loading dialog
        Navigator.of(context).pop();

        // Show a snackbar to indicate successful profile update
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Dismiss the loading dialog
      Navigator.of(context).pop();

      // Show a snackbar to indicate error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating profile. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildTextField(String labelText, IconData icon, Color textColor) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            style: const TextStyle(
              fontFamily: 'Playfair',
              color: Colors.black,
              fontSize: 20,
            ),
            enabled: false,
            decoration: InputDecoration(
              hintText: labelText,
              hintStyle: const TextStyle(
                fontFamily: 'Jost',
                color: Colors.black,
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black), // Add bottom line
              ),
            ),
          ),
        ),
      ],
    );
  }
}
