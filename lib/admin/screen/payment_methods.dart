import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../constant/dbkeys.dart';
import '../../model/payment.dart';
import 'add_payment.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {

  List<Payment> payment = [];
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() {
    payment = [];

    FirebaseFirestore.instance.collection(AppConstant.paymentTable).
    get().then((value) {

      if(value.docs.isNotEmpty) {

        value.docs.forEach((room) {

          setState(() {

            payment.add(Payment.fromJson(room.data()));

          });

        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Payment Methods List",style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.green,
          actions: [
            IconButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPayment()),).then((val) {
                  getData();
              });

            }, icon: Icon(Icons.add,color: Colors.white,))
          ]
      ),
      body: payment.isEmpty ? Center(child: Text("No Payment Method Available"),) :
      ListView.builder(
          itemCount: payment.length,
          itemBuilder: (context,index) {
            Payment data = payment[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              Text("Payment Type: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              Text(data.payType,style: TextStyle(fontSize: 16),),
                            ],
                          ),

                          SizedBox(height: 20,),

                          Row(
                            children: [
                              Text("QR Pic:  ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              Image(
                                image: NetworkImage(
                                  data.qrPic,
                                ),
                                // height: 100,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            ],
                          ),

                        ],
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(onPressed: () async{
                          if(!isloading) {
                            isloading = true;

                            await FirebaseStorage.instance.refFromURL(
                                data.qrPic).delete();

                            await FirebaseFirestore.instance.collection(
                                AppConstant.paymentTable)
                                .doc(data.payType)
                                .delete();

                            setState(() {
                              payment.removeAt(index);
                              isloading = false;
                            });
                          }

                        }, icon: Icon(Icons.delete)),
                      )


                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
