import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MyCarousel extends StatelessWidget {
  const MyCarousel({super.key, required this.images});

 final List<Widget> images;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: images,
      options: CarouselOptions(
        height: 400,
        viewportFraction: 1,
        // reverse: true,
        autoPlay: true,
        // autoPlayInterval: Duration(seconds: 10),
      ),
    );
  }
}
