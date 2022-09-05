import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:library_management/constants/book_genre.dart';
import 'package:library_management/constants/book_status.dart';
import 'package:library_management/models/inventory_model.dart';
import 'package:library_management/style/colors.dart';
import 'package:library_management/style/text_field_decoration.dart';
import 'package:library_management/style/style.dart';
import 'package:library_management/widgets/admin_widgets/inventory_table.dart';

class AddBookForm extends StatelessWidget {
  final GlobalKey dataKey;
  AddBookForm({Key? key, required this.dataKey}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('inventory');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            key: dataKey,
            text: 'Add Book',
            size: 20,
            fontWeight: FontWeight.w800,
          ),
          const SizedBox(height: 20),
          FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [
                FormBuilderTextField(
                    name: 'isbn',
                    decoration: getDecoration('ISBN'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.integer(),
                    ])),
                const SizedBox(height: 10),
                FormBuilderTextField(
                    name: 'title',
                    decoration: getDecoration('Title'),
                    validator: FormBuilderValidators.required()),
                const SizedBox(height: 10),

                FormBuilderDropdown(
                  name: 'genre',
                  decoration: getDecoration('Genre'),
                  // valueTransformer: (value) => (value as String).toLowerCase(),
                  items: genre
                      .map((String e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  initialValue: genre[0],
                ),
                const SizedBox(height: 10),

                FormBuilderTextField(
                  name: 'author',
                  decoration: getDecoration('Author'),
                ),
                const SizedBox(height: 10),

                FormBuilderDropdown(
                  name: 'book_status',
                  decoration: getDecoration('Book Status'),
                  // valueTransformer: (value) => (value as String).toLowerCase(),
                  items: bookStatus
                      .map((String e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  initialValue: bookStatus[0],
                ),
                const SizedBox(height: 10),
                // FormBuilderDateTimePicker(
                //     name: 'year_published',
                //     inputType: InputType.date,
                //     decoration: getDecoration('Publication Date')),
                FormBuilderTextField(
                  name: 'year_published',
                  decoration: getDecoration('Year Published'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.integer()
                  ]),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'summary',
                  decoration: getDecoration('Summary'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                    name: 'qty',
                    decoration: getDecoration('Quantity'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.integer(),
                      FormBuilderValidators.required()
                    ])),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final validationSuccess =
                            _formKey.currentState!.saveAndValidate();

                        if (validationSuccess) {
                          _formKey.currentState!.save();
                          var isbn =
                              _formKey.currentState!.fields['isbn']!.value;

                          var isbnExists = await doesISBNAlreadeExists(isbn);

                          // if isbn exist dont proceed to add it to database
                          if (isbnExists) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Found!'),
                                    content: const Text(
                                        'The ISBN provided already exists, please provide a new ISBN'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Ok'))
                                    ],
                                  );
                                });
                          } else {
                            // CollectionReference test =
                            //     FirebaseFirestore.instance.collection('test');

                            // test.add(_formKey.currentState!.value);
                            collectionReference
                                .add(_formKey.currentState!.value);

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text('Book added to database!'),
                                    actions: [
                                      TextButton(
                                        // textColor: shrineBrown900,
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Ok'),
                                      ),
                                    ],
                                    elevation: 24,
                                  );
                                });
                          }
                        }
                      },
                      child: const PrimaryText(
                        text: 'Add',
                        size: 14.0,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      child: const PrimaryText(
                        text: 'Reset',
                        color: Colors.blueAccent,
                        size: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Future<bool> doesISBNAlreadeExists(isbn) async {
  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('inventory')
      .where('isbn', isEqualTo: isbn)
      .limit(1)
      .get();

  return result.docs.length == 1;
}
