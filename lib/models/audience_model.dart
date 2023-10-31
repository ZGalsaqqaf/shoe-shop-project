/// _id : "65236b2fbd6e396200012d0b"
/// Name : "Boys"
/// Image : ["652412993c0fd4270000006e"]
/// Idx : 3

class AudienceModel {
  AudienceModel({
      this.id, 
      this.name, 
      this.image, 
      this.idx,});

  AudienceModel.fromJson(dynamic json) {
    id = json['_id'];
    name = json['Name'];
    image = json['Image'];
    idx = json['Idx'];
  }
  String? id;
  String? name;
  String? image;
  int? idx;
AudienceModel copyWith({  String? id,
  String? name,
  String? image,
  int? idx,
}) => AudienceModel(  id: id ?? this.id,
  name: name ?? this.name,
  image: image ?? this.image,
  idx: idx ?? this.idx,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['Name'] = name;
    map['Image'] = image;
    map['Idx'] = idx;
    return map;
  }

}