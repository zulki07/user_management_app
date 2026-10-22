import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'user_model.dart';

class UserService {
  final String baseUrl = 'https://reqres.in/api/users';


  Exception _handleException(dynamic e) {
    if (e is SocketException) {
      return Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } else if (e is TimeoutException) {
      return Exception('Koneksi RTO. Silakan coba lagi.');
    } else if (e is Exception) {
      return e;
    }
    return Exception('Terjadi kesalahan yang tidak diketahui.');
  }

  // GET: Fetch Users
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?page=1')).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> listJson = data['data'];
        return listJson.map((item) => UserModel.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat data (Status Code: ${response.statusCode})');
      }
    } catch (e) {
      throw _handleException(e);
    }
  }

  Future<UserModel> createUser(String firstName, String lastName, String email) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return UserModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal menambah user (Status Code: ${response.statusCode})');
      }
    } catch (e) {
      throw _handleException(e);
    }
  }


  Future<UserModel> updateUser(int id, String firstName, String lastName, String email) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return UserModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal memperbarui user (Status Code: ${response.statusCode})');
      }
    } catch (e) {
      throw _handleException(e);
    }
  }


  Future<bool> deleteUser(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id')).timeout(const Duration(seconds: 10));
      if (response.statusCode == 204 || response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Gagal menghapus user (Status Code: ${response.statusCode})');
      }
    } catch (e) {
      throw _handleException(e);
    }
  }
}