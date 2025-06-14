import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_manager/constant/dbkeys.dart';
import 'package:rent_manager/screen/renter_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../admin/screen/dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isloading = false;
  String phone = '';
  String password = '';

  void showSnack(String text) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
          actions: [
            
          IconButton(onPressed: () {

      Navigator.pushReplacement(
        context,MaterialPageRoute(builder: (context) => Dashboard()),);
        
          }, icon: Icon(Icons.add,color: Colors.white,)),
        ]
      ),
      body: isloading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [


              // Phone Number
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Phone Number',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  onChanged: (value) {
                    phone = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Phone Number',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),

              // Password
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Password',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey[200],
                ),

                child: TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter password',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),



              SizedBox(height: 30,),

              Center(
                child: InkWell(
                  onTap: () async{
                    if(phone.length != 10) {
                      showSnack("Please Enter Correct Phone Number");
                    } else {

                      await FirebaseFirestore.instance.collection(AppConstant.userTable).doc(phone).get().then((doc) async{
                        if(doc.exists) {
                         if(doc.data()!['password'] != password) {
                           showSnack("Incorrect Password");
                         } else {
                           final SharedPreferences prefs = await SharedPreferences.getInstance();
                           await prefs.setString('phone', phone);

                           Navigator.pushReplacement(
                             context,MaterialPageRoute(builder: (context) => RenterDashboard(phoneNumber: phone,)),);

                         }
                        } else {
                          showSnack("Phone Number not exists");
                        }
                      }
                      );

                    }

                  },
                  child: Container(
                    height: 40,
                    width: 180,
                    child: Center(
                      child: Text("Login",style: TextStyle(color: Colors.white),),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30,),





            ],
          ),
        ),
      ),
    );
  }
}
