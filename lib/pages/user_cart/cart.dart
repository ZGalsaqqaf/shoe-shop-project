import 'package:flutter/material.dart';
import 'package:shoe_shop_3/helper/auth_helper.dart';
import 'package:shoe_shop_3/pages/one_product/item_edit.dart';
import 'package:shoe_shop_3/pages/user_cart/purchases.dart';
import 'package:shoe_shop_3/reops/cart_user_repo.dart';

import '../../../widgets/custom_drawer_app_mode.dart';
import '../../../widgets/search_appbar.dart';
import '../../models/cart_user_model.dart';
import '../../models/product_model.dart';
import '../../reops/product_repo.dart';
import '../user_op/add_creditcart_number.dart';
import '../one_product/cart_delete.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<double>? totalPrice;

  @override
  void initState() {
    super.initState();
    _initializeTotalPrice();
  }

  Future<void> _initializeTotalPrice() async {
    totalPrice = _fetchCategoryData();
  }

  Future<double> _fetchCategoryData() async {
    final repository = CartUserRepository();
    return repository
        .getTotalPriceOfUnpaidItems(AuthenticationProvider.userId ?? '');
  }

  Future<List<CartUserModel>>? _cardData;
  CartUserRepository _cards = CartUserRepository();

  @override
  Widget build(BuildContext context) {
    IconData appModeIcon = Icons.sunny;

    void updateAppModeIcon(IconData newIcon) {
      setState(() {
        appModeIcon = newIcon;
      });
    }

    return Scaffold(
      appBar: SearchAppBar(context),
      drawer: CustomDrawerWithAppMode(context, updateAppModeIcon),
      body: Container(
        child: FutureBuilder<List<CartUserModel>>(
          future: CartUserRepository().getByFieldWithCheckIsPaid(
              "User_id", AuthenticationProvider.userId ?? '', false),
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
                  setState(() {});
                },
                child: items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage(
                                  "assets/images/shop/shopping-cart1.png"),
                              height: 200,
                              width: 200,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 50),
                              child: Text("You're cart is empty"),
                            ),
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
                                                      return UpdateCartItem(
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
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () async {
                                            await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CartDelete(
                                                    itemId:
                                                        items[index].id ?? '',
                                                  );
                                                }).then((_) {
                                              setState(() {});
                                            });
                                            // Implement the remove item functionality
                                          },
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
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        color: Theme.of(context).colorScheme.secondary,
        child: AuthenticationProvider.isLoggedIn.value
            ? FutureBuilder<double>(
                future: CartUserRepository().getTotalPriceOfUnpaidItems(
                    AuthenticationProvider.userId ?? ''),
                builder: (context, snapshot) {
                  // if (snapshot.connectionState == ConnectionState.waiting) {
                  //   return CircularProgressIndicator();
                  // } else
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error.toString()}");
                  } else {
                    double totalPrice = snapshot.data ?? 0;
                    print(
                        "=====================Total price: ${totalPrice.toStringAsFixed(2)}");
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: \$${totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (AuthenticationProvider.userCreditCard != null &&
                                AuthenticationProvider.userCreditCard != '') {
                              try {
                                print(
                                    "credit : ${AuthenticationProvider.userCreditCard}");
                                // empty the cart when do checkout
                                List<CartUserModel> unpaidItems =
                                    await _cards.getUnpaidItems(
                                        AuthenticationProvider.userId ?? '');
                                setState(() {});
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return PurchasesPage();
                                  }),
                                );
                              } catch (e) {
                                print("Error occurs: $e");
                              }
                            } else {
                              print("No Credit Card");
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Credit Card Required',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                    content: Text(
                                        "We don't have your credit card \nPlease Add it first to buy your purchases."),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                      ),
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                              return AddCreditCardNumber(
                                                userId: AuthenticationProvider
                                                        .userId ??
                                                    '',
                                              );
                                            }),
                                          ).then((_) {
                                            setState(() {
                                              // Refresh the UI after adding the credit card
                                            });
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Text(
                            'Checkout',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      ],
                    );
                  }
                },
              )
            : Row(),
      ),
    );
  }
}
