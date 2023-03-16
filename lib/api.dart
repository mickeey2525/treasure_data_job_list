import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = "10452/15cb28aed67a701f4f4a72a45b951b5f59beed31";
  final String apiUrl = "https://api.treasuredata.com";

  Future<List<dynamic>> getJobsList() async {
    final response = await http.get(
      Uri.parse('$apiUrl/v3/job/list'),
      headers: {
        'Authorization': 'TD1 $apiKey',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['jobs'] as List<dynamic>;
    } else {
      throw Exception('Failed to load jobs');
    }
  }
}
