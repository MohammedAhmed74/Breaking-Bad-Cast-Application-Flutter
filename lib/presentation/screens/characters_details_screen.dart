import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import '../../business_logic/cubit/characters_cubit.dart';
import '../../constants/my_colors.dart';
import '../../data/models/character_model.dart';
import '../../data/models/quote_model.dart';
import '../../data/repository/characters_repo.dart';
import '../../data/web_services/characters_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;
  CharacterDetailsScreen({super.key, required this.character});
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

  // Spliting the quote to appeare in 3 levels
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
                              quoteWidget: buildCharacterQuote(state.quotes)))
                          : SliverChildListDelegate(buildSliverDelegateList())),
                ],
              );
            },
          ),
        );
      }),
    );
  }

//**************************** UI functions *************************************

  Widget buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: MyColors.myGrey,
      pinned: true,
      stretch: true,
      expandedHeight: 600,
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

  List<Widget> buildSliverDelegateList({Widget? quoteWidget}) {
    List<Widget> sliverDelegateList = [
      const SizedBox(
        height: 20,
      ),
    ];
    actorInfo.forEach((key, value) {
      if (value != null && value != '') {
        sliverDelegateList.add(buildSliverDelegateItem(key, value));
        sliverDelegateList.add(
            buildDivider(key.toString().length * 13, key.toString().length));
      }
    });
    sliverDelegateList.add(Container(
      height: 40,
    ));
    sliverDelegateList.add(Center(child: quoteWidget ?? Container()));
    sliverDelegateList.add(Container(
      height: 400,
    ));
    return sliverDelegateList;
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
              style: const TextStyle(
                fontSize: 22.0,
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
            style: const TextStyle(
                color: MyColors.myWhite,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Color.fromARGB(255, 176, 176, 176),
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }

  Widget buildDivider(double width, int titleLength) {
    if (width > 150) {
      width = titleLength * 11;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 15, right: 400 - width, left: 10),
      child: Container(
        height: 2,
        color: MyColors.myYellow,
      ),
    );
  }
}
