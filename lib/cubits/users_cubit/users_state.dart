part of 'users_cubit.dart';

@immutable
class UsersState extends Equatable {
  final UserModel user;
  final List<UserModel> users;
  final FormzStatus formzStatus;
  final String errorText;


  const UsersState({
    required this.users,
    required this.user,
    required this.formzStatus,
    required this.errorText,
  
  });

  UsersState copyWith({
    UserModel? user,
    List<UserModel>? users,
    FormzStatus? formzStatus,
    String? errorText,
  }) =>
      UsersState(
        users: users ?? this.users,
        user: user ?? this.user,
        formzStatus: formzStatus ?? this.formzStatus,
        errorText: errorText ?? this.errorText,
      );

  @override
  List<Object?> get props => [
    users,
        user,
        formzStatus,
        errorText,
      ];
}
