import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:vlog_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/constants.dart';
import 'package:vlog_app/utils/style.dart';
import 'package:vlog_app/views/widgest/custom_appbar.dart';
import 'package:vlog_app/views/widgest/custom_botton.dart';
import 'package:vlog_app/views/widgest/custom_text_field.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPassworViewState();
}

class _ResetPassworViewState extends State<ResetPasswordView> {
  late TextEditingController _emailController;
  late FocusNode _focusNode;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) => Scaffold(
        backgroundColor: MyColors.backgroundColor,
        appBar: const CustomAppBar(title: "Reset password"),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                "Enter the email associated with your account and we'll send a code to reset your password",
                style: MyTextStyle.sfProRegular.copyWith(fontSize: 24.sp),
              ),
              SizedBox(height: 40.h),
              Text(
                "  Email Address",
                style: MyTextStyle.sfProRegular.copyWith(fontSize: 24.sp),
              ),
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: CustomTextField(
                  isEnd: true,
                  controller: _emailController,
                  isPassword: false,
                  text: 'example@mail.com',
                  focusNode: _focusNode,
                  nextFocusNode: _focusNode,
                  type: 'email',
                ),
              ),
              const Expanded(child: SizedBox()),
              customBotton(
                onPressed: () async {
                  var isValidate = formKey.currentState!.validate();
                  if (isValidate) {
                    context.read<AuthCubit>().changeUser(
                          user:
                              state.user.copyWith(email: _emailController.text),
                        );
                    Navigator.pushNamed(context, verifyCodeView,
                        arguments: createNewPasswordView);
                  }
                },
                title: state.formzStatus.isSubmissionInProgress ? null : 'SEND',
                fillColor: true,
              ),
              SizedBox(height: 25.h),
            ],
          ),
        ),
      ),
    );
  }
}
