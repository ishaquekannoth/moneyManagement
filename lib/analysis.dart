import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Analysis extends StatelessWidget {
  const Analysis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome To analysis Page'),centerTitle: true,
    ),
    body: Center(child: Text('OOPS...Nothing implimented here yet..',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
    
    );
  }
}
