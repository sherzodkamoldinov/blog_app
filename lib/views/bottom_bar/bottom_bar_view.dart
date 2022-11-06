import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlog_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:vlog_app/cubits/users_cubit/users_cubit.dart';
import 'package:vlog_app/data/models/user/user_model.dart';
import 'package:vlog_app/data/services/local/storage_service.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/views/bottom_bar/favorites/favorite_view.dart';
import 'package:vlog_app/views/bottom_bar/main_view/main_view.dart';
import 'package:vlog_app/views/bottom_bar/my_blogs_view/my_blogs_view.dart';
import 'package:vlog_app/views/bottom_bar/profile/profile_view.dart';

class BottomBarView extends StatefulWidget {
  const BottomBarView({super.key});

  @override
  State<BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> {
  int _current_screen = 0;

  List<Widget> screens = [
    const MainView(),
    const FavoritesView(),
    const MyBlogsView(),
    const ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    UserModel user =
        await BlocProvider.of<UsersCubit>(context).getCurrentUser();
        await BlocProvider.of<UsersCubit>(context).getAllUser();
    BlocProvider.of<AuthCubit>(context).changeUser(user: user);
    debugPrint(user.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: MyColors.backgroundColor,
      body: screens[_current_screen],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: CustomNavigationBar(
          elevation: 5,
          borderRadius: Radius.circular(16.r),
          iconSize: 30.0.sp,
          selectedColor: MyColors.richBlack,
          unSelectedColor: MyColors.grey,
          backgroundColor: MyColors.white,
          strokeColor: MyColors.ntColor,
          currentIndex: _current_screen,
          onTap: (v) {
            setState(() {
              _current_screen = v;
            });
          },
          items: [
            CustomNavigationBarItem(
              icon: const Icon(Icons.home),
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.favorite),
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.lightbulb_outline),
            ),
            CustomNavigationBarItem(
              icon: const Icon(CupertinoIcons.person_alt),
            ),
          ],
          isFloating: true,
        ),
      ),
    );
  }
}
