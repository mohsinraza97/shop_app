import '../base_model.dart';

class User implements BaseModel {
  String? id;
  String? name;
  String? email;
  String? imageUrl;
  String? token;
  String? expiresIn;

  User({
    this.id,
    this.name,
    this.email,
    this.imageUrl,
    this.token,
    this.expiresIn,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['localId'],
      name: json['displayName'],
      email: json['email'],
      imageUrl: json['imageUrl'],
      token: json['idToken'],
      expiresIn: json['expiresIn'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'localId': id,
      'displayName': name,
      'email': email,
      'imageUrl': imageUrl,
      'idToken': token,
      'expiresIn': expiresIn,
    };
  }

  DateTime get tokenExpiryDate {
    return DateTime.now().add(
      Duration(seconds: int.tryParse(expiresIn ?? '') ?? 0),
    );
  }
}

class UserRequest implements BaseModel {
  final String email;
  final String password;
  bool returnSecureToken;

  UserRequest({
    required this.email,
    required this.password,
    this.returnSecureToken = true,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'returnSecureToken': returnSecureToken,
    };
  }
}
