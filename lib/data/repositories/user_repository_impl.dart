import 'dart:convert';
import 'package:aviaraassignment/core/error/failures.dart';
import 'package:aviaraassignment/core/utils/constants.dart';
import 'package:aviaraassignment/data/models/user_model.dart';
import 'package:aviaraassignment/domain/repositories/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepositoryImpl implements UserRepository {
  final Dio _dio;
  final SharedPreferences _prefs;

  UserRepositoryImpl(this._dio, this._prefs);

  @override
  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await _dio.get(AppConstants.usersPath);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final users = data.map((json) => UserModel.fromJson(json)).toList();

        // Cache the result
        await _prefs.setString(AppConstants.cacheKey, json.encode(data));

        return users;
      } else {
        throw ServerFailure();
      }
    } on DioException catch (e) {
      // Return cached data if network error occurs
      final cachedData = _prefs.getString(AppConstants.cacheKey);
      if (cachedData != null) {
        final List<dynamic> data = json.decode(cachedData);
        return data.map((json) => UserModel.fromJson(json)).toList();
      }
      throw NetworkFailure(e.message ?? 'Check your connection');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
