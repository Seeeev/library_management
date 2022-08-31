import 'package:cloud_firestore/cloud_firestore.dart';

class BookLogger {
  final String? materialId;
  final String? title;
  final String? author;
  final DateTime? publicationDate;
  final DateTime? dateAdded;
  final String? addedBy;

  BookLogger(
      {required this.materialId,
      required this.title,
      required this.author,
      required this.publicationDate,
      required this.dateAdded,
      required this.addedBy});

  Map<String, dynamic> toMap() {
    return {
      'materialId': materialId,
      'title': title,
      'author': author,
      'publicationDate': publicationDate,
      'dateAdded': dateAdded,
      'addedBy': addedBy
    };
  }

  BookLogger.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : materialId = doc.data()!['materialId'],
        title = doc.data()!['title'],
        author = doc.data()!['author'],
        publicationDate = doc.data()!['publicationDate'],
        dateAdded = doc.data()!['dateAdded'],
        addedBy = doc.data()!['addedBy'];
}
