import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:android_enyeni_duvarkagitlari/fullscreen.dart';
class Wallpaper extends StatefulWidget {
  const Wallpaper({Key? key}) : super(key: key);

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  TextEditingController editText = TextEditingController();
  List images = [];
  int page = 1;
  BannerAd? bannerAd;
  bool isBannerAdLoaded = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-8924173754312904/6651390482",
      listener: BannerAdListener(onAdFailedToLoad: (ad, error) {
        print("Ad Failed to Load");
        ad.dispose();
      }, onAdLoaded: (ad) {
        print("Ad Loaded");
        setState(() {
          isBannerAdLoaded = true;
        });
      }),
      request: const AdRequest(),
    );
    bannerAd!.load();
  }
  @override
  void initState(){
    super.initState();
    try{
      gethttp();
    }
    catch(e){}
  }
  //gethttp
  Future<http.Response> gethttp() async {
    var url = Uri.parse("https://api.pexels.com/v1/curated?per_page=80");
    var response = await http.get(url,
        headers: {
          "Authorization":'563492ad6f9170000100000106ac4ff7d65a4577b251cd0da8606d73'
        });

    if(response.statusCode == 200){
      Map<String, dynamic> result = jsonDecode(response.body);
      setState(() {
        images = result['photos'];
      });
    }else if(response.statusCode >200){
      print('Hata Kodu 200 Üstü');
    }
    return response;
  }

  String query2 = ''; // arama yerine yazılan kelimeyi içeren devam fotoğrafları
  Future<void> search(String query)async{
   query = editText.text;
   query2 = query;
   try {
     if (query == '') {
       gethttp();
     } else {
       var url = Uri.parse( "https://api.pexels.com/v1/search?query=$query&per_page=80");
       var response = await http.get(url,
           headers: {
             "Authorization":'563492ad6f9170000100000106ac4ff7d65a4577b251cd0da8606d73'
           });
       Map<String, dynamic> result = jsonDecode(response.body);
       setState(() {
         images = result['photos'];
       });
       print(images);
     }
   }catch(e){print('Hata Search Yerinde'+e.toString());}
  }
  Future<void> loadmore()async{
    setState(() {
      page++;
    });
    if(query2 == ''){
      await http.get(
          Uri.parse('https://api.pexels.com/v1/curated?per_page=80&page='+page.toString()), headers: {
        'Authorization': '563492ad6f9170000100000106ac4ff7d65a4577b251cd0da8606d73'
      }).then((value) {
        Map<String, dynamic> result = jsonDecode(value.body);
        //Map result = jsonDecode(value.body);
        setState(() {
          images.addAll(result['photos']);
        });
        print(images);
      });

    }else{
      await http.get(
          Uri.parse("https://api.pexels.com/v1/search?query="+query2+"&per_page=80&page="+page.toString()), headers: {
        'Authorization': '563492ad6f9170000100000106ac4ff7d65a4577b251cd0da8606d73'
      }).then((value) {
        Map<String, dynamic> result = jsonDecode(value.body);
        setState(() {
          images.addAll(result['photos']);
        });
        print(images);
      });
    }
  }
  Icon cusIcon = Icon(Icons.search);
  Widget cusAppBarTitle = Text('Harika Telefon Duvar Kağıtları');
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: CustomAppBar(context),
          backgroundColor: Colors.white,
        body: Column(
            children: [
              isBannerAdLoaded
                  ? SizedBox(
                width: double.infinity,
                height: 50,
                child: AdWidget(
                  ad: bannerAd!,
                ),
              )
                  : SizedBox(),
              Text('Görseller pexels.com tarafından pexels api kullanılarak sağlanmaktadır'),
              Expanded(child: buildGridView()),
              InkWell(
                onTap: () {
                  loadmore();
                },
                child: ShowMoreImgContainer(),
              )
            ],
        ),
        ),
    );
  }

  GridView buildGridView() {
    return GridView.builder(
                itemCount: images.length > 0 ? images.length : 0,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing:0,
                      crossAxisCount: 3,
                      childAspectRatio: 2 / 4,
                    mainAxisSpacing: 0
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(// ClipRRect e alırsak Resimlerin kenarlarını oval hale getirebiliriz.
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => FullScreen(imageurl: images[index]['src']['large2x'])));
                        },
                        child: Container(
                          child: Image.network(images[index]['src']['portrait'],fit: BoxFit.cover),),
                      );
                  },);
  }

  AppBar CustomAppBar(BuildContext context) {
    return AppBar(title:cusAppBarTitle, centerTitle: true,
          toolbarHeight: 70, // Set this height
          titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:Colors.white),
          backgroundColor: Colors.green,
          actions: <Widget>[
            SearchImgIconButton(context),
      ]);
  }

  IconButton SearchImgIconButton(BuildContext context) {
    return new IconButton(onPressed: () {
              setState(() {
                if(this.cusIcon.icon == Icons.search){
                  this.cusIcon = new Icon(Icons.close);
                  this.cusAppBarTitle = new TextField(
                    onChanged: (query) => search(query),
                    controller: editText,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(color:Colors.white),
                    decoration: new InputDecoration(
                      hintText: 'Görsel Ara...',
                      hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color:Colors.white),
                      prefixIcon: new Icon(Icons.search,color:Colors.white)
                    ),
                  );

                }
                else{
                  this.cusIcon = new Icon(Icons.search);
                  this.cusAppBarTitle = Text('Harika Telefon Duvar Kağıtları');
                  editText.clear();
                  query2='';
                  gethttp();
                }
              });
            }, icon: cusIcon,
            );
  }

  Container ShowMoreImgContainer() {
    return Container(
                  height: 55,
                  width: double.infinity,
                  color: Colors.green,
                  child: Center(
                    child: Text(
                      'Daha Fazlasını Göster',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ));
  }
}
