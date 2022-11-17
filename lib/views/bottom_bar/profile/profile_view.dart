import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vlog_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:vlog_app/cubits/users_cubit/users_cubit.dart';
import 'package:vlog_app/data/models/helper/action_model.dart';
import 'package:vlog_app/data/models/user/user_model.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/constants.dart';
import 'package:vlog_app/utils/icon.dart';
import 'package:vlog_app/utils/my_utils.dart';
import 'package:vlog_app/views/bottom_bar/profile/widgets/image_picker_bottom_sheet.dart';
import 'package:vlog_app/views/bottom_bar/profile/widgets/user_info_item.dart';
import 'package:vlog_app/views/widgest/custom_appbar_with_drawer.dart';
import 'package:vlog_app/views/widgest/custom_drawer.dart';
import 'package:vlog_app/views/widgest/ask_dialog.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: CustomAppBarWithDrawer(
        title: "Profile",
        actions: [
          ActionModel(
            icon: Icons.settings,
            onPressed: () {
              Navigator.pushNamed(context, settingsView);
            },
          ),
          ActionModel(
            icon: Icons.logout_outlined,
            onPressed: () {
              // ASK FOR EXIT
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
      drawer: const CustomDrawer(),
      body: BlocConsumer<UsersCubit, UsersState>(
        listener: (context, state) {
          if (state.formzStatus.isSubmissionFailure) {
            MyUtils.showSnackBar(context, state.errorText);
          }
        },
        builder: (context, state) {
          UserModel user = state.user;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Column(
              children: [
                // USER IMAGE
                SizedBox(
                  width: 200.h,
                  height: 200.h,
                  child: Stack(
                    children: [
                      // IMAGE
                      ClipOval(
                          child: state.formzStatus.isSubmissionInProgress
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  enabled: true,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                )
                              : CachedNetworkImage(
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      'https://blogappuz.herokuapp.com/${user.imageUrl}',
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    enabled: true,
                                    child: Container(
                                      color: Colors.white,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    MyIcons.users[4],
                                  ),
                                )),
                      // EDITER
                      Positioned(
                        bottom: 0,
                        right: 10.w,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            await selectImageAndUpdateDialog(
                              context: context,
                            );
                            // await context.read<UsersCubit>().updateCurrentUser(
                            //     updateUser: state.user, file: image);
                          },
                          icon: Icon(
                            Icons.add_a_photo_rounded,
                            color: MyColors.grey.withOpacity(0.7),
                            size: 42,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15.h),

                /// UPDATE INFO CUBIT WORKS INTO USER INFO ITEM
                // USER INFO ITEMS
                Column(
                  children: [
                    // USERNAME
                    UserInfoItem(
                      title: 'USERNAME',
                      text: '@${user.userName}',
                      canEdit: false,
                    ),
                    SizedBox(height: 15.h),

                    // NAME
                    UserInfoItem(
                      title: 'NAME',
                      text: user.firstName.isEmpty
                          ? 'Enter your name'
                          : user.firstName,
                      canEdit: true,
                    ),
                    SizedBox(height: 15.h),

                    // LASTNAME
                    UserInfoItem(
                      title: 'LASTNAME',
                      text: user.lastName.isEmpty
                          ? 'Enter your last name'
                          : user.lastName,
                      canEdit: true,
                    ),
                    SizedBox(height: 15.h),

                    // EMAIL
                    UserInfoItem(
                      title: 'EMAIL',
                      text: user.email,
                      canEdit: false,
                    ),
                    SizedBox(height: 15.h),
                  ],
                ),

                // PADDING BOTTOM
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 15,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
