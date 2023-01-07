import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final double borderRadius;
  final double? height;
  final double? width;
  const CustomShimmer({ Key? key, this.height =10, this.width=10, this.borderRadius=0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.5), 
        highlightColor: Colors.grey.withOpacity(0.2),
        enabled: true,
        child: Container(
          color: Colors.white,
          height: height,
          width: width,
        )
      ),
    );
  }
}