import 'package:vlog_app/data/models/user/user_model.dart';
import 'package:vlog_app/data/services/api/api_provider.dart';

class AuthRepository {
  AuthRepository({required ApiProvider apiProvider})
      : _apiProvider = apiProvider;

  final ApiProvider _apiProvider;

  Future<void> registerUser({required UserModel user}) =>
      _apiProvider.registerUser(user: user);

  Future<Map<String, dynamic>> login(
          {required String email, required String password}) =>
      _apiProvider.login(email: email, password: password);

  Future<void> verifyEmail({required String email, required int code}) =>
      _apiProvider.verifyEmail(email: email, code: code);

  Future<void> sendCodeToEmail({required String email}) =>
      _apiProvider.sendCodeToEmail(email: email);

  Future<bool> resetPassword(
          {required String email,
          required int code,
          required String password}) =>
      _apiProvider.resetPassword(email: email, code: code, password: password);
}
