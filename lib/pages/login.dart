import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iot_frontend/io/http.dart';
import 'package:iot_frontend/state/user.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late var userState = ref.watch(userStateProvider.notifier);

  void logIn() async {
    final jwt =
        await httpApi.login(usernameController.text, passwordController.text);

    if (jwt != null) {
      userState.logIn(jwt);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(jwt != null ? 'Login successful!' : 'Login failed!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  hintText: 'Username',
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              ElevatedButton(
                onPressed: logIn,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
