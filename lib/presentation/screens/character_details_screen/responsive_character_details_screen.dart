import 'package:breaking_bad_cast/data/models/character_model.dart';
import 'package:breaking_bad_cast/presentation/screens/character_details_screen/disctop_character_details_screen.dart';
import 'package:breaking_bad_cast/presentation/screens/character_details_screen/mobile_characters_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ResponsiveCharacterDetailsScreen extends StatelessWidget {
  ResponsiveCharacterDetailsScreen({Key? key, required this.character})
      : super(key: key);
  Character character;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return MobileCharacterDetailsScreen(character: character);
        } else {
          return DisctopCharacterDetailsScreen(character: character);
        }
      },
    );
  }
}
