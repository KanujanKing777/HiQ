import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth package
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget { // Change to StatefulWidget to handle form state
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance; // Firebase Auth instance

  String? email;
  String? password;
  String? name;
  String profilepic = "https://wallpapers.com/images/high/cool-skull-profile-picture-j6r78po6xuuton85.webp";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (newName) {
              name = newName; // Save email
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "Name",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (newLink) {
              if(newLink != null){
                profilepic = newLink;
              } // Save email
            },
            
            decoration: const InputDecoration(
              hintText: "Profile Pic URL",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (newEmail) {
              email = newEmail; // Save email
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              obscureText: true,
              textInputAction: TextInputAction.done,
              cursorColor: kPrimaryColor,
              onSaved: (newPassword) {
                password = newPassword; // Save password
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                try {
                  // Register the user with Firebase Auth
                  UserCredential king = await _auth.createUserWithEmailAndPassword(
                    email: email!,
                    password: password!,
                    
                  );
                  await king.user?.updateDisplayName(name);
                  await king.user?.updatePhotoURL(profilepic);
                  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

                  bool darkMode = true;
                  String selectedCourse = "";
                  String selectedLanguage = "English";
                  bool notificationsEnabled = true;
                  try {
                    await _firestore.collection('users').doc(email).set({
                      'darkMode': darkMode,
                      'selectedCourse': selectedCourse,
                      'selectedLanguage': selectedLanguage,
                      'notificationsEnabled':notificationsEnabled
                    }, SetOptions(merge: true)); // Merge if the document already exists
                    print("User preferences saved successfully!");
                  } catch (e) {
                    print("Error saving user preferences: $e");
                  }
                  // Navigate to the login screen after successful sign up
                  Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                } catch (e) {
                  // Handle errors (e.g., show a dialog or snackbar)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to sign up: $e'))
                  );
                }
              }
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
