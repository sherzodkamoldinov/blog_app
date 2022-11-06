import 'package:vlog_app/data/models/user/user_model.dart';
import 'package:vlog_app/data/services/api/api_provider.dart';

class UsersRepository {
  UsersRepository({required ApiProvider apiProvider})
      : _apiProvider = apiProvider;

  ApiProvider _apiProvider;

  Future<List<UserModel>> getAllUsers() => _apiProvider.getAllUsers();

  Future<UserModel> getUserById({required int id}) =>
      _apiProvider.getUserById(id: id);

  Future<bool> updateUserById({required UserModel user}) =>
      _apiProvider.updateUserById(user: user);

  Future<void> deleteUser() =>
      _apiProvider.deleteUser();

  Future<UserModel> getCurrentUser() => _apiProvider.getCurrentUser();
}
