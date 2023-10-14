import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/custom_exception.dart';

part 'response_state.freezed.dart';

@freezed
class ResponseState<T> with _$ResponseState<T> {
  const factory ResponseState.idle() = _Idle<T>;

  const factory ResponseState.loading() = _Loading<T>;

  const factory ResponseState.data({required T data}) = _Data<T>;

  const factory ResponseState.success({required Map<String, dynamic>? data}) =
  _Success<T>;

  const factory ResponseState.dataList({required List<T> data}) = _DataList<T>;

  const factory ResponseState.error({required CustomException error}) =
  _Error<T>;
}
