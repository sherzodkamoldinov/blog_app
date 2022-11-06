import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

// "id": 1,
// "last_name": "Piare",
// "first_name": "Lauren",
// "user_name": "",
// "email": "taslonboyev@gmail.com",
// "image_path": "",

@JsonSerializable()
class UserModel {
  @JsonKey(defaultValue: 0, name: "id")
  int id;

  @JsonKey(defaultValue: "", name: "first_name")
  String firstName;

  @JsonKey(defaultValue: "", name: "last_name")
  String lastName;

  @JsonKey(defaultValue: "", name: "user_name")
  String userName;

  @JsonKey(defaultValue: "", name: "email")
  String email;

  @JsonKey(defaultValue: "", name: "image_path")
  String imageUrl;

  @JsonKey(defaultValue: "", name: "password")
  String password;

  UserModel(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.userName,
      required this.email,
      required this.imageUrl,
      required this.password});

  UserModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? userName,
    String? email,
    String? imageUrl,
    String? password,
  }) =>
      UserModel(
          id: id ?? this.id,
          firstName: firstName ?? this.firstName,
          lastName: lastName ?? this.lastName,
          userName: userName ?? this.userName,
          email: email ?? this.email,
          imageUrl: imageUrl ?? this.imageUrl,
          password: password ?? this.password);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String toString() {
    return '''
  userId: $id,
  firstName: $firstName,
  lastName: $lastName,
  userName: $userName,
  email: $email,
  imageUrl: $imageUrl,
  password: $password,
  ''';
  }
}
