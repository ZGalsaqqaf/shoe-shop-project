import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoe_shop_3/home_bottom_nav_var.dart';
import 'package:shoe_shop_3/reops/check_connection.dart';
import 'package:shoe_shop_3/theme/app_theme.dart';
import 'package:shoe_shop_3/theme/theme_provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
  checkConnectivityAndApiAvailability();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
      return MaterialApp(
        title: 'Shoe Shop',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeProvider.currentTheme == AppTheme.darkTheme
            ? ThemeMode.dark
            : ThemeMode.light,
        routes: {
          '/': (context) => HomeBtmNavBarPage(),
        },
        initialRoute: '/',
      );
    });
  }
}

void checkConnectivityAndApiAvailability() async {
  bool isConnected = await checkInternetConnectivity();
  bool isApiAvailable = await checkApiAvailability();

  if (isConnected && isApiAvailable) {
    print("isConnected: $isConnected,  isApiAvailable: $isApiAvailable");
    // Both internet and API are available, navigate to HomeBtmNavBarPage
    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: MyApp(),
      ),
    );
  } else {
    // Either internet or API is not available, show an error message
    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.brown[50],
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("assets/images/shop/warning.png"),
                  height: 200,
                  width: 200,
                ),
                SizedBox(
                  height: 20,
                ),
                Text("There is something worng !"),
                Text("Check Internet connection and try again."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
