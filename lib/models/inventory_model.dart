import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryModel {
  String? isbn;
  String? title;
  String? genre;
  String? author;
  String? book_status;
  int? year_published;
  String? summary;
  int? qty;

  InventoryModel(
      {required this.isbn,
      required this.title,
      required this.genre,
      required this.author,
      required this.book_status,
      required this.year_published,
      required this.summary,
      required this.qty});

  Map<String, dynamic> toMap() {
    return {
      'isbn': isbn,
      'title': title,
      'genre': genre,
      'author': author,
      'book_status': book_status,
      'year_published': year_published,
      'summary': summary,
      'qty': qty
    };
  }

  // InventoryModel.fromDocumentSnapshot(
  //     DocumentSnapshot<Map<dynamic, dynamic>> doc)
  //     : isbn = doc.data()!['isbn'],
  //       title = doc.data()!['title'],
  //       author = doc.data()!['author'],
  //       publicationDate = doc.data()!['publicationDate'],
  //       summary = doc.data()!['summary'],
  //       qty = doc.data()!['qty'];

  InventoryModel.fromJson(Map<String, dynamic> json) {
    isbn = json['isbn'];
    title = json['title'];
    genre = json['genre'];
    author = json['author'];
    book_status = json['book_status'];
    year_published = int.parse(json['year_published']);
    summary = json['summary'];
    qty = int.parse(json['qty']);
  }
}
