import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/style.dart';

void showLanguageDialog(
    BuildContext context, String activeLanguage, ValueChanged changed) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: SizedBox(
            height: 300.h,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  minLeadingWidth: 3.w,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  tileColor: activeLanguage == 'en_EN'
                      ? MyColors.lightCyan
                      : MyColors.ntColor,
                  title: Text(
                    tr('eng'),
                    style: MyTextStyle.sfProRegular,
                  ),
                  leading: Text(
                    '🇬🇧',
                    style: TextStyle(fontSize: 24.sp),
                  ),
                  onTap: () {
                    Navigator.pop(_);
                    if (activeLanguage != "en_EN") {
                      changed.call(<String>['en', 'EN']);
                    }
                    
                  },
                ),
                SizedBox(height: 10.h),
                ListTile(
                  minLeadingWidth: 3.w,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  tileColor: activeLanguage == 'ru_RU'
                      ? MyColors.lightCyan
                      : MyColors.ntColor,
                  title: Text(tr('rus'), style: MyTextStyle.sfProRegular),
                  leading: Text(
                    '🇷🇺',
                    style: TextStyle(fontSize: 24.sp),
                  ),
                  onTap: () {
                    if (activeLanguage != "ru_RU") {
                      changed.call(<String>['ru', 'RU']);
                    }
                    Navigator.pop(_);
                  },
                ),
                SizedBox(height: 10.h),
                ListTile(
                  minLeadingWidth: 3.w,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  tileColor: activeLanguage == 'uz_UZ'
                      ? MyColors.lightCyan
                      : MyColors.ntColor,
                  title: Text(tr('uz'), style: MyTextStyle.sfProRegular),
                  leading: Text(
                    '🇺🇿',
                    style: TextStyle(fontSize: 24.sp),
                  ),
                  onTap: () {
                    if (activeLanguage != "uz_UZ") {
                      changed.call(<String>['uz', 'UZ']);
                    }
                    Navigator.pop(_);
                  },
                ),
              ],
            ),
          ),
        );
      });
}
