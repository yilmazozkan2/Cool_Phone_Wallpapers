import 'package:flutter/material.dart';
import 'package:android_enyeni_duvarkagitlari/wallpaper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Wallpaper()
    );
  }
}