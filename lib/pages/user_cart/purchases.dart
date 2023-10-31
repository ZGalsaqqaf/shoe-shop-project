import 'package:flutter/material.dart';
import 'package:shoe_shop_3/helper/auth_helper.dart';
import 'package:shoe_shop_3/reops/cart_user_repo.dart';

import '../../../widgets/custom_drawer_app_mode.dart';
import '../../../widgets/search_appbar.dart';
import '../../models/cart_user_model.dart';
import '../../models/product_model.dart';
import '../../reops/product_repo.dart';
import '../one_product/item_details.dart';

class PurchasesPage extends StatefulWidget {
  const PurchasesPage({super.key});

  @override
  State<PurchasesPage> createState() => _PurchasesPageState();
}

class _PurchasesPageState extends State<PurchasesPage> {
  IconData appModeIcon = Icons.sunny;

  double totalPrice = 0;

  void updateAppModeIcon(IconData newIcon) {
    setState(() {
      appModeIcon = newIcon;
    });
  }

  Future<List<CartUserModel>>? _cardData;
  CartUserRepository _cards = CartUserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: SearchAppBar(context),
      drawer: CustomDrawerWithAppMode(context, updateAppModeIcon),
      body: Container(
        child: FutureBuilder<List<CartUserModel>>(
          future: CartUserRepository().getByFieldWithCheckIsPaid(
              "User_id", AuthenticationProvider.userId ?? '', true),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                    child: Text("Error: ${snapshot.error.toString()}"));
              }
              var items = snapshot.data ?? [];
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    totalPrice;
                  });
                },
                child: items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage(
                                  "assets/images/shop/shpping-img1.png"),
                              height: 200,
                              width: 200,
                            ),
                            SizedBox(height: 20,),
                            Text("You haven't any purchases yet"),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return FutureBuilder<ProductShoeModel?>(
                            future: ProductShoeRepository()
                                .getById(items[index].prodId ?? ''),
                            builder: (context, snapshot) {
                              // if (snapshot.connectionState ==
                              //     ConnectionState.waiting) {
                              //   return CircularProgressIndicator();
                              // } else
                              if (snapshot.hasError) {
                                return Text(
                                    "Error: ${snapshot.error.toString()}");
                              } else if (snapshot.hasData) {
                                ProductShoeModel product = snapshot.data!;
                                var cate = product.cateId![0];
                                var audi = product.audiId![0];
                                var catName = cate.name;
                                var audName = audi.name;
                                var price = product.price;
                                var image = product.image;
                                var quantity = items[index].numPieces;
                                var total = price! * quantity!;

                                return Card(
                                  color: Colors.grey[200],
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Image.network(
                                            image ?? '',
                                            width: 80.0,
                                            height: 80.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(width: 16.0),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                      return ItemDetailsPage(
                                                        prodId:
                                                            product.id ?? '',
                                                        cardItem: items[index],
                                                      );
                                                    }),
                                                  ).then((_) {
                                                    setState(() {});
                                                  });
                                                  ;
                                                },
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      catName ?? '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline1,
                                                    ),
                                                    SizedBox(height: 8.0),
                                                    Text(
                                                      '\$${total.toStringAsFixed(2)}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 8.0),
                                              Text(
                                                'Quantity: ${items[index].numPieces}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return SizedBox(); // Placeholder widget or loading indicator
                              }
                            },
                          );
                        },
                      ),
              );
            } else {
              return Center(
                child: Text("Error: ${snapshot.error.toString()}"),
              );
            }
          },
        ),
      ),
    );
  }
}
