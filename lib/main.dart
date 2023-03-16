import 'package:flutter/material.dart';
import 'api.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treasure Data Jobs List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: JobsListPage(),
    );
  }
}

class JobsListPage extends StatefulWidget {
  @override
  _JobsListPageState createState() => _JobsListPageState();
}

void launchURL(String jobId) async {
  final url = Uri.parse('https://console.treasuredata.com/app/jobs/$jobId');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

class _JobsListPageState extends State<JobsListPage> {
  ApiService apiService = ApiService();
  Future<List<dynamic>>? _jobsList;

  @override
  void initState() {
    super.initState();
    _jobsList = apiService.getJobsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Treasure Data Jobs List')),
    body: FutureBuilder<List<dynamic>>(
    future: _jobsList,
    builder: (context, snapshot) {
    if (snapshot.hasData) {
    return ListView.builder(
    itemCount: snapshot.data!.length,
    itemBuilder: (context, index) {
    final job = snapshot.data![index];
    return ListTile(
      title: Text(job['job_id']),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(job['status']),
          Text(job['type']),
        ],
      ),
      onTap: () => launchURL(job['job_id']), // ここでlaunchURL関数を呼び出す
    );
    },
    );
    } else if (snapshot.hasError) {
    return Center(child: Text('${snapshot.error}'));
    }
    return Center(child: CircularProgressIndicator
      ());
    },
    ),
    );
  }
}

