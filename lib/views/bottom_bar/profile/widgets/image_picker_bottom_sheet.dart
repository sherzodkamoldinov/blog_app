import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vlog_app/cubits/users_cubit/users_cubit.dart';
import 'package:vlog_app/utils/my_utils.dart';
import 'package:vlog_app/utils/style.dart';

Future<void> selectImageAndUpdateDialog({required BuildContext context}) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(16),
        topLeft: Radius.circular(16),
      ),
    ),
    backgroundColor: Theme.of(context).primaryColor,
    builder: (BuildContext bc) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: 150,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.photo_library,
                    color: Theme.of(context).cardColor,
                  ),
                  title: Text(
                    "Gallery",
                    style: MyTextStyle.sfProRegular.copyWith(
                        fontSize: 16, color: Theme.of(context).cardColor),
                  ),
                  onTap: () async {
                    await MyUtils.getFromGallery().then((value) async {
                      Navigator.of(context).pop();
                      await context.read<UsersCubit>().updateCurrentUser(
                          updateUser: context.read<UsersCubit>().state.user,
                          file: value);
                    });
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.photo_camera,
                    color: Theme.of(context).cardColor,
                  ),
                  title: Text(
                    "Camera",
                    style: MyTextStyle.sfProRegular.copyWith(
                        fontSize: 16, color: Theme.of(context).cardColor),
                  ),
                  onTap: () async {
                    await MyUtils.getFromCamera().then((value) async {
                      await context.read<UsersCubit>().updateCurrentUser(
                          updateUser: context.read<UsersCubit>().state.user,
                          file: value);
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
