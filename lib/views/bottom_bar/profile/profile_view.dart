import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:vlog_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:vlog_app/cubits/users_cubit/users_cubit.dart';
import 'package:vlog_app/data/services/local/storage_service.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/constants.dart';
import 'package:vlog_app/utils/icon.dart';
import 'package:vlog_app/utils/style.dart';
import 'package:vlog_app/views/widgest/custom_appbar_with_drawer.dart';
import 'package:vlog_app/views/widgest/custom_botton.dart';
import 'package:vlog_app/views/widgest/custom_drawer.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: MyColors.backgroundColor,
          appBar: CustomAppBarWithDrawer(
            title: "Profile",
            actionIcon: Icons.logout_outlined,
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: AlertDialog(
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.read<AuthCubit>().clearUser();
                              BlocProvider.of<UsersCubit>(context).clearState();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, authView, (route) => false);
                            },
                            child: const Text('Yes'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(_);
                            },
                            child: const Text('No'),
                          ),
                        ],
                      )
                    ],
                    scrollable: true,
                    content: Column(
                      children: [
                        const Text('Do you really want to log out'),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          drawer: const CustomDrawer(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Column(
              children: [
                const SizedBox(width: double.infinity),
                SizedBox(height: 20.h),

                // USER IMAGE
                SizedBox(
                  width: 200.h,
                  height: 200.h,
                  child: Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.r),
                      child: Container(
                        color: MyColors.richBlack,
                        child: Image.asset(
                          MyIcons.users[3],
                          height: 200.h,
                          width: 200.h,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 10.w,
                      child: GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.add_circle_sharp,
                          color: MyColors.richBlack,
                          size: 42,
                        ),
                      ),
                    )
                  ]),
                ),
                SizedBox(height: 30.h),

                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      height: 70.h,
                      decoration: BoxDecoration(
                          color: MyColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: MyColors.grey.withOpacity(0.4),
                              blurRadius: 4,
                              offset: const Offset(1, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            "@${state.user.userName}",
                            overflow: TextOverflow.ellipsis,
                            style: MyTextStyle.sfProLight
                                .copyWith(fontSize: 22.sp),
                          )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                                color: MyColors.richBlack,
                              ))
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      height: 70.h,
                      decoration: BoxDecoration(
                          color: MyColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: MyColors.grey.withOpacity(0.4),
                              blurRadius: 4,
                              offset: const Offset(1, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            "${state.user.firstName} ${state.user.lastName}",
                            overflow: TextOverflow.ellipsis,
                            style: MyTextStyle.sfProLight
                                .copyWith(fontSize: 22.sp),
                          )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                                color: MyColors.richBlack,
                              ))
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      height: 70.h,
                      decoration: BoxDecoration(
                          color: MyColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: MyColors.grey.withOpacity(0.4),
                              blurRadius: 4,
                              offset: const Offset(1, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            state.user.email,
                            overflow: TextOverflow.ellipsis,
                            style: MyTextStyle.sfProLight
                                .copyWith(fontSize: 22.sp),
                          )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                                color: MyColors.richBlack,
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 48.h),
                customBotton(
                  onPressed: () async {
                    debugPrint(
                        'MY TOKEN ${StorageService.instance.storage.read('token')}');
                    await context.read<UsersCubit>().deleteUser();
                    Navigator.pushNamed(context, authView);
                  },
                  title: state.formzStatus.isSubmissionInProgress
                      ? null
                      : 'Delete Accaount',
                  fillColor: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
