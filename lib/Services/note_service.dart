import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/notes/data/models/note_model.dart';
import 'auth_service.dart';

class NoteService {
  static const String baseUrl = 'http://10.0.2.2:5000/api/notes';

  Future<List<Note>> fetchNotes(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((n) => Note.fromMap({
        'id': n['_id'],
        'title': n['title'],
        'content': n['content'],
        'userId': n['userId'],
      })).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  Future<void> createNote(String title, String content, String token) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'title': title, 'content': content}),
    );
  }

  Future<void> deleteNote(String id, String token) async {
    await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
