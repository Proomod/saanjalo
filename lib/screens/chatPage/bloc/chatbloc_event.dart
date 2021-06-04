part of 'chatbloc_bloc.dart';

abstract class ChatblocEvent extends Equatable {
  const ChatblocEvent();

  @override
  List<Object> get props => [];
}

class SendMessage extends ChatblocEvent {
  const SendMessage({required this.message, required this.receiver});
  final String message;
  final User receiver;

  @override
  // ignore: always_specify_types
  List<Object> get props => [message, receiver];
}

class ReceiveMessage extends ChatblocEvent {
  const ReceiveMessage({required this.chatMessages});

  final List<ChatMessage> chatMessages;
  List<Object> get props => [chatMessages];
}
