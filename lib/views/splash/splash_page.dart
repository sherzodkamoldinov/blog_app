import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vlog_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:vlog_app/cubits/users_cubit/users_cubit.dart';
import 'package:vlog_app/data/services/local/storage_service.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/constants.dart';
import 'package:vlog_app/utils/icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.black,
      body: Center(
        child: Image.asset(
          MyIcons.logo,
          width: 250,
          height: 250,
        ),
      ),
    );
  }

  Future<void> _init() async {
    await Future.delayed(
      const Duration(seconds: 1),
      () {
        String? token = StorageService.instance.storage.read('token');
        if (token == null) {
          Navigator.pushReplacementNamed(context, authView);
        } else {
          debugPrint(
              "$token and ${StorageService.instance.storage.read('id')}");
          Navigator.pushReplacementNamed(context, homeView);
        }
      },
    );
  }
}
