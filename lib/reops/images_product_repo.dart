import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shoe_shop_3/models/images_product_model.dart';

import '../myclasses/api.dart';

class ImagesProductRepository {
  late Dio dio;
  String apiLink = imageproductApiLink;
  String apiKey = theApiKey;

  ImagesProductRepository() {
    dio = Dio();
    dio.options.connectTimeout = Duration(seconds: 20);
    dio.options.responseType = ResponseType.json;
  }

  Future<List<ImagesProductModel>> getAll(int limit) async {
    try {
      await Future.delayed(Duration(seconds: 1));

      var res = await dio.get(
        apiLink,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'x-apikey': apiKey,
        }),
      );
      List<ImagesProductModel> items = [];
      if (res.statusCode == 200) {
        var data = res.data as List;
        List<String> prodsId = [];
        if (data.isNotEmpty) {
          var i = 0;

          for (var item in data) {
            // prevant repeat images for the same product
            ImagesProductModel img = ImagesProductModel.fromJson(item);
            String pid = img.prodId![0].id??'';
            if (!prodsId.contains(pid)) {
              items.add(ImagesProductModel.fromJson(item));
              prodsId.add(pid);
              i++;
              if (limit == i) {
                break;
              }
            }
          }
        }
      }
      return items;
    } catch (e) {
      rethrow;
    }
  } // end getAll

  Future<ImagesProductModel?> getById(String id) async {
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
        return ImagesProductModel.fromJson(data);
      } else if (res.statusCode == 404) {
        return null; // Id not found
      } else {
        throw Exception('Failed to fetch audience by id');
      }
    } catch (e) {
      rethrow;
    }
  } // end getById

  Future<List<ImagesProductModel>> getImagesByProductId(String value1) async {
    try {
      final response = await dio.get(
        apiLink,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-apikey': apiKey,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        final products = <ImagesProductModel>[];

        for (var productData in data) {
          final productImages = ImagesProductModel.fromJson(productData);

          // Check if the product's Prod_id matches the provided value1
          if (productImages.prodId != null &&
              productImages.prodId!.isNotEmpty) {
            bool productMatched = false;
            for (var prodId in productImages.prodId!) {
              if (prodId.id == value1) {
                productMatched = true;
                break;
              }
            }
            if (!productMatched) {
              continue; // Skip to the next product if the product ID didn't match
            }
          }

          products.add(productImages);
        }

        return products;
      } else {
        throw Exception('Failed to fetch products by product ID');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ImagesProductModel>> getByField(String field, String value) async {
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
        final categories = <ImagesProductModel>[];
        for (var audienceData in data) {
          categories.add(ImagesProductModel.fromJson(audienceData));
        }
        return categories;
      } else {
        throw Exception('Failed to fetch Category by field');
      }
    } catch (e) {
      rethrow;
    }
  } // end getByField
}
