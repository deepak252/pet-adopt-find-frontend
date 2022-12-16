import 'dart:developer';

import 'package:adopt_us/widgets/custom_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomCarousel extends StatelessWidget {
  final List<String> urls;
  final double? height;
  const CustomCarousel({ Key? key, required this.urls, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("$urls");
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: urls.isEmpty
      ? SizedBox()
      : CarouselSlider(
         items: urls
          .map((imgUrl) =>CachedNetworkImage(
            fit: BoxFit.fill,
            width: double.infinity,
            imageUrl: imgUrl,
            placeholder: (context, url) => const CustomShimmer(
              width: double.infinity
            ),
            errorWidget: (context, url, error){
              return const Padding(
                padding:  EdgeInsets.all(24),
                child: Icon(Icons.image,)
              );
            },
          )
        ).toList(),
        options: CarouselOptions(
          enableInfiniteScroll: urls.length!=1,
          viewportFraction: 1,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          scrollDirection: Axis.horizontal,
          height: height,
          
        ),
      ),
    );
  }
}