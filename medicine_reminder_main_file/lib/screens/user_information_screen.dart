import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:med_reminder/models/user_model.dart';
import 'package:med_reminder/provider/auth_provider.dart';
import 'package:med_reminder/screens/home_screen.dart';
import 'package:med_reminder/utils/utils.dart';
import 'dart:io';
import 'package:med_reminder/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UserInformationScreen extends StatefulWidget {
  final String email; // Receive the email from the previous screen
  final String password; // Receive the password from the previous screen

  const UserInformationScreen({super.key, required this.email, required this.password});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  File? image; // User avatar
  final nameController = TextEditingController(); // For name

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;

    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        )
            : SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Medi ",
                      style: TextStyle(
                          fontSize: 6.h, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Reminder",
                      style: GoogleFonts.abel(
                          color: Colors.green,
                          fontSize: 6.h,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(height: 8.h),

                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 15),
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      // Name field
                      textField(
                        hintText: "John Smith",
                        icon: Icons.account_circle,
                        inputType: TextInputType.name,
                        maxLines: 1,
                        controller: nameController,
                      ),

                      // Secondary email field (displaying the passed email)
                      textField(
                        hintText: widget.email, // Display the passed email
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                        maxLines: 1,
                        controller: TextEditingController(
                            text: widget.email), // Make it non-editable
                        enabled: false, // Disable editing
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: CustomButton(
                    text: "Continue",
                    onPressed: () => storeData(), // Store the data when the user presses this button
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom textField
  Widget textField({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
    bool enabled = true, // By default, the field is enabled
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: Colors.green,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        enabled: enabled,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.green,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Colors.green.shade50,
          filled: true,
        ),
      ),
    );
  }

  // Store user data to database
  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    // Pass the password to the UserModel
    UserModel userModel = UserModel(
      name: nameController.text.trim(),
      email: widget.email, // Use the passed email
      uid: "",
      createdAt: "",
      password: widget.password, // Pass the password to the model
    );

    // Save the data to Firestore
    ap.saveUserDataToFirebase(
      context: context,
      userModel: userModel,
      onSuccess: () {
        // After saving the data to Firebase, save the data locally
        ap.saveUserDataToSP().then((value) {
          ap.setSignIn().then((value) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
            );
          });
        });
      },
    );
  }
}