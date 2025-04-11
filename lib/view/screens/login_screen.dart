import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart' show ConditionalBuilder;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_bank_app/view/screens/register_screen.dart';
import '../components/custom_button.dart';
import '../components/custom_text_form_field.dart';
import '../components/navigate.dart';
import '../constants/color.dart';
import 'BottomNav.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // This controller is used for both username and email input.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login function with username/email check and error handling
  Future<void> loginUser() async {
    try {
      String loginInput = emailController.text.trim();
      String loginEmail = loginInput;

      // If input doesn't look like an email, treat it as a username and normalize it to lowercase
      if (!loginInput.contains('@')) {
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: loginInput.toLowerCase())
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          loginEmail = userSnapshot.docs.first.get('email');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Username not found')),
          );
          return;
        }
      }

      // Sign in with the email (from input or retrieved) and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: loginEmail,
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        navigateAndFinish(context, const BottomNav());
      }
    } on FirebaseAuthException catch (e) {
      // Show error message from FirebaseAuth
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login error')),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: rbackgroundcolor,
      appBar: AppBar(
        backgroundColor: rbackgroundcolor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/bank_12202822.png',
                    height: 100,
                    color: rmaincolor,
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'LOGIN',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: rmaincolor,
                      fontSize: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  controller: emailController,
                  focusNode: _emailFocusNode,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  hintText: 'Enter your username or email',
                  labelText: 'Username / Email',
                  prefixIcon: Icons.supervised_user_circle,
                  prefixIconColor: rmaincolor,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username or email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: passwordController,
                  focusNode: _passwordFocusNode,
                  onFieldSubmitted: (data) {
                    if (formKey.currentState!.validate()) {}
                  },
                  hintText: 'Enter your Password',
                  labelText: 'Password',
                  prefixIcon: Icons.lock,
                  prefixIconColor: rmaincolor,
                  suffixIcon: Icons.visibility_outlined,
                  suffixIconToggle: Icons.visibility_off_outlined,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ConditionalBuilder(
                  condition: true,
                  builder: (context) => CustomButton(
                    text: 'LOGIN',
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        loginUser();
                      }
                    },
                  ),
                  fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        navigateAndFinish(context, const RegisterScreen());
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: rmaincolor),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
