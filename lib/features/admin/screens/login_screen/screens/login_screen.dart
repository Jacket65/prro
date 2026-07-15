import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:prro/features/admin/screens/main_screen/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController(
    text: 'admin',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: 'admin123',
  );
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await _authenticateUser(
        _phoneController.text,
        _passwordController.text,
      );

      if (token != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Телефон'),
              const SizedBox(height: 8),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _phoneController,
                  cursorWidth: 1,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    hintText: 'Телефон',
                    hintStyle: const TextStyle(color: Colors.grey),
                    isDense: true,
                    contentPadding: const EdgeInsets.all(10),
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Пароль'),
              const SizedBox(height: 8),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  cursorWidth: 1,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    hintText: 'Пароль',
                    hintStyle: const TextStyle(color: Colors.grey),
                    isDense: true,
                    contentPadding: const EdgeInsets.all(10),
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Вхід',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _authenticateUser(String login, String password) async {
    final dio = Dio(
      BaseOptions(baseUrl: 'http://pos.coffeebeans.space.test/api/v1'),
    );

    try {
      final response = await dio.post(
        '/auth/login',
        data: {'login': login, 'password': password},
      );

      log('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final authHeader = response.headers['authorization']?.first;
        if (authHeader != null &&
            authHeader.toLowerCase().startsWith('bearer ')) {
          return authHeader.substring(7).trim();
        }
      }
    } catch (e) {
      log('Authentication error: $e');
    }
    return null;
  }
}
