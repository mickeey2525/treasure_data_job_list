import 'dart:convert';
import 'package:http/http.dart' as http;
import 'job.dart';

class ApiService {
  final String apiKey;
  final String apiUrl = "https://api.treasuredata.com";

  ApiService({required this.apiKey});

  Future<List<dynamic>> getJobsList({String? type, String? status}) async {
    final response = await http.get(
      Uri.parse('$apiUrl/v3/job/list?to=100'),
      headers: {
        'Authorization': 'TD1 $apiKey',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      List<dynamic> jobs = responseBody['jobs'] as List<dynamic>;
      if (type != null) {
        jobs = jobs.where((job) => job['type'] == type).toList();
      }

      if (status != null) {
        jobs = jobs.where((job) => job['status'] == status).toList();
      }
      return jobs;
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  Future<List<Job>> getJobs() async {
    final response = await http.get(
      Uri.parse('$apiUrl/v3/job/list'), // Replace with the correct endpoint
      headers: {'Authorization': 'TD1 $apiKey'}
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> jobsList = jsonData['jobs'];
      return jobsList.map((job) => Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }

}
