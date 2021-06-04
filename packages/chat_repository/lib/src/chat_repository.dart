import 'package:authentication_repository/authentication_repository.dart';
import 'package:chat_repository/utils/chatId.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/chatModel.dart';
import 'dart:convert';

class ChatRepository {
  ChatRepository(
      {required AuthenticationRepository authenticationRepository,
      FirebaseFirestore? fireStore})
      : _authenticationRepository = authenticationRepository,
        _fireStore = fireStore ?? FirebaseFirestore.instance;

  final AuthenticationRepository _authenticationRepository;
  final FirebaseFirestore _fireStore;

  Future<bool> sendChatMessage(
      {required String message, required User receiver}) async {
    final User sender = _authenticationRepository.currentUser;

    //query to the user having some email address maybe
    print('this is receiver ${receiver.name}');
    final chatId = calculateChatId(receiver.id);
    final ChatMessage _chatMessage = ChatMessage(
        chatId: chatId,
        senderId: sender.id,
        createdAt: DateTime.now(),
        message: message,
        members: <String>[
          sender.name ?? 'anomymous',
          receiver.username ?? 'anomymous'
        ],
        receiverId: receiver.id);

    try {
      await _fireStore
          .collection('Chats')
          .doc(chatId)
          .collection('messages')
          .add(_chatMessage.toJson());

      await _fireStore.collection('Chats').doc(chatId).set({
        'chats': {
          'message': _chatMessage.message,
          'sender': _chatMessage.senderId,
          'time': _chatMessage.createdAt
        },
        'members': _chatMessage.members
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<ChatMessage>> receiveChatMessageStream(String receiverId) async* {
    List<ChatMessage> chatMessages = [];
    final String chatId = calculateChatId(receiverId);
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = _fireStore
        .collection('Chats')
        .doc(chatId)
        .collection('messages')
        .snapshots();

    await for (var data in stream) {
      chatMessages =
          data.docs.map((doc) => ChatMessage.fromJson(doc.data())).toList();

      yield chatMessages;
    }
  }

  // Future<String> calculateReceiverDetails(String email) async {
  //   final snapshot = await _fireStore
  //       .collection('users')
  //       .where('email', isEqualTo: email)
  //       .get();
  //   print(snapshot.docs.first.data());
  //   return Future.delayed(Duration(seconds: 2), () => "FUckyou");
  // }

  String calculateChatId(String receiverId) {
    final User sender = _authenticationRepository.currentUser;
    return ChatId(senderId: sender.id, receiverId: receiverId)
        .generateHash()
        .toString();
  }
}
