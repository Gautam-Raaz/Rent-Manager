import 'package:flutter/material.dart';
import 'package:rent_manager/admin/screen/add_renter.dart';
import 'package:rent_manager/admin/screen/add_room.dart';
import 'package:rent_manager/admin/screen/home.dart';
import 'package:rent_manager/admin/screen/renterList.dart';
import 'package:rent_manager/admin/screen/roomList.dart';
import 'package:rent_manager/admin/screen/transaction_history.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    Renterlist(),
    Roomlist(),
    TransactionHistory(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: _currentIndex == 0 ? Colors.blue: Colors.blueGrey,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: _currentIndex == 1 ? Colors.blue: Colors.blueGrey,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.house,color: _currentIndex == 2 ? Colors.blue: Colors.blueGrey,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_sharp,color: _currentIndex == 3 ? Colors.blue: Colors.blueGrey,),
            label: '',
          ),
        ],
      ),
    );
  }
}
