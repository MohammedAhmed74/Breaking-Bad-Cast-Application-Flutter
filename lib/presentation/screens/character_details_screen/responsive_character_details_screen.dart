import 'package:breaking_bad_cast/constants/sizes.dart';
import 'package:breaking_bad_cast/data/models/character_model.dart';
import 'package:breaking_bad_cast/presentation/screens/character_details_screen/disctop_character_details_screen.dart';
import 'package:breaking_bad_cast/presentation/screens/character_details_screen/mobile_characters_details_screen.dart';
import 'package:flutter/material.dart';

class ResponsiveCharacterDetailsScreen extends StatelessWidget {
  ResponsiveCharacterDetailsScreen(
      {Key? key, required this.characters, required this.characterIndex})
      : super(key: key);
  List<Character> characters;
  int characterIndex;
  late Character character = characters[characterIndex];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < miniTabletScreenWidth) {
          return MobileCharacterDetailsScreen(characters: characters, characterIndex: characterIndex,);
        } else {
          return DisctopCharacterDetailsScreen(characters: characters, characterIndex: characterIndex,);
        }
      },
    );
  }
}
