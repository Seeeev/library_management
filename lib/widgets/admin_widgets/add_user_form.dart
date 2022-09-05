import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:library_management/constants/book_genre.dart';
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
                      name: 'department',
                      labelText: 'Department',
                      items: department),
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
                  generateTextField(
                      name: 'email_address', labelText: 'Email Address'),
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
                  TextButton(
                    onPressed: () async {
                      var isValidated =
                          _formKey.currentState!.saveAndValidate();

                      if (isValidated) {
                        var data = _formKey.currentState!.value;
                        var idNumber =
                            _formKey.currentState!.value['id_number'];

                        await FirebaseFirestore.instance
                            .collection('students')
                            .doc(idNumber)
                            .set(data);

                        showConfimationInfo(context, data['first_name']);
                      }
                    },
                    child: const PrimaryText(
                      text: 'Create',
                      size: 14.0,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
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
                  )
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

showConfimationInfo(context, name) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const PrimaryText(
        text: 'Account Created!',
        color: Colors.green,
      ),
      content: PrimaryText(
        text: 'Account Sucessfuly created for $name',
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
