import 'package:flutter/material.dart';

import '../../fullscreen.dart';

class GridViewBuilder extends StatelessWidget {
  GridViewBuilder({
    super.key,
    required this.images,
  });
  List images;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: images.length > 0 ? images.length : 0,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 0,
          crossAxisCount: 3,
          childAspectRatio: 2 / 4,
          mainAxisSpacing: 0),
      itemBuilder: (context, index) {
        return InkWell(
          // ClipRRect e alırsak Resimlerin kenarlarını oval hale getirebiliriz.
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    FullScreen(imageurl: images[index]['src']['large2x'])));
          },
          child: Container(
            child: Image.network(images[index]['src']['portrait'],
                fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
