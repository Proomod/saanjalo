// ignore: file_names
import 'package:equatable/equatable.dart';
import 'package:chat_repository/utils/chatId.dart';

class ChatMessage extends Equatable {
  ChatMessage(
      {required this.chatId,
      this.message,
      this.createdAt,
      required this.members,
      required this.senderId,
      required this.receiverId});

  ChatMessage.fromJson(
    Map<String, dynamic> json,
  )   : chatId = json['chatId'].toString(),
        senderId = json['senderId'].toString(),
        message = json['message'].toString(),
        createdAt = castOrNull<DateTime>(json['createdAt'], DateTime.now()),
        members = <String>[...json['members']],
        receiverId = json['receiverId'].toString();

  // ignore: always_specify_types
  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'message': message,
        'createdAt': createdAt,
        'receiverId': receiverId,
        'senderId': senderId,
        'members': members
      };

  String chatId;
  final String? message;
  final DateTime? createdAt;
  final String receiverId;
  final String senderId;
  final List<String> members;

  static T castOrNull<T>(dynamic value, T fallback) =>
      value is T ? value : fallback;

  @override
  // ignore: always_specify_types
  List<Object?> get props => [chatId, message, createdAt, receiverId];
}

// String? gotoSomething<double>() {
//   return 'hello world';
// }
