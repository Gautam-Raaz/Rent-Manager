import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent_manager/model/payment.dart';

import '../../constant/dbkeys.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({super.key});

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  bool isloading = false;
  String payType = '';
  String payImg = '';
  String upiId = '';

  void showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white,),
        title: Text("Payment Method",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      body: isloading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [


              // room number
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Payment Type',
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
                    payType = value;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Payment Type',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),

              // Price
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'QR Image',
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

              // phone number
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Enter UPI ID',
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
                    upiId = value;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Payment Type',
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

                    if(payType.isEmpty) {
                      showSnack("Please Enter Payment Type");
                    } else if(upiId.isEmpty) {
                      showSnack("Please Enter UPI ID");
                    } else if(payImg.isEmpty) {
                      showSnack("Please Click Image");
                    } else {

                      setState(() {
                        isloading = true;
                      });

                        await FirebaseFirestore.instance.collection(
                            AppConstant.paymentTable).doc(payType).get().then((
                            doc) async {
                          if (doc.exists) {
                            showSnack("Payment Name already exists");
                            setState(() {
                              isloading = false;
                            });
                          } else {

                            final storageRef = FirebaseStorage.instance.ref();

                            final qrImg = storageRef.child(
                                "renter_manager/${payType}_qr.jpg");


                            try {
                              await qrImg.putFile(File(payImg));


                              String qr = await qrImg.getDownloadURL();

                              var data = Payment(
                                  payType: payType,
                                  qrPic: qr,
                                  upiId: upiId
                              );
                              await  FirebaseFirestore.instance.collection(
                                  AppConstant.paymentTable).doc(payType).set(data.toJson());

                              setState(() {
                                isloading = false;
                              });

                              showSnack("Payment Type Added Successfuly");

                              Navigator.pop(context, true);
                            } catch (e) {
                              showSnack("Something went wrong");
                              setState(() {
                                isloading = false;
                              });
                            }
                          }
                        }
                        );

                    }
                  },
                  child: Container(
                    height: 40,
                    width: 180,
                    child: Center(
                      child: Text("Save Details",style: TextStyle(color: Colors.white),),
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
