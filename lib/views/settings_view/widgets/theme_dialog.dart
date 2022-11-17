import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/style.dart';

List<Color> color = [MyColors.white, MyColors.black];

void showThemeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        content: SizedBox(
          height: 200.h,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                color.length,
                (index) {
                  return getItem(index);
                },
              )
            ],
          ),
        ),
      );
    },
  );
}

Widget getItem(int index) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10.h),
    child: ListTile(
      minLeadingWidth: 3.w,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      tileColor: index == 0 ? MyColors.lightCyan : MyColors.ntColor,
      title: Text(index == 0 ? tr('bright_mode') : tr('dark_mode'),
          style: MyTextStyle.sfProRegular),
      leading: ClipOval(
        child: Container(
          width: 50.w,
          height: 50.w,
          color: color[index],
        ),
      ),
      onTap: () {},
    ),
  );
}
