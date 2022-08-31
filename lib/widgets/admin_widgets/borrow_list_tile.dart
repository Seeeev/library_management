import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:library_management/style/colors.dart';
import 'package:library_management/style/style.dart';

class ApprovalListTile extends StatelessWidget {
  final IconData? icon;
  final String? borrower;
  final String? bookId;

  const ApprovalListTile({
    Key? key,
    required this.icon,
    required this.borrower,
    required this.bookId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return ListTile(
    //   contentPadding: const EdgeInsets.only(left: 0, right: 20),
    //   visualDensity: VisualDensity.standard,
    //   leading: Container(
    //     padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    //     width: 50,
    //     decoration: BoxDecoration(
    //       color: AppColors.white,
    //       borderRadius: BorderRadius.circular(20),
    //     ),
    //     child: Icon(icon!),
    //   ),
    //   title: PrimaryText(
    //     text: borrower!,
    //     size: 14.0,
    //     fontWeight: FontWeight.w500,
    //   ),
    //   subtitle: PrimaryText(
    //     text: bookId!,
    //     size: 12,
    //     color: AppColors.secondary,
    //   ),
    // );

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon!),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: borrower!,
                  size: 14.0,
                  fontWeight: FontWeight.bold,
                ),
                PrimaryText(
                  text: bookId!,
                  size: 12.0,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Material(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  child: Container(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
              Material(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: Container(
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    width: 30,
                    height: 30,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
