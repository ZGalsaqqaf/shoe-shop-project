// Get Categories of Each Audience ==> Sneakers, Heels, Boots, ....

import 'package:flutter/material.dart';
import 'package:shoe_shop_3/models/category_model.dart';
import 'package:shoe_shop_3/pages/cate_prod/products.dart';
import 'package:shoe_shop_3/reops/category_repo.dart';

import '../../../widgets/custom_drawer_app_mode.dart';
import '../../../widgets/search_appbar.dart';

class AllCategoriesPage extends StatefulWidget {
  const AllCategoriesPage(
      {super.key, required this.field, required this.value});
  final String field;
  final String value;

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  IconData appModeIcon = Icons.sunny;

  void updateAppModeIcon(IconData newIcon) {
    setState(() {
      appModeIcon = newIcon;
    });
  }

  Future<List<CategoryModel>>? _categoryData;

  @override
  void initState() {
    super.initState();
    _categoryData = _fetchcategoryData();
  }

  Future<List<CategoryModel>> _fetchcategoryData() async {
    final repository = CategoryRepository();
    return repository.getByField(widget.field, widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: SearchAppBar(context),
      drawer: CustomDrawerWithAppMode(context, updateAppModeIcon),
      body: FutureBuilder<List<CategoryModel>>(
        future: _categoryData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final categories = snapshot.data;
            if (categories == null || categories.isEmpty) {
              return Text(
                'No category data found.',
                style: Theme.of(context).textTheme.bodyText1,
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: categories.isEmpty
                    ? Center(child: Text("No Data"))
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ProductsPage(
                                  value1: '${categories[index].name}',
                                  value2: '${categories[index].audience}',
                                );
                              }));
                            },
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          categories[index].image ?? ''),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(
                                            0.4), // Adjust background image opacity (0.0 to 1.0)
                                        BlendMode
                                            .darken, // Apply a dark overlay
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 16.0),
                                        Text(
                                          '${categories[index].name}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: categories.length,
                      ),
              );
            } else {
              return Center(
                child: Text("Error: ${snapshot.error.toString()}"),
              );
            }
          }
        },
      ),
    );
  }
}
