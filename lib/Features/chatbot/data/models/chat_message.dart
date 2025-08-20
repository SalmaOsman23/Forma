enum MessageType {
  user,
  bot,
}

class ChatMessage {
  final String message;
  final MessageType type;
  final DateTime timestamp;
  final bool isLoading;

  ChatMessage({
    required this.message,
    required this.type,
    required this.timestamp,
    this.isLoading = false,
  });

  ChatMessage copyWith({
    String? message,
    MessageType? type,
    DateTime? timestamp,
    bool? isLoading,
  }) {
    return ChatMessage(
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  String toString() {
    return 'ChatMessage(message: $message, type: $type, timestamp: $timestamp, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage &&
        other.message == message &&
        other.type == type &&
        other.timestamp == timestamp &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        type.hashCode ^
        timestamp.hashCode ^
        isLoading.hashCode;
  }
}
