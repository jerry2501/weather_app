import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SunTimeCard extends  StatelessWidget {
  final MediaQueryData mediaquery;
  final String imgUrl;
  final String body;

  SunTimeCard(this.mediaquery, this.imgUrl, this.body);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      child: Column(
        children: [
          Container(
            height:(mediaquery.size.height*0.10)-5,
            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
            child:  Image.asset('${imgUrl}',fit: BoxFit.fitHeight,),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(body,style: TextStyle(fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    );
  }
}
