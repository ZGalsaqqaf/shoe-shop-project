/// _id : "6524cead3c0fd4270000123d"
/// Prod_id : [{"_id":"65236f89bd6e396200012d75","Cate_id":["65236c30bd6e396200012d28"],"Audi_id":["65236b1bbd6e396200012d09"],"Details":"Comfortable women's heals","Date":"2023-10-09T03:10:15.000Z","_created":"2023-10-09T03:12:09.587Z","_changed":"2023-10-13T03:40:40.344Z","Price":30.5,"Idx":17,"Image":"https://i.pinimg.com/736x/c6/bb/b3/c6bbb37e5767c116671a435c0ba8988d.jpg"}]
/// Image : "https://i.pinimg.com/564x/85/23/da/8523da302caa7ee0975f87b45dfed752.jpg"

class ImagesProductModel {
  ImagesProductModel({
      this.id, 
      this.prodId, 
      this.image,});

  ImagesProductModel.fromJson(dynamic json) {
    id = json['_id'];
    if (json['Prod_id'] != null) {
      prodId = [];
      json['Prod_id'].forEach((v) {
        prodId?.add(ProdId.fromJson(v));
      });
    }
    image = json['Image'];
  }
  String? id;
  List<ProdId>? prodId;
  String? image;
ImagesProductModel copyWith({  String? id,
  List<ProdId>? prodId,
  String? image,
}) => ImagesProductModel(  id: id ?? this.id,
  prodId: prodId ?? this.prodId,
  image: image ?? this.image,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    if (prodId != null) {
      map['Prod_id'] = prodId?.map((v) => v.toJson()).toList();
    }
    map['Image'] = image;
    return map;
  }

}

/// _id : "65236f89bd6e396200012d75"
/// Cate_id : ["65236c30bd6e396200012d28"]
/// Audi_id : ["65236b1bbd6e396200012d09"]
/// Details : "Comfortable women's heals"
/// Date : "2023-10-09T03:10:15.000Z"
/// _created : "2023-10-09T03:12:09.587Z"
/// _changed : "2023-10-13T03:40:40.344Z"
/// Price : 30.5
/// Idx : 17
/// Image : "https://i.pinimg.com/736x/c6/bb/b3/c6bbb37e5767c116671a435c0ba8988d.jpg"

class ProdId {
  ProdId({
      this.id, 
      this.cateId, 
      this.audiId, 
      this.details, 
      this.date, 
      this.created, 
      this.changed, 
      this.price, 
      this.idx, 
      this.image,});

  dynamic operator [](String key) {
    switch (key) {
      case '_id':
        return id;
      default:
        throw Exception('Invalid key: $key');
    }
  }

  ProdId.fromJson(dynamic json) {
    id = json['_id'];
    cateId = json['Cate_id'] != null ? json['Cate_id'].cast<String>() : [];
    audiId = json['Audi_id'] != null ? json['Audi_id'].cast<String>() : [];
    details = json['Details'];
    date = json['Date'];
    created = json['_created'];
    changed = json['_changed'];
    price = json['Price'];
    idx = json['Idx'];
    image = json['Image'];
  }
  String? id;
  List<String>? cateId;
  List<String>? audiId;
  String? details;
  String? date;
  String? created;
  String? changed;
  double? price;
  int? idx;
  String? image;
ProdId copyWith({  String? id,
  List<String>? cateId,
  List<String>? audiId,
  String? details,
  String? date,
  String? created,
  String? changed,
  double? price,
  int? idx,
  String? image,
}) => ProdId(  id: id ?? this.id,
  cateId: cateId ?? this.cateId,
  audiId: audiId ?? this.audiId,
  details: details ?? this.details,
  date: date ?? this.date,
  created: created ?? this.created,
  changed: changed ?? this.changed,
  price: price ?? this.price,
  idx: idx ?? this.idx,
  image: image ?? this.image,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['Cate_id'] = cateId;
    map['Audi_id'] = audiId;
    map['Details'] = details;
    map['Date'] = date;
    map['_created'] = created;
    map['_changed'] = changed;
    map['Price'] = price;
    map['Idx'] = idx;
    map['Image'] = image;
    return map;
  }

}