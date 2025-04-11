import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import '../components/custom_text_form_field.dart';
import '../components/navigate.dart';
import '../constants/color.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      try {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': usernameController.text.trim().toLowerCase(),
          'email': emailController.text.trim(),
          'banks': [],
        });
      } catch (firestoreError) {
        print('Firestore error: $firestoreError');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Firestore write failed: $firestoreError')),
        );
      }

      if (userCredential.user != null) {
        navigateAndFinish(context, const LoginScreen());
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registration error')),
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
                    'REGISTER',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: rmaincolor,
                      fontSize: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  controller: emailController,
                  focusNode: _emailFocusNode,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_usernameFocusNode);
                  },
                  hintText: 'Enter your email',
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                  prefixIconColor: rmaincolor,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: usernameController,
                  focusNode: _usernameFocusNode,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  hintText: 'Enter your username',
                  labelText: 'Username',
                  prefixIcon: Icons.supervised_user_circle,
                  prefixIconColor: rmaincolor,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
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
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ConditionalBuilder(
                  condition: true,
                  builder: (context) => CustomButton(
                    text: 'REGISTER'.toUpperCase(),
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        registerUser();
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
                    const Text('Already have an account?'),
                    DefoultTextButtom(
                      onpressed: () {
                        navigateAndFinish(context, const LoginScreen());
                      },
                      text: 'Login',
                      color: rmaincolor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DefoultTextButtom extends StatelessWidget {
  final VoidCallback onpressed;
  final String text;
  final Color color;

  const DefoultTextButtom({
    super.key,
    required this.onpressed,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onpressed,
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
    );
  }
}