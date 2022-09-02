// import 'package:editable/editable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/foundation/key.dart';

// class MyTable extends StatelessWidget {
//   MyTable({Key? key}) : super(key: key);

//   final _editableKey = GlobalKey<EditableState>();

//   List rows = [
//     {
//       "name": 'James LongName Joe',
//       "date": '23/09/2020',
//       "month": 'June',
//       "status": 'completed'
//     },
//     {
//       "name": 'Daniel Paul',
//       "month": 'March',
//       "status": 'new',
//       "date": '12/4/2020',
//     },
//     {
//       "month": 'May',
//       "name": 'Mark Zuckerberg',
//       "date": '09/4/1993',
//       "status": 'expert'
//     },
//     {
//       "name": 'Jack',
//       "status": 'legend',
//       "date": '01/7/1820',
//       "month": 'December',
//     },
//   ];
//   List cols = [
//     {"title": 'Name', 'widthFactor': 0.2, 'key': 'name', 'editable': false},
//     {"title": 'Date', 'widthFactor': 0.2, 'key': 'date'},
//     {"title": 'Month', 'widthFactor': 0.2, 'key': 'month'},
//     {"title": 'Status', 'key': 'status'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Editable(
//       key: _editableKey,
//       columns: cols,
//       rows: rows,
//       zebraStripe: true,
//       stripeColor1: Colors.blue.shade50,
//       stripeColor2: Colors.grey.shade200,
//       onRowSaved: (value) {
//         print(value);
//       },
//       onSubmitted: (value) {
//         print(value);
//       },
//       borderColor: Colors.blueGrey,
//       tdStyle: TextStyle(fontWeight: FontWeight.bold),
//       trHeight: 80,
//       thStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//       thAlignment: TextAlign.center,
//       thVertAlignment: CrossAxisAlignment.end,
//       thPaddingBottom: 3,
//       showSaveIcon: true,
//       saveIconColor: Colors.black,
//       showCreateButton: true,
//       tdAlignment: TextAlign.left,
//       tdEditableMaxLines: 100, // don't limit and allow data to wrap
//       tdPaddingTop: 0,
//       tdPaddingBottom: 14,
//       tdPaddingLeft: 10,
//       tdPaddingRight: 8,
//       focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue),
//           borderRadius: BorderRadius.all(Radius.circular(0))),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

// List<PlutoColumn> columns = [
//   PlutoColumn(
//     title: 'Book ID',
//     field: 'id_field',
//     type: PlutoColumnType.text(),
//   ),

//   /// Text Column definition
//   PlutoColumn(
//     title: 'Title',
//     field: 'title_field',
//     type: PlutoColumnType.text(),
//   ),

//   /// Number Column definition
//   PlutoColumn(
//     title: 'Author',
//     field: 'author_field',
//     type: PlutoColumnType.text(),
//   ),

//   /// Select Column definition
//   PlutoColumn(
//     title: 'Date Published',
//     field: 'date_field',
//     type: PlutoColumnType.date(),
//   ),
// ];

// List<PlutoRow> rows = [
//   PlutoRow(
//     cells: {
//       'id_field': PlutoCell(value: '11111'),
//       'title_field': PlutoCell(value: 'Text cell value1'),
//       'author_field': PlutoCell(value: 'Author Name 1'),
//       'date_field': PlutoCell(value: '2020-08-06'),
//     },
//   ),
//   PlutoRow(
//     cells: {
//       'id_field': PlutoCell(value: '098234234'),
//       'title_field': PlutoCell(value: 'Text cell value1'),
//       'author_field': PlutoCell(value: 'Author Name 1'),
//       'date_field': PlutoCell(value: '2020-08-06'),
//     },
//   ),
//   PlutoRow(
//     cells: {
//       'id_field': PlutoCell(value: '098234234'),
//       'title_field': PlutoCell(value: 'Text cell value1'),
//       'author_field': PlutoCell(value: 'Author Name 1'),
//       'date_field': PlutoCell(value: '2020-08-06'),
//     },
//   ),
//   PlutoRow(
//     cells: {
//       'id_field': PlutoCell(value: '098234234'),
//       'title_field': PlutoCell(value: 'Text cell value1'),
//       'author_field': PlutoCell(value: 'Author Name 1'),
//       'date_field': PlutoCell(value: '2020-08-06'),
//     },
//   ),
//   PlutoRow(
//     cells: {
//       'id_field': PlutoCell(value: '098234234'),
//       'title_field': PlutoCell(value: 'Text cell value1'),
//       'author_field': PlutoCell(value: 'Author Name 1'),
//       'date_field': PlutoCell(value: '2020-08-06'),
//     },
//   ),
//   PlutoRow(
//     cells: {
//       'id_field': PlutoCell(value: '098234234'),
//       'title_field': PlutoCell(value: 'Text cell value1'),
//       'author_field': PlutoCell(value: 'Author Name 1'),
//       'date_field': PlutoCell(value: '2020-08-06'),
//     },
//   ),
// ];

