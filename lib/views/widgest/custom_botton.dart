import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/style.dart';

Widget customBotton( 
        {required VoidCallback onPressed,
        required String? title,
        required bool fillColor,}) =>
    SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            elevation: 0.0,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            backgroundColor:
                fillColor ? MyColors.richBlack : MyColors.backgroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            side: fillColor ? BorderSide.none : BorderSide()),
        child: title != null ? Text(
          title,
          style: MyTextStyle.sfProLight.copyWith(
            color: fillColor ? MyColors.white : MyColors.richBlack,
            fontSize: 34.sp,
          ),
        ): const Center(child: CircularProgressIndicator(color: MyColors.white,),),
      ),
    );
