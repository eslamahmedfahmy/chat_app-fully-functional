import 'dart:async';
import 'dart:developer';
import 'package:chat_app_fully_functional/api/apis.dart';
import 'package:chat_app_fully_functional/features/pages/auth/forget_password.dart';
import 'package:chat_app_fully_functional/features/pages/auth/sign_up_screen.dart';
import 'package:chat_app_fully_functional/features/pages/home_screen/homepage.dart';
import 'package:chat_app_fully_functional/utils/dialoges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  // SharedPreferences? loginData;
  // bool? newUser;

  login(String email1, pass1) async {
    setState(() {
      isLoading = true;
    });

    try {
      await Apis.auth.signInWithEmailAndPassword(
          email: email1.trim(), password: pass1);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
        ),
            (route) => false,
      );
      setState(() {
        isLoading = false;
      });

      // loginData!.setBool("login", false);
      // loginData!.setString("username", email.text);
      // loginData!.setString("password", password.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (!mounted) return;
      if (e.code == 'user-not-found') {
        Dialogues.errorDialogue(context, "User not found");
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        Dialogues.errorDialogue(context, "Wrong email or password");
      } else {
        Dialogues.errorDialogue(context, e.message ?? e.code);
      }
    }
    // } else {}
  }

  String? passValidation(value) {
    if (value == null || value.isEmpty) {
      return " password is required";
    } else if (value.length < 5) {
      return " password must be  5 Characters";
    } else if (value.length > 15) {
      return " password is too Long";
    } else {
      return null;
    }
  }

  // late SharedPreferences loginDataa;
  // late String userName;
  // late String pass;

  // void checkIfLogin() async {
  // loginData = await SharedPreferences.getInstance();

  //   newUser = (loginDataa.getBool("login") ?? true);
  //   print(newUser);
  //   if (newUser == false) {
  //     loginData = await SharedPreferences.getInstance();
  //     setState(() {
  //       userName = loginDataa.getString("username").toString();
  //       pass = loginDataa.getString("password").toString();
  //     });
  //     login(
  //       userName,
  //       pass,
  //     );
  //   }
  // }
  Timer? _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkIfLogin();
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

  handleWithGoogle() {
    EasyLoading.show(status: 'Loading...');
    signInWithGoogle().then((user) {
      EasyLoading.showSuccess('Login successful');
      EasyLoading.dismiss();

      log(user.user.toString());

    }).onError((error, stackTrace) {
      EasyLoading.showError(error.toString());
    });
  }

  static bool _googleSignInReady = false;

  Future<UserCredential> signInWithGoogle() async {
    // google_sign_in 7.x: initialize once, then authenticate
    final googleSignIn = GoogleSignIn.instance;
    if (!_googleSignInReady) {
      await googleSignIn.initialize();
      _googleSignInReady = true;
    }
    final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

    // Obtain the auth details from the request (v7 only returns an idToken)
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await Apis.auth.signInWithCredential(credential);
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3c83f1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.all(22),
              padding: EdgeInsets.all(22),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: email,
                          validator: MultiValidator(
                            [
                              RequiredValidator(errorText: "Email is required"),
                              EmailValidator(errorText: "Not a valid Email"),
                            ],
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            prefix: SizedBox(
                              width: 5,
                            ),
                            labelText: "Email",
                            hintText: "Enter your email",
                            suffixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
                              child: Icon(Icons.email_outlined),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: password,
                          validator: passValidation,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefix: SizedBox(
                              width: 5,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Password",
                            hintText: "Enter your password",
                            suffixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
                              child: Icon(Icons.lock_outline),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Forgot Password ?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade400,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        isLoading
                            ? Center(child: CircularProgressIndicator())
                            : SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white, shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(24)),
                              backgroundColor: Color(0xFF4167b2),
                            ),
                            onPressed: () {
                              final isvalid =
                              _formKey.currentState!.validate();
                              if (isvalid) {
                                login(email.text, password.text);
                              } else {}
                            },
                            child: Text(
                              "SIGN IN",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Flexible(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "OR",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Flexible(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                signInWithGoogle();
                              },
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: Image.asset("assets/images/google.png"),
                              ),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            InkWell(
                              onTap: () async {},
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child:
                                Image.asset("assets/images/facebook.png"),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don’t have an account? ",
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUPScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}