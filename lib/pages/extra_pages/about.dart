import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('About Us'),
        
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Our Shoe Shop!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/images/shop/shop1.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'At Our Shoe Shop, we are passionate about providing our customers with the latest and most fashionable footwear. With a wide range of shoes for men, women, and children, we strive to cater to every individual\'s style and comfort.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              'Quality and Durability',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'We believe in offering high-quality shoes that are not only stylish but also durable. Our shoes are crafted using premium materials to ensure long-lasting wear and comfort.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/images/shop/shop2.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Customer Satisfaction',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Customer satisfaction is our top priority. We strive to provide exceptional customer service and a seamless shopping experience. Our knowledgeable staff is always available to assist you in finding the perfect pair of shoes.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
