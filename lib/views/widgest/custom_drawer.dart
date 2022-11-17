import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vlog_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:vlog_app/cubits/users_cubit/users_cubit.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/constants.dart';
import 'package:vlog_app/utils/icon.dart';
import 'package:vlog_app/utils/style.dart';
import 'package:vlog_app/views/widgest/ask_dialog.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        return Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                decoration: const BoxDecoration(color: MyColors.richBlack),
                accountName: Text(
                  "@${state.user.userName}",
                  style: MyTextStyle.sfProRegular
                      .copyWith(fontSize: 28.sp, color: MyColors.white),
                ),
                accountEmail: Text(
                  state.user.email,
                  style: MyTextStyle.sfProRegular.copyWith(
                      fontSize: 20.sp,
                      color: MyColors.white,
                      fontStyle: FontStyle.italic),
                ),
                currentAccountPicture: ClipOval(
                  child: CachedNetworkImage(
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl:
                        'https://blogappuz.herokuapp.com/${state.user.imageUrl}',
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      enabled: true,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      MyIcons.users[4],
                    ),
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
                          Navigator.pushNamed(context, settingsView);
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
                          showAskDialog(context, tr('log_out_text'), () {
                            context.read<AuthCubit>().clearUser();
                            context.read<UsersCubit>().logOut();
                            Navigator.pushNamedAndRemoveUntil(
                                context, authView, (route) => false);
                          });
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
