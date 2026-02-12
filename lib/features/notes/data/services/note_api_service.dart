import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';

class NoteApiService {
  static const String _endpoint = "/notes";

  static Future<List<dynamic>> getNotes() async {
    final response =
        await http.get(Uri.parse("${ApiConstants.baseUrl}$_endpoint/all"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch notes");
    }
  }
}
