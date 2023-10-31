import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

import '../myclasses/api.dart';

// check internet connection
Future<bool> checkInternetConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult != ConnectivityResult.none;
}

//check api connection
Future<bool> checkApiAvailability() async {
  try {
    final response = await http.get(
      Uri.parse(productsApiLink),
      headers: {'x-apikey': theApiKey},
    );
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}