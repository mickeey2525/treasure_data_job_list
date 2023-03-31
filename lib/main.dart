import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api.dart';
import 'settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treasure Data Jobs List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SettingsPage(),
    );
  }
}

class JobsListPage extends StatefulWidget {
  final String apiKey;

  JobsListPage({required this.apiKey});

  @override
  _JobsListPageState createState() => _JobsListPageState();
}

class _JobsListPageState extends State<JobsListPage> {
  late ApiService apiService;
  Future<List<dynamic>>? _jobsList;
  String? _filterType;
  String? _filterStatus;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(apiKey: widget.apiKey);
    _jobsList = apiService.getJobsList();
  }

  void launchURL(String jobId) async {
    final url = Uri.parse('https://console.treasuredata.com/app/jobs/$jobId');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _applyFilter({String? type, String? status}) {
    setState(() {
      _filterType = type;
      _filterStatus = status;
      _jobsList = apiService.getJobsList(type: _filterType, status: _filterStatus);
    });
  }

  void _refreshJobsList() {
    setState(() {
      _jobsList = apiService.getJobsList(type: _filterType, status: _filterStatus);
    });
  }

  Future<void> _showFilterDialog() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
      String? selectedType = _filterType;
      String? selectedStatus = _filterStatus;

      return AlertDialog(
          title: Text('Filter Jobs'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Type:'),
              DropdownButton<String?>(
                value: selectedType,
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedType = newValue;
                  });
                },
                items: <String?>[null, 'hive', 'presto', 'export', 'result_export', 'bulk_import', 'partial_delete']
                    .map<DropdownMenuItem<String?>>((String? value) {
                  return DropdownMenuItem<String?>(
                    value: value,
                    child: value != null ? Text(value) : Text('All Types'),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              Text('Status:'),
              DropdownButton<String?>(
                value: selectedStatus,
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStatus = newValue;
                  });
                },
                items: <String?>[null, 'success', 'error', 'running', 'queued']
                    .map<DropdownMenuItem<String?>>((String? value) {
                  return DropdownMenuItem<String?>(
                    value: value,
                    child: value != null ? Text(value) : Text('All Status'),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
      TextButton(
      child: Text('Apply Filter'),
    onPressed: () {
    _applyFilter(type: selectedType, status: selectedStatus);
    Navigator.of(context).pop();
    },
    ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
      );
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treasure Data Jobs List'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshJobsList,
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () async {
              await _showFilterDialog();
            },
          ),
        ],
      ),
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
                  onTap: () => launchURL(job['job_id']),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),

    );
  }
}

