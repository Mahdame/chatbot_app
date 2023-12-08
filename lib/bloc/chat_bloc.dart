import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<SendMessage>(_onSendMessage);
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    List<String> updatedMessages = [];

    if (state is ChatLoaded) {
      updatedMessages = List<String>.from((state as ChatLoaded).messages);
    }

    updatedMessages.insert(0, event.message); // Insert new message at the beginning of the list
    emit(ChatLoaded(updatedMessages));
  }
}
