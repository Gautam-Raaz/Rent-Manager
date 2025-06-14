import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_manager/admin/controller/firebase_api.dart';
import 'package:rent_manager/model/transaction.dart';

import '../../constant/dbkeys.dart';

class AdminPay extends StatefulWidget {
  const AdminPay({super.key});

  @override
  State<AdminPay> createState() => _AdminPayState();
}

class _AdminPayState extends State<AdminPay> {
  String amount = '';
  String phoneNumber = '';
  bool isloading = false;

  void showSnack(String text) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Cash Payment",style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.green,
          leading: BackButton(color: Colors.white,),
      ),
      body: isloading ? Center(child: CircularProgressIndicator(),) : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [


            // Phone Number
            SizedBox(height: 20,),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                'Amount',
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
                  amount = value;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Cash Amount',
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
                'Renter Phone Number',
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
                  phoneNumber = value;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Renter Phone Number',
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

                  if(phoneNumber.length != 10) {
                    showSnack("Please Enter Correct Phone Number");
                  } else if(int.parse(amount) < 0) {
                    showSnack("Please Enter Cash Amount");
                  } else {
                    setState(() {
                      isloading = true;
                    });

                    await FirebaseFirestore.instance.collection(AppConstant.userTable).doc(phoneNumber).get().then((doc) async{
                      if(doc.exists) {

                        var wallet = Wallet(
                            amount: amount,
                            status: 'Approved',
                            timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
                            userPhone: phoneNumber,
                            userName: doc.data()!['name'],
                            userPic: doc.data()!['profilePic'],
                            transId: 'admin_pay',
                            paymentPic: '',
                            mode: 'cash',
                            remark: '',
                            duesType: ''
                        );

                        FirebaseApi().addPayment(wallet);

                        setState(() {
                          isloading = false;
                        });

                        showSnack("Add Payment Successfully");

                        Navigator.pop(context, true);

                      } else {
                        setState(() {
                          isloading = false;
                        });
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
    );
  }
}
