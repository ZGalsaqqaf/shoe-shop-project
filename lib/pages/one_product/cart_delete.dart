import 'package:flutter/material.dart';
import 'package:shoe_shop_3/reops/cart_user_repo.dart';

class CartDelete extends StatefulWidget {
  const CartDelete({Key? key, required this.itemId}) : super(key: key);
  final String itemId;

  @override
  State<CartDelete> createState() => _CartDeleteState();
}

class _CartDeleteState extends State<CartDelete> {
  String txtConfirm = "Do you want to delete this item?";
  bool loading = false;
  bool isError = false;
  String errorMsg = "";
  String successMsg = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Icon(Icons.delete),
      content: Container(
        constraints: BoxConstraints(
          maxWidth: 250,
          minWidth: 150,
          maxHeight: 200,
          minHeight: 100,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            loading
                ? CircularProgressIndicator()
                : Text(
                    txtConfirm,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
            isError
                ? Text(
                    "Error: $errorMsg",
                    style: TextStyle(color: Colors.red),
                  )
                : Text(
                    successMsg,
                    style: TextStyle(color: Colors.green),
                  ),
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      setState(() {
                        loading = true;
                        isError = false;
                        errorMsg = "";
                        successMsg = "";
                      });
                      var addRes =
                          await CartUserRepository().deleteCart(widget.itemId);
                      if (addRes > 0) {
                        setState(() {
                          loading = false;
                          isError = false;
                          successMsg = "Added successfully";
                        });
                        Navigator.of(context).pop(true);
                      } else {
                        setState(() {
                          loading = false;
                          isError = true;
                          errorMsg = "Operation Faild";
                        });
                      }
                    } catch (e) {
                      setState(() {
                        loading = false;
                        isError = true;
                        errorMsg = "Exception: ${e.toString()}";
                      });
                    }
                  },
                  child: Text("Yes"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
