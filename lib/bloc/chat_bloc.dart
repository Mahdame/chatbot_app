import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<SendMessage>(_onSendMessage);
    on<BonnieResponse>(_onBonnieResponse);
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    List<String> updatedMessages = [];

    if (state is ChatLoaded) {
      updatedMessages = List<String>.from((state as ChatLoaded).messages);
    }

    updatedMessages.insert(0, "User: ${event.message}"); // Insert new message at the beginning of the list
    emit(ChatLoaded(updatedMessages));

    // Schedule BONNIE's response
    Future.delayed(const Duration(seconds: 1), () {
      add(BonnieResponse(event.message)); // Dispatch a new event for BONNIE's response
    });
  }

  String _generateBonnieResponse(String userMessage) {
    // Check if the user message is "Help"
    if (userMessage.trim().toLowerCase() == "help") {
      // List of predefined responses for "Help"
      List<String> helpResponses = [
        "Sure, I'm here to help you!",
        "How can I assist you today?",
        "Need some help? I'm here for you.",
        "What do you need assistance with?",
      ];

      // Selecting a random response
      final randomIndex = math.Random().nextInt(helpResponses.length);
      return helpResponses[randomIndex];
    }

    // Default response logic
    return "Echo: $userMessage";
  }

  void _onBonnieResponse(BonnieResponse event, Emitter<ChatState> emit) {
    if (state is ChatLoaded) {
      final updatedMessages = List<String>.from((state as ChatLoaded).messages);
      String bonnieResponse = _generateBonnieResponse(event.userMessage);
      updatedMessages.insert(0, "BONNIE: $bonnieResponse");
      emit(ChatLoaded(updatedMessages));
    }
  }
}
