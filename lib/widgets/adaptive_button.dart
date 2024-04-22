import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {

    final String text;
  final void Function() handler;

   AdaptiveFlatButton({required this.text,required this.handler});





  @override
  Widget build(BuildContext context) {
    return  Platform.isIOS ? CupertinoButton(
                       onPressed: handler,
                        child:  Text(
                          text,
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        )
                     )

                    : MaterialButton(
                        onPressed: handler,
                        child:  Text(
                          text,
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        )
                        );
  }
}