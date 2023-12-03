import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../data/model/event_model.dart';

class EventImage extends StatelessWidget {
  final EventModel event;
  final void Function()? onPressed;
  const EventImage({super.key, required this.event, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          20.0,
        ),
        border: Border.all(width: 1, color: Colors.black12),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onPressed,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                    imageUrl: event.url,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Container(
                      color: Colors.black,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                event.title,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      ),
    );
  }
}
