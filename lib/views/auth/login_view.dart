import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:lottie/lottie.dart';
import 'package:vlog_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/constants.dart';
import 'package:vlog_app/utils/icon.dart';
import 'package:vlog_app/utils/my_utils.dart';
import 'package:vlog_app/utils/style.dart';
import 'package:vlog_app/views/widgest/custom_appbar.dart';
import 'package:vlog_app/views/widgest/custom_botton.dart';
import 'package:vlog_app/views/widgest/custom_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
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
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.formzStatus.isSubmissionFailure) {
          MyUtils.showSnackBar(context, state.errorText);
        }
      },
      child: Scaffold(
        backgroundColor: MyColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: MyColors.backgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Login",
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
                Navigator.pushReplacementNamed(context, authView);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: MyColors.richBlack,
              )),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LOTTIE
              Align(
                alignment: Alignment.center,
                child: Lottie.asset(MyIcons.login, height: 370.h),
              ),

              // FIELDS
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // EMAIL FIELD
                    Text("  Email",
                        style:
                            MyTextStyle.sfProRegular.copyWith(fontSize: 20.sp)),
                    SizedBox(height: 5.h),
                    CustomTextField(
                      type: "email",
                      controller: _emailController,
                      isPassword: false,
                      text: "Enter your email",
                      focusNode: _emailFocusNode,
                      nextFocusNode: _passwordFocusNode,
                    ),

                    // PASSWORD FIELD
                    SizedBox(height: 20.h),
                    Text("  Password",
                        style:
                            MyTextStyle.sfProRegular.copyWith(fontSize: 20.sp)),
                    SizedBox(height: 5.h),
                    CustomTextField(
                      type: "password",
                      isEnd: true,
                      controller: _passwordController,
                      isPassword: true,
                      text: "Password",
                      focusNode: _passwordFocusNode,
                      nextFocusNode: _passwordFocusNode,
                    ),
                  ],
                ),
              ),

              // RESET PASSWORD
              SizedBox(height: 35.h),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, resetPasswordView);
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Forgot ",
                          style: MyTextStyle.sfProRegular,
                        ),
                        TextSpan(
                          text: "Password?",
                          style: MyTextStyle.sfProSemibold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // SIGNIN BUTTON
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return customBotton(
                    onPressed: () async {
                      var isValid = formKey.currentState!.validate();
                      if (isValid) {
                        await context.read<AuthCubit>().login(
                            email: _emailController.text,
                            password: _passwordController.text);

                        Navigator.pushNamed(context, homeView);
                      } else {
                        MyUtils.showSnackBar(context, "Please fill currently");
                      }
                    },
                    title: state.formzStatus.isSubmissionInProgress
                        ? null
                        : 'Sign In',
                    fillColor: true,
                  );
                },
              ),
              SizedBox(height: 18.h),

              // NAVIGATE TO REGISTER BUTTON
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, registerView);
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account? ",
                          style: MyTextStyle.sfProRegular,
                        ),
                        TextSpan(
                          text: "Register Now ",
                          style: MyTextStyle.sfProSemibold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
