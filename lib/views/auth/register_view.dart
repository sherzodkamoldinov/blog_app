import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:vlog_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:vlog_app/data/models/user/user_model.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/constants.dart';
import 'package:vlog_app/utils/my_utils.dart';
import 'package:vlog_app/utils/style.dart';
import 'package:vlog_app/views/widgest/custom_appbar.dart';
import 'package:vlog_app/views/widgest/custom_botton.dart';
import 'package:vlog_app/views/widgest/custom_text_field.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _userNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  late FocusNode _firstNameFocusNode;
  late FocusNode _lastNameFocusNode;
  late FocusNode _userNameFocusNode;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  late FocusNode _confirmPasswordFocusNode;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _userNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _firstNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    _userNameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.formzStatus.isSubmissionFailure) {
          MyUtils.showSnackBar(context, state.errorText);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: MyColors.backgroundColor,
          appBar: CustomAppBar(title: tr('register')),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    // TITLE
                    Text(
                      tr('register_title'),
                      style: MyTextStyle.sfProRegular.copyWith(fontSize: 32.sp),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(height: 5.h),

                    // FIELDS
                    CustomTextField(
                      type: 'text',
                      controller: _firstNameController,
                      isPassword: false,
                      text: "Enter your First Name",
                      focusNode: _firstNameFocusNode,
                      nextFocusNode: _lastNameFocusNode,
                    ),
                    SizedBox(height: 15.h),

                    SizedBox(height: 5.h),
                    CustomTextField(
                      type: 'text',
                      controller: _lastNameController,
                      isPassword: false,
                      text: "Enter your Last Name",
                      focusNode: _lastNameFocusNode,
                      nextFocusNode: _userNameFocusNode,
                    ),
                    SizedBox(height: 15.h),

                    SizedBox(height: 5.h),
                    CustomTextField(
                      type: 'text',
                      controller: _userNameController,
                      isPassword: false,
                      text: tr('enter_your_username'),
                      focusNode: _userNameFocusNode,
                      nextFocusNode: _emailFocusNode,
                    ),

                    SizedBox(height: 15.h),
                    CustomTextField(
                      type: 'email',
                      controller: _emailController,
                      isPassword: false,
                      text: tr('enter_your_email'),
                      focusNode: _emailFocusNode,
                      nextFocusNode: _passwordFocusNode,
                    ),

                    SizedBox(height: 15.h),
                    CustomTextField(
                      type: 'password',
                      controller: _passwordController,
                      isPassword: true,
                      text: tr('enter_your_password'),
                      focusNode: _passwordFocusNode,
                      nextFocusNode: _confirmPasswordFocusNode,
                    ),

                    SizedBox(height: 15.h),
                    CustomTextField(
                      type: 'confirm',
                      isEnd: true,
                      controller: _confirmPasswordController,
                      confirm: _passwordController,
                      isPassword: true,
                      text: tr('confirm_password'),
                      focusNode: _confirmPasswordFocusNode,
                      nextFocusNode: _confirmPasswordFocusNode,
                    ),

                    SizedBox(height: 35.h),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return customBotton(
                          onPressed: () async {
                            final isValidForm =
                                formKey.currentState!.validate();
                            if (isValidForm) {
                              await context.read<AuthCubit>().registerUser(
                                    userModel: UserModel(
                                      id: -1,
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                      userName: _userNameController.text,
                                      email: _emailController.text,
                                      imageUrl: '',
                                      password: _passwordController.text,
                                    ),
                                  );

                              Navigator.pushNamed(context, verifyCodeView,
                                  arguments: loginView);
                            } else {
                              MyUtils.showSnackBar(
                                  context, tr('please_fill_right'));
                            }
                          },
                          title: state.formzStatus.isSubmissionInProgress
                              ? null
                              : tr('register'),
                          fillColor: true,
                        );
                      },
                    ),
                    SizedBox(height: 18.h),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, loginView);
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: tr('have_an_account'),
                              style: MyTextStyle.sfProRegular,
                            ),
                            TextSpan(
                              text: tr('sign_in'),
                              style: MyTextStyle.sfProSemibold,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
