import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_manager/admin/screen/admin_pay.dart';
import 'package:rent_manager/admin/screen/paymentApproved.dart';
import 'package:rent_manager/model/transaction.dart';

import '../../constant/dbkeys.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  List<Wallet> trans = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() {

    trans = [];

    FirebaseFirestore.instance.collection(AppConstant.transactionTable).
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Payment History",style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.green,
          // actions: [
          //   IconButton(onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => AdminPay()),).then((val) {
          //       getData();
          //     });
          //   }, icon: Icon(Icons.add,color: Colors.white,))
          // ]
      ),
      body: trans.isEmpty ? Center(child: Text("No Payment History"),) :
      ListView.builder(
          itemCount: trans.length,
          itemBuilder: (context,index) {
            Wallet data = trans[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
              child: Container(
                height: 200,
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

                         if(data.mode.isNotEmpty) Row(
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

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Paymentapproved(trans: data,)),).then((val) {
                                      getData();
                                    });

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

                          Row(
                            children: [
                              Text("Bill Remark: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              Text(data.remark,style: TextStyle(fontSize: 16),),
                            ],
                          ),

                          Row(
                            children: [
                              Text("Bill Type: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              Text(data.duesType,style: TextStyle(fontSize: 16),),
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
    );
  }
}
