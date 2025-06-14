import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_manager/admin/screen/add_bill.dart';
import 'package:rent_manager/constant/dbkeys.dart';
import 'package:rent_manager/model/Renter.dart';

import 'add_renter.dart';

class Renterlist extends StatefulWidget {
  const Renterlist({super.key});

  @override
  State<Renterlist> createState() => _RenterlistState();
}

class _RenterlistState extends State<Renterlist> {
  List<Renter> renters = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() {
    renters = [];

    FirebaseFirestore.instance.collection(AppConstant.userTable).
    get().then((value) {

      if(value.docs.isNotEmpty) {

        value.docs.forEach((renter) {

          setState(() {

            renters.add(Renter.fromJson(renter.data()));

          });

        });
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Renter List",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green, 
        actions: [
          IconButton(onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddRenter(isAdmin: true,)),).then((value) {
                          getData();
                      });
          }, icon: Icon(Icons.add,color: Colors.white,)),
        ]
      ),
      body: renters.isEmpty ? Center(child: Text("No Renter Found"),) :
        ListView.builder(
            itemCount: renters.length,
            itemBuilder: (context,index) {
              Renter data = renters[index];
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: Image(
                          image: NetworkImage(
                            data.profilePic,
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
                              Text(data.name,style: TextStyle(fontSize: 16),),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Phone Number: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              Text(data.phoneNumber,style: TextStyle(fontSize: 16),),
                            ],
                          ),

                          if(data.email.isNotEmpty)  Row(
                            children: [
                              Text("E-mail: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              Container(
                                  width: 180,
                                  height: 30,
                                  child: Center(
                                  child: Text(data.email,style: TextStyle(fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis,)))
                            ],
                          ),

                          Row(
                            children: [
                              Text("Identity Number: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              Text(data.identityNo.toString(),style: TextStyle(fontSize: 16),),
                            ],
                          ),

                          Row(
                            children: [
                              Text("Pending Amount: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              Text("Rs " + data.pendingAmount.toString(),style: TextStyle(fontSize: 16),),
                            ],
                          )

                        ],
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddRenter(isAdmin: true,phoneNumber: data.phoneNumber,)),).then((value) {
                            getData();
                          });
                        }, icon: Icon(Icons.edit)),
                      ),


                    ],
                  ),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddBill(data: data,)),);

                    },
                    child: Container(
                      height: 40,
                      width: 150,
                      child: Center(
                        child: Text("Add Bill",style: TextStyle(color: Colors.white),),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
