import 'package:breaking_bad_cast/presentation/screens/characters_screen/disctop_characters_screen.dart';
import 'package:breaking_bad_cast/presentation/screens/characters_screen/mobile_characters_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ResponsiveCharacterScreen extends StatelessWidget {
  const ResponsiveCharacterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return const MobileCharactersScreen();
        } else {
          return const DisctopCharactersScreen();
        }
      },
    );
  }
}
