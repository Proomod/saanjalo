// ignore: file_names
import 'dart:convert';
import 'package:crypto/crypto.dart';

class ChatId {
  ChatId({required this.senderId, required this.receiverId});
  final String senderId;
  final String receiverId;

  Digest generateHash() {
    final StringBuffer hashBuilder = StringBuffer();
    if (senderId.compareTo(receiverId) > 0) {
      hashBuilder.write(senderId);
      hashBuilder.write(receiverId);
    } else {
      hashBuilder.write(receiverId);
      hashBuilder.write(senderId);
    }

    var bytes = utf8.encode(hashBuilder.toString());
    return sha1.convert(bytes);
  }
}
