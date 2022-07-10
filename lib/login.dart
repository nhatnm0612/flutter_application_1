// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'input_text.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  String? username;
  String? password;
  String? url;
  String? databaseName;
  String errors = '';
  bool login = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController dbController = TextEditingController();

  void setLogin() async {
    username = usernameController.text;
    password = passwordController.text;
    databaseName = dbController.text;
    url = urlController.text;
    Uri authenticateUrl = Uri.parse('$url/web/session/authenticate');
    Map<String, String> headers = {'content-type': 'application/json'};
    Object body = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {"db": databaseName, "login": username, "password": password}
    };
    var resp = await http.post(
      authenticateUrl,
      body: jsonEncode(body),
      headers: headers,
    );
    var jsonResp = jsonDecode(resp.body);
    setState(() {
      if (!jsonResp.keys.contains('error')) {
        login = !login;
        errors = '';
      } else {
        errors = '${jsonResp['error'].toString().substring(0, 200)}...';
      }
    });
  }

  String _getButtonName() {
    if (login) {
      return 'Log Out';
    }
    return 'Log In';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Odoo Login')),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InputText(controller: urlController, label: 'Odoo URL'),
              InputText(controller: dbController, label: 'Database'),
              InputText(controller: usernameController, label: 'Username'),
              InputText(
                controller: passwordController,
                label: 'Password',
                obscure: true,
              ),
              Container(
                width: 350.0,
                height: 60.0,
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: setLogin, child: Text(_getButtonName())),
              ),
              Container(
                width: 350.0,
                padding: const EdgeInsets.all(8.0),
                child: Text(errors),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
