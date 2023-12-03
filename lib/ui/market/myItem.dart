import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyItem extends StatefulWidget {
  final String id;
  final String title;
  final String price;
  final String content;
  final String url;
  MyItem(
      {Key? key,
      required this.id,
      required this.title,
      required this.price,
      required this.content,
      required this.url})
      : super(key: key);

  @override
  State<MyItem> createState() => _MyItemState();
}

class _MyItemState extends State<MyItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.width - 20,
                child: CachedNetworkImage(
                  imageUrl: widget.url,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Container(
                    color: Colors.black,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              )),
        ],
      ),
    );
  }
}
