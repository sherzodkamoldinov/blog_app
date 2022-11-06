import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/icon.dart';
import 'package:vlog_app/utils/style.dart';

class CustomAppBarWithDrawer extends StatelessWidget implements PreferredSize {
  const CustomAppBarWithDrawer(
      {super.key, this.title, this.actionIcon, this.onPressed});
  final String? title;
  final IconData? actionIcon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyColors.backgroundColor,
      elevation: 0,
      centerTitle: true,
      title:
          title != null ? Text(title!, style: MyTextStyle.sfProRegular.copyWith(fontSize: 24.sp)) : null,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: MyColors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      leading: Builder(builder: (context) {
        return IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          icon: Image.asset(
            MyIcons.menu,
            color: MyColors.richBlack,
          ),
        );
      }),
      actions: actionIcon != null
          ? [
              IconButton(
                  onPressed: onPressed ?? (){},
                  icon: Icon(
                    actionIcon,
                    color: MyColors.richBlack,
                  ))
            ]
          : null,
    );
    ;
  }

  @override
  Widget get child => throw UnimplementedError();

  @override
  Size get preferredSize => const Size(double.infinity, 56);
}
