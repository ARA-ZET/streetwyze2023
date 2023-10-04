import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:street_wyze/screens/Auth/register_screen.dart';
import 'package:street_wyze/screens/Auth/reset_password.dart';
import 'package:street_wyze/services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _auth = AuthService();
  bool obscure = true;
  String errorMsg = "";
  Color color = Colors.green;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: width,
            height: height,
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 12),
            color: Colors.black,
            child: Column(
              children: [
                Container(
                  height: 120,
                  width: width,
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                    ),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: const Column(
                          children: [
                            Text(
                              "  STREETWYZE",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Your guardian on the go !",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 96, 96, 96),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(1),
                        width: 70,
                        height: 70,
                        child: const ClipRRect(
                          child: Image(
                            image: AssetImage("assets/logowhite.png"),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: EdgeInsets.all(width * 0.05),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _emailController,
                          cursorColor: Colors.white,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.white),
                            labelStyle: const TextStyle(color: Colors.white),
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          style: const TextStyle(color: Colors.white),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? 'Enter a valid email'
                                  : null,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          height: 60,
                          width: width,
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2,
                              )
                            ],
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          child: TextFormField(
                            obscureText: obscure,
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "please enter password";
                              }
                              return null;
                            },
                            onTapOutside: (PointerDownEvent event) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            decoration: InputDecoration(
                              hintText: "password",
                              icon: const Icon(
                                Icons.lock_outline,
                                size: 35,
                                color: Colors.green,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscure = !obscure;
                                  });
                                },
                                icon: Icon(
                                  obscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.green,
                                ),
                              ),
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintStyle: const TextStyle(color: Colors.white),
                              labelStyle: const TextStyle(color: Colors.white),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text("Don't have have account  ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12)),
                                const SizedBox(
                                  width: 2,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: isLoading
                                      ? const CircularProgressIndicator()
                                      : Text("signup?",
                                          style: TextStyle(
                                              color: color,
                                              fontSize: 17,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: Colors.green)),
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                try {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading =
                                          true; // Start loading animation
                                    });
                                    dynamic result =
                                        await _auth.signInWithEmailAndPassword(
                                      context,
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                    if (result != null) {
                                      debugPrint(
                                          "couldn't sign with these credentials");
                                    }
                                  }
                                } catch (e) {
                                  setState(() {
                                    color = Colors.grey;
                                  });
                                } finally {
                                  setState(() {
                                    isLoading = false; // Stop loading animation
                                  });
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                margin: const EdgeInsets.only(
                                  top: 16,
                                ),
                                height: 40,
                                width: width * 0.35,
                                decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green,
                                      blurRadius: 4,
                                    )
                                  ],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  color: Colors.green,
                                ),
                                child: const Text(
                                  "Signin",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                try {
                                  await _auth.signInWithGoogle(context);
                                } catch (e) {
                                  setState(() {
                                    isLoading = false; // Stop loading animation
                                  });
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                margin: const EdgeInsets.only(
                                  top: 16,
                                ),
                                height: 40,
                                width: width * 0.4,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color.fromARGB(255, 0, 93, 3),
                                    Color.fromARGB(255, 145, 87, 0)
                                  ]),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green,
                                      blurRadius: 4,
                                    )
                                  ],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                child: const Text(
                                  "Signin with google",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text("Forgotten password  ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12)),
                                const SizedBox(
                                  width: 2,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPasswordPage(),
                                      ),
                                    );
                                  },
                                  child: Text("Reset?",
                                      style: TextStyle(
                                          color: color,
                                          fontSize: 17,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.green)),
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        Wrap(
                          children: [
                            Text(
                              errorMsg,
                              style: const TextStyle(color: Colors.red),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
