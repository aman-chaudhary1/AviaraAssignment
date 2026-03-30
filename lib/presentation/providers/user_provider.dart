import 'dart:async';
import 'package:aviaraassignment/core/error/failures.dart';
import 'package:aviaraassignment/core/utils/constants.dart';
import 'package:aviaraassignment/data/models/user_model.dart';
import 'package:aviaraassignment/data/repositories/user_repository_impl.dart';
import 'package:aviaraassignment/domain/repositories/user_repository.dart';
import 'package:aviaraassignment/presentation/providers/user_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dioProvider = Provider<Dio>((ref) => Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        headers: {
          'User-Agent': 'Flutter/AviaraAssignment',
          'Accept': 'application/json',
        },
      ),
    ));

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return UserRepositoryImpl(dio, prefs);
});

final userNotifierProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UserNotifier(repository);
});

class UserNotifier extends StateNotifier<UserState> {
  final UserRepository _repository;
  Timer? _debounce;
  List<UserModel> _allUsers = [];
  int _currentPage = 1;
  final int _pageSize = 6;

  UserNotifier(this._repository) : super(const UserState.initial());

  Future<void> fetchUsers() async {
    state = const UserState.loading();
    try {
      _allUsers = await _repository.fetchUsers();
      if (_allUsers.isEmpty) {
        state = const UserState.empty();
      } else {
        _currentPage = 1;
        _paginate();
      }
    } on Failure catch (e) {
      state = UserState.error(e.message);
    } catch (e) {
      state = UserState.error('Unexpected error: $e');
    }
  }

  void searchUsers(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.isEmpty) {
        _currentPage = 1;
        _paginate();
        return;
      }

      final filtered = _allUsers
          .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      if (filtered.isEmpty) {
        state = const UserState.empty();
      } else {
        state = UserState.success(
          users: _allUsers,
          filteredUsers: filtered,
          hasMore: false,
        );
      }
    });
  }

  void loadMore() {
    state.maybeWhen(
      success: (users, filteredUsers, hasMore, isPaginating) {
        if (!hasMore || isPaginating) return;
        state = (state as Success).copyWith(isPaginating: true);
        _currentPage++;
        _paginate();
      },
      orElse: () {},
    );
  }

  void _paginate() {
    final end = _currentPage * _pageSize;
    final filtered = _allUsers.sublist(0, end > _allUsers.length ? _allUsers.length : end);
    state = UserState.success(
      users: _allUsers,
      filteredUsers: filtered,
      hasMore: end < _allUsers.length,
      isPaginating: false,
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
