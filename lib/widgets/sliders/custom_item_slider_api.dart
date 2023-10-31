import 'package:flutter/material.dart';
import 'package:shoe_shop_3/models/images_product_model.dart';
import 'package:shoe_shop_3/reops/images_product_repo.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomItemSliderApi extends StatefulWidget {
  const CustomItemSliderApi(
      {Key? key, required this.value, required this.productImage})
      : super(key: key);
  final String value; // prodId
  final String productImage; //prod img to show it if there is no imgs in ImageProduct table

  @override
  State<CustomItemSliderApi> createState() => _CustomItemSliderApiState();
}

class _CustomItemSliderApiState extends State<CustomItemSliderApi> {
  Future<List<ImagesProductModel>>? _imagesData;

  @override
  void initState() {
    super.initState();
    _imagesData = _fetchImageData();
  }

  Future<List<ImagesProductModel>> _fetchImageData() async {
    final repository = ImagesProductRepository();
    return repository.getImagesByProductId(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ImagesProductModel>>(
        future: _imagesData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final images = snapshot.data;
            if (images == null || images.isEmpty) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          '${widget.productImage}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              final imageUrls = images
                  .map((img) => img.image)
                  .where((url) => url != null)
                  .toList();

              final prodImageUrl = images[0].prodId?[0].image;

              return CarouselSlider.builder(
                itemCount: imageUrls.length + 1,
                itemBuilder: (context, index, _) {
                  if (index == 0) {
                    // start with product image
                    return Container(
                      width: double.infinity,
                      child: Image.network(
                        prodImageUrl ?? '',
                        fit: BoxFit.cover,
                      ),
                    );
                  } else {
                    final imageUrl = imageUrls[index - 1]!;
                    return Container(
                      width: double.infinity,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                },
                options: CarouselOptions(
                  aspectRatio: 16 / 9, // Set the desired aspect ratio
                  viewportFraction:
                      0.95, // Set the desired item size as a fraction of the viewport
                  enableInfiniteScroll:
                      false, // Set to true if you want the slider to loop infinitely
                  initialPage: 0, // Set the initial page index
                ),
              );
            }
          }
        },
    );
  }
}
