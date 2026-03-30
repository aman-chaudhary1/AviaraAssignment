import 'package:aviaraassignment/data/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_state.freezed.dart';

@freezed
sealed class UserState with _$UserState {
  const factory UserState.initial() = Initial;
  const factory UserState.loading() = Loading;
  const factory UserState.success({
    required List<UserModel> users,
    required List<UserModel> filteredUsers,
    required bool hasMore,
    @Default(false) bool isPaginating,
  }) = Success;
  const factory UserState.error(String message) = Error;
  const factory UserState.empty() = Empty;
}
