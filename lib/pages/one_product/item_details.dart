import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoe_shop_3/models/cart_user_model.dart';
import 'package:shoe_shop_3/reops/cart_user_repo.dart';
import 'package:shoe_shop_3/reops/product_repo.dart';
import 'package:shoe_shop_3/widgets/sliders/custom_item_slider_api.dart';

import '../../../models/product_model.dart';

class ItemDetailsPage extends StatefulWidget {
  const ItemDetailsPage({
    Key? key,
    required this.prodId,
    required this.cardItem,
  }) : super(key: key);
  final String prodId;
  final CartUserModel cardItem;

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedColor;
  Color _labelColor = Colors.black;

  int _size = 5;
  final int _minSize = 5;
  final int _maxSize = 55;

  int _piecesNumber = 1;

  CartUserRepository carts = CartUserRepository();

  String formattedDate(){
    DateTime dateTime = DateTime.parse(widget.cardItem.date??'');
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDate;
  }


  Widget itemShow(String desc, String value) {
    return Row(
      children: [
        Text(
          '$desc:',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          '$value',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 15,
          ),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: FutureBuilder<ProductShoeModel?>(
          future: ProductShoeRepository()
              .getById(widget.prodId), // Fetch thisProduct details based on ID
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              ProductShoeModel thisProduct = snapshot.data!;
              var category = thisProduct.cateId![0];
              var audience = thisProduct.audiId![0];
              final prod = thisProduct;
              var prodName = category.name;
              double? prodPrice = prod.price?.toDouble();
              var prodDetails = prod.details;
              var prodImage = prod.image;
              List<String> allImages = [];
              allImages.add(prodImage ?? '');
              return ListView(
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomItemSliderApi(
                          value: widget.prodId,
                          productImage: prodImage ?? '', // send the prod img to show it if there is no images in prodimg table
                        ),
                        SizedBox(height: 10.0),
                        Text("Date of buying: ${formattedDate()}", style: TextStyle(color: Colors.grey),),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '$prodName',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          '$prodDetails',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 20,
                        ),
                        itemShow("Price", "\$${prodPrice.toString()}"),
                        itemShow("Color", "${widget.cardItem.color}"),
                        itemShow("Size", "${widget.cardItem.size.toString()}"),
                        itemShow("Quantity", "${widget.cardItem.numPieces.toString()}"),
                        Divider(
                          color: Colors.grey,
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              'Total Paid:',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '\$${widget.cardItem.numPieces! * prodPrice!}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Text('No thisProduct found');
            }
          },
        ),
      ),
    );
  }
}
