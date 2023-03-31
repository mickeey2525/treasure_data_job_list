import 'package:flutter/material.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';

// APIキーを保存する関数
Future<void> saveApiKey(String apiKey) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('apiKey', apiKey);
}

// APIキーを削除する関数
Future<void> deleteApiKey() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('apiKey');
}



class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    String? apiKey = prefs.getString('apiKey');
    if (apiKey != null) {
      setState(() {
        _apiKeyController.text = apiKey;
      });
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              obscureText: true,
              controller: _apiKeyController,
              decoration: InputDecoration(
                labelText: 'API Key',
                hintText: 'Enter your Treasure Data API Key',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String apiKey = _apiKeyController.text;
                if (apiKey.isNotEmpty) {
                  await saveApiKey(apiKey);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobsListPage(apiKey: apiKey),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid API Key'),
                    ),
                  );
                }
              },
              child: Text('Submit'),
            ),
            ElevatedButton(
              onPressed: () async {
                await deleteApiKey();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('API Key has been deleted'),
                  ),
                );
              },
              child: Text('Delete API Key'),
            ),
          ],
        ),
      ),
    );
  }
}
