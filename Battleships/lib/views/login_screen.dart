import 'dart:convert';
import 'package:battleships/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/sessionmanager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => _login(context),
                  child: const Text('Log in'),
                ),
                TextButton(
                  onPressed: () => _register(context),
                  child: const Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkAccessToken() async {
    final accessToken = await SessionManager.getSessionToken();
    final response = await http.get(
      Uri.parse('http://165.227.117.48/games'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      if (!mounted) return;
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      SessionManager.clearSession();
    }
  }

  Future<void> _login(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;
    final url = Uri.parse('http://165.227.117.48/login');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }));
    if (!mounted) return;
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final sessionToken = responseBody['access_token'];
      await SessionManager.setSessionToken(sessionToken);
      SessionManager.setUsername(username);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ));
    } else {
      _showSnackBar('Login failed');
    }
  }

  Future<void> _register(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;
    if (username.length < 3 || password.length < 3) {
      _showSnackBar('Username and Password must be atleast 3 characters.');
      return;
    }
    final url = Uri.parse('http://165.227.117.48/register');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }));
    if (!mounted) return;
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final sessionToken = responseBody['access_token'];
      await SessionManager.setSessionToken(sessionToken);
      SessionManager.setUsername(username);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ));
    } else {
      _showSnackBar('Registration failed');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
