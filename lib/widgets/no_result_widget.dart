import 'package:flutter/material.dart';

class NoResultWidget extends StatelessWidget {
  final String? title;
  final bool showRefresh;
  final VoidCallback? onRefresh;


  const NoResultWidget({ Key? key, 
    this.title, 
    this.showRefresh=true,
    this.onRefresh
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child : Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(showRefresh)
              IconButton(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
              ),
            if(title!=null)
              Text(title!),
            
          ],
        )
      )
    );
  }
}