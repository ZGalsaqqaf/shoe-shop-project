import 'package:flutter/material.dart';
import 'package:shoe_shop_3/models/images_product_model.dart';
import 'package:shoe_shop_3/reops/images_product_repo.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomHomeSlider extends StatefulWidget {
  const CustomHomeSlider({Key? key});

  @override
  State<CustomHomeSlider> createState() => _CustomHomeSliderState();
}

class _CustomHomeSliderState extends State<CustomHomeSlider> {
  Future<List<ImagesProductModel>>? _imagesData;

  @override
  void initState() {
    super.initState();
    _imagesData = _fetchImageData();
  }

  Future<List<ImagesProductModel>> _fetchImageData() async {
    final repository = ImagesProductRepository();
    return repository.getAll(10);
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
            return const Text("There are no images!");
          } else {
            return CarouselSlider.builder(
              itemCount: images.length,
              itemBuilder: (context, index, _) {
                return SizedBox(
                  width: 300, // Increase the width
                  height: 100, // Decrease the height
                  child: Image.network(
                    '${images[index].image}',
                    fit: BoxFit.cover,
                  ),
                );
              },
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                aspectRatio: 3/2, // Set aspect ratio to 1 for square images
                // Add more options as needed
              ),
            );
          }
        }
      },
    );
  }
}