import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/note_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NoteRepository {
  final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:5000/api';

  Future<List<Note>> fetchNotes() async {
    final response = await http.get(Uri.parse('$baseUrl/notes'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Note.fromMap(e)).toList();
    } else {
      throw Exception('Failed to fetch notes');
    }
  }

  Future<Note> createNote(String title, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notes'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'content': content}),
    );
    if (response.statusCode == 201) {
      return Note.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to create note');
    }
  }

  Future<Note> updateNote(String id, String title, String content) async {
    final response = await http.put(
      Uri.parse('$baseUrl/notes/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'content': content}),
    );
    if (response.statusCode == 200) {
      return Note.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to update note');
    }
  }

  Future<void> deleteNote(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/notes/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete note');
    }
  }
}
