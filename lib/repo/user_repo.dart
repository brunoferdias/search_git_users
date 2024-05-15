import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/github_user.dart';

class UserRepository {
  Future<List<GithubUser>> searchUsers(String query) async {
    final response = await http.get(Uri.parse('https://api.github.com/search/users?q=$query'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> usersJson = data['items'];
      final List<GithubUser> users = usersJson.map((json) => GithubUser.fromJson(json)).toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<dynamic>> getUserRepositories(String username) async {
    final response = await http.get(Uri.parse('https://api.github.com/users/$username/repos'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load repositories');
    }
  }
}
