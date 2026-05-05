import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:med_reminder/provider/auth_provider.dart';
import 'package:med_reminder/screens/Login_page.dart';
import 'package:med_reminder/screens/home_screen.dart';
import 'package:med_reminder/screens/user_information_screen.dart';
import 'package:med_reminder/utils/utils.dart';
import 'package:med_reminder/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Medi ",
                          style: TextStyle(
                              fontSize: 6.h, fontWeight: FontWeight.bold)),
                      Text("Reminder",
                          style: GoogleFonts.abel(
                              color: Colors.green,
                              fontSize: 6.h,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    width: 200,
                    height: 200,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.shade50,
                    ),
                    child: Image.asset(
                      "assets/signup.png",
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Enter your email and password to sign up",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Email input field
                  TextFormField(
                    cursorColor: Colors.green,
                    controller: emailController,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter email",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Password input field
                  TextFormField(
                    cursorColor: Colors.green,
                    controller: passwordController,
                    obscureText: true,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter password",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Register button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CustomButton(
                      text: "Register",
                      onPressed: () => signInWithEmailAndPassword(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signInWithEmailAndPassword() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      showSnackBar(context, "Please enter a valid email");
    } else if (password.length < 6) {
      showSnackBar(context, "Password must be at least 6 characters long");
    } else {
      // Authenticate the user with Firebase Authentication
      ap.registerWithEmailPassword(context, email, password).then((_) async {
        // After successful registration/sign-in, store the email and password in Firebase Firestore
        await FirebaseFirestore.instance.collection('users').doc(ap.uid).set({
          'email': email,
          'password': password,  // Note: Storing plain passwords is not recommended for production
          'lastLogin': Timestamp.now(),
        }).then((value) {
          // Data successfully saved to Firestore
          print("User data saved to Firestore");

          // Navigate to UserInformationScreen on success
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }).catchError((error) {
          // Handle any errors in Firestore data saving
          showSnackBar(context, "Failed to store user data: $error");
        });
      }).catchError((e) {
        // Handle errors in Firebase Authentication
        showSnackBar(context, "Authentication failed: ${e.toString()}");
      });
    }
  }


}
