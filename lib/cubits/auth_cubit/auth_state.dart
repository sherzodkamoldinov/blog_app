part of 'auth_cubit.dart';

@immutable
class AuthState extends Equatable {
  final UserModel user;
  final FormzStatus formzStatus;
  final String errorText;
  final int code;

  const AuthState({
    required this.user,
    required this.formzStatus,
    required this.errorText,
    required this.code,
  });

  AuthState copyWith({
    UserModel? user,
    FormzStatus? formzStatus,
    String? errorText,
    int? code,
  }) =>
      AuthState(
        user: user ?? this.user,
        formzStatus: formzStatus ?? this.formzStatus,
        errorText: errorText ?? this.errorText,
        code: code ?? this.code,
      );

  @override
  List<Object?> get props => [
        user,
        formzStatus,
        errorText,
        code,
      ];
}
