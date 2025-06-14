import 'package:flutter/material.dart';
import 'package:rent_manager/screen/login_screen.dart';
import 'package:rent_manager/screen/renter_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../admin/screen/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 2),() {
   /// for admin app
    // Future.delayed(Duration(seconds: 1),() {
    //   Navigator.pushReplacement(
    //     context,MaterialPageRoute(builder: (context) => Dashboard()),);
    // });

     checkUser();
    });

 
  }

  checkUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? phoneNumber = prefs.getString('phone');

    if(phoneNumber == null || phoneNumber == "null") {
        Navigator.pushReplacement(
          context,MaterialPageRoute(builder: (context) => LoginScreen()),);
    } else {
       Navigator.pushReplacement(
          context,MaterialPageRoute(builder: (context) => RenterDashboard(phoneNumber: phoneNumber,)),);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'asset/splash.jpg', // Replace with your image path
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Welcome!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
