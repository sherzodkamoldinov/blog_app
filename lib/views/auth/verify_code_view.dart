import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:pinput/pinput.dart';
import 'package:vlog_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/constants.dart';
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
  bool showError = false;

  _init() async {
    await BlocProvider.of<AuthCubit>(context).sendCodeToEmail(
        email: BlocProvider.of<AuthCubit>(context).state.user.email);
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

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.formzStatus == FormzStatus.submissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorText)));
        }
      },
      child: Scaffold(
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
                  "Please enter the verication code sent to email ${context.read<AuthCubit>().state.user.email}",
                  style: MyTextStyle.sfProRegular.copyWith(fontSize: 18.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 35.h),

                // PINPUT
                Pinput(
                  length: 4,
                  controller: _pinPutController,
                  focusNode: _pinPutFocusNode,
                  defaultPinTheme: defaultPinTheme,
                  onCompleted: (pin) {
                    setState(() => showError = pin != '5555');
                  },
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
                SizedBox(height: 25.h),

                // RESEND CODE BUTTON
                InkWell(
                  onTap: () {},
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Didn't get the code? ",
                          style: MyTextStyle.sfProRegular
                              .copyWith(fontSize: 20.sp)),
                      TextSpan(
                          text: "Resend",
                          style: MyTextStyle.sfProSemibold
                              .copyWith(fontSize: 20.sp)),
                    ]),
                  ),
                ),
                SizedBox(height: 15.h),

                // TRY ANTORHER EMAIL
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text("Or Try Another Email Address",
                      style: MyTextStyle.sfProSemibold
                          .copyWith(fontSize: 20.sp, color: MyColors.ntColor)),
                ),
                const Expanded(child: SizedBox()),

                // TODO:TEST
                Text("$showError and ${_pinPutController.text}"),
                const Expanded(child: SizedBox()),

                // SEND CODE BUTTON
                customBotton(
                    onPressed: () async {
                      if (_pinPutController.text.length == 4) {
                        try{
                          await context.read<AuthCubit>().verifyEmail(
                              code: int.parse(_pinPutController.text),
                            );
                        debugPrint(context.read<AuthCubit>().state.formzStatus.toString());
                        Navigator.pushReplacementNamed(context, widget.navigateView);
                        }catch (e){
                          MyUtils.showSnackBar(context, "Wrong code");
                        }
                      } else {
                        MyUtils.showSnackBar(context, "Please enter code!");
                      }
                    },
                    title: "NEXT",
                    fillColor: true),
                SizedBox(height: 20.h),
              ],
            ),
          )),
    );
  }
}
