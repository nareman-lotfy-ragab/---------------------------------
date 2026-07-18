import 'dart:convert';
import 'package:agri_sense_ai/core/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_models.dart';

class ChatStorageService {
  static String get _storageKey =>
    'agrisense_chat_sessions_${ApiService.currentUserId}';

  static Future<List<ChatSession>> getSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? sessionsJson = prefs.getString(_storageKey);
    
    if (sessionsJson == null) return [];
    
    final List<dynamic> decoded = json.decode(sessionsJson);
    return decoded.map((item) => ChatSession.fromMap(item)).toList();
  }

  static Future<void> saveSession(ChatSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final List<ChatSession> sessions = await getSessions();
    
    final int existingIndex = sessions.indexWhere((s) => s.id == session.id);
    
    if (existingIndex != -1) {
      sessions[existingIndex] = session;
    } else {
      sessions.insert(0, session);
    }
    
    final String encoded = json.encode(sessions.map((s) => s.toMap()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  static Future<void> deleteSession(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<ChatSession> sessions = await getSessions();
    
    sessions.removeWhere((s) => s.id == id);
    
    final String encoded = json.encode(sessions.map((s) => s.toMap()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
