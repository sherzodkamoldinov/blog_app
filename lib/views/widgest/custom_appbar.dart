import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSize {
  const CustomAppBar({Key? key, required this.title})
      : super(key: key);

  final String title;


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyColors.backgroundColor,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: MyTextStyle.sfProSemibold
            .copyWith(fontSize: 20, color: MyColors.richBlack),
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: MyColors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: MyColors.richBlack,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 56);

  @override
  Widget get child => throw UnimplementedError();
}
