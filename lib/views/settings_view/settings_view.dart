import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlog_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:vlog_app/cubits/users_cubit/users_cubit.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/constants.dart';
import 'package:vlog_app/views/settings_view/widgets/language_dialog.dart';
import 'package:vlog_app/views/settings_view/widgets/settings_item.dart';
import 'package:vlog_app/views/settings_view/widgets/theme_dialog.dart';
import 'package:vlog_app/views/widgest/custom_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:vlog_app/views/widgest/ask_dialog.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late String activeLanguage = "";
  @override
  Widget build(BuildContext context) {
    activeLanguage = context.locale.toString();
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: CustomAppBar(
        title: tr('settings'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            // CHOOSE LANGUAGE
            SettingsItem(
              title: tr('language'),
              icon: Icons.language,
              onTap: () {
                showLanguageDialog(context, activeLanguage, (value) {
                  setState(() {
                    context.setLocale(Locale(value[0], value[1]));
                    activeLanguage = "${value[0]}_${value[1]}";
                  });
                });
              },
            ),
            SizedBox(height: 10.h),

            // THEME
            SettingsItem(
              title: tr('theme'),
              icon: Icons.color_lens,
              onTap: () {
                showThemeDialog(context);
                setState(() {});
              },
            ),
            SizedBox(height: 10.h),

            // ABOUT US
            SettingsItem(
              title: tr('about_us'),
              icon: Icons.people,
              onTap: () {},
            ),
            SizedBox(height: 10.h),

            SettingsItem(
              title: tr('delete_account'),
              icon: Icons.delete,
              onTap: () async {
                showAskDialog(context, tr('delete_account_text'), () async {
                  context.read<AuthCubit>().clearUser();
                  await context.read<UsersCubit>().deleteCurrentUser();
                  Navigator.pushNamedAndRemoveUntil(
                      context, authView, (route) => false);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
