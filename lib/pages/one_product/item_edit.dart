import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoe_shop_3/models/cart_user_model.dart';
import 'package:shoe_shop_3/reops/cart_user_repo.dart';
import 'package:shoe_shop_3/reops/product_repo.dart';
import 'package:shoe_shop_3/widgets/sliders/custom_item_slider_api.dart';

import '../../../models/product_model.dart';
import '../../../myclasses/choose_color_product.dart';
import '../../helper/auth_helper.dart';

class UpdateCartItem extends StatefulWidget {
  const UpdateCartItem({
    Key? key,
    required this.prodId,
    required this.cardItem,
  }) : super(key: key);
  final String prodId;
  final CartUserModel cardItem;

  @override
  State<UpdateCartItem> createState() => _UpdateCartItemState();
}

class _UpdateCartItemState extends State<UpdateCartItem> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedColor;
  Color _labelColor = Colors.black;

  int _size = 5;
  final int _minSize = 5;
  final int _maxSize = 55;

  int _piecesNumber = 1;

  CartUserRepository carts = CartUserRepository();

  TextEditingController _sizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load the Product data by ID when the page is initialized
    _size = widget.cardItem.size!;
    _selectedColor = widget.cardItem.color!;
    _piecesNumber = widget.cardItem.numPieces!;
    _sizeController.text = widget.cardItem.size.toString();
  }

  String formattedDate(){
    DateTime dateTime = DateTime.parse(widget.cardItem.date??'');
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Edit Cart'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: FutureBuilder<ProductShoeModel?>(
          future: ProductShoeRepository()
              .getById(widget.prodId), // Fetch thisProduct details based on ID
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Center(child: CircularProgressIndicator());
            // } else
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
                          productImage: prodImage ?? '',
                        ),
                        SizedBox(height: 10.0),
                        Text("Date of adding: ${formattedDate()}", style: TextStyle(color: Colors.grey),),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '$prodName for ${audience.name}',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          '$prodDetails',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          '\$${prodPrice.toString()}',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        SizedBox(height: 16.0),
                        Divider(),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Color',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                      color: _labelColor,
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                      color: _labelColor,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _labelColor,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color:
                                        _labelColor, // Set the label color dynamically
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                value: _selectedColor,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedColor = newValue!;
                                    _labelColor = getColorFromName(
                                        newValue); // Update the label color
                                  });
                                },
                                items: colors.map((color) {
                                  return DropdownMenuItem<String>(
                                    value: color,
                                    child: Text(color),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a color';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _sizeController,
                                // initialValue: _size.toString(),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Size',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a size';
                                  }
                                  final intSize = int.tryParse(value);
                                  if (intSize == null ||
                                      intSize < _minSize ||
                                      intSize > _maxSize) {
                                    return 'Size must be between $_minSize and $_maxSize';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _size = int.tryParse(value) ?? _size;
                                  });
                                },
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Number of Pieces: $_piecesNumber',
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                  SizedBox(width: 16.0),
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        _piecesNumber--;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        _piecesNumber++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    _formKey.currentState?.save();
                                    DateTime now = DateTime.now();
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd HH:mm:ss')
                                            .format(now);
                                    CartUserModel _cart = CartUserModel(
                                      id: widget.cardItem.id,
                                      userId: AuthenticationProvider.userId,
                                      prodId: widget.prodId,
                                      color: _selectedColor,
                                      date: formattedDate,
                                      size: _size,
                                      numPieces: _piecesNumber,
                                      isPaid: false,
                                    );
                                    String? cId = widget.cardItem.id;
                                    try {
                                      CartUserModel addCart = (await carts
                                              .updateCart(cId ?? '', _cart))
                                          as CartUserModel;
                                      print(
                                          'User updated successfully! userId:${AuthenticationProvider.userId}');
                                    } catch (e) {
                                      print("Faild to update cart: $e");
                                    }
                                    setState(() {});

                                    Navigator.of(context).pop();

                                    print('Form is valid');
                                    print('Selected Color: $_selectedColor');
                                    print('Selected Size: $_size');
                                    print('Amount of Pieces: $_piecesNumber');
                                  }
                                },
                                child: Text(
                                  'Update Product',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                            ],
                          ),
                        ),
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
