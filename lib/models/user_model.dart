/// _id : "652bd3dc3c0fd427000105de"
/// Username : "zzzzzz"
/// email : "zz@nn@nn"
/// Password : "nn123"
/// Profile : "234567ertyuidfghj4567fgh"
/// CreditCard : "110-091-918"

class UserModel {
  UserModel({
      this.id, 
      this.username, 
      this.email, 
      this.password, 
      this.profile, 
      this.creditCard,});

  UserModel.fromJson(dynamic json) {
    id = json['_id'];
    username = json['Username'];
    email = json['email'];
    password = json['Password'];
    profile = json['Profile'];
    creditCard = json['CreditCard'];
  }
  String? id;
  String? username;
  String? email;
  String? password;
  String? profile;
  String? creditCard;
UserModel copyWith({  String? id,
  String? username,
  String? email,
  String? password,
  String? profile,
  String? creditCard,
}) => UserModel(  id: id ?? this.id,
  username: username ?? this.username,
  email: email ?? this.email,
  password: password ?? this.password,
  profile: profile ?? this.profile,
  creditCard: creditCard ?? this.creditCard,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['Username'] = username;
    map['email'] = email;
    map['Password'] = password;
    map['Profile'] = profile;
    map['CreditCard'] = creditCard;
    return map;
  }

}