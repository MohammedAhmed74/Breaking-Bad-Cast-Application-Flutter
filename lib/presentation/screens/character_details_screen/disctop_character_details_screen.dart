import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../business_logic/cubit/characters_cubit.dart';
import '../../../constants/my_colors.dart';
import '../../../data/models/character_model.dart';
import '../../../data/models/quote_model.dart';
import '../../../data/repository/characters_repo.dart';
import '../../../data/web_services/characters_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisctopCharacterDetailsScreen extends StatelessWidget {
  final Character character;
  DisctopCharacterDetailsScreen({super.key, required this.character});
  late Map actorInfo = {
    'Job': character.jobs,
    'Appeared in': character.categoryForTwoSeries,
    'Breaking Bad seasons': character.appearanceOfSeasons,
    'Status': character.statusIfDeadOrAlive,
    'Better Call Saul Seasons': character.betterCallSaulAppearance,
    'Actor/Actress': character.acotrName,
  };

//**************************** Logic functions **********************************
  int getRandomQuote(int qoutesLength) {
    return Random().nextInt(qoutesLength - 1);
  }

  List<Widget> getCharacterInfo({List<Quote>? quotes}) {
    final List<Widget> charInformations = [
      Text(
        character.nickName,
        style: TextStyle(
          color: MyColors.myYellow,
          fontSize: 26.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      SizedBox(
        height: 25.sp,
      ),
    ];
    actorInfo.forEach((key, value) {
      if (value != null && value != '') {
        charInformations.add(buildSingleInformation(key, value));
        charInformations.add(
            buildDivider(key.toString().length * 13, key.toString().length));
      }
    });
    if (quotes != null) {
      charInformations.add(
        SizedBox(
          height: 50.sp,
        ),
      );
      charInformations.add(buildCharacterQuote(quotes));
    }
    return charInformations;
  }

//****************************     Builder     **********************************

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHight = MediaQuery.of(context).size.height;
    print(deviceWidth);
    final charactersServices = CharactersServices();
    final charactersRepository = CharactersRepository(charactersServices);

    return BlocProvider(
      create: (context) => CharactersCubit(charactersRepository),
      child: Builder(builder: (context) {
        BlocProvider.of<CharactersCubit>(context)
            .getQuotesByCharacterName(character.name);
        return Scaffold(
          backgroundColor: MyColors.myGrey,
          body: BlocBuilder<CharactersCubit, CharactersStates>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            height: deviceHight,
                            width: deviceWidth - 400 > 450
                                ? 450
                                : deviceWidth - 400,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            child: Image.network(
                              character.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: BackButton(
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: deviceWidth / 50,
                    ),
                    Container(
                      width: deviceWidth - 450 > 500 ? 430 : 350,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: state is QuotesLoadedState
                            ? getCharacterInfo(quotes: state.quotes)
                            : getCharacterInfo(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

//**************************** UI functions *************************************

  Widget buildCharacterQuote(List<Quote>? qoutes) {
    int randomIndex = 0;
    if (qoutes!.length > 1) {
      randomIndex = getRandomQuote(qoutes.length);
    }
    //List<String> quoteParts = getQuoteAfterSplit(qoutes[randomIndex]);
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DefaultTextStyle(
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontFamily: 'Agne',
                color: MyColors.myYellow,
                fontWeight: FontWeight.bold,
              ),
              child: AnimatedTextKit(
                repeatForever: true,
                displayFullTextOnTap: true,
                animatedTexts: [
                  TypewriterAnimatedText(qoutes[randomIndex].text),
                  // TypewriterAnimatedText(quoteParts[1]),
                  // TypewriterAnimatedText(quoteParts[2]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider(double width, int titleLength) {
    if (width > 150) {
      width = titleLength * 11;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        height: 2,
        width: width,
        color: MyColors.myYellow,
      ),
    );
  }

  Widget buildSingleInformation(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Text(
            '$title : ',
            style: TextStyle(
                color: MyColors.myWhite,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: const Color.fromARGB(255, 176, 176, 176),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }
}
