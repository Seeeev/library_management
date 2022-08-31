import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:library_management/style/text_field_decoration.dart';
import 'package:library_management/style/style.dart';

class DeleteBookForm extends StatelessWidget {
  final GlobalKey dataKey;
  DeleteBookForm({Key? key, required this.dataKey}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryText(
          key: dataKey,
          text: 'Delete Book',
          size: 20,
          fontWeight: FontWeight.w800,
        ),
        const SizedBox(height: 20),
        FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'isbn',
                decoration: getDecoration('ISBN'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.redAccent)),
                    onPressed: () async {
                      var validateSucces =
                          _formKey.currentState!.saveAndValidate();
                      if (validateSucces) {
                        var isbn = _formKey.currentState!.fields['isbn']!.value;
                        var isbnExists = await doesISBNAlreadeExists(isbn);
                        if (!isbnExists) {
                          showDialog(
                              context: context,
                              builder: (context) => isbnMissing(context));
                        } else {
                          QuerySnapshot snapshot = await FirebaseFirestore
                              .instance
                              .collection('inventory')
                              .where('isbn', isEqualTo: isbn)
                              .limit(1)
                              .get();

                          String title = snapshot.docs.single['title'];

                          await FirebaseFirestore.instance
                              .collection('inventory')
                              .doc(snapshot.docs.single.id)
                              .delete();

                          showDialog(
                            context: context,
                            builder: (context) => docDeleted(context, title),
                          );
                        }
                      }
                    },
                    child: const PrimaryText(
                      text: 'Delete',
                      size: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

docDeleted(BuildContext context, String title) {
  return AlertDialog(
      title: const Text('Book deleted!'),
      content: Text("The book: $title has been deleted from database"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('Ok')),
      ]);
}

isbnMissing(BuildContext context) {
  return AlertDialog(
    title: const Text('ISBN missing!'),
    content:
        const Text('The ISBN you provided does not exist in the database.'),
    actions: [
      TextButton(
          onPressed: () => Navigator.pop(context), child: const Text('Ok'))
    ],
  );
}

Future<bool> doesISBNAlreadeExists(isbn) async {
  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('inventory')
      .where('isbn', isEqualTo: isbn)
      .limit(1)
      .get();

  return result.docs.length == 1;
}
