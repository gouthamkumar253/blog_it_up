import 'package:flutter/material.dart';
import 'package:blogitup/services/authentication.dart';
import 'package:blogitup/pages/root_page.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog It Up',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(
        seconds: 4,
        navigateAfterSeconds: RootPage(
          auth: Auth(),
        ),
        image: Image.asset(
          'assets/images/blog_home.png',
          fit: BoxFit.contain,
          colorBlendMode: BlendMode.clear,
        ),
        backgroundColor: Colors.blue.withOpacity(0.1),
        photoSize: 200,
        //styleTextUnderTheLoader: const TextStyle(),
        loaderColor: Colors.blue,
      ),
    );
  }
}
