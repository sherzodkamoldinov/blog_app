import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlog_app/utils/style.dart';

void showAskDialog(BuildContext context, String text, VoidCallback onPressed) {
  showDialog(
    context: context,
    builder: (_) => SizedBox(
      height: 60,
      width: double.infinity,
      child: AlertDialog(
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: onPressed,
                child: Text(tr('yes')),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(_);
                },
                child: Text(tr('no')),
              ),
            ],
          )
        ],
        scrollable: true,
        content: Column(  
          children: [
            Text(text, style: MyTextStyle.sfProRegular.copyWith(fontSize: 20.sp),textAlign: TextAlign.center,),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ),
  );
}
