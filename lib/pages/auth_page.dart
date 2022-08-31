import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:library_management/controllers/login_controller/auth_controller.dart';

class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();
  final _passKey = GlobalKey<FormBuilderState>();
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Library Management System',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 40,
                    color: Colors.blueAccent),
              ),
              SizedBox(height: 50),
              Text(
                'Login to Account',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    color: Colors.grey),
              ),
              SizedBox(height: 10),
              FormBuilder(
                key: _formKey,
                child: Obx(
                  () => Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: FormBuilderTextField(
                              name: 'email',
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email()
                              ]),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                labelText: 'Email',
                                fillColor: Colors.white,
                                filled: true,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: FormBuilderSwitch(
                              name: 'isAdmin',
                              initialValue: false,
                              title: Text('Admin'),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        key: _passKey,
                        name: 'password',
                        obscureText: true,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          labelText: 'Password',
                          fillColor: Colors.white,
                          filled: true,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      _authController.isPressed.value == true
                          ? CircularProgressIndicator()
                          : TextButton(
                              onPressed: () async {
                                var isValid =
                                    _formKey.currentState!.saveAndValidate();

                                if (isValid) {
                                  _authController.toggleLoginButton();
                                  await Future.delayed(Duration(seconds: 1));
                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: _formKey
                                                .currentState!.value['email'],
                                            password: _formKey.currentState!
                                                .value['password']);

                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .where('uid',
                                            isEqualTo: FirebaseAuth
                                                .instance.currentUser!.uid)
                                        .where('isAdmin',
                                            isEqualTo: _formKey
                                                .currentState!.value['isAdmin'])
                                        .get()
                                        .then((value) {
                                      if (_formKey
                                              .currentState!.value['isAdmin'] ==
                                          true) {
                                        Get.offNamed('/admin_dashboard');
                                      } else {
                                        _formKey.currentState!.invalidateField(
                                            name: 'email',
                                            errorText: 'User not found');
                                        FirebaseAuth.instance.signOut();
                                        _authController.toggleLoginButton();
                                      }
                                    });
                                    // Get.offNamed('/admin_dashboard');
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'user-not-found') {
                                      _formKey.currentState!.invalidateField(
                                          name: 'email',
                                          errorText: 'User not found');
                                    }
                                    if (e.code == 'wrong-password') {
                                      _formKey.currentState!.invalidateField(
                                          name: 'password',
                                          errorText: 'Invalid password');
                                    }
                                    _authController.toggleLoginButton();

                                    // _formKey.currentState!.invalidateField(
                                    //     name: 'password', errorText: 'patal');
                                  }
                                }
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
