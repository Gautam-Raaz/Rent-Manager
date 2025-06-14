import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_manager/admin/screen/add_room.dart';
import 'package:rent_manager/constant/dbkeys.dart';
import 'package:rent_manager/model/room.dart';

class Roomlist extends StatefulWidget {
  const Roomlist({super.key});

  @override
  State<Roomlist> createState() => _RoomlistState();
}

class _RoomlistState extends State<Roomlist> {
  List<Room> rooms = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() {
    rooms = [];

    FirebaseFirestore.instance.collection(AppConstant.roomTable).
    get().then((value) {

      if(value.docs.isNotEmpty) {

        value.docs.forEach((room) {

          setState(() {

            rooms.add(Room.fromJson(room.data()));

          });

        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Room List",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
          actions: [
            IconButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddRoom(roomNumber: '0',)),).then((val) {
                getData();
              });

            }, icon: Icon(Icons.add,color: Colors.white,))
          ]
      ),
      body: rooms.isEmpty ? Center(child: Text("No Room Found"),) :
        ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (context,index) {
            Room data = rooms[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
              child: Container(
                height: 100,
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
                              Text("Room Number: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              Text(data.roomNumber,style: TextStyle(fontSize: 16),),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Room Cost: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              Text(data.price.toString(),style: TextStyle(fontSize: 16),),
                            ],
                          ),

                          Row(
                            children: [
                              Text("Available: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              Text(data.isAvailable.toString(),style: TextStyle(fontSize: 16),),
                            ],
                          ),

                        ],
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddRoom(roomNumber: data.roomNumber,)),).then((val) {
                            getData();
                          });
                        }, icon: Icon(Icons.edit)),
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
