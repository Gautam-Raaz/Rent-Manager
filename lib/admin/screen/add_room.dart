import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constant/dbkeys.dart';
import '../../model/room.dart';
import '../controller/firebase_api.dart';

class AddRoom extends StatefulWidget {
  String roomNumber;
   AddRoom({super.key,required this.roomNumber});

  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  String roomNumber = '';
  String price = '';

  bool isloading = false;

  void showSnack(String text) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.roomNumber != '0') getRoomDetails();
  }

  getRoomDetails() {
    FirebaseFirestore.instance.collection(AppConstant.roomTable).doc(widget.roomNumber).
    get().then((value) {
      Room data = Room.fromJson(value.data()!);
      setState(() {
        roomNumber = data.roomNumber;
        price = data.price.toString();
      });


      });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white,),
        title: Text(widget.roomNumber == '0' ? "Add Room" : "Update Room Details",style: TextStyle(color: Colors.white),),
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
                  'Room Number',
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
                    roomNumber = value;
                  },
                  readOnly: widget.roomNumber != '0',
                  controller: TextEditingController(text: roomNumber),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Room Number',
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
                  'Price',
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
                    price = value;
                  },
                  controller: TextEditingController(text: price),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter room price',
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

                    if(roomNumber.isEmpty) {
                      showSnack("Please Enter Room Number");
                    } else if(price.isEmpty) {
                      showSnack("Please Enter Price");
                    } else {

                      setState(() {
                        isloading = true;
                      });

                      if(widget.roomNumber == '0') {
                        await FirebaseFirestore.instance.collection(
                            AppConstant.roomTable).doc(roomNumber).get().then((
                            doc) async {
                          if (doc.exists) {
                            showSnack("Room Number already exists");
                            setState(() {
                              isloading = false;
                            });
                          } else {
                            try {
                              var data = Room(
                                  roomNumber: roomNumber,
                                  price: price,
                                  isAvailable: true
                              );

                              FirebaseApi().addRoom(data);

                              setState(() {
                                isloading = false;
                              });

                              showSnack("Room Added Successfuly");
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
                      } else {

                        await FirebaseFirestore.instance.collection(AppConstant.roomTable).doc(roomNumber).update(
                            {
                              'price': price
                            }).then((val) {
                          setState(() {
                            isloading = false;
                          });

                          showSnack("Room Update Successfuly");
                          Navigator.pop(context, true);
                        });
                      }
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
