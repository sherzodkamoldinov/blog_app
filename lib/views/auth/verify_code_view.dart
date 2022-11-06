import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:pinput/pinput.dart';
import 'package:vlog_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/my_utils.dart';
import 'package:vlog_app/utils/style.dart';
import 'package:vlog_app/views/widgest/custom_appbar.dart';
import 'package:vlog_app/views/widgest/custom_botton.dart';

class VerifyCodeView extends StatefulWidget {
  const VerifyCodeView({super.key, required this.navigateView});

  final String navigateView;

  @override
  State<VerifyCodeView> createState() => _VerifyViewState();
}

class _VerifyViewState extends State<VerifyCodeView> {
  late TextEditingController _pinPutController;
  late FocusNode _pinPutFocusNode;

  Timer? countdownTimer;
  Duration myDuration = const Duration(minutes: 4);

  _init() async {
    await context.read<AuthCubit>().sendCodeToEmail(
          email: context.read<AuthCubit>().state.user.email,
        );
    context.read<AuthCubit>().state.formzStatus.isSubmissionSuccess
        ? startTimer()
        : null;
  }

  @override
  void initState() {
    super.initState();
    _init();
    _pinPutController = TextEditingController();
    _pinPutFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _pinPutController.dispose();
    _pinPutFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: MyTextStyle.sfProRegular.copyWith(
        fontSize: 22,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(222, 231, 240, .57),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );
    const borderColor = Color.fromRGBO(114, 178, 238, 1);
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    const fillColor = Color.fromRGBO(222, 231, 240, .57);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.formzStatus == FormzStatus.submissionFailure) {
          MyUtils.showSnackBar(context, state.errorText);
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: MyColors.backgroundColor,
          appBar: const CustomAppBar(title: "Verify Register"),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                // TITLE
                SizedBox(height: 30.h),
                Text("Enter verification code",
                    style: MyTextStyle.sfProRegular.copyWith(fontSize: 32.sp)),
                Text(
                  "Please enter the verication code sent to email ${state.user.email}",
                  style: MyTextStyle.sfProRegular.copyWith(fontSize: 20.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 35.h),

                // PINPUT
                Pinput(
                  length: 4,
                  controller: _pinPutController,
                  focusNode: _pinPutFocusNode,
                  defaultPinTheme: defaultPinTheme,
                  onCompleted: (pin) {},
                  focusedPinTheme: defaultPinTheme.copyWith(
                    height: 68,
                    width: 64,
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: borderColor),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyWith(
                    decoration: BoxDecoration(
                      color: errorColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 45.h),

                // TIMER
                Visibility(
                  visible: !state.formzStatus.isSubmissionInProgress,
                  child: Text(
                    '$minutes : $seconds',
                    style: MyTextStyle.sfProMedium.copyWith(
                        fontSize: 45.sp, color: MyColors.ntGradient[0]),
                  ),
                ),

                const Expanded(flex: 1, child: SizedBox()),

                // RESEND CODE BUTTON
                InkWell(
                  onTap: () async {
                    _pinPutController.clear();
                    resetTimer();
                    await context.read<AuthCubit>().sendCodeToEmail(
                          email: state.user.email,
                        );
                    state.formzStatus.isSubmissionSuccess ? startTimer() : null;
                  },
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Didn't get the code? ",
                          style: MyTextStyle.sfProRegular
                              .copyWith(fontSize: 23.sp)),
                      TextSpan(
                          text: "Resend",
                          style: MyTextStyle.sfProSemibold
                              .copyWith(fontSize: 23.sp)),
                    ]),
                  ),
                ),
                SizedBox(height: 30.h),

                // TRY ANTORHER EMAIL
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Or Try Another Email Address",
                    style: MyTextStyle.sfProSemibold
                        .copyWith(fontSize: 20.sp, color: MyColors.ntColor),
                  ),
                ),

                const Expanded(flex: 4, child: SizedBox()),

                // SEND CODE BUTTON
                customBotton(
                  onPressed: () async {
                    if (_pinPutController.text.length == 4) {
                      await context.read<AuthCubit>().verifyEmail(
                            code: int.parse(_pinPutController.text),
                          );
                      Navigator.pushReplacementNamed(
                        context,
                        widget.navigateView,
                      );
                    } else {
                      MyUtils.showSnackBar(context, "Please enter code!");
                    }
                  },
                  title:
                      state.formzStatus.isSubmissionInProgress ? null : "NEXT",
                  fillColor: true,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void resetTimer() {
    stopTimer();
    setState(() => myDuration = const Duration(minutes: 4));
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(
      () {
        final seconds = myDuration.inSeconds - reduceSecondsBy;
        if (seconds < 0) {
          countdownTimer!.cancel();
        } else {
          myDuration = Duration(seconds: seconds);
        }
      },
    );
  }
}
