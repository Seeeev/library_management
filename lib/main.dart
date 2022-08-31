import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:library_management/bindings/admin_bindings.dart';
import 'package:library_management/bindings/auth_bindings.dart';

import 'package:library_management/pages/admin_dashboard.dart';
import 'package:library_management/pages/auth_page.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> initialization = Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDRqYjfyX2XVBqD8aJE_Hm9bIRjv12CeAs",
          appId: "1:981830909542:web:95355fc620cd44e56df7a7",
          messagingSenderId: "981830909542",
          projectId: "lhs-libraray-management"));

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: FormBuilderLocalizations.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
            name: '/admin_dashboard',
            page: () => firebaseInit(
                initialization: initialization, page: AdminDashboard()),
            binding: AdminBindings()),
        GetPage(
            name: '/auth_page',
            page: () =>
                firebaseInit(initialization: initialization, page: AuthPage()),
            binding: AuthBindings())
      ],
      initialRoute: '/auth_page',
    );
  }

  FutureBuilder firebaseInit({initialization, page}) {
    return FutureBuilder(
        future: initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          if (snapshot.hasData) {
            return page;
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
