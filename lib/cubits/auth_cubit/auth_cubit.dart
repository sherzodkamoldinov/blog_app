import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:vlog_app/data/models/user/user_model.dart';
import 'package:vlog_app/data/repositories/auth_repository.dart';
import 'package:formz/formz.dart';
import 'package:vlog_app/data/services/local/storage_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authRepository})
      : super(
          AuthState(
            code: 0,
            user: UserModel(
              email: "",
              firstName: "",
              id: -1,
              imageUrl: "",
              lastName: "",
              password: "",
              userName: "",
            ),
            errorText: '',
            formzStatus: FormzStatus.pure,
          ),
        );

  final AuthRepository authRepository;

  void changeUser({required UserModel user}) {
    emit(
      state.copyWith(user: user, formzStatus: FormzStatus.submissionSuccess),
    );
  }

  Future<void> registerUser({required UserModel userModel}) async {
    emit(state.copyWith(formzStatus: FormzStatus.submissionInProgress));
    try {
      await authRepository.registerUser(user: userModel);
      emit(
        state.copyWith(
            user: userModel, formzStatus: FormzStatus.submissionSuccess),
      );
    } catch (e) {
      emit(state.copyWith(
          formzStatus: FormzStatus.submissionFailure, errorText: e.toString()));
      throw Exception();
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(formzStatus: FormzStatus.submissionInProgress));
    try {
      var data = await authRepository.login(email: email, password: password);
      debugPrint('------ USER LOGINED -------');
      await StorageService.instance.storage.write('token', data['token']);
      debugPrint(
          '------ USER TOKEN WRITED -------\ntoken: ${StorageService.instance.storage.read('token')}');
      debugPrint('------------- USER AUTHORIZED --------------');
      emit(state.copyWith(
          formzStatus: FormzStatus.submissionSuccess,
          user: state.user.copyWith(id: data['id'])));
    } catch (e) {
      emit(state.copyWith(
          formzStatus: FormzStatus.submissionFailure, errorText: e.toString()));
      rethrow;
    }
  }

  Future<bool> verifyEmail({required int code}) async {
    emit(state.copyWith(formzStatus: FormzStatus.submissionInProgress));
    try {
      debugPrint('EMAIL: ${state.user.email}\nCODE:${code}');
      await authRepository.verifyEmail(email: state.user.email, code: code);
      emit(state.copyWith(
          formzStatus: FormzStatus.submissionSuccess, code: code));
      return true;
    } catch (e) {
      emit(state.copyWith(
          formzStatus: FormzStatus.submissionFailure, errorText: e.toString()));
      rethrow;
    }
  }

  Future<void> sendCodeToEmail({required String email}) async {
    emit(state.copyWith(formzStatus: FormzStatus.submissionInProgress));
    try {
      await authRepository.sendCodeToEmail(email: email);
      debugPrint('CODE SENT TO EMAIL: ${state.user.email}');
      emit(
        state.copyWith(
          formzStatus: FormzStatus.submissionSuccess,
          user: state.user.copyWith(email: email),
        ),
      );
    } catch (e) {
      emit(state.copyWith(
          formzStatus: FormzStatus.submissionFailure, errorText: e.toString()));
      rethrow;
    }
  }

  Future<void> resetPassword({required String password}) async {
    emit(state.copyWith(formzStatus: FormzStatus.submissionInProgress));
    try {
      await authRepository.resetPassword(
          email: state.user.email, code: state.code, password: password);
      emit(
        state.copyWith(
          formzStatus: FormzStatus.submissionSuccess,
          user: state.user.copyWith(password: password),
        ),
      );
      debugPrint('RESET PASSWORD SUCCES NEW PASSWORD: ${state.user.password}');
    } catch (e) {
      emit(state.copyWith(
          formzStatus: FormzStatus.submissionFailure, errorText: e.toString()));
      rethrow;
    }
  }


  void clearUser() async {
    await StorageService.instance.storage.remove('token');
    emit(state.copyWith(
      code: 0,
      user: UserModel(
        email: "",
        firstName: "",
        id: -1,
        imageUrl: "",
        lastName: "",
        password: "",
        userName: "",
      ),
      errorText: '',
      formzStatus: FormzStatus.pure,
    ));
  }
}
