import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shoe_shop_3/models/category_model.dart';

import '../myclasses/api.dart';

class CategoryRepository {
  late Dio dio;
  String apiLink = categoriesApiLink;
  String apiKey = theApiKey;

  CategoryRepository() {
    dio = Dio();
    dio.options.connectTimeout = Duration(seconds: 20);
    dio.options.responseType = ResponseType.json;
  }

  Future<List<CategoryModel>> getAll() async {
    try {
      await Future.delayed(Duration(seconds: 1));

      var res = await dio.get(
        apiLink,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'x-apikey': apiKey,
        }),
      );
      List<CategoryModel> items = [];
      if (res.statusCode == 200) {
        var data = res.data as List;
        if (data.isNotEmpty) {
          for (var item in data) {
            items.add(CategoryModel.fromJson(item));
          }
        }
      }
      return items;
    } catch (e) {
      rethrow;
    }
  } // end getAll

  Future<CategoryModel?> getById(String id) async {
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
        return CategoryModel.fromJson(data);
      } else if (res.statusCode == 404) {
        return null; // Id not found
      } else {
        throw Exception('Failed to fetch audience by id');
      }
    } catch (e) {
      rethrow;
    }
  } // end getById

  Future<List<CategoryModel>> getByField(String field, String value) async {
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
        final categories = <CategoryModel>[];
        for (var audienceData in data) {
          categories.add(CategoryModel.fromJson(audienceData));
        }
        return categories;
      } else {
        throw Exception('Failed to fetch Category by field');
      }
    } catch (e) {
      rethrow;
    }
  } // end getByField

  Future<List<CategoryModel>> getAllWithNoRepeated() async {
    try {
      await Future.delayed(Duration(seconds: 1));

      var res = await dio.get(
        apiLink,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'x-apikey': apiKey,
        }),
      );
      List<CategoryModel> items = [];
      List<String> cateNames = [];
      if (res.statusCode == 200) {
        var data = res.data as List;
        if (data.isNotEmpty) {
          for (var item in data) {
            var category = CategoryModel.fromJson(item);
            if(!cateNames.contains(category.name)){
            items.add(CategoryModel.fromJson(item));
            cateNames.add(category.name!);
            }
          }
        }
      }
      return items;
    } catch (e) {
      rethrow;
    }
  } // end getAll

}
