import '../../data/models/chat_message.dart';

abstract class ChatbotState {
  const ChatbotState();
}

class ChatbotInitial extends ChatbotState {
  const ChatbotInitial();
}

class ChatbotLoading extends ChatbotState {
  const ChatbotLoading();
}

class ChatbotLoaded extends ChatbotState {
  final List<ChatMessage> messages;
  final bool isLoading;

  const ChatbotLoaded({
    required this.messages,
    this.isLoading = false,
  });

  ChatbotLoaded copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
  }) {
    return ChatbotLoaded(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ChatbotError extends ChatbotState {
  final String message;

  const ChatbotError({required this.message});
}
