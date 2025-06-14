import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:rent_manager/constant/dbkeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/Renter.dart';
import '../../screen/login_screen.dart';
import '../controller/firebase_api.dart';

class AddRenter extends StatefulWidget {
  bool isAdmin;
  String? phoneNumber;
   AddRenter({super.key, required this.isAdmin,this.phoneNumber});

  @override
  State<AddRenter> createState() => _AddRenterState();
}

class _AddRenterState extends State<AddRenter> {
  String name = "";
  String identityNo = "";
  String identityPic = "";
  List<String> roomsNo = [];
  String phoneNumber = "";
  String email = "";
  String password = "";
  String profilePic = "";
  bool isHidden = true;
  bool isloading = false;
  List<String> availableRoom = [];

  void showSnack(String text) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.phoneNumber == null)  getAvailableRoom();
    if(widget.phoneNumber != null) getUserDetails();

  }

  getAvailableRoom() {
    FirebaseFirestore.instance.collection(AppConstant.roomTable).where('isAvailable',isEqualTo: true).
      get().then((value) {
        if(value.docs.isNotEmpty) {
          value.docs.forEach((room) {

            setState(() {
              availableRoom.add(room.data()['roomNumber']);
            });

          });
        }
    });
  }

  getUserDetails() {
    FirebaseFirestore.instance.collection(AppConstant.userTable).doc(widget.phoneNumber).
    get().then((value) {
      Renter data = Renter.fromJson(value.data()!);

      name = data.name;
      identityNo = data.identityNo;
      identityPic = data.identityPic;
      roomsNo = data.roomsNo;
      phoneNumber = data.phoneNumber;
      email = data.email;
      password = data.password;
      profilePic = data.profilePic;
      setState(() {
        availableRoom.addAll(roomsNo);
      });



    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white,),
        title: Text(widget.isAdmin ? widget.phoneNumber == null ? "Add Renter" : "Update Renter Data" : "Profile Data",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      body: isloading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [

              // profile pic
              SizedBox(height: 20,),

              InkWell(
                onTap: () {
                  if(widget.phoneNumber == null)
                  ImagePicker()
                      .pickImage(
                      source: ImageSource.gallery, imageQuality: 100)
                      .then((value) {

                    if(value != null) {
                      setState(() {
                        profilePic = value.path;
                      });
                    }

                  });
                },
                child: ClipOval(
                  child: profilePic.isEmpty
                      ? Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey[300],
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.person,size: 50,color: Colors.white,),

                      ],
                    ),
                  )
                      : widget.phoneNumber == null ? Image(
                    image: FileImage(
                      File(profilePic),
                    ),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ) : Image(
                    image: NetworkImage(
                      profilePic,
                    ),
                    height: 100,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // name
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Renter Name',
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
                    name = value;
                  },
                  readOnly: !widget.isAdmin,
                  controller: TextEditingController(text: name),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Name',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),

              // identityNo
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'identity Number',
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
                    identityNo = value;
                  },
                  readOnly: !widget.isAdmin,
                  controller: TextEditingController(text: identityNo),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'identity Number',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),

              // identity Pic
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'identity Picture',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if(widget.phoneNumber == null)
                   ImagePicker()
                      .pickImage(
                      source: ImageSource.gallery, imageQuality: 100)
                      .then((value) {

                    if(value != null) {
                      setState(() {
                        identityPic = value.path;
                      });
                    }

                  });
                },
                child: identityPic.isEmpty
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
                )
                    : widget.phoneNumber == null ? Image(
                  image: FileImage(
                    File(identityPic),
                  ),
                  height: 100,
                  width: 200,
                  fit: BoxFit.cover,
                ) : Image(
                  image: NetworkImage(
                    identityPic,
                  ),
                  height: 100,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),

              // Room Number
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
              Wrap(
                alignment: WrapAlignment.center,
                children: availableRoom.map<Widget>((e) {

                  return InkWell(
                    onTap: () {
                      if(widget.isAdmin)
                        setState(() {
                        roomsNo.contains(e) ? roomsNo.remove(e) : roomsNo.add(e);
                      });

                    },
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        gradient:  LinearGradient(
                          end: Alignment.topCenter,
                          begin: Alignment.bottomCenter,
                          colors: [
                            roomsNo.contains(e) ? Colors.green : Colors.grey,
                            roomsNo.contains(e) ? Colors.greenAccent : Colors.blueGrey,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: Text(
                        "${e}",
                        style: TextStyle(
                          color: Colors.white ,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // phoneNumber
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
                    phoneNumber = value;
                  },
                  readOnly: widget.phoneNumber != null,
                  controller: TextEditingController(text: phoneNumber),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Phone Number',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("+91"),
                      ],
                    )
                  ),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),

              // email
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Email',
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
                    email = value;
                  },
                  readOnly: !widget.isAdmin,
                  controller: TextEditingController(text: email),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Email (Optional)',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),

              // password
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
                  readOnly: !widget.isAdmin,
                  controller: TextEditingController(text: password),
                  obscureText: isHidden,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Password',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            isHidden = !isHidden;
                          });
                        },
                        child: Icon( isHidden ? Icons.visibility_off : Icons.visibility,color: Colors.black,),
                      )
                  ),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),

              SizedBox(height: 30,),

             if(widget.isAdmin) 
             Center(
                child: InkWell(
                  onTap: () async{

                    if(profilePic.isEmpty) {
                      showSnack("Please Click Renter Pic");
                    } else if(name.isEmpty) {
                      showSnack("Please Enter Renter Name");
                    } else if(identityNo.isEmpty) {
                      showSnack("Please Enter Renter Identity Number");
                    } else if(identityPic.isEmpty) {
                      showSnack("Please Click Renter Identity Pic");
                    } else if(phoneNumber.isEmpty) {
                      showSnack("Please Enter phone number");
                    } else if(password.isEmpty) {
                      showSnack("Please Enter password");
                    }  else if(password.replaceAll(' ', '').length < 8) {
                      showSnack("Please Enter password of atleast 8 digit");
                    } else if(phoneNumber.replaceAll(' ', '').length != 10) {
                      showSnack("Please Enter Correct phone number");
                    } else if(roomsNo.isEmpty) {
                      showSnack("Please add atleast one room");
                    } else {
                      setState(() {
                        isloading = true;
                      });

                      if (widget.phoneNumber == null) {
                        await FirebaseFirestore.instance.collection(
                            AppConstant.userTable).doc(phoneNumber).get().then((
                            doc) async {
                          if (doc.exists) {
                            showSnack("Phone Number already exists");
                            setState(() {
                              isloading = false;
                            });
                          } else {
                            final storageRef = FirebaseStorage.instance.ref();

                            final profile = storageRef.child(
                                "renter_manager/${phoneNumber}_prof.jpg");

                            final identity = storageRef.child(
                                "renter_manager/${phoneNumber}_ident.jpg");

                            try {
                              await profile.putFile(File(profilePic));

                              await identity.putFile(File(identityPic));

                              String profileUrl = await profile
                                  .getDownloadURL();

                              String identityUrl = await identity
                                  .getDownloadURL();

                              var data = Renter(
                                  name: name,
                                  identityNo: identityNo,
                                  identityPic: identityUrl,
                                  roomsNo: roomsNo,
                                  phoneNumber: phoneNumber,
                                  email: email,
                                  password: password,
                                  pendingAmount: 0,
                                  joiningDate: DateTime.now().toString(),
                                  profilePic: profileUrl
                              );

                              FirebaseApi().addRenter(data);

                              setState(() {
                                isloading = false;
                              });

                              showSnack("Renter Added Successfuly");

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
                        FirebaseFirestore.instance.collection(
                            AppConstant.userTable).doc(phoneNumber).update(
                            {
                              "name": name,
                              "identityNo": identityNo,
                              "identityPic": identityPic,
                              "roomsNo": roomsNo,
                              "phoneNumber": phoneNumber,
                              "email": email,
                              "password": password,
                              "profilePic": profilePic,
                            });

                        setState(() {
                          isloading = false;
                        });

                        showSnack("Renter Update Successfuly");

                        Navigator.pop(context, true);
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
 
              if(!widget.isAdmin) Center(
                child: InkWell(
                  onTap: () async{

                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setString('phone', 'null');
                                  Navigator.pushReplacement(
                                   context,MaterialPageRoute(builder: (context) => LoginScreen()),);

                   
                  },
                  child: Container(
                    height: 40,
                    width: 180,
                    child: Center(
                      child: Text("Log out",style: TextStyle(color: Colors.white),),
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
