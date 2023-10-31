import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/audience_model.dart';
import '../myclasses/api.dart';


class AudienceRepository {
  late Dio dio;
  String apiLink = audiencesApiLink;
  String apiKey = theApiKey;

  AudienceRepository() {
    dio = Dio();
    dio.options.connectTimeout = Duration(seconds: 20);
    dio.options.responseType = ResponseType.json;
  }

  Future<List<AudienceModel>> getAll() async {
    try {
      await Future.delayed(Duration(seconds: 1));

      var res = await dio.get(
        apiLink,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-apikey': apiKey,
          }
        ),
      );
      List<AudienceModel> items = [];
      if (res.statusCode == 200) {
        var data = res.data as List;
        if (data.isNotEmpty) {
          for (var item in data) {
            items.add(AudienceModel.fromJson(item));
            
          }
        }
      }
      return items;
    } catch (e) {
      rethrow;
    }
  } // end getAll

  Future<AudienceModel?> getById(String id) async {
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
        return AudienceModel.fromJson(data);
      } else if (res.statusCode == 404) {
        return null; // Id not found
      } else {
        throw Exception('Failed to fetch audience by id');
      }
    } catch (e) {
      rethrow;
    }
  } // end getById

  Future<List<AudienceModel>> getByField(String field, String value) async {
    try {
      final response = await dio.get(
        apiLink,
        queryParameters: {'q': jsonEncode({field: value})},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-apikey': apiKey,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        final audiences = <AudienceModel>[];
        for (var audienceData in data) {
          audiences.add(AudienceModel.fromJson(audienceData));
        }
        return audiences;
      } else {
        throw Exception('Failed to fetch audience by field');
      }
    } catch (e) {
      rethrow;
    }
  } // end getByField
}
