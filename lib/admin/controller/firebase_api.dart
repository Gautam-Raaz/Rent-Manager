import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_manager/constant/dbkeys.dart';
import 'package:rent_manager/model/Renter.dart';
import 'package:rent_manager/model/room.dart';
import 'package:rent_manager/model/transaction.dart';

class FirebaseApi {


  void addRenter(Renter userData) {
    FirebaseFirestore.instance.collection(AppConstant.userTable).
    doc(userData.phoneNumber).
    set(userData.toJson()).
    onError((e, _) => print("Error writing document: $e"));

    userData.roomsNo.forEach((element) {

      FirebaseFirestore.instance.collection(AppConstant.roomTable).
      doc(element).update({
        'isAvailable':false,
      });

    });
  }

  void addRoom(Room roomData) {
    FirebaseFirestore.instance.collection(AppConstant.roomTable).
    doc(roomData.roomNumber).
    set(roomData.toJson()).
    onError((e, _) => print("Error writing document: $e"));
  }

  void addPayment(Wallet trans) {
    FirebaseFirestore.instance.collection(AppConstant.transactionTable).
      doc(trans.timestamp).
        set(trans.toJson()).
      onError((e, _) => print("Error writing document: $e"));
  }

}