/// _id : "652bd3dc3c0fd427000105de"
/// Prod_id : "345ertyui"
/// User_id : "ert456"
/// Color : "red"
/// Date : "15/10/23 06:20:07 - am"
/// NumPieces : 2
/// Size : 40
/// IsPaid : false

class CartUserModel {
  CartUserModel({
      this.id, 
      this.prodId, 
      this.userId, 
      this.color, 
      this.date, 
      this.numPieces, 
      this.size, 
      this.isPaid,});

  CartUserModel.fromJson(dynamic json) {
    id = json['_id'];
    prodId = json['Prod_id'];
    userId = json['User_id'];
    color = json['Color'];
    date = json['Date'];
    numPieces = json['NumPieces'];
    size = json['Size'];
    isPaid = json['IsPaid'];
  }
  String? id;
  String? prodId;
  String? userId;
  String? color;
  String? date;
  int? numPieces;
  int? size;
  bool? isPaid;
CartUserModel copyWith({  String? id,
  String? prodId,
  String? userId,
  String? color,
  String? date,
  int? numPieces,
  int? size,
  bool? isPaid,
}) => CartUserModel(  id: id ?? this.id,
  prodId: prodId ?? this.prodId,
  userId: userId ?? this.userId,
  color: color ?? this.color,
  date: date ?? this.date,
  numPieces: numPieces ?? this.numPieces,
  size: size ?? this.size,
  isPaid: isPaid ?? this.isPaid,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['Prod_id'] = prodId;
    map['User_id'] = userId;
    map['Color'] = color;
    map['Date'] = date;
    map['NumPieces'] = numPieces;
    map['Size'] = size;
    map['IsPaid'] = isPaid;
    return map;
  }

}