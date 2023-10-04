import 'package:flutter/material.dart';
import 'package:street_wyze/services/auth_service.dart';
import 'package:street_wyze/services/notification_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _auth = AuthService();
  bool isLoading = false;
  bool obscure = true;

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
                  height: 150,
                  width: width,
                  padding: EdgeInsets.all(width * 0.08),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
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
                        width: 100,
                        height: 100,
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
                  padding: EdgeInsets.all(width * 0.08),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3, vertical: 3),
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            height: 50,
                            width: width,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color.fromARGB(255, 0, 111, 37),
                                        width: 2))),
                            child: TextFormField(
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "please enter your name";
                                }
                                return null;
                              },
                              onTapOutside: (PointerDownEvent event) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              decoration: const InputDecoration(
                                hintText: "name",
                                icon: Icon(
                                  Icons.person_2_outlined,
                                  size: 25,
                                  color: Colors.green,
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 193, 193, 193)),
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 193, 193, 193)),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3, vertical: 3),
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            height: 50,
                            width: width,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color.fromARGB(255, 0, 111, 37),
                                        width: 2))),
                            child: TextFormField(
                              controller: _surnameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "please enter your surname";
                                }
                                return null;
                              },
                              onTapOutside: (PointerDownEvent event) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              decoration: const InputDecoration(
                                hintText: "Surname",
                                icon: Icon(
                                  Icons.person_2_rounded,
                                  size: 25,
                                  color: Colors.green,
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 193, 193, 193)),
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 193, 193, 193)),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3, vertical: 3),
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            height: 50,
                            width: width,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color.fromARGB(255, 0, 111, 37),
                                        width: 2))),
                            child: TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value!.contains("@")) {
                                  return null;
                                } else {
                                  return "please enter valid email";
                                }
                              },
                              onTapOutside: (PointerDownEvent event) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              decoration: const InputDecoration(
                                hintText: "email",
                                icon: Icon(
                                  Icons.email_outlined,
                                  size: 25,
                                  color: Colors.green,
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 193, 193, 193)),
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 193, 193, 193)),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3, vertical: 3),
                            margin: const EdgeInsets.only(top: 12),
                            height: 50,
                            width: width,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color.fromARGB(255, 0, 111, 37),
                                        width: 2))),
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
                                  size: 25,
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
                                hintStyle: const TextStyle(
                                    color: Color.fromARGB(255, 193, 193, 193)),
                                labelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 193, 193, 193)),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )),
                ),
                Container(
                    child: isLoading
                        ? const CircularProgressIndicator.adaptive()
                        : Container()),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              try {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          context,
                                          _nameController.text,
                                          _surnameController.text,
                                          _emailController.text,
                                          _passwordController.text);
                                  if (result != null) {
                                    Navigator.pop(context);
                                  } else {
                                    setState(() {
                                      isLoading =
                                          false; // Stop loading animation
                                    });
                                  }
                                }
                              } catch (e) {
                                setState(() {
                                  isLoading = false; // Stop loading animation
                                });
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              margin: const EdgeInsets.only(
                                top: 16,
                              ),
                              height: 40,
                              width: width * 0.3,
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
                                "SIGN UP",
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
                                final results =
                                    await _auth.signInWithGoogle(context);
                                if (results != null) {
                                  Navigator.pop(context);
                                } else {
                                  setState(() {
                                    isLoading = false; // Stop loading animation
                                  });
                                }
                              } catch (e) {
                                setState(() {
                                  isLoading = false; // Stop loading animation
                                });
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              margin: const EdgeInsets.only(
                                top: 16,
                              ),
                              height: 40,
                              width: width * 0.5,
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
                                "SIGN UP WITH GOOGLE",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
