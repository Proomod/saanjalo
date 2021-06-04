import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  const User(
      {required this.id,
      this.name,
      this.email,
      this.username,
      this.displayPicture});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        email = json['email'].toString(),
        name = json['name'].toString(),
        username = json['username'].toString(),
        displayPicture = json['displayPicture'].toString();

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'username': username,
        'displayPicture': displayPicture
      };

  static const empty = User(id: '');

  final String id;
  final String? name;
  final String? email;
  final String? username;
  final String? displayPicture;

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [id, name, email, username];
}
