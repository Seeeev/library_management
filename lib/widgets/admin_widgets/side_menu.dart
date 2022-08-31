import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_management/config/responsive.dart';
import 'package:library_management/config/size_config.dart';
import 'package:library_management/style/colors.dart';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  final List<GlobalKey>? dataKeys;
  const SideMenu({
    Key? key,
    required this.dataKeys,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    //   if (user == null) {
    //     print('User is currently signed out!');
    //   } else {
    //     print('User is signed in!');
    //   }
    // });

    return Drawer(
      elevation: 2,
      child: Container(
        height: SizeConfig.screenHeight,
        color: AppColors.secondaryBg,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Responsive.isDesktop(context)
                  ? Container(
                      height: 100,
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: 35,
                        width: 35,
                        child: SvgPicture.asset('assets/mac-action.svg'),
                      ),
                    )
                  : const SizedBox(
                      height: 50,
                    ),
              iconBuilder(
                  iconData: Icons.table_chart_outlined,
                  toolTipMessage: 'Inventory',
                  dataKey: dataKeys![0]),
              iconBuilder(
                  iconData: Icons.add,
                  dataKey: dataKeys![1],
                  toolTipMessage: 'Add book'),
              iconBuilder(
                  iconData: Icons.system_update_alt,
                  dataKey: dataKeys![2],
                  toolTipMessage: 'Update book'),
              iconBuilder(
                  iconData: Icons.delete,
                  dataKey: dataKeys![3],
                  toolTipMessage: 'Delete book'),

              // iconBuilder(assetName: 'assets/pie-chart.svg', dataKey: dataKey!),
              // iconBuilder(assetName: 'assets/clipboard.svg', dataKey: dataKey!),
              // iconBuilder(
              //     assetName: 'assets/credit-card.svg', dataKey: dataKey!),
              // iconBuilder(assetName: 'assets/trophy.svg', dataKey: dataKey!),
              // iconBuilder(assetName: 'assets/invoice.svg', dataKey: dataKey!),
            ],
          ),
        ),
      ),
    );
  }
}

authenticate() async {
  print('executed');
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'admin@gmail.com', password: '00000000');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}

Widget iconBuilder({
  required IconData iconData,
  required GlobalKey dataKey,
  required String toolTipMessage,
}) {
  // DashboardController controller = Get.find<DashboardController>();

  return Tooltip(
    message: toolTipMessage,
    child: IconButton(
      onPressed: () {
        // authenticate();
        Scrollable.ensureVisible(dataKey.currentContext!);
        // print(basename(File(assetName).path).split('.')[0]);
        // controller.switchPage(basename(File(assetName).path).split('.')[0]);
      },
      hoverColor: Colors.grey,
      icon: Icon(iconData),
      iconSize: 20,
      padding: const EdgeInsets.symmetric(vertical: 20.0),
    ),
  );
}
