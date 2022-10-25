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

class MobileCharacterDetailsScreen extends StatelessWidget {
  final List<Character> characters;
  final int characterIndex;
  late Character character = characters[characterIndex];
  MobileCharacterDetailsScreen({
    super.key,
    required this.characters,
    required this.characterIndex
  });
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

  // Spliting the quote 3 levels
  // List<String> getQuoteAfterSplit(Quote quote) {
  //   print(quote.text);
  //   List<String> quoteAfterSplit = quote.text.split(' ');
  //   int quotePartsNum = (quoteAfterSplit.length / 3).round();
  //   List<String> quoteParts = ['', '', ''];
  //   int counter = 0;
  //   for (int i = 0; i < quoteAfterSplit.length; i++) {
  //     quoteParts[counter] += '${quoteAfterSplit[i]} ';
  //     if (quoteAfterSplit.length == quotePartsNum ||
  //         quoteAfterSplit.length == quotePartsNum * 2) counter++;
  //   }
  //   return quoteParts;
  // }

//****************************     Builder     **********************************

  @override
  Widget build(BuildContext context) {
    var charactersServices = CharactersServices();
    var charactersRepository = CharactersRepository(charactersServices);

    double deviceWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => CharactersCubit(charactersRepository),
      child: Builder(builder: (context) {
        BlocProvider.of<CharactersCubit>(context)
            .getQuotesByCharacterName(character.name);
        return Scaffold(
          backgroundColor: MyColors.myGrey,
          body: BlocBuilder<CharactersCubit, CharactersStates>(
            builder: (context, state) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  buildSliverAppBar(),
                  SliverList(
                      delegate: state is QuotesLoadedState
                          ? SliverChildListDelegate(buildSliverDelegateList(
                              quoteWidget: buildCharacterQuote(state.quotes),
                              deviceWidth: deviceWidth))
                          : SliverChildListDelegate(
                              buildSliverDelegateList(deviceWidth: deviceWidth),
                            )),
                ],
              );
            },
          ),
        );
      }),
    );
  }

//**************************** UI functions *************************************


  List<Widget> buildSliverDelegateList(
      {Widget? quoteWidget, required double deviceWidth}) {
    List<Widget> sliverDelegateList = [
      SizedBox(
        height: 20.sp,
      ),
    ];
    // filling actorInfo with all required informations
    actorInfo.forEach((key, value) {
      if (value != null && value != '') {
        sliverDelegateList.add(buildSliverDelegateItem(key, value));
        sliverDelegateList.add(buildDivider(
            key.toString().length * 13, key.toString().length, deviceWidth));
      }
    });
    sliverDelegateList.add(Container(
      height: 40.sp,
    ));
    sliverDelegateList.add(Center(child: quoteWidget ?? Container()));
    sliverDelegateList.add(Container(
      height: 400.sp,
    ));
    return sliverDelegateList;
  }

  Widget buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: MyColors.myGrey,
      pinned: true,
      stretch: true,
      expandedHeight: 600.sp,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          character.nickName,
          style: const TextStyle(color: MyColors.myWhite),
        ),
        background: Hero(
          tag: character.charId,
          child: Image.network(
            character.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

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

  Widget buildSliverDelegateItem(String title, String value) {
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

  Widget buildDivider(double width, int titleLength, double deviceWidth) {
    if (width > 150) {
      width = titleLength * 11;
    }
    return Padding(
      padding: EdgeInsets.only(right: deviceWidth - width, left: 10),
      child: Container(
        height: 0.8.sp,
        color: MyColors.myYellow,
      ),
    );
  }
}
