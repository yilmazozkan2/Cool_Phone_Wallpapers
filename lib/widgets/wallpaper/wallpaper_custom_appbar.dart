import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WallpaperCustomAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  WallpaperCustomAppBar({
    super.key,
    required this.context,
    required this.images,
    required this.query2,

  });
  String query2; // arama yerine yazılan kelimeyi içeren devam fotoğrafları
  List images;
  BuildContext context;

  @override
  State<WallpaperCustomAppBar> createState() => _WallpaperCustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(56);
}

class _WallpaperCustomAppBarState extends State<WallpaperCustomAppBar> {
  Widget cusAppBarTitle = Text('Harika Telefon Duvar Kağıtları');
  Icon cusIcon = Icon(Icons.search);
  TextEditingController editText = TextEditingController();


  @override
  Widget build(context) {
    return AppBar(
        title: cusAppBarTitle,
        centerTitle: true,
        toolbarHeight: 70,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: Colors.white),
        backgroundColor: Colors.green,
        actions: <Widget>[
          SearchImgIconButton(context),
        ]);
  }

  IconButton SearchImgIconButton(context) {
    return new IconButton(
      onPressed: () {
        setState(() {
          if (this.cusIcon.icon == Icons.search) {
            this.cusIcon = new Icon(Icons.close);
            this.cusAppBarTitle = new TextField(
              onChanged: (query) => search(query),
              controller: editText,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: Colors.white),
              decoration: new InputDecoration(
                  hintText: 'Görsel Ara...',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white),
                  prefixIcon: new Icon(Icons.search, color: Colors.white)),
            );
          } else {
            this.cusIcon = new Icon(Icons.search);
            this.cusAppBarTitle = Text('Harika Telefon Duvar Kağıtları');
            editText.clear();
            widget.query2 = '';
            gethttp();
          }
        });
      },
      icon: cusIcon,
    );
  }

  Future<void> search(String query) async {
    query = editText.text;
    widget.query2 = query;
    try {
      if (query == '') {
        gethttp();
      } else {
        var url = Uri.parse(
            "https://api.pexels.com/v1/search?query=$query&per_page=80");
        var response = await http.get(url, headers: {
          "Authorization":
              '563492ad6f9170000100000106ac4ff7d65a4577b251cd0da8606d73'
        });
        Map<String, dynamic> result = jsonDecode(response.body);
        setState(() {
          widget.images = result['photos'];
        });
        print(widget.images);
      }
    } catch (e) {
      print('Hata Search Yerinde' + e.toString());
    }
  }

  Future<http.Response> gethttp() async {
    var url = Uri.parse("https://api.pexels.com/v1/curated?per_page=80");
    var response = await http.get(url, headers: {
      "Authorization":
          '563492ad6f9170000100000106ac4ff7d65a4577b251cd0da8606d73'
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      setState(() {
        widget.images = result['photos'];
      });
    } else if (response.statusCode > 200) {
      print('Hata Kodu 200 Üstü');
    }
    return response;
  }
}
