import 'package:vlog_app/data/models/type/type_model.dart';
import 'package:vlog_app/data/services/api/api_provider.dart';

class TypeRepository {
  TypeRepository({required ApiProvider apiProvider})
      : _apiProvider = apiProvider;

  final ApiProvider _apiProvider;

  Future<List<TypeModel>> getTypes() => _apiProvider.getTypes();
}
