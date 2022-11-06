import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlog_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/icon.dart';
import 'package:vlog_app/utils/style.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                decoration: const BoxDecoration(color: MyColors.richBlack),
                accountName: Text(
                  "${state.user.firstName} ${state.user.lastName}",
                  style: MyTextStyle.sfProRegular
                      .copyWith(fontSize: 28.sp, color: MyColors.white),
                ),
                accountEmail: Text(
                  "@${state.user.userName}",
                  style: MyTextStyle.sfProRegular.copyWith(
                      fontSize: 20.sp,
                      color: MyColors.white,
                      fontStyle: FontStyle.italic),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: MyColors.white,
                  child: Image.asset(
                    MyIcons.person,
                    scale: 9,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: MyColors.backgroundColor,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      
                      ListTile(
                        leading: Icon(
                          Icons.add_box,
                          size: 32.sp,
                          color: MyColors.richBlack,
                        ),
                        title: Text(
                          'Add new post',
                          style: MyTextStyle.sfProRegular
                              .copyWith(fontSize: 24.sp),
                        ),
                        onTap: () {
                          debugPrint(state.user.toString());
                          Navigator.pop(context);
                        },
                      ),
                      
                      ListTile(
                        leading: Icon(
                          Icons.settings,
                          size: 32.sp,
                          color: MyColors.richBlack,
                        ),
                        title: Text(
                          'Settings',
                          style: MyTextStyle.sfProRegular
                              .copyWith(fontSize: 24.sp),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      
                      ListTile(
                        leading: Icon(
                          Icons.logout_outlined,
                          size: 32.sp,
                          color: MyColors.richBlack,
                        ),
                        title: Text(
                          'Log Out',
                          style: MyTextStyle.sfProRegular
                              .copyWith(fontSize: 24.sp),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
