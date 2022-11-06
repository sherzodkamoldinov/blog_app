import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:lottie/lottie.dart';
import 'package:vlog_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:vlog_app/data/models/user/user_model.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/constants.dart';
import 'package:vlog_app/utils/icon.dart';
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
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: MyColors.backgroundColor,
          appBar: const CustomAppBar(title: "Register"),
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
                      "Hello user, you have a greatful journey!",
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
                      text: "Enter your User Name",
                      focusNode: _userNameFocusNode,
                      nextFocusNode: _emailFocusNode,
                    ),

                    SizedBox(height: 15.h),
                    CustomTextField(
                      type: 'email',
                      controller: _emailController,
                      isPassword: false,
                      text: "Enter your Email",
                      focusNode: _emailFocusNode,
                      nextFocusNode: _passwordFocusNode,
                    ),

                    SizedBox(height: 15.h),
                    CustomTextField(
                      type: 'password',
                      controller: _passwordController,
                      isPassword: true,
                      text: "Password",
                      focusNode: _passwordFocusNode,
                      nextFocusNode: _confirmPasswordFocusNode,
                    ),

                    SizedBox(height: 15.h),
                    CustomTextField(
                      type: 'password',
                      isEnd: true,
                      controller: _confirmPasswordController,
                      isPassword: true,
                      text: "Confirm Password",
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
                              if (_confirmPasswordController.text ==
                                  _passwordController.text) {
                                var isNotExist = await context.read<AuthCubit>().registerUser(
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
                                   
                                if (isNotExist) {
                                  Navigator.pushNamed(context, verifyCodeView,
                                      arguments: loginView);
                                } else if (!isNotExist) {
                                  MyUtils.showSnackBar(context,
                                      'Such a User exists, please login');
                                }
                              } else {
                                MyUtils.showSnackBar(
                                    context, "Passwords should be equel");
                              }
                            } else {
                              MyUtils.showSnackBar(context, "Field Currently");
                            }
                          },
                          title: state.formzStatus.isSubmissionInProgress
                              ? null
                              : "Register",
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
                              text: "Already have an accaount? ",
                              style: MyTextStyle.sfProRegular,
                            ),
                            TextSpan(
                              text: "Login",
                              style: MyTextStyle.sfProSemibold,
                            ),
                          ],
                        ),
                      ),
                    ),
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
