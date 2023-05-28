import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class FullScreen extends StatefulWidget {

  final String imageurl;
  FullScreen({Key? key,required this.imageurl}) : super(key: key);
  @override
  State<FullScreen> createState() => _FullScreenState();
}
class _FullScreenState extends State<FullScreen> {
  InterstitialAd? _interstitialAd;

  _save() async {
    var status = await Permission.storage.request();
    if(status.isGranted) {
      var response = await Dio().get(
          widget.imageurl,
          options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100,
          name: "aizensoftimage");
      print(result);
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
      body: Column(
        children: [
          Expanded(child: Container(
            child: Image.network(widget.imageurl),
          )),
          InkWell(
            onTap: () async{
              LoadInterstitialAd();
            },
            child: DownloadImgContainer(context),
          ),
        ],
      )),
    );
  }

  Container DownloadImgContainer(BuildContext context) {
    return Container(
              height: 55,
              width: double.infinity,
              color: Colors.green,
              child: Center(
                child: Text(
                  'Görseli İndir',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color:Colors.white),
                ),
              ));
  }

  Future<void> LoadInterstitialAd() {
    return InterstitialAd.load(
                adUnitId: 'ca-app-pub-8924173754312904/4836047252',
                request: AdRequest(),
                adLoadCallback: InterstitialAdLoadCallback(
                    onAdLoaded: (ad){
                      this._interstitialAd = ad;
                      _interstitialAd!.show();
                      print('ad loaded');
                      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
                          onAdFailedToShowFullScreenContent: ((ad, error){
                            ad.dispose();
                            _interstitialAd!.dispose();
                          }),
                          onAdDismissedFullScreenContent: (ad){
                            ad.dispose();
                            _interstitialAd!.dispose();
                            _save();
                          }
                      );
                    }, onAdFailedToLoad: (LoadAdError error){
                  print('InterstitialAd failed '+error.toString());
                }));
  }
}