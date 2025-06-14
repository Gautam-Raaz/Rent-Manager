class Renter {
  String name;
  String identityNo;
  String identityPic;
  List<String> roomsNo;
  String phoneNumber;
  String email;
  String password;
  int pendingAmount;
  String joiningDate;
  String profilePic;


  Renter({
    required this.name,
    required this.identityNo,
    required this.identityPic,
    required this.roomsNo,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.pendingAmount,
    required this.joiningDate,
    required this.profilePic,
  });

  factory Renter.fromJson(Map<String, dynamic> json) =>
      Renter(
        name: json["name"],
        identityNo: json["identityNo"],
        identityPic: json["identityPic"],
        roomsNo: List<String>.from(json['roomsNo']),
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        password: json["password"],
        pendingAmount: json["pendingAmount"],
        joiningDate: json["joiningDate"],
        profilePic: json["profilePic"],
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "identityNo": identityNo,
    "identityPic": identityPic,
    "roomsNo": roomsNo,
    "phoneNumber": phoneNumber,
    "email": email,
    "password": password,
    "pendingAmount": pendingAmount,
    "joiningDate": joiningDate,
    "profilePic": profilePic,
  };


}