import 'package:breaking_bad_cast/presentation/screens/character_details_screen/responsive_character_details_screen.dart';

import '../../constants/my_colors.dart';
import '../../data/models/character_model.dart';
import 'package:flutter/material.dart';

class CharacterItem extends StatelessWidget {
  CharacterItem(
      {Key? key, required this.characters, required this.characretIndex})
      : super(key: key);
  List<Character> characters;
  int characretIndex;
  late Character character = characters[characretIndex];
  @override
  Widget build(BuildContext context) {
    // HTTP request failed, statusCode: 502, can't be catched !!
    if (character.name == 'Lydia Rodarte-Quayle' ||
        character.name == 'Skinny Pete') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/images/notFound.png', fit: BoxFit.contain),
      );
    }
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ResponsiveCharacterDetailsScreen(characters: characters, characterIndex: characretIndex),
            ));
      },
      child: Container(
        margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
        padding: const EdgeInsetsDirectional.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
          color: MyColors.myWhite,
          borderRadius: BorderRadius.circular(12),
        ),
        child: GridTile(
          footer: Container(
            width: double.infinity,
            height: 65,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            alignment: Alignment.bottomCenter,
            child: Center(
              child: Text(
                character.name,
                style: const TextStyle(
                  height: 1.3,
                  fontSize: 14,
                  color: MyColors.myWhite,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          child: character.image.isNotEmpty
              ? Builder(builder: (context) {
                  return Container(
                    decoration: BoxDecoration(
                      color: MyColors.myWhite,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Hero(
                      tag: character.charId,
                      child: FadeInImage.assetNetwork(
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: 'assets/images/loading.gif',
                        image: character.image,
                        placeholderErrorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/notFound.png',
                              fit: BoxFit.fitWidth);
                        },
                      ),
                    ),
                  );
                })
              : Image.asset('assets/images/notFound.png'),
        ),
      ),
    );
  }
}
