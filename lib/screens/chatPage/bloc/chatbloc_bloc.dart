import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';

part 'chatbloc_event.dart';
part 'chatbloc_state.dart';

class ChatblocBloc extends Bloc<ChatblocEvent, ChatblocState> {
  ChatblocBloc(
      {required AuthenticationRepository authenticationRepository,
      required User receiver})
      : _authenticationRepository = authenticationRepository,
        _receiver = receiver,
        super(const ChatblocState._()) {
    _chatRepository =
        ChatRepository(authenticationRepository: _authenticationRepository);
    _chatSubscription = _chatRepository
        .receiveChatMessageStream(_receiver.id)
        .listen(_onMessageReceived);
  }

  late StreamSubscription<List<ChatMessage>> _chatSubscription;

  void _onMessageReceived(List<ChatMessage> message) {
    print(message);
    add(ReceiveMessage(chatMessages: message));
  }

  final AuthenticationRepository _authenticationRepository;
  late final ChatRepository _chatRepository;
  final User _receiver;

  @override
  Stream<ChatblocState> mapEventToState(
    ChatblocEvent event,
  ) async* {
    if (event is SendMessage) {
      await _chatRepository.sendChatMessage(
          message: event.message, receiver: event.receiver);
    }
    if (event is ReceiveMessage) {
      yield ChatblocState.fetchMessage(event.chatMessages);
    }
  }

  @override
  Future<void> close() async {
    await _chatSubscription.cancel();
    return super.close();
  }
}
