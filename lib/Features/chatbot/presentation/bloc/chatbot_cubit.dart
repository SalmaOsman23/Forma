import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/chatbot_logic_service.dart';
import '../../data/models/chat_message.dart';
import 'chatbot_state.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  ChatbotCubit() : super(const ChatbotInitial()) {
    _initializeChat();
  }

  void _initializeChat() {
    final welcomeMessage = ChatMessage(
      message: "Hello! I'm your fitness assistant. I can help you with exercises, workout routines, and fitness advice. What would you like to know?",
      type: MessageType.bot,
      timestamp: DateTime.now(),
    );
    
    emit(ChatbotLoaded(messages: [welcomeMessage]));
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final currentState = state;
    if (currentState is ChatbotLoaded) {
      // Add user message
      final userMessage = ChatMessage(
        message: message.trim(),
        type: MessageType.user,
        timestamp: DateTime.now(),
      );

      // Add loading message
      final loadingMessage = ChatMessage(
        message: "Typing...",
        type: MessageType.bot,
        timestamp: DateTime.now(),
        isLoading: true,
      );

      final updatedMessages = [...currentState.messages, userMessage, loadingMessage];
      emit(currentState.copyWith(messages: updatedMessages, isLoading: true));

      try {
        // Process the message and get response
        final response = await ChatbotLogicService.processQuery(message.trim());
        
        // Remove loading message and add bot response
        final messagesWithoutLoading = updatedMessages.where((msg) => !msg.isLoading).toList();
        final botMessage = ChatMessage(
          message: response,
          type: MessageType.bot,
          timestamp: DateTime.now(),
        );

        final finalMessages = [...messagesWithoutLoading, botMessage];
        emit(currentState.copyWith(messages: finalMessages, isLoading: false));
      } catch (e) {
        // Handle error
        final messagesWithoutLoading = updatedMessages.where((msg) => !msg.isLoading).toList();
        final errorMessage = ChatMessage(
          message: "Sorry, I encountered an error. Please try again.",
          type: MessageType.bot,
          timestamp: DateTime.now(),
        );

        final finalMessages = [...messagesWithoutLoading, errorMessage];
        emit(currentState.copyWith(messages: finalMessages, isLoading: false));
      }
    }
  }

  void clearChat() {
    _initializeChat();
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
