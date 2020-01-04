import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PageRoutes{

  void cupertinoNavigation(Widget widget,BuildContext context){
    Navigator.of(context).push(
      CupertinoPageRoute<Widget>(
        builder: (BuildContext context) => widget,
      ),
    );
  }
  void materialNavigation(Widget widget,BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) => widget,
      ),
    );
  }
}