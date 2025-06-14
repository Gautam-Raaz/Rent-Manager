import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent_manager/model/transaction.dart';

import '../constant/dbkeys.dart';
import '../model/Renter.dart';

class RenterPay extends StatefulWidget {
   Wallet data;
   RenterPay({super.key, required this.data});

  @override
  State<RenterPay> createState() => _RenterPayState();
}

class _RenterPayState extends State<RenterPay> {
  bool isloading = false;
  String transId = '';
  String payImg = '';

  void showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white,),
        title: Text("Pay Bill",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      body: isloading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [


              // Amount
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Amount Paid',
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
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: widget.data.amount),
                  readOnly: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Amount Paid',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),

              // transaction id
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Transaction ID',
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
                    transId = value;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Transaction ID',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),


              // transaction image
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Payment Recipt Image',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  ImagePicker()
                      .pickImage(
                      source: ImageSource.gallery, imageQuality: 100)
                      .then((value) {

                    if(value != null) {
                      setState(() {
                        payImg = value.path;
                      });
                    }

                  });
                },
                child:  payImg.isEmpty
                    ? Container(
                  height: 100,
                  width: 200,
                  color: Colors.grey[300],
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.credit_card,size: 50,color: Colors.white,),

                    ],
                  ),
                ) :
                Image(
                  image: FileImage(
                    File(payImg),
                  ),
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),




              SizedBox(height: 30,),

              Center(
                child: InkWell(
                  onTap: () async{

                     if(payImg.isEmpty) {
                      showSnack("Please Click Payment Receipt");
                    }  else if(transId.isEmpty) {
                      showSnack("Please Enter Transaction ID");
                    }  else {

                      setState(() {
                        isloading = true;
                      });


                      final storageRef = FirebaseStorage.instance.ref();
                      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

                      final qrImg = storageRef.child(
                          "renter_manager/${timestamp}_qr.jpg");


                      try {
                        await qrImg.putFile(File(payImg));


                        String qr = await qrImg.getDownloadURL();

                        await FirebaseFirestore.instance.collection(
                            AppConstant.transactionTable).doc(widget.data.timestamp).update({
                          'status': AppConstant.pending,
                          'mode': 'UPI',
                          'paymentPic': qr,
                          'transId': transId,
                        });

                        setState(() {
                          isloading = false;
                        });

                        showSnack('Payment Send for Approval');

                        Navigator.pop(context, true);
                      } catch (e) {
                        showSnack("Something went wrong");
                        setState(() {
                          isloading = false;
                        });
                      }

                    }
                  },
                  child: Container(
                    height: 40,
                    width: 180,
                    child: Center(
                      child: Text("Pay",style: TextStyle(color: Colors.white),),
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
