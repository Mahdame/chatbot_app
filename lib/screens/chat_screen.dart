// ignore_for_file: library_private_types_in_public_api

import 'package:chatbot_app/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  late ChatBloc _chatBloc;

  @override
  void initState() {
    super.initState();
    _chatBloc = ChatBloc();
  }

  @override
  void dispose() {
    _textController.dispose();
    _chatBloc.close();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) {
      return;
    }

    _textController.clear();

    _chatBloc.add(SendMessage(text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _chatBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Chatbot')),
        body: Column(
          children: [
            Flexible(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoaded) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) => ListTile(title: Text(state.messages[index])),
                      itemCount: state.messages.length,
                    );
                  }
                  return const Center(child: Text('No messages'));
                },
              ),
            ),
            const Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
