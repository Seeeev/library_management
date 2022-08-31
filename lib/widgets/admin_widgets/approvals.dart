import 'package:flutter/material.dart';
import 'package:library_management/config/size_config.dart';
import 'package:library_management/style/colors.dart';
import 'package:library_management/style/style.dart';
import 'package:library_management/widgets/admin_widgets/borrow_list_tile.dart';

class Approvals extends StatelessWidget {
  const Approvals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: SizeConfig.blockSizeVertical! * 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PrimaryText(
              text: 'Borrow Approvals',
              size: 18,
              fontWeight: FontWeight.w800,
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 2,
            ),
            Column(
              children: const [
                ApprovalListTile(
                    icon: Icons.person, borrower: 'Person 1', bookId: '1233'),
                ApprovalListTile(
                    icon: Icons.person, borrower: 'Person 2', bookId: '1233'),
              ],
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical! * 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PrimaryText(
              text: 'Return Approvals',
              size: 18,
              fontWeight: FontWeight.w800,
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 2,
            ),
            Column(
              children: const [
                ApprovalListTile(
                    icon: Icons.person, borrower: 'Person 1', bookId: '1233'),
                ApprovalListTile(
                    icon: Icons.person, borrower: 'Person 2', bookId: '1233'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
