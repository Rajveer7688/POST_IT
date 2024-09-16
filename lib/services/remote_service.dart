import 'dart:convert';
import 'package:post_it/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:post_it/models/user.dart';

class RemoteService {
  /* --> <-- --> <-- Get Posts from API --> <-- --> <-- */
  Future<List<Post>?> getPosts() async {
    var client = http.Client();
    var uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    var response = await client.get(uri);
    if(response.statusCode == 200) {
      var json = response.body;
      return postFromJson(json);
    } else {
      print('Failed to load posts. Status Code: ${response.statusCode}');
    }
  }

  /* --> <-- --> <-- Get Posts by User ID from API --> <-- --> <-- */
  Future<List<Post>?> getUserPosts(int userID) async {
    var client = http.Client();
    var uri = Uri.parse('https://jsonplaceholder.typicode.com/posts?userId=$userID');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return postFromJson(json);
    } else {
      print('Failed to load user posts. Status Code: ${response.statusCode}');
    }
  }

  /* --> <-- --> <-- Get User by ID from API --> <-- --> <-- */
  Future<User?> getUserById(int userId) async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/users/$userId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return User.fromJson(json);
    } else {
      print('Failed to load user by id, Status Code: ${response.statusCode}');
    }
  }

  /* --> <-- --> <-- Get User by ID from API --> <-- --> <-- */
  Future<List<User>> getAllUsers() async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/users');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}