import 'package:flutter/material.dart';

class ShowMoreImgContainer extends StatelessWidget {
  const ShowMoreImgContainer({super.key});

  @override
  Widget build(BuildContext context) {
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