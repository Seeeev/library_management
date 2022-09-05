import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_tables/data_tables.dart';
import 'package:library_management/config/responsive.dart';
import 'package:library_management/config/size_config.dart';
import 'package:library_management/style/colors.dart';
import 'package:library_management/widgets/admin_widgets/add_user_form.dart';
import 'package:library_management/widgets/admin_widgets/app_bar_action_item.dart';
import 'package:library_management/widgets/admin_widgets/approvals.dart';
import 'package:library_management/widgets/admin_widgets/dashboard_header.dart';
import 'package:library_management/widgets/admin_widgets/add_book_form.dart';
import 'package:library_management/widgets/admin_widgets/delete_book_form.dart';
import 'package:library_management/widgets/admin_widgets/inventory_table.dart';
import 'package:library_management/widgets/admin_widgets/update_book_form.dart';
import 'package:library_management/widgets/admin_widgets/side_menu.dart';
import 'package:library_management/widgets/admin_widgets/table.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class AdminDashboard extends StatelessWidget {
  AdminDashboard({Key? key}) : super(key: key);

  List<GlobalKey> dataKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

    // DashboardController controller = Get.find<DashboardController>();

    SizeConfig().init(context);
    return Scaffold(
      key: _drawerKey,
      drawer: SizedBox(
        width: 100,
        child: SideMenu(
          dataKeys: dataKeys,
        ),
      ),
      appBar: !Responsive.isDesktop(context)
          ? AppBar(
              elevation: 0,
              backgroundColor: AppColors.white,
              leading: IconButton(
                  onPressed: () {
                    _drawerKey.currentState!.openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: AppColors.black,
                  )),
              actions: const [AppBarActionItem()],
            )
          : const PreferredSize(
              child: SizedBox(),
              preferredSize: Size.zero,
            ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                flex: 1,
                child: SideMenu(
                  dataKeys: dataKeys,
                ),
              ),
            Expanded(
              flex: 10,
              child: SingleChildScrollView(
                primary: false,
                padding:
                    EdgeInsets.all(Responsive.isDesktop(context) ? 30 : 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DashboardHeader(subtitle: 'Admin', showSearch: false),
                    SizedBox(
                      height: Responsive.isDesktop(context)
                          ? SizeConfig.blockSizeVertical! * 5
                          : SizeConfig.blockSizeVertical! * 3,
                    ),
                    InventoryTable(dataKey: dataKeys[0]),
                    const SizedBox(height: 20),
                    AddBookForm(dataKey: dataKeys[1]),
                    UpdateBookForm(dataKey: dataKeys[2]),
                    DeleteBookForm(dataKey: dataKeys[3]),
                    AddStudentForm(dataKey: dataKeys[4])
                  ],
                ),
              ),
            ),
            if (Responsive.isDesktop(context))
              Expanded(
                flex: 4,
                child: Container(
                  height: SizeConfig.screenHeight,
                  color: AppColors.secondaryBg,
                  child: SingleChildScrollView(
                    primary: false,
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: const [
                        AppBarActionItem(),
                        Approvals(),
                        // PaymentsDetailList(),
                        // BorrowRequest()
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
