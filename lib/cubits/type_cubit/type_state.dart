part of 'type_cubit.dart';

class TypeState extends Equatable {
  const TypeState({
    required this.types,
    this.status = FormzStatus.pure,
    this.errorText = '',
    required this.type,
  });

  final List<TypeModel> types;
  final FormzStatus status;
  final String errorText;
  final TypeModel type;

  TypeState copyWith({
    List<TypeModel>? types,
    FormzStatus? status,
    String? errorText,
    TypeModel? type,
  }) =>
      TypeState(
        types: types ?? this.types,
        status: status ?? this.status,
        errorText: errorText ?? this.errorText,
        type: type ?? this.type,
      );

  @override
  List<Object> get props => [types, type, status, errorText];
}
