import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:post_it/models/post.dart';
import 'package:post_it/models/user.dart';

class RemoteService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  RemoteService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (kDebugMode) {
          print('Request: ${options.method} ${options.path}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          print('Response: ${response.statusCode} ${response.statusMessage}');
        }
        handler.next(response);
      },
      onError: (DioException e, handler) {
        if (kDebugMode) {
          print('Error: ${e.message}');
        }
        return handler.next(e);
      },
    ));
  }

  /* --> <-- --> <-- Get Posts from API using Dio --> <-- --> <-- */
  Future<List<Post>> getPosts() async {
    try {
      final response = await _dio.get('/posts');
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        return jsonData.map((postJson) => Post.fromJson(postJson)).toList();
      } else {
        throw Exception('Failed to load posts. Status Code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleError(e);
      throw Exception('Error fetching posts: ${e.message}');
    }
  }

  /* --> <-- --> <-- Get Posts by User ID from API using Dio --> <-- --> <-- */
  Future<List<Post>> getUserPosts(int userId) async {
    try {
      final response = await _dio.get('/posts', queryParameters: {'userId': userId});
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        return jsonData.map((postJson) => Post.fromJson(postJson)).toList();
      } else {
        throw Exception('Failed to load user posts. Status Code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleError(e);
      throw Exception('Error fetching user posts: ${e.message}');
    }
  }

  /* --> <-- --> <-- Get User by ID from API using Dio --> <-- --> <-- */
  Future<User> getUserById(int userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to load user by id. Status Code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleError(e);
      throw Exception('Error fetching user by id: ${e.message}');
    }
  }

  /* --> <-- --> <-- Get All Users from API using Dio --> <-- --> <-- */
  Future<List<User>> getAllUsers() async {
    try {
      final response = await _dio.get('/users');
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        return jsonData.map((userJson) => User.fromJson(userJson)).toList();
      } else {
        throw Exception('Failed to load users. Status Code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleError(e);
      throw Exception('Error fetching users: ${e.message}');
    }
  }

  /* --> <-- --> <-- Handle Errors in Dio Requests --> <-- --> <-- */
  void _handleError(DioException error) {
    if (error.response != null) {
      if (kDebugMode) {
        print('Error occurred: ${error.response?.statusCode} - ${error.response?.statusMessage}');
      }
      if (kDebugMode) {
        print('Response Data: ${error.response?.data}');
      }
    } else {
      if (kDebugMode) {
        print('Request failed: ${error.message}');
      }
    }
  }
}