List<PlutoColumn> columns = [
  PlutoColumn(
    title: 'ISBN',
    field: 'isbn_field',
    type: PlutoColumnType.text(),
  ),

  /// Text Column definition
  PlutoColumn(
    title: 'Title',
    field: 'title_field',
    type: PlutoColumnType.text(),
  ),

  /// Number Column definition
  PlutoColumn(
    title: 'Author',
    field: 'author_field',
    type: PlutoColumnType.text(),
  ),

  /// Select Column definition
  // PlutoColumn(
  //   title: 'Date Published',
  //   field: 'date_field',
  //   type: PlutoColumnType.date(),
  // ),
  PlutoColumn(
    title: 'Year Published',
    field: 'published_field',
    type: PlutoColumnType.number(format: '####'),
  ),

  PlutoColumn(
    title: 'Quantity',
    field: 'qty_field',
    type: PlutoColumnType.number(),
  ),

  PlutoColumn(
    title: 'Summary',
    field: 'summary_field',
    type: PlutoColumnType.text(),
  ),
];

List<PlutoRow> processRows(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
  var rows = snapshot.data!.docs.map(
    (doc) {
      return PlutoRow(cells: {
        'isbn_field': PlutoCell(value: doc.get('isbn')),
        'title_field': PlutoCell(value: doc.get('title')),
        'author_field': PlutoCell(value: doc.get('author')),
        'published_field': PlutoCell(value: doc.get('year_published')),
        // 'published_field': PlutoCell(value: doc.get('date_published')),
        // 'date_field': PlutoCell(
        //     value: (doc.get('publication_date') as Timestamp).toDate()),
        'qty_field': PlutoCell(value: doc.get('qty')),
        'summary_field': PlutoCell(value: doc.get('summary'))
      });
    },
  ).toList();
  return rows;
}

// List<PlutoRow> rows = [
//   PlutoRow(
//     cells: {
//       'id_field': PlutoCell(value: '11111'),
//       'title_field': PlutoCell(value: 'Text cell value1'),
//       'author_field': PlutoCell(value: 'Author Name 1'),
//       'date_field': PlutoCell(value: '2020-08-06'),
//     },
//   ),
//   PlutoRow(
//     cells: {
//       'id_field': PlutoCell(value: '098234234'),
//       'title_field': PlutoCell(value: 'Text cell value1'),
//       'author_field': PlutoCell(value: 'Author Name 1'),
//       'date_field': PlutoCell(value: '2020-08-06'),
//     },
//   ),
//   PlutoRow(
//     cells: {
//       'id_field': PlutoCell(value: '098234234'),
//       'title_field': PlutoCell(value: 'Text cell value1'),
//       'author_field': PlutoCell(value: 'Author Name 1'),
//       'date_field': PlutoCell(value: '2020-08-06'),
//     },
//   ),
//   PlutoRow(
//     cells: {
//       'id_field': PlutoCell(value: '098234234'),
//       'title_field': PlutoCell(value: 'Text cell value1'),
//       'author_field': PlutoCell(value: 'Author Name 1'),
//       'date_field': PlutoCell(value: '2020-08-06'),
//     },
//   ),
//   PlutoRow(
//     cells: {
//       'id_field': PlutoCell(value: '098234234'),
//       'title_field': PlutoCell(value: 'Text cell value1'),
//       'author_field': PlutoCell(value: 'Author Name 1'),
//       'date_field': PlutoCell(value: '2020-08-06'),
//     },
//   ),
//   PlutoRow(
//     cells: {
//       'id_field': PlutoCell(value: '098234234'),
//       'title_field': PlutoCell(value: 'Text cell value1'),
//       'author_field': PlutoCell(value: 'Author Name 1'),
//       'date_field': PlutoCell(value: '2020-08-06'),
//     },
//   ),
// ];
