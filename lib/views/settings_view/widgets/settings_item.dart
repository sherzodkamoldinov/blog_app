import 'package:flutter/material.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsItem extends StatelessWidget {
  const SettingsItem({super.key, required this.title, required this.icon, required this.onTap});
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
      leading: Icon(
        icon,
        color: MyColors.ntColor,
      ),
      title: Text(title),
      tileColor: MyColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      onTap: onTap,
    );
  }
}
