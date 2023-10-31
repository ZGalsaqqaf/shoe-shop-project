import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shoe_shop_3/models/product_model.dart';

import '../myclasses/api.dart';

class ProductShoeRepository {
  late Dio dio;
  String apiLink = productsApiLink;
  String apiKey = theApiKey;

  ProductShoeRepository() {
    dio = Dio();
    dio.options.connectTimeout = Duration(seconds: 20);
    dio.options.responseType = ResponseType.json;
  }

  Future<List<ProductShoeModel>> getAll() async {
    try {
      await Future.delayed(Duration(seconds: 1));

      var res = await dio.get(
        apiLink,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'x-apikey': apiKey,
        }),
      );
      List<ProductShoeModel> items = [];
      if (res.statusCode == 200) {
        var data = res.data as List;
        if (data.isNotEmpty) {
          for (var item in data) {
            items.add(ProductShoeModel.fromJson(item));
          }
        }
      }

      return items;
    } catch (e) {
      rethrow;
    }
  } // end getAll

  Future<ProductShoeModel?> getById(String id) async {
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
        return ProductShoeModel.fromJson(data);
      } else if (res.statusCode == 404) {
        return null; // Id not found
      } else {
        throw Exception('Failed to fetch audience by id');
      }
    } catch (e) {
      rethrow;
    }
  } // end getById

  Future<List<ProductShoeModel>> getByField(String field, String value) async {
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
        final audiences = <ProductShoeModel>[];
        for (var audienceData in data) {
          audiences.add(ProductShoeModel.fromJson(audienceData));
        }
        return audiences;
      } else {
        throw Exception('Failed to fetch audience by field');
      }
    } catch (e) {
      rethrow;
    }
  } // end getByField

  Future<List<ProductShoeModel>> getByCateNameAndAudienceName(
      String value1, String value2) async {
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
        final products = <ProductShoeModel>[];

        for (var productData in data) {
          final product = ProductShoeModel.fromJson(productData);

          // Check if the product's category name matches the provided value1
          if (value1 == '0' || value1.isEmpty || value1 == null) {
            // Check if the product's audience name matches the provided value2
            if (product.audiId != null && product.audiId!.isNotEmpty) {
              bool audienceMatched = false;
              for (var audienceId in product.audiId!) {
                if (audienceId['Name'] == value2) {
                  audienceMatched = true;
                  break;
                }
              }
              if (!audienceMatched) {
                continue; // Skip to the next product if the audience didn't match
              }
            }
          } else if (value2 == '0' || value2.isEmpty || value2 == null) {
            if (product.cateId != null && product.cateId!.isNotEmpty) {
              bool categoryMatched = false;
              for (var categoryId in product.cateId!) {
                if (categoryId['Name'] == value1) {
                  categoryMatched = true;
                  break;
                }
              }
              if (!categoryMatched) {
                continue; // Skip to the next product if the category didn't match
              }
            }
          } else {
            if (product.cateId != null && product.cateId!.isNotEmpty) {
              bool categoryMatched = false;
              for (var categoryId in product.cateId!) {
                if (categoryId['Name'] == value1) {
                  categoryMatched = true;
                  break;
                }
              }
              if (!categoryMatched) {
                continue; // Skip to the next product if the category didn't match
              }
            }

            // Check if the product's audience name matches the provided value2
            if (product.audiId != null && product.audiId!.isNotEmpty) {
              bool audienceMatched = false;
              for (var audienceId in product.audiId!) {
                if (audienceId['Name'] == value2) {
                  audienceMatched = true;
                  break;
                }
              }
              if (!audienceMatched) {
                continue; // Skip to the next product if the audience didn't match
              }
            }
          }

          products.add(product);
        }

        return products;
      } else {
        throw Exception('Failed to fetch products by field');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductShoeModel>> search(String value) async {
    try {
      // Trim and convert to lowercase
      final searchValue = value.trim().toLowerCase();

      // get all products
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
        final products = <ProductShoeModel>[];

        for (var productData in data) {
          // convert to object to search in it
          final product = ProductShoeModel.fromJson(productData);

          // Trim and convert to lowercase
          final categoryName = product.cateId
              ?.map((categoryId) =>
                  (categoryId['Name'] as String).trim().toLowerCase())
              .toList();
          final audienceName = product.audiId
              ?.map((audienceId) =>
                  (audienceId['Name'] as String).trim().toLowerCase())
              .toList();

          // Check if the product's category name or audience name contains the provided value
          bool categoryMatched = false;
          if (categoryName != null && categoryName.isNotEmpty) {
            for (var category in categoryName) {
              if (category.contains(searchValue)) {
                categoryMatched = true;
                break;
              }
            }
          }
          if (!categoryMatched &&
              audienceName != null &&
              audienceName.isNotEmpty) {
            bool audienceMatched = false;
            for (var audience in audienceName) {
              if (audience.contains(searchValue)) {
                audienceMatched = true;
                break;
              }
            }
            if (!audienceMatched) {
              continue; // Skip to the next product if neither category nor audience matched
            }
          } else if (!categoryMatched &&
              (audienceName == null || audienceName.isEmpty)) {
            continue; // Skip to the next product if neither category nor audience available
          }
          products.add(product);
        }
        return products;
      } else {
        throw Exception('Failed to fetch products by field');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductShoeModel>> getRecentProducts() async {
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
        var limit = 15;
        
        final data = response.data as List<dynamic>;
        final allProducts = data
            .map((productData) => ProductShoeModel.fromJson(productData))
            .toList();
        final lastNProducts = allProducts.reversed.take(limit).toList();
        return lastNProducts;
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      rethrow;
    }
  }
}
