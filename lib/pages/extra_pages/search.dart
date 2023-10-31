import 'package:flutter/material.dart';
import 'package:shoe_shop_3/pages/one_product/item.dart';
import 'package:shoe_shop_3/reops/product_repo.dart';
import 'package:shoe_shop_3/widgets/cards/custom_card_api.dart';

import '../../../models/product_model.dart';
import '../../../widgets/custom_drawer_app_mode.dart';
import '../../../widgets/search_appbar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.value})
      : super(key: key);

  final String value;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  IconData appModeIcon = Icons.sunny;

  void updateAppModeIcon(IconData newIcon) {
    setState(() {
      appModeIcon = newIcon;
    });
  }

  Future<List<ProductShoeModel>>? _categoryData;

  @override
  void initState() {
    super.initState();
    _categoryData = _fetchcategoryData();
  }

  Future<List<ProductShoeModel>> _fetchcategoryData() async {
    final repository = ProductShoeRepository();
    return repository.search(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: SearchAppBar(context),
      drawer: CustomDrawerWithAppMode(context, updateAppModeIcon),
      body: FutureBuilder<List<ProductShoeModel>>(
        future: _categoryData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final products = snapshot.data;
            if (products == null || products.isEmpty) {
              return Center(
                child: Text(
                  'No product data found.',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              );
            } else {
              return GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Display three items in each line
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 0.5,
                ),
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) {
                  var category = products[index].cateId![0];
                  var audience = products[index].audiId![0];
                  final prod = products[index];
                  var prodName = category.name;
                  double? prodPrice = prod.price?.toDouble();
                  var prodDetails = prod.details;
                  var prodImage = prod.image;

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return ItemPage(itemId: prod.id??'0',);
                        },
                      ));
                      print(
                          '===========image : ${products[index].image ?? ''}');
                    },
                    child: CustomCard(
                      imageUrl: prodImage ?? '',
                      productName: prodName ?? '',
                      details: prodDetails ?? '',
                      price: prodPrice ?? 0.0,
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
