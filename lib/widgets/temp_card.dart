import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TempCard extends StatelessWidget {
  final MediaQueryData mediaquery;
  final String text;
  final Color color;
  final String body;

  TempCard({this.mediaquery, this.text, this.color, this.body});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: mediaquery.size.width*0.23,
      child: Card(
        elevation: 1.5,
        shadowColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              AutoSizeText(text,style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: mediaquery.size.height*0.02,),
              AutoSizeText(body,style: TextStyle(color: color,fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
    );
  }
}
