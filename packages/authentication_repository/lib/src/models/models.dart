import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final String? username;

  const User({required this.id, this.name, this.email, this.username});

  static const empty = User(id: "");

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [id, name, email, username];
}
