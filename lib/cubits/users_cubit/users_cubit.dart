import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:vlog_app/data/models/user/user_model.dart';
import 'package:vlog_app/data/repositories/users_repository.dart';
import 'package:vlog_app/data/services/local/storage_service.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit({required this.usersRepository})
      : super(UsersState(
          errorText: '',
          formzStatus: FormzStatus.pure,
          user: UserModel(
            id: -1,
            email: '',
            firstName: '',
            imageUrl: '',
            lastName: '',
            password: '',
            userName: '',
          ),
          users: [],
        ));

  final UsersRepository usersRepository;

  Future<void> getCurrentUser() async {
    emit(state.copyWith(formzStatus: FormzStatus.submissionInProgress));
    try {
      UserModel user = await usersRepository.getCurrentUser();
      emit(
        state.copyWith(user: user, formzStatus: FormzStatus.submissionSuccess),
      );
      debugPrint('CURRENT USER: ${user.toString()}');
    } catch (e) {
      emit(state.copyWith(
          errorText: e.toString(), formzStatus: FormzStatus.submissionFailure));
      rethrow;
    }
  }

  Future<void> updateCurrentUser(
      {required UserModel updateUser, XFile? file}) async {
    emit(state.copyWith(formzStatus: FormzStatus.submissionInProgress));
    try {
      UserModel updatedUser =
          await usersRepository.updateCurrentUser(user: updateUser, file: file);
      emit(state.copyWith(
          formzStatus: FormzStatus.submissionSuccess, user: updatedUser));
    } catch (e) {
      emit(state.copyWith(
          formzStatus: FormzStatus.submissionFailure, errorText: e.toString()));
    }
  }

  Future<void> getAllUser() async {
    emit(state.copyWith(formzStatus: FormzStatus.submissionInProgress));
    try {
      List<UserModel> users = await usersRepository.getAllUsers();
      emit(state.copyWith(
          users: users, formzStatus: FormzStatus.submissionSuccess));
    } catch (e) {
      emit(state.copyWith(
          errorText: e.toString(), formzStatus: FormzStatus.submissionFailure));
      rethrow;
    }
  }

  Future<UserModel> getUserById({required int userId}) async {
    emit(state.copyWith(formzStatus: FormzStatus.submissionInProgress));
    try {
      UserModel userById = await usersRepository.getUserById(id: userId);
      return userById;
    } catch (e) {
      emit(state.copyWith(
          errorText: e.toString(), formzStatus: FormzStatus.submissionFailure));
      rethrow;
    }
  }

  Future<void> deleteCurrentUser() async {
    emit(state.copyWith(formzStatus: FormzStatus.submissionInProgress));
    try {
      await usersRepository.deleteCurrentUser();
      // TODO: ADD HERE DELETE ALL BLOGS OF USER
      await StorageService.instance.storage.remove('token');
      emit(state.copyWith(formzStatus: FormzStatus.submissionSuccess));
      clearState();
    } catch (e) {
      emit(state.copyWith(
          formzStatus: FormzStatus.submissionFailure, errorText: e.toString()));
      rethrow;
    }
  }

  void logOut() async {
    clearState();
    await StorageService.instance.storage.remove('token');
  }

  void clearState() {
    emit(
      state.copyWith(
        errorText: '',
        formzStatus: FormzStatus.pure,
        user: UserModel(
          id: -1,
          email: '',
          firstName: '',
          imageUrl: '',
          lastName: '',
          password: '',
          userName: '',
        ),
        users: [],
      ),
    );
  }
}
