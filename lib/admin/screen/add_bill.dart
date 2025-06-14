import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_manager/constant/dbkeys.dart';

import '../../model/Renter.dart';
import '../../model/transaction.dart';
import '../controller/firebase_api.dart';

class AddBill extends StatefulWidget {
   Renter data;
   AddBill({super.key,required this.data});

  @override
  State<AddBill> createState() => _AddBillState();
}

class _AddBillState extends State<AddBill> {

  bool isloading = false;
  List<String> billTypes = ["Room Rent", "Electricity Bill", "Additional Bill"];
  String selectedBillType = 'Room Rent';
  String amount = '';
  String remark = '';

  void showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white,),
        title: Text("Add Bill",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      body: isloading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [


              // Bill Type
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Bill Type: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),

           DropdownButton(
            value: selectedBillType,
            onChanged: (newValue) {
              setState(() {
                selectedBillType = newValue!;
              });
            },
            items: billTypes.map((location) {
              return DropdownMenuItem(
                child: new Text(location),
                value: location,
              );
            }).toList(),
          ),

              // Bill Amount
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Bill Amount',
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
                    hintText: 'Enter Bill Amount',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),

              // Bill Remark
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Bill Remark',
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
                    remark = value;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Bill Remark',
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
                  onTap: () async {

                 if(amount.isEmpty) {
                      showSnack("Please Enter Bill Amount");
                    } else if(remark.isEmpty) {
                      showSnack("Please Enter Bill Remark");
                    } else {

                      setState(() {
                         isloading = true;
                       });

                      var wallet = Wallet(
                          amount: amount,
                          status: AppConstant.payBill,
                          timestamp: DateTime
                              .now()
                              .millisecondsSinceEpoch
                              .toString(),
                          userPhone: widget.data.phoneNumber,
                          userName: widget.data.name,
                          userPic: widget.data.profilePic,
                          transId: '',
                          paymentPic: '',
                          mode: '',
                          remark: remark,
                          duesType: selectedBillType
                      );

                      FirebaseApi().addPayment(wallet);

                      int pendingAmount = widget.data.pendingAmount + int.parse(amount);

                     await FirebaseFirestore.instance.collection(AppConstant.userTable).
                        doc(widget.data.phoneNumber).
                      update({
                        'pendingAmount': pendingAmount
                      });

                      setState(() {
                        isloading = false;
                      });

                      showSnack("Bill Added Successfully");

                      Navigator.pop(context, true);
                    }

                  },
                  child: Container(
                    height: 40,
                    width: 180,
                    child: Center(
                      child: Text("Add Bill",style: TextStyle(color: Colors.white),),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}
