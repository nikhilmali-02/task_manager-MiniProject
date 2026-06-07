import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter your Email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passController,
                obscureText: true,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Password';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    if (_formKey.currentState!.validate()) {
                      await AuthService().signIn(
                        _emailController.text,
                        _passController.text,
                      );
                      context.go('/');
                    }
                  } catch (e) {
                    setState(() {
                      _error = ("Invalid email or password");
                    });
                  }
                },
                child: Text("Login"),
              ),
              if (_error != null)
                Text(_error!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 20),
              Text('-OR-'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.go('/signup');
                },
                child: Text('SignUp'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }
}
