class Payment {
  String payType;
  String qrPic;
  String upiId;

  Payment({
    required this.payType,
    required this.qrPic,
    required this.upiId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) =>
      Payment(
        payType: json["payType"],
        qrPic: json["qrPic"],
        upiId: json["upiId"],
      );

  Map<String, dynamic> toJson() => {
    "payType": payType,
    "qrPic": qrPic,
    "upiId": upiId,
  };


}