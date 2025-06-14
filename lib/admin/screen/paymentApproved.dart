import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_manager/constant/dbkeys.dart';

import '../../model/transaction.dart';

class Paymentapproved extends StatefulWidget {
  Wallet trans;
   Paymentapproved({super.key,required this.trans});

  @override
  State<Paymentapproved> createState() => _PaymentapprovedState();
}

class _PaymentapprovedState extends State<Paymentapproved> {
  bool isloading = false;

  void showSnack(String text) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Approval",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        leading: BackButton(color: Colors.white,),
      ),
      body: isloading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              SizedBox(height: 20,),

              ClipOval(
                child: Image(
                  image: NetworkImage(
                    widget.trans.userPic,
                  ),
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Renter Name: ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  Text(widget.trans.userName,style: TextStyle(fontSize: 16,),),
                ],
              ),

              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Renter Phone Number: ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  Text(widget.trans.userPhone,style: TextStyle(fontSize: 16,),),
                ],
              ),

              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Payment Amount: ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  Text(widget.trans.amount,style: TextStyle(fontSize: 16,),),
                ],
              ),

             if(widget.trans.mode.isNotEmpty) SizedBox(height: 20,),

             if(widget.trans.mode.isNotEmpty) Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Mode: ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  Text(widget.trans.mode,style: TextStyle(fontSize: 16,),),
                ],
              ),

              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Payment Status: ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  Text(widget.trans.status,style: TextStyle(fontSize: 16, color: widget.trans.status == AppConstant.approved ? Colors.green : widget.trans.status == AppConstant.pending ? Colors.orange : widget.trans.status == AppConstant.rejected ?  Colors.red : Colors.blue,
                  ),),
                ],
              ),

              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Bill Type: ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  Text(widget.trans.duesType,style: TextStyle(fontSize: 16,
                  ),),
                ],
              ),

              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Bill Remark: ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  Text(widget.trans.remark,style: TextStyle(fontSize: 16,
                  ),),
                ],
              ),

            if(widget.trans.transId.isNotEmpty)  SizedBox(height: 20,),

            if(widget.trans.transId.isNotEmpty)  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Transaction Id: ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  Text(widget.trans.transId,style: TextStyle(fontSize: 16,),),
                ],
              ),

            if(widget.trans.paymentPic.isNotEmpty) SizedBox(height: 20,),

            if(widget.trans.paymentPic.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Payment Screenshot: ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  Image(
                    image: NetworkImage(
                      widget.trans.paymentPic,
                    ),
                    // height: 100,
                    width: 150,
                    fit: BoxFit.cover,
                  )
                ],
              ),



              SizedBox(height: 30,),

             if(widget.trans.status == AppConstant.pending)
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 InkWell(
                   onTap: () {

                     setState(() {
                       isloading = true;
                     });

                     FirebaseFirestore.instance.collection(AppConstant.transactionTable).doc(widget.trans.timestamp).
                     update({
                       'status': 'Approved'
                     }).then((val) async{

                       await FirebaseFirestore.instance.collection(AppConstant.userTable).doc(widget.trans.userPhone).update({
                         'pendingAmount': FieldValue.increment(-1*int.parse(widget.trans.amount))
                       });

                       setState(() {
                         isloading = false;
                       });

                       showSnack("Payment Status Approved");

                       Navigator.pop(context, true);

                     });

                   },
                   child: Container(
                     height: 40,
                     width: 150,
                     child: Center(
                       child: Text("Approve",style: TextStyle(color: Colors.white),),
                     ),
                     decoration: BoxDecoration(
                       color: Colors.green,
                       borderRadius: BorderRadius.all(Radius.circular(10)),
                     ),
                   ),
                 ),

                 InkWell(
                   onTap: () {

                     setState(() {
                       isloading = true;
                     });

                     FirebaseFirestore.instance.collection(AppConstant.transactionTable).doc(widget.trans.timestamp).
                     update({
                       'status': 'Rejected Pay Again'
                     }).then((val) {

                       setState(() {
                         isloading = false;
                       });

                       showSnack("Payment Status Rejected");

                       Navigator.pop(context, true);

                     });
                   },
                   child: Container(
                     height: 40,
                     width: 150,
                     child: Center(
                       child: Text("Reject",style: TextStyle(color: Colors.white),),
                     ),
                     decoration: BoxDecoration(
                       color: Colors.red,
                       borderRadius: BorderRadius.all(Radius.circular(10)),
                     ),
                   ),
                 )
               ],
             ),

              if(widget.trans.status == AppConstant.payBill)  InkWell(
                onTap: () {

                  setState(() {
                    isloading = true;
                  });

                  FirebaseFirestore.instance.collection(AppConstant.transactionTable).doc(widget.trans.timestamp).
                  update({
                    'status': 'Approved'
                  }).then((val) async{




                   await FirebaseFirestore.instance.collection(AppConstant.userTable).doc(widget.trans.userPhone).update({
                      'pendingAmount': FieldValue.increment(-1*int.parse(widget.trans.amount))
                    });



                    setState(() {
                      isloading = false;
                    });

                    showSnack("Payment Status Approved");

                    Navigator.pop(context, true);

                  });

                },
                child: Container(
                  height: 40,
                  width: 150,
                  child: Center(
                    child: Text("Cash Payment",style: TextStyle(color: Colors.white),),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
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
