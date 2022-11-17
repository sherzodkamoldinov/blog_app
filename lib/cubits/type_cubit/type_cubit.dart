import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:vlog_app/data/models/type/type_model.dart';
import 'package:vlog_app/data/repositories/type_repository.dart';

part 'type_state.dart';

class TypeCubit extends Cubit<TypeState> {
  TypeCubit({required TypeRepository typeRepository})
      : _typeRepository = typeRepository,
        super(
          TypeState(
            type: TypeModel(id: -1, name: ''),
            types: const [],
          ),
        );

  TypeRepository _typeRepository;

  Future<void> getTypes() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      List<TypeModel> types = await _typeRepository.getTypes();
      emit(state.copyWith(status: FormzStatus.submissionSuccess, types: types));
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure, errorText: e.toString()));
    }
  }
}
