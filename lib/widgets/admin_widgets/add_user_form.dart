import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:library_management/constants/book_genre.dart';
import 'package:library_management/controllers/admin_controller/add_user_form_controller.dart';
import 'package:library_management/style/style.dart';
import 'package:library_management/style/text_field_decoration.dart';

// used for creating library card
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AddStudentForm extends StatelessWidget {
  final GlobalKey dataKey;
  AddStudentForm({Key? key, required this.dataKey}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();
  final _addUserController = Get.find<AddUserController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText(
          key: dataKey,
          text: 'Create User Account',
          size: 20,
          fontWeight: FontWeight.w800,
        ),
        const SizedBox(height: 20),
        FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              // Student ID
              FormBuilderTextField(
                name: 'id_number',
                decoration: getDecoration('ID Number'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.integer(),
                ]),
              ),
              const SizedBox(height: 10),
              // Student Name
              Row(
                children: [
                  generateTextField(
                      name: 'first_name',
                      labelText: 'First Name',
                      required: true),
                  const SizedBox(width: 5),
                  generateTextField(
                      name: 'middle_name', labelText: 'Middle Name'),
                  const SizedBox(width: 5),
                  generateTextField(
                      name: 'last_name',
                      labelText: 'Last Name',
                      required: true),
                ],
              ),
              const SizedBox(height: 10),
              // Department
              Row(
                children: [
                  generateDropDown(
                      name: 'year_level',
                      labelText: 'Year Level',
                      items: yearLevel),
                  const SizedBox(width: 5),
                  generateDropDown(
                      name: 'category', labelText: 'Category', items: category)
                ],
              ),
              const SizedBox(height: 10),
              // Address
              FormBuilderTextField(
                name: 'address',
                decoration: getDecoration('Address'),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  // Date of Birth
                  Expanded(
                    child: FormBuilderDateTimePicker(
                      name: 'birth_date',
                      inputType: InputType.date,
                      decoration: getDecoration('Date of Birth'),
                      validator: FormBuilderValidators.required(),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'email_address',
                      decoration: getDecoration('Email Address'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ]),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              // Phone Number
              FormBuilderTextField(
                name: 'phone_number',
                decoration: getDecoration('Phone Number'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.integer(),
                ]),
              ),
              const SizedBox(height: 10),
              // Buttons: (Add student, reset)

              // Container(
              //   width: 500,
              //   height: 300,
              //   child: PdfPreview(build: (format) => pdf.save()),
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Create account button
                  Obx(
                    () => TextButton(
                      onPressed: _addUserController.isEnabled.value == false
                          ? null
                          : () async {
                              var isValidated =
                                  _formKey.currentState!.saveAndValidate();
                              // check form if complete and valid
                              if (isValidated) {
                                _addUserController.disableButton();
                                var data = _formKey.currentState!.value;

                                var idNumber = _formKey
                                    .currentState!.value['id_number']
                                    .toString();
                                var emailAddress = _formKey
                                    .currentState!.value['email_address'];

                                // check if user exists in the database
                                var isValidUser = await validateUser(
                                    idNumber: idNumber,
                                    emailAddress: emailAddress);

                                if (isValidUser) {
                                  await FirebaseFirestore.instance
                                      .collection('students')
                                      .doc(idNumber)
                                      .set(data);

                                  String firstName = _formKey
                                      .currentState!.value['first_name']
                                      .substring(0, 2)
                                      .toUpperCase();
                                  String month = _formKey
                                      .currentState!.value['birth_date'].month
                                      .toString()
                                      .padLeft(2, '0');
                                  String day = _formKey
                                      .currentState!.value['birth_date'].day
                                      .toString()
                                      .padLeft(2, '0');
                                  String year = _formKey
                                      .currentState!.value['birth_date'].year
                                      .toString();

                                  var accountCreated = await createUserAccount(
                                      emailAddress: emailAddress,
                                      password: '$firstName$month$day$year');

                                  if (accountCreated) {
                                    showConfimationInfo(
                                        context: context,
                                        title: 'Success!',
                                        content:
                                            'Account successfuly created!');
                                    _addUserController.enableButton();
                                  } else {
                                    showConfimationInfo(
                                        context: context,
                                        title: 'Failed!',
                                        content:
                                            'Account creation failed, email already taken!');
                                    _addUserController.enableButton();
                                  }
                                } else {
                                  showConfimationInfo(
                                      context: context,
                                      title: 'Failed!',
                                      content:
                                          'ID or email address already exists');
                                  _addUserController.disableButton();
                                }
                              }
                            },
                      child: const PrimaryText(
                        text: 'Create',
                        size: 14.0,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      // generateLibraryCard(context);
                      _formKey.currentState!.reset();
                    },
                    child: const PrimaryText(
                      text: 'Reset',
                      size: 14.0,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  generateTextField(
      {required String name, required String labelText, bool? required}) {
    return Expanded(
      child: FormBuilderTextField(
        name: name,
        decoration: getDecoration(labelText),
        validator: required == null
            ? null
            : FormBuilderValidators.compose([FormBuilderValidators.required()]),
      ),
    );
  }
}

generateDropDown(
    {required String name,
    required String labelText,
    required List<String> items}) {
  return Expanded(
    child: FormBuilderDropdown(
      name: name,
      decoration: getDecoration(labelText),
      items: items
          .map((String e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      initialValue: items[0],
    ),
  );
}

generateLibraryCard(context) {
  final pdf = pw.Document();

  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text("Hello World"),
        ); // Center
      })); // Page

  PdfPreview(build: (format) => pdf.save());
}

showConfimationInfo({context, title, content}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: PrimaryText(
        text: title,
        color: Colors.green,
      ),
      content: PrimaryText(
        text: content,
        size: 15,
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Ok'))
      ],
    ),
  );
}

Future<bool> validateUser({required idNumber, required emailAddress}) async {
  var isValidUser = false;
  try {
    await FirebaseFirestore.instance
        .collection('students')
        .where('id_number', isEqualTo: idNumber)
        .where('email_address', isEqualTo: emailAddress)
        .get()
        .then((value) {
      isValidUser = true;
    });
  } on FirebaseAuthException catch (e) {
    isValidUser = false;
  }
  return isValidUser;
}

Future<bool> createUserAccount(
    {required String emailAddress, required String password}) async {
  var isCreated = false;
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress, password: password);
    isCreated = true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
    isCreated = false;
  } catch (e) {
    isCreated = false;
  }
  return isCreated;
}
