class Wallet {
  String amount;
  String status;
  String timestamp;
  String userPhone;
  String userName;
  String userPic;
  String transId;
  String paymentPic;
  String mode;
  String remark;
  String duesType;


  Wallet({
    required this.amount,
    required this.status,
    required this.timestamp,
    required this.userPhone,
    required this.userName,
    required this.userPic,
    required this.transId,
    required this.paymentPic,
    required this.mode,
    required this.remark,
    required this.duesType,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) =>
      Wallet(
        amount: json["amount"],
        status: json["status"],
        timestamp: json["timestamp"],
        userPhone: json["userPhone"],
        userName: json["userName"],
        userPic: json["userPic"],
        transId: json["transId"],
        paymentPic: json["paymentPic"],
        mode: json["mode"],
        remark: json["remark"],
        duesType: json["duesType"],
      );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "status": status,
    "timestamp": timestamp,
    "userPhone": userPhone,
    "userName": userName,
    "userPic": userPic,
    "transId": transId,
    "paymentPic": paymentPic,
    "mode": mode,
    "remark": remark,
    "duesType": duesType,
  };


}