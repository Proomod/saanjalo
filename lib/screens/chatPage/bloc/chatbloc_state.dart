part of 'chatbloc_bloc.dart';

class ChatblocState extends Equatable {
  const ChatblocState._({
    this.message = const [],
  });

  const ChatblocState.fetchMessage(List<ChatMessage> message)
      : this._(message: message);

  const ChatblocState.sendMessage(List<ChatMessage> message)
      : this._(message: message);

  const ChatblocState.errorState() : this._();

  final List<ChatMessage> message;
  @override
  List<Object> get props => [message];
}
