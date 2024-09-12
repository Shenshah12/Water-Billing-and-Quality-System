import 'package:flutter/material.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuad,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuad,
      ),
    );

    _animationController.forward();

    navigateToLoginScreen();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void navigateToLoginScreen() {
    Future.delayed(const Duration(milliseconds: 2800), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1000),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          pageBuilder: (_, __, ___) => const MyLogin(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Set background color to transparent
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //     colors: [
        //       Color(0xFFAAB5C6), // Moonstone color
        //       Color(0xFFB0C2D8),
        //       Color(0xFFCAD0DC),
        //       Color(0xFFE6E9ED),
        //       Color(0xFFB0C2D8),
        //       Color(0xFFAAB5C6),
        //     ],
        //   ),
        // ),
        color: Colors.white,
        child: Stack(
          children: [
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: Image.asset(
                    'assets/back.png', // Replace with your image asset path
                    width: 400, // Adjust width as needed
                    height: 400, // Adjust height as needed
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
