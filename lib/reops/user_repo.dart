import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shoe_shop_3/models/user_model.dart';

import '../myclasses/api.dart';

class UserRepository {
  late Dio dio;
  String apiLink = usersApiLink;
  String apiKey = theApiKey;

  UserRepository() {
    dio = Dio();
    dio.options.connectTimeout = Duration(seconds: 20);
    dio.options.responseType = ResponseType.json;
  }

  Future<List<UserModel>> getAll() async {
    try {
      await Future.delayed(Duration(seconds: 1));

      var res = await dio.get(
        apiLink,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-apikey': apiKey,
          },
        ),
      );
      List<UserModel> items = [];
      if (res.statusCode == 200) {
        var data = res.data as List;
        if (data.isNotEmpty) {
          for (var item in data) {
            items.add(UserModel.fromJson(item));
          }
        }
      }
      return items;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getById(String id) async {
    try {
      var res = await dio.get(
        '$apiLink/$id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-apikey': apiKey,
          },
        ),
      );

      if (res.statusCode == 200) {
        var data = res.data as Map<String, dynamic>;
        return UserModel.fromJson(data);
      } else if (res.statusCode == 404) {
        return null; // Id not found
      } else {
        throw Exception('Failed to fetch audience by id');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> getByField(String field, String value) async {
    try {
      final response = await dio.get(
        apiLink,
        queryParameters: {
          'q': jsonEncode({field: value})
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-apikey': apiKey,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        final users = <UserModel>[];
        for (var userData in data) {
          users.add(UserModel.fromJson(userData));
        }
        return users;
      } else {
        throw Exception('Failed to fetch users by field');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> addUser(UserModel user) async {
    try {
      final response = await dio.post(
        apiLink,
        data: user.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-apikey': apiKey,
          },
        ),
      );

      if (response.statusCode == 201) {
        var data = response.data as Map<String, dynamic>;
        return UserModel.fromJson(data);
      } else {
        throw Exception('Failed to add user');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> updateUser(String id, UserModel user) async {
    try {
      final response = await dio.put(
        '$apiLink/$id',
        data: user.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-apikey': apiKey,
          },
        ),
      );

      if (response.statusCode == 200) {
        var data = response.data as Map<String, dynamic>;
        return UserModel.fromJson(data);
      } else {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isUsernameExists(String username) async {
    try {
      final response = await dio.get(
        apiLink,
        queryParameters: {
          'q': jsonEncode({'Username': username})
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-apikey': apiKey,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data.isNotEmpty;
      } else {
        throw Exception('Failed to check username existence');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isEmailExists(String email) async {
    try {
      final response = await dio.get(
        apiLink,
        queryParameters: {
          'q': jsonEncode({'email': email})
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-apikey': apiKey,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data.isNotEmpty;
      } else {
        throw Exception('Failed to check email existence');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isValueExists(String field, String value) async {
    try {
      final response = await dio.get(
        apiLink,
        queryParameters: {
          'q': jsonEncode({'$field': value})
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-apikey': apiKey,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data.isNotEmpty;
      } else {
        throw Exception('Failed to check email existence');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> authenticateUser(String email, String password) async {
    try {
    final response = await dio.get(
      apiLink,
      queryParameters: {
        'q': jsonEncode({'email': email, 'Password': password})
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'x-apikey': apiKey,
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data as List<dynamic>;
      return data.isNotEmpty;
    } else {
      throw Exception('Failed to check email existence');
    }
  } catch (e) {
    rethrow;
  }
  }

  Future<UserModel> updateOneField(String id, String field, String value) async {
  try {
    final response = await dio.put(
      '$apiLink/$id',
      data: {
        '$field': value,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'x-apikey': apiKey,
        },
      ),
    );

    if (response.statusCode == 200) {
      var data = response.data as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to update user');
    }
  } catch (e) {
    rethrow;
  }
}

Future<bool> isValueExistsOnAnotherId(String id, String field, String value) async {
  try {
    final response = await dio.get(
      apiLink,
      queryParameters: {
        'q': jsonEncode({
          '$field': value,
        })
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'x-apikey': apiKey,
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data as List<dynamic>;
      for (var item in data) {
        if (item['_id'] != id) {
          return true;
        }
      }
      return false;
    } else {
      throw Exception('Failed to check existence');
    }
  } catch (e) {
    rethrow;
  }
}

Future<bool> UserNameAndEmailCheckMatching(String email, String username) async {
    try {
    final response = await dio.get(
      apiLink,
      queryParameters: {
        'q': jsonEncode({'email': email, 'Username': username})
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'x-apikey': apiKey,
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data as List<dynamic>;
      return data.isNotEmpty;
    } else {
      throw Exception('Failed to check email existence');
    }
  } catch (e) {
    rethrow;
  }
  }
}
