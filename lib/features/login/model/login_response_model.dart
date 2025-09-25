import 'package:cloud_firestore/cloud_firestore.dart';

class LoginResponseModel {
  final String uid;
  final String name;
  final String email;
  final String role;
  final Timestamp? createdAt;

  LoginResponseModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.createdAt,
  });

  static Map<String, dynamic> toMap(LoginResponseModel user) {
    return {
      'uid': user.uid,
      'name': user.name,
      'email': user.email,
      'role': user.role,
      'createdAt': user.createdAt,
    };
  }

  factory LoginResponseModel.fromjson(Map<String, dynamic> json) {
    return LoginResponseModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      role: json['role'] ?? 'user',
      createdAt: json['createdAt'],
    );
  }
}
