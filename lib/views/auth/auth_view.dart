import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/constants.dart';
import 'package:vlog_app/utils/style.dart';
import 'package:vlog_app/views/widgest/custom_botton.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: MyColors.backgroundColor,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: MyColors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Column(
        children: [
          // TITLE OF PAGE
          Expanded(
            child: Column(
              children: [
                Text(
                  "NAJOT TA'LIMDA",
                  style: MyTextStyle.sfProLight.copyWith(fontSize: 48.sp),
                ),
                Text(
                  "DUV - DUV GAP",
                  style: MyTextStyle.sfBold800
                      .copyWith(fontSize: 44.sp, color: MyColors.ntColor),
                )
              ],
            ),
          ),

          // SUBTITLE OF PAGE
          Expanded(
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: "Tell your ",
                  style: MyTextStyle.sfProLight.copyWith(fontSize: 24.sp),
                ),
                TextSpan(
                  text: "story ",
                  style: MyTextStyle.sfProMedium
                      .copyWith(fontSize: 24.sp, color: MyColors.ntColor),
                ),
                TextSpan(
                  text: "with us.",
                  style: MyTextStyle.sfProLight.copyWith(fontSize: 24.sp),
                ),
              ]),
            ),
          ),

          // CUSTOM BUTTONS
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              children: [
                customBotton(
                    onPressed: () {
                      Navigator.pushNamed(context, loginView);
                    },
                    title: "Login",
                    fillColor: false),
                SizedBox(height: 20.h),
                Text(
                  "New here?",
                  style: MyTextStyle.sfProLight.copyWith(fontSize: 18.sp),
                ),
                SizedBox(height: 5.h),
                customBotton(
                    onPressed: () {
                      Navigator.pushNamed(context, registerView);
                    },
                    title: "Register",
                    fillColor: true)
              ],
            ),
          )),
        ],
      ),
    );
  }
}
