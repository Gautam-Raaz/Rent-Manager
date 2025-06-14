import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_manager/constant/dbkeys.dart';
import 'package:rent_manager/model/Renter.dart';
import 'package:rent_manager/screen/renter_pay.dart';

import '../model/transaction.dart';

class PaymentHistory extends StatefulWidget {
  String phoneNumber;
   PaymentHistory({super.key,required this.phoneNumber});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  List<Wallet> trans = [];
  bool isAllowed = true;
  Renter? data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

    getUserDetails();
  }

  getUserDetails() {
    FirebaseFirestore.instance.collection(AppConstant.userTable).doc(widget.phoneNumber).
    get().then((value) {
      setState(() {
        data = Renter.fromJson(value.data()!);
      });
    });
  }

  getData() {

    trans = [];

    FirebaseFirestore.instance.collection(AppConstant.transactionTable).where('userPhone',isEqualTo: widget.phoneNumber).
    get().then((value) {

      if(value.docs.isNotEmpty) {

        value.docs.forEach((transaction) {

          setState(() {

            trans.add(Wallet.fromJson(transaction.data()));

          });

        });
      }
    });

  }

  void showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Payment History",style: TextStyle(color: Colors.white),),
          centerTitle: true,
          backgroundColor: Colors.green,
      ),
      body: Column(children: [
        Container(
          height: 100,
          color: Colors.grey[100],
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(" Pending Amount: ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                Icon(Icons.currency_rupee),
                Text("${data != null ? data!.pendingAmount.toString() : '0'}",style: TextStyle(fontSize: 18,),)
              ],
            ),
          ),

        ),
        Expanded(
          child: trans.isEmpty ? Center(child: Text("No Payment History"),) : ListView.builder(
              itemCount: trans.length,
              itemBuilder: (context,index) {
                Wallet data = trans[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipOval(
                            child: Image(
                              image: NetworkImage(
                                data.userPic,
                              ),
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 20,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("Name: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                  Text(data.userName,style: TextStyle(fontSize: 16),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Phone Number: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                  Text(data.userPhone,style: TextStyle(fontSize: 16),),
                                ],
                              ),

                              Row(
                                children: [
                                  Text("Payment Amount: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                  Text(data.amount,style: TextStyle(fontSize: 16),),
                                ],
                              ),

                              Row(
                                children: [
                                  Text("Payment Mode: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                  Text(data.mode,style: TextStyle(fontSize: 16),),
                                ],
                              ),

                              Row(
                                children: [
                                  Text("Payment Status: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),

                                  InkWell(
                                      onTap: () {
                                        if(data.status == AppConstant.payBill || data.status == AppConstant.rejected) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => RenterPay(data: data,)),).then((val) {
                                            getData();
                                          });
                                        }

                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(builder: (context) => Paymentapproved(trans: data,)),).then((val) {
                                        //   getData();
                                        // });

                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: data.status == AppConstant.approved ? Colors.green : data.status == AppConstant.pending ? Colors.orange : data.status == AppConstant.rejected ?  Colors.red : Colors.blue,
                                              borderRadius: BorderRadius.circular(10)

                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                                            child: Center(
                                                child: Text(data.status,style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold,),)),
                                          ))),
                                ],
                              ),

                            ],
                          ),
                          Spacer(),


                        ],
                      ),
                    ),
                  ),
                );
              }),
        )
      ],),
    );
  }
}
