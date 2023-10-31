/// _id : "65236c94bd6e396200012d32"
/// Name : "Sandals"
/// Idx : 11
/// Audience : "Girls"
/// Image : "https://i.pinimg.com/564x/e2/b8/4a/e2b84a6dcf2a214f893692917dbeb4e2.jpg"

class CategoryModel {
  CategoryModel({
      this.id, 
      this.name, 
      this.idx, 
      this.audience, 
      this.image,});

  CategoryModel.fromJson(dynamic json) {
    id = json['_id'];
    name = json['Name'];
    idx = json['Idx'];
    audience = json['Audience'];
    image = json['Image'];
  }
  String? id;
  String? name;
  int? idx;
  String? audience;
  String? image;
CategoryModel copyWith({  String? id,
  String? name,
  int? idx,
  String? audience,
  String? image,
}) => CategoryModel(  id: id ?? this.id,
  name: name ?? this.name,
  idx: idx ?? this.idx,
  audience: audience ?? this.audience,
  image: image ?? this.image,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['Name'] = name;
    map['Idx'] = idx;
    map['Audience'] = audience;
    map['Image'] = image;
    return map;
  }

}