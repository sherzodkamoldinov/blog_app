import 'package:image_picker/image_picker.dart';
import 'package:vlog_app/data/models/user/user_model.dart';
import 'package:vlog_app/data/services/api/api_provider.dart';

class UsersRepository {
  UsersRepository({required ApiProvider apiProvider})
      : _apiProvider = apiProvider;

  ApiProvider _apiProvider;

  Future<List<UserModel>> getAllUsers() => _apiProvider.getAllUsers();

  Future<UserModel> getUserById({required int id}) =>
      _apiProvider.getUserById(id: id);

  Future<UserModel> updateCurrentUser({required UserModel user, XFile? file}) =>
      _apiProvider.updateCurrentUser(user: user, file: file);

  Future<void> deleteCurrentUser() =>
      _apiProvider.deleteCurrentUser();

  Future<UserModel> getCurrentUser() => _apiProvider.getCurrentUser();
}
