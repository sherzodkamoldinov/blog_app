import 'package:vlog_app/views/auth/auth_view.dart';
import 'package:vlog_app/views/auth/login_view.dart';
import 'package:vlog_app/views/auth/register_view.dart';
import 'package:vlog_app/views/auth/reset_password/create_new_password_view.dart';
import 'package:vlog_app/views/auth/reset_password/reset_password.dart';
import 'package:vlog_app/views/auth/verify_code_view.dart';
import 'package:vlog_app/views/bottom_bar/bottom_bar_view.dart';
import 'package:vlog_app/views/bottom_bar/main_view/main_view.dart';
import 'package:vlog_app/views/bottom_bar/my_blogs_view/add_blog/add_blog_view.dart';
import 'package:vlog_app/views/read_more_view/read_more_view.dart';
import 'package:vlog_app/views/splash/splash_page.dart';
import 'package:vlog_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:vlog_app/views/test_view.dart';

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case testView:
        return _navigateTo(view: const TestView());
      case splashView:
        return _navigateTo(view: const SplashPage());
        // MaterialPageRoute(builder: (_) => const SplashPage());
      case authView:
        return MaterialPageRoute(builder: (_) => const AuthView());
      case loginView:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case registerView:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case verifyCodeView:
        return MaterialPageRoute(
            builder: (_) => VerifyCodeView(
                  navigateView: settings.arguments as String,
                ));
      case resetPasswordView:
        return MaterialPageRoute(builder: (_) => const ResetPasswordView());
      case createNewPasswordView:
        return MaterialPageRoute(builder: (_) => const CreateNewPasswordView());
      case homeView:
        return MaterialPageRoute(builder: (_) => const BottomBarView());
      case mainView:
        return MaterialPageRoute(builder: (_) => const MainView());
      case addBlogView:
        return MaterialPageRoute(builder: (_) => const AddBlog());
      case readMoreView:
        var a = settings.arguments as List;
        return MaterialPageRoute(
          builder: (_) => ReadMoreView(
            text: a[0],
            title: a[1],
            userImageUrl: a[2],
            userName: a[3],
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}

MaterialPageRoute _navigateTo({required Widget view}) {
  return MaterialPageRoute(builder: (_) => view);
}
