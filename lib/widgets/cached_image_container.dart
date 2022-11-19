import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageContainer extends StatelessWidget {
  final String imgUrl;
  final double borderRadius;
  final double? height;
  final double? width;
  final Color? borderColor;
  final IconData? placeholderIcon;
  const CachedImageContainer({ Key? key, 
    required this.imgUrl,
    this.borderRadius = 100,
    this.borderColor,
    this.height,
    this.width,
    this.placeholderIcon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: height??70,
      width: width??70,
      decoration: BoxDecoration(
        // shape: BoxShape.rectangle,
        border: Border.all(
          color: borderColor?? Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(borderRadius)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular( borderRadius),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          height: height??70,
          width: width??70,
          alignment: Alignment.topCenter, 
          imageUrl: imgUrl,
          placeholder: (context, url) => FittedBox(
            fit: BoxFit.cover,
            child: Icon(
              placeholderIcon??Icons.image,
              color: Colors.grey,
              size: height??70,
            ),
          ),
          errorWidget: (context, url, error) => Icon(
            placeholderIcon??Icons.image,
            color: Colors.grey,
            size: height??70,
          ),
        ),
      ),
    );
  }
}