import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ZoomImage extends StatelessWidget {
  final String url;
  const ZoomImage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Hero(
          tag: url,
          child: CachedNetworkImage(
            imageUrl: this.url,
            fit: BoxFit.fill,
            placeholder: (context, url) => Container(
              color: Colors.black,
            ),
            errorWidget: (context, url, error) =>
                CircularProgressIndicator.adaptive(),
          ),
        ),
      ),
    );
  }
}
