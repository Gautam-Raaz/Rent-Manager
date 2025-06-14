class Room {
  String roomNumber;
  String price;
  bool isAvailable;

  Room({
    required this.roomNumber,
    required this.price,
    required this.isAvailable,
  });

  factory Room.fromJson(Map<String, dynamic> json) =>
      Room(
        roomNumber: json["roomNumber"],
        price: json["price"],
        isAvailable: json["isAvailable"],
      );

  Map<String, dynamic> toJson() => {
    "roomNumber": roomNumber,
    "price": price,
    "isAvailable": isAvailable,
  };


}