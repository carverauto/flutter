import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_notifier_state.freezed.dart';

@freezed
abstract class PaginationNotifierState<T> with _$PaginationNotifierState<T> {
  const factory PaginationNotifierState.data(
      List<T> items, bool hasReachedMax) = _Data;
  const factory PaginationNotifierState.loading(List<T> movies) = _Loading;
  const factory PaginationNotifierState.error(Object? e, [StackTrace? stk]) =
      _Error;
}
