import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:vlog_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/constants.dart';
import 'package:vlog_app/utils/my_utils.dart';
import 'package:vlog_app/utils/style.dart';
import 'package:vlog_app/views/widgest/custom_appbar.dart';
import 'package:vlog_app/views/widgest/custom_botton.dart';
import 'package:vlog_app/views/widgest/custom_text_field.dart';

class CreateNewPasswordView extends StatefulWidget {
  const CreateNewPasswordView({super.key});

  @override
  State<CreateNewPasswordView> createState() => _CreateNewPasswordViewState();
}

class _CreateNewPasswordViewState extends State<CreateNewPasswordView> {
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  late FocusNode _passwordFocusNode;
  late FocusNode _confirmPasswordFocusNode;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.backgroundColor,
      appBar: const CustomAppBar(title: 'Create New Password'),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.formzStatus.isSubmissionFailure) {
            MyUtils.showSnackBar(context, state.errorText);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 30.h),

                  // TITLE
                  Text(
                    "Your new Password must be different from previous used passwords.",
                    style: MyTextStyle.sfProRegular.copyWith(fontSize: 24.sp),
                  ),
                  SizedBox(height: 30.h),

                  // FIELDS
                  // PASSWORD FIELD
                  Text(
                    "  Password",
                    style: MyTextStyle.sfProRegular.copyWith(fontSize: 24.sp),
                  ),
                  SizedBox(height: 7.h),
                  CustomTextField(
                    controller: _passwordController,
                    isPassword: true,
                    text: 'Enter new Password',
                    focusNode: _passwordFocusNode,
                    nextFocusNode: _confirmPasswordFocusNode,
                    type: 'password',
                  ),
                  SizedBox(height: 30.h),

                  // CONFIRM FIELD
                  Text(
                    "  Confirm Password",
                    style: MyTextStyle.sfProRegular.copyWith(fontSize: 24.sp),
                  ),
                  SizedBox(height: 7.h),
                  CustomTextField(
                    isEnd: true,
                    confirm: _passwordController,
                    controller: _confirmPasswordController,
                    isPassword: true,
                    text: 'Enter confirm Password',
                    focusNode: _confirmPasswordFocusNode,
                    nextFocusNode: _confirmPasswordFocusNode,
                    type: 'confirm',
                  ),
                  const Expanded(child: SizedBox()),

                  // SEND NEW PASSWORD
                  customBotton(
                    onPressed: () async {
                      var isValid = formKey.currentState!.validate();
                      if (isValid) {
                        await context
                            .read<AuthCubit>()
                            .resetPassword(password: _passwordController.text);
                        Navigator.pushNamedAndRemoveUntil(
                            context, loginView, (route) => false);
                      } else {
                        MyUtils.showSnackBar(context, 'Fill currently!');
                      }
                    },
                    title: state.formzStatus.isSubmissionInProgress
                        ? null
                        : "Reset Password",
                    fillColor: true,
                  ),
                  SizedBox(height: 25.h),
                  
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
