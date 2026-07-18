import 'dart:convert';

class ChatMessage {
  final String text;
  final bool isUser;
  final String time;
  final String type;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.type = 'normal',
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isUser': isUser,
      'time': time,
      'type': type,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'] ?? '',
      isUser: map['isUser'] ?? false,
      time: map['time'] ?? '',
      type: map['type'] ?? 'normal',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) => ChatMessage.fromMap(json.decode(source));
}

class ChatSession {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<ChatMessage> messages;

  ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.messages,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'messages': messages.map((x) => x.toMap()).toList(),
    };
  }

  factory ChatSession.fromMap(Map<String, dynamic> map) {
    return ChatSession(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      messages: List<ChatMessage>.from(map['messages']?.map((x) => ChatMessage.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatSession.fromJson(String source) => ChatSession.fromMap(json.decode(source));
}
