import 'package:flutter/material.dart';
import 'package:rent_manager/admin/screen/add_renter.dart';
import 'package:rent_manager/screen/payment_history.dart';

class RenterDashboard extends StatefulWidget {
  String phoneNumber;
   RenterDashboard({super.key,required this.phoneNumber});

  @override
  State<RenterDashboard> createState() => _RenterDashboardState();
}

class _RenterDashboardState extends State<RenterDashboard> {

  int _currentIndex = 0;

   List<Widget> _screens = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializedScreen();
  }

  initializedScreen() async{
    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      _screens = [
        PaymentHistory(phoneNumber: widget.phoneNumber),
        AddRenter(isAdmin: false,phoneNumber: widget.phoneNumber),
      ];
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_screens.isNotEmpty ? _screens[_currentIndex] : Center(child: CircularProgressIndicator(),),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [

          BottomNavigationBarItem(
            icon: Icon(Icons.manage_history_sharp),
            label: 'Payment History',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
