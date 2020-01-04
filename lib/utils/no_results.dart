import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class NoResults extends StatelessWidget {
  const NoResults({Key key, this.message, this.height}) : super(key: key);

  final String message;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: const AssetImage('assets/images/no_results.png'),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}
