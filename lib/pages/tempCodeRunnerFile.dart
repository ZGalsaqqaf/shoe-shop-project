import 'package:flutter/material.dart';
import 'package:shoe_shop_3/pages/one_product/item.dart';
import 'package:shoe_shop_3/reops/product_repo.dart';
import 'package:shoe_shop_3/widgets/cards/custom_card_api.dart';

import '../../../models/product_model.dart';
import '../../../widgets/custom_drawer_app_mode.dart';
import '../../../widgets/search_appbar.dart';

class NewProductsPage extends StatefulWidget {
  const NewProductsPage({Key? key})
      : super(key: key);

  @override
  State<NewProductsPage> createState() => _NewProductsPageState();
}

class _NewProductsPageState extends State<NewProductsPage> {
  IconData appModeIcon = Icons.sunny;

  void updateAppModeIcon(IconData newIcon) {
    setState(() {
      appModeIcon = newIcon;
    });
  }

  late ScrollController _scrollController;
  List<ProductShoeModel> _products = [];
  int _startIndex = 0;
  int _batchSize = 12;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _fetchProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchMoreProducts();
    }
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final repository = ProductShoeRepository();
      final products = await repository.getRecentProducts();
      setState(() {
        _products = products;
      });
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchMoreProducts() async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = ProductShoeRepository();
      final moreProducts = await repository.getRecentProducts(
        startIndex: _startIndex + _products.length,
        batchSize: _batchSize,
      );
      setState(() {
        _products.addAll(moreProducts);
      });
    } catch (e) {
      print('Error fetching more products: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: SearchAppBar(context),
      drawer: CustomDrawerWithAppMode(context, updateAppModeIcon),
      body: _buildProductGridView(),
    );
  }

  Widget _buildProductGridView() {
    if (_products.isEmpty && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_products.isEmpty) {
      return Center(
        child: Text(
          'No category data found.',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );
    } else {
      return GridView.builder(
        controller: _scrollController,
        itemCount: _products.length + (_isLoading ? 1 : 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Display three items in each line
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 0.5,
        ),
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, index) {
          if (index < _products.length) {
            var category = _products[index].cateId![0];
            var audience = _products[index].audiId![0];
            final prod = _products[index];
            var prodName = category.name;
            double? prodPrice = prod.price?.toDouble();
            var prodDetails = prod.details;
            var prodImage = prod.image;

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    // return ProductImagesAll(value: prod.id??'0', productImage: prodImage??'',);
                    return ItemPage(itemId: prod.id ?? '0');
                  },
                ));
                print('===========image : ${_products[index].image ?? ''}');
              },
              child: CustomCard(
                imageUrl: prodImage ?? '',
                productName: prodName ?? '',
                details: prodDetails ?? '',
                price: prodPrice ?? 0.0,
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    }
  }
}

class ProductShoeRepository {
  Future<List<ProductShoeModel>> getRecentProducts({
    int startIndex = 0,
    int batchSize = 12,
  }) async {
    // Your logic to fetch recent products using the startIndex and batchSize parameters
    // Make an HTTP request or perform any other necessary operations
    // Return a list of ProductShoeModel objects

    // For demonstration purposes, returning an empty list
    return [];
  }
}