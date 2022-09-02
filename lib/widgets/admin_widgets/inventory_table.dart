import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_management/config/size_config.dart';

import 'package:library_management/style/style.dart';
import 'package:library_management/widgets/admin_widgets/table.dart';
import 'package:pluto_grid/pluto_grid.dart';

class InventoryTable extends StatelessWidget {
  InventoryTable({Key? key, required this.dataKey}) : super(key: key);

  final GlobalKey dataKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // height: SizeConfig.screenHeight,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('inventory').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  key: dataKey,
                  text: 'Inventory',
                  size: 20,
                  fontWeight: FontWeight.w800,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: SizeConfig.screenHeight,
                  child: PlutoGrid(
                    columns: columns,
                    rows: processRows(snapshot),
                    onChanged: (PlutoGridOnChangedEvent event) {
                      print(event);
                    },
                    onLoaded: (PlutoGridOnLoadedEvent event) {
                      print(event);
                    },
                  ),
                ),
              ],
            );
          }
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  key: dataKey,
                  text: 'Inventory',
                  size: 20,
                  fontWeight: FontWeight.w800,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: SizeConfig.screenHeight,
                  child: PlutoGrid(
                    // this key is currently used for controlled scrolling
                    // key: dataKey,
                    columns: columns,
                    rows: processRows(snapshot),
                    onChanged: (PlutoGridOnChangedEvent event) {
                      print(event);
                    },
                    onLoaded: (PlutoGridOnLoadedEvent event) {
                      print(event);
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
