part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendMessage extends ChatEvent {
  final String message;

  SendMessage(this.message);

  @override
  List<Object> get props => [message];
}

class BonnieResponse extends ChatEvent {
  final String userMessage;

  BonnieResponse(this.userMessage);

  @override
  List<Object> get props => [userMessage];
}
