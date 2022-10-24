import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:breaking_bad_cast/constants/sizes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../business_logic/cubit/characters_cubit.dart';
import '../../../constants/my_colors.dart';
import '../../../data/models/character_model.dart';
import '../../../data/models/quote_model.dart';
import '../../../data/repository/characters_repo.dart';
import '../../../data/web_services/characters_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisctopCharacterDetailsScreen extends StatefulWidget {
  List<Character> characters;
  int characterIndex;

  DisctopCharacterDetailsScreen(
      {super.key, required this.characters, required this.characterIndex});

  @override
  State<DisctopCharacterDetailsScreen> createState() =>
      _DisctopCharacterDetailsScreenState();
}

class _DisctopCharacterDetailsScreenState
    extends State<DisctopCharacterDetailsScreen> {
  late Character character = widget.characters[widget.characterIndex];

//**************************** Logic functions **********************************
  int getRandomQuote(int qoutesLength) {
    return Random().nextInt(qoutesLength - 1);
  }

  Map fillActorInformations(Character char) {
    Map actorInfo = {
      'Job': char.jobs,
      'Appeared in': char.categoryForTwoSeries,
      'Breaking Bad seasons': char.appearanceOfSeasons,
      'Status': char.statusIfDeadOrAlive,
      'Better Call Saul Seasons': char.betterCallSaulAppearance,
      'Actor/Actress': char.acotrName,
    };
    return actorInfo;
  }

  List<Widget> getCharacterInfo(
      {List<Quote>? quotes, required Character char}) {
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
    Map actorInfo = fillActorInformations(char);
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

  late int currentIndex;
  @override
  void initState() {
    currentIndex = widget.characterIndex;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

//****************************     Builder     **********************************
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHight = MediaQuery.of(context).size.height;
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
              return Row(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: deviceHight,
                          width:
                              deviceWidth - 400 < 450 ? deviceWidth - 400 : 450,
                          //deviceWidth - 400 > 450 ? 450 : deviceWidth - 400,
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
                    width: deviceWidth / 50, //just small space
                  ),
                  Builder(builder: (context) {
                    final double width;
                    if (deviceWidth > miniPCScreenWidth) {
                      //pc mode
                      width = deviceWidth -
                          900; // 900 => image.width + listView.width
                    } else {
                      //tablet mode
                      width = 350;
                    }
                    return SizedBox(
                      width: width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: state is QuotesLoadedState
                            ? getCharacterInfo(
                                quotes: state.quotes,
                                char: widget.characters[currentIndex])
                            : getCharacterInfo(
                                char: widget.characters[currentIndex]),
                      ),
                    );
                  }),
                  const Spacer(),
                  Builder(
                    builder: (context) {
                      if (deviceWidth > miniPCScreenWidth) {
                        // pc mode
                        return Container(
                          width: 300,
                          color: MyColors.myYellow.withOpacity(0.7),
                          child: ListView.builder(
                            itemBuilder: (context, index) =>
                                buildSingleCharacterItem(
                                    widget.characters[index], index),
                            itemCount: widget.characters.length,
                          ),
                        );
                      }
                      return Container();
                    },
                  )
                ],
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

  Widget buildSingleCharacterItem(Character character, int index) {
    return InkWell(
      onTap: () {
        currentIndex = index;
        this.character = character;
        setState(() {});
      },
      child: Container(
        color: index == currentIndex
            ? MyColors.myGrey
            : MyColors.myYellow.withOpacity(0.7),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  clipBehavior: Clip.antiAlias,
                  child: Builder(builder: (context) {
                    if (character.name == 'Lydia Rodarte-Quayle' ||
                        character.name == 'Skinny Pete') {
                      return Image.asset('assets/images/notFound.png');
                    }
                    return Image.network(
                      character.image,
                      fit: BoxFit.cover,
                    );
                  }),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      character.nickName,
                      style: TextStyle(
                          fontSize: 20,
                          color: index == currentIndex
                              ? MyColors.myYellow
                              : MyColors.myGrey,
                          fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      character.acotrName,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
