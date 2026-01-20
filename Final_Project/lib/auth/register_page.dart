import 'package:flutter/material.dart';
import 'package:sad/auth/login_page.dart';
import 'package:sad/home_page.dart';
import 'package:sad/widgets/input_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();
  bool _isLoading = false;
  final _supabase = Supabase.instance.client;

  void register() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = authResponse.user;

      if (user != null) {
        // Save extra user info in profiles table
        await _supabase.from('profiles').insert({
          'id': user.id,
          'name': name,
          'email': email,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registered Successfully!!"),
          backgroundColor: Colors.pinkAccent,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );

      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _cPasswordController.clear();
    } on AuthApiException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.pinkAccent),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // soft pink background
      appBar: AppBar(
        title: const Text("Register to Mini Marvels"),
        backgroundColor: Colors.pink[200],
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 350,
            child: Card(
              color: Colors.pink[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Register Form",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent,
                          fontFamily: 'ComicSans',
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Name Field
                      InputField(
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        label: "Name",
                        hint: "Enter Name",
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter name";
                          }
                          if (!RegExp(r'^[a-zA-Z \.]+$').hasMatch(value)) {
                            return "Please enter a valid name!!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Email Field
                      InputField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        label: "Email",
                        hint: "Enter Email",
                        icon: Icons.email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Password Field
                      InputField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        label: "Password",
                        hint: "Enter Password",
                        icon: Icons.lock,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter password";
                          }
                          if (value.length < 8) {
                            return "Length must be more than 8";
                          }
                          if (_passwordController.text !=
                              _cPasswordController.text) {
                            return "Passwords don't match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Confirm Password Field
                      InputField(
                        controller: _cPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        label: "Confirm Password",
                        hint: "Enter Confirm Password",
                        icon: Icons.lock,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter confirm password";
                          }
                          if (value.length < 8) {
                            return "Length must be more than 8";
                          }
                          if (_passwordController.text !=
                              _cPasswordController.text) {
                            return "Passwords don't match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),

                      // Register Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            register();
                          }
                        },
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Register",
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                      const SizedBox(height: 20),

                      // Login Link
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        ),
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(
                            color: Colors.pinkAccent,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
