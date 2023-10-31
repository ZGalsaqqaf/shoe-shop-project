/// _id : "6528b1d33c0fd4270000998b"
/// Cate_id : [{"_id":"6526bba13c0fd427000053c2","Name":"Dress","Idx":7,"Audience":"Boys","_created":"2023-10-11T15:13:37.152Z","_changed":"2023-10-12T03:11:19.194Z","Image":"https://i.pinimg.com/736x/dc/d8/09/dcd809acb226e257ce0de18bc9fbb33b.jpg"}]
/// Audi_id : [{"_id":"65236b2fbd6e396200012d0b","Name":"Boys","_created":"2023-10-09T02:53:35.859Z","_changed":"2023-10-10T02:13:31.186Z","Image":"https://i.pinimg.com/564x/39/7a/e3/397ae3474203de8476cbeb748522db3c.jpg","Idx":3}]
/// Details : "Comfortable boy's dress shoes"
/// Date : "2023-10-13T02:55:21.000Z"
/// Price : 30.99
/// Image : "https://i.pinimg.com/564x/6e/75/25/6e7525f9b1f399839ce5763461b54bcf.jpg"
/// Idx : 12

class ProductShoeModel {
  ProductShoeModel({
      this.id, 
      this.cateId, 
      this.audiId, 
      this.details, 
      this.date, 
      this.price, 
      this.image, 
      this.idx,});

  ProductShoeModel.fromJson(dynamic json) {
    id = json['_id'];
    if (json['Cate_id'] != null) {
      cateId = [];
      json['Cate_id'].forEach((v) {
        cateId?.add(CateId.fromJson(v));
      });
    }
    if (json['Audi_id'] != null) {
      audiId = [];
      json['Audi_id'].forEach((v) {
        audiId?.add(AudiId.fromJson(v));
      });
    }
    details = json['Details'];
    date = json['Date'];
    price = json['Price'];
    image = json['Image'];
    idx = json['Idx'];
  }
  String? id;
  List<CateId>? cateId;
  List<AudiId>? audiId;
  String? details;
  String? date;
  double? price;
  String? image;
  int? idx;
ProductShoeModel copyWith({  String? id,
  List<CateId>? cateId,
  List<AudiId>? audiId,
  String? details,
  String? date,
  double? price,
  String? image,
  int? idx,
}) => ProductShoeModel(  id: id ?? this.id,
  cateId: cateId ?? this.cateId,
  audiId: audiId ?? this.audiId,
  details: details ?? this.details,
  date: date ?? this.date,
  price: price ?? this.price,
  image: image ?? this.image,
  idx: idx ?? this.idx,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    if (cateId != null) {
      map['Cate_id'] = cateId?.map((v) => v.toJson()).toList();
    }
    if (audiId != null) {
      map['Audi_id'] = audiId?.map((v) => v.toJson()).toList();
    }
    map['Details'] = details;
    map['Date'] = date;
    map['Price'] = price;
    map['Image'] = image;
    map['Idx'] = idx;
    return map;
  }

}

/// _id : "65236b2fbd6e396200012d0b"
/// Name : "Boys"
/// _created : "2023-10-09T02:53:35.859Z"
/// _changed : "2023-10-10T02:13:31.186Z"
/// Image : "https://i.pinimg.com/564x/39/7a/e3/397ae3474203de8476cbeb748522db3c.jpg"
/// Idx : 3

class AudiId {
  AudiId({
      this.id, 
      this.name, 
      this.created, 
      this.changed, 
      this.image, 
      this.idx,});

  dynamic operator [](String key) {
    switch (key) {
      case '_id':
        return id;
      case 'Name':
        return name;
      case '_created':
        return created;
      case '_changed':
        return changed;
      case 'Idx':
        return idx;
      default:
        throw Exception('Invalid key: $key');
    }
  }

  AudiId.fromJson(dynamic json) {
    id = json['_id'];
    name = json['Name'];
    created = json['_created'];
    changed = json['_changed'];
    image = json['Image'];
    idx = json['Idx'];
  }
  String? id;
  String? name;
  String? created;
  String? changed;
  String? image;
  int? idx;
AudiId copyWith({  String? id,
  String? name,
  String? created,
  String? changed,
  String? image,
  int? idx,
}) => AudiId(  id: id ?? this.id,
  name: name ?? this.name,
  created: created ?? this.created,
  changed: changed ?? this.changed,
  image: image ?? this.image,
  idx: idx ?? this.idx,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['Name'] = name;
    map['_created'] = created;
    map['_changed'] = changed;
    map['Image'] = image;
    map['Idx'] = idx;
    return map;
  }

}

/// _id : "6526bba13c0fd427000053c2"
/// Name : "Dress"
/// Idx : 7
/// Audience : "Boys"
/// _created : "2023-10-11T15:13:37.152Z"
/// _changed : "2023-10-12T03:11:19.194Z"
/// Image : "https://i.pinimg.com/736x/dc/d8/09/dcd809acb226e257ce0de18bc9fbb33b.jpg"

class CateId {
  CateId({
      this.id, 
      this.name, 
      this.idx, 
      this.audience, 
      this.created, 
      this.changed, 
      this.image,});
  
  dynamic operator [](String key) {
    switch (key) {
      case '_id':
        return id;
      case 'Name':
        return name;
      case '_created':
        return created;
      case '_changed':
        return changed;
      case 'Idx':
        return idx;
      case 'Audience':
        return audience;
      case 'Image':
        return image;
      default:
        throw Exception('Invalid key: $key');
    }
  }

  CateId.fromJson(dynamic json) {
    id = json['_id'];
    name = json['Name'];
    idx = json['Idx'];
    audience = json['Audience'];
    created = json['_created'];
    changed = json['_changed'];
    image = json['Image'];
  }
  String? id;
  String? name;
  int? idx;
  String? audience;
  String? created;
  String? changed;
  String? image;
CateId copyWith({  String? id,
  String? name,
  int? idx,
  String? audience,
  String? created,
  String? changed,
  String? image,
}) => CateId(  id: id ?? this.id,
  name: name ?? this.name,
  idx: idx ?? this.idx,
  audience: audience ?? this.audience,
  created: created ?? this.created,
  changed: changed ?? this.changed,
  image: image ?? this.image,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['Name'] = name;
    map['Idx'] = idx;
    map['Audience'] = audience;
    map['_created'] = created;
    map['_changed'] = changed;
    map['Image'] = image;
    return map;
  }

}