import 'dart:ui';

import 'package:blogitup/pages/blog_feed.dart';
import 'package:blogitup/pages/root_page.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlareTick extends StatelessWidget {
  const FlareTick({Key key, this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .popUntil((Route<dynamic> route) => route.isFirst);
        },
        child: WillPopScope(
          onWillPop: () {
            return Future<bool>.value(false);
          },
          child: Stack(
            children: <Widget>[
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
              ),
              Dialog(
                backgroundColor: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 100,
                                child: Transform.scale(
                                  scale: 3,
                                  child: const FlareActor(
                                    'assets/flare/tick_animation.flr',
                                    animation: 'Checkmark_appear',
                                    sizeFromArtboard: true,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Text(
                                  message,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
