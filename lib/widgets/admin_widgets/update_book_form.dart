import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:library_management/controllers/admin_controller/update_book_controller.dart';
import 'package:library_management/models/inventory_model.dart';
import 'package:library_management/style/text_field_decoration.dart';
import 'package:library_management/style/style.dart';
import 'package:get/get.dart';

class UpdateBookForm extends StatelessWidget {
  final GlobalKey dataKey;
  UpdateBookForm({Key? key, required this.dataKey}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  final _updateBookController = Get.find<UpdateBookController>();

  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('inventory');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            key: dataKey,
            text: 'Update Book',
            size: 20,
            fontWeight: FontWeight.w800,
          ),
          const SizedBox(height: 20),
          FormBuilder(
            key: _formKey,
            skipDisabled: true,
            child: Obx(
              () => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderTextField(
                          name: 'isbn',
                          enabled: _updateBookController.enableISBN.value,
                          decoration: getDecoration('ISBN'),
                        ),
                      ),
                      Obx(
                        () => TextButton(
                            onPressed: _updateBookController
                                        .disableValidateButton.value ==
                                    true
                                ? null
                                : () async {
                                    // _updateBookController
                                    //     .toggleValidateButton();
                                    // check if isbn exists in database
                                    var isbn = _formKey
                                        .currentState!.fields['isbn']!.value;

                                    _collectionReference
                                        .where('isbn', isEqualTo: isbn)
                                        .get()
                                        .then((snapshot) {
                                      if (snapshot.docs.isNotEmpty) {
                                        confirmUpdate(
                                            context,
                                            _updateBookController,
                                            _formKey,
                                            snapshot);
                                      } else {
                                        updateCancelled(
                                            context, _updateBookController);
                                        _updateBookController
                                            .toggleValidateButton();
                                      }
                                    });
                                  },
                            child: const Text('Validate')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  FormBuilderTextField(
                    name: 'title',
                    decoration: getDecoration('Title'),
                  ),
                  const SizedBox(height: 10),
                  FormBuilderTextField(
                    name: 'author',
                    decoration: getDecoration('Author'),
                  ),
                  const SizedBox(height: 10),
                  // FormBuilderDateTimePicker(
                  //   name: 'year_published',
                  //   inputType: InputType.date,
                  //   decoration: const InputDecoration(
                  //     fillColor: Colors.white,
                  //     filled: true,
                  //     labelText: 'Year Published',
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  FormBuilderTextField(
                    name: 'year_published',
                    decoration: getDecoration('Year Published'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.integer(),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  FormBuilderTextField(
                    name: 'summary',
                    decoration: getDecoration('Summary'),
                  ),
                  const SizedBox(height: 10),
                  FormBuilderTextField(
                    name: 'qty',
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.integer()]),
                    decoration: getDecoration('Quantity'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _updateBookController
                                    .disableUpdateButton.value ==
                                true
                            ? null
                            : () async {
                                final validationSuccess =
                                    _formKey.currentState!.saveAndValidate();

                                var isbn = _formKey
                                    .currentState!.fields['isbn']!.value;

                                if (validationSuccess) {
                                  _collectionReference
                                      .where('isbn', isEqualTo: isbn)
                                      .get()
                                      .then((snapshot) {
                                    _collectionReference
                                        .doc(snapshot.docs[0].id)
                                        .update(_formKey.currentState!.value);
                                  });
                                }
                                await updateSuccess(context);
                                _updateBookController.toggleValidateButton();
                                _updateBookController.toggleUpdateButton();
                                _updateBookController.toggleISBN();
                                _formKey.currentState!.reset();
                              },
                        child: const PrimaryText(
                          text: 'Update',
                          size: 14.0,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          if (_updateBookController.enableISBN.value == false) {
                            _updateBookController.toggleISBN();
                            _updateBookController.toggleValidateButton();
                            _updateBookController.toggleUpdateButton();
                          }

                          _formKey.currentState!.reset();
                        },
                        child: const PrimaryText(
                          text: 'Cancel',
                          size: 14.0,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

void updateCancelled(context, UpdateBookController updateBookController) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Book not found!'),
          content:
              const Text('Sorry the book you are looking for does not exist..'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'))
          ],
        );
      });
}

Future<void> confirmUpdate(
    context,
    updateBookController,
    GlobalKey<FormBuilderState> formKey,
    QuerySnapshot<Object?> snapshot) async {
  await showDialog(
      context: context,
      builder: (contex) {
        return AlertDialog(
          title: const Text('Book found!'),
          content: const Text('Are you sure you want to edit this book?'),
          actions: [
            TextButton(
              onPressed: () {
                // close popup dialog
                Navigator.pop(context);

                // disable isbn field and enable other fields
                updateBookController.toggleISBN();
                updateBookController.toggleFields();
                updateBookController.toggleUpdateButton();

                var map = (snapshot.docs[0].data() as Map<String, dynamic>);

                var data = InventoryModel.fromJson(map);

                // set textfield data
                formKey.currentState!.patchValue({
                  'title': data.title,
                  'author': data.author,
                  'year_published': data.year_published,
                  'summary': data.summary,
                  'qty': data.qty.toString()
                });
              },
              child: Text('Yes'),
            ),
            TextButton(
              // textColor: shrineBrown900,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
          ],
          elevation: 24,
        );
      });
}

Future<void> updateSuccess(context) async {
  await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Update success!'),
            content: Text('Updated fields has been added to the database.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text('Ok')),
            ],
          ));
}
