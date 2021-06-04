import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saanjalo/screens/chatPage/bloc/chatbloc_bloc.dart';

class ChatPage extends StatelessWidget {
  ChatPage({required this.receiver});
  // final String receiverId;
  // final String receiverName;
  final User receiver;
  //

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ChatblocBloc(
            receiver: receiver,
            authenticationRepository: context.read<AuthenticationRepository>()),
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 5.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(
                  maxRadius: 20.0,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(receiver.username ?? 'unknown'),
              ],
            ),
            actions: [
              IconButton(icon: const Icon(Icons.phone), onPressed: () {}),
              IconButton(
                  icon: const Icon(Icons.video_call_rounded), onPressed: () {}),
              IconButton(icon: const Icon(Icons.info_sharp), onPressed: () {})
            ],
          ),
          body: Column(children: [
            // Expanded(
            //   child: StreamBuilder<List>(
            //       stream: ChatRepository(
            //               authenticationRepository:
            //                   RepositoryProvider.of<AuthenticationRepository>(
            //                       context))
            //           .receiveChatMessageStream,
            //       builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            //         if (snapshot.hasError) {
            //           return const Text('Something went wrong');
            //         }
            //         if (snapshot.connectionState == ConnectionState.waiting) {
            //           return Center(
            //             child: CircularProgressIndicator(),
            //           );
            //         }
            //         return const Text('Something was done');
            //       }),
            // ),
            Expanded(
              child: BlocBuilder<ChatblocBloc, ChatblocState>(
                buildWhen: (previous, current) =>
                    previous.message != current.message,
                builder: (context, state) {
                  List<ChatMessage> items = state.message;

                  return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        bool sender = false;
                        if (items[index].senderId ==
                            context
                                .read<AuthenticationRepository>()
                                .currentUser
                                .id) {
                          sender = true;
                        }

                        Widget child = sender
                            ? Align(
                                alignment: Alignment.topRight,
                                child: Text(items[index].message ?? ''))
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Text(items[index].message ?? ''));
                        return child;
                      });
                },
              ),
            ),
            ChatInput(receiver: receiver)
          ]),
        ));
  }
}

// ignore: use_key_in_widget_constructors
class ChatInput extends StatefulWidget {
  ChatInput({required this.receiver});
  final User receiver;
  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _textController = TextEditingController();
  String textContent = '';
  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      textContent = _textController.text;
    });
  }

  @override
  void dispose() {
    super.dispose();

    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 4.0,
        vertical: 10.0,
      ),
      // color: Colors.red,
      child: SafeArea(
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.mic), onPressed: () {}),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    height: 40.0,
                    child: Row(
                      children: [
                        IconButton(
                            icon: const Icon(Icons.emoji_emotions_rounded),
                            onPressed: () {}),
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            showCursor: false,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (value) {
                              _textController.clear();
                            },
                            // keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Enter your message',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            print(textContent);
                            context.read<ChatblocBloc>().add(SendMessage(
                                message: textContent,
                                receiver: widget.receiver));
                            _textController.clear();

                            //send message to firebase through bloc
                          },
                        )
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
