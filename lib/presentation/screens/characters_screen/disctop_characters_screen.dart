import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

import '../../../business_logic/cubit/characters_cubit.dart';
import '../../../constants/my_colors.dart';
import '../../../data/models/character_model.dart';
import '../../widgets/character_item.dart';
import '../no_internet_screen.dart';

class DisctopCharactersScreen extends StatefulWidget {
  const DisctopCharactersScreen({Key? key}) : super(key: key);

  @override
  State<DisctopCharactersScreen> createState() =>
      _DisctopCharactersScreenState();
}

class _DisctopCharactersScreenState extends State<DisctopCharactersScreen> {
  List<Character> allCharacters = [];
  List<Character> wantedCharacters = [];
  bool? isSearching;
  var searchCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

//**************************** Logic functions **********************************

  void searchForCharacter(String searchText) {
    wantedCharacters = [];
    wantedCharacters = allCharacters.where((character) {
      return character.name.toLowerCase().startsWith(searchText.toLowerCase());
    }).toList();
    setState(() {});
  }

//****************************     Builder     **********************************
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHight = MediaQuery.of(context).size.height;
    return BlocBuilder<CharactersCubit, CharactersStates>(
        builder: (context, state) {
      if (state is CharactersLoadedState) {
        allCharacters = state.characters;
      }
      return Scaffold(
        appBar: isSearching == true ? searchAppBar() : noramlAppBar(),
        body: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            if (!connected) {
              return const NoInternetScreen();
            }
            return allCharacters.isNotEmpty
                ? buildCharactersList(deviceWidth, deviceHight)
                : buildLoadingWidget();
          },
          child: buildLoadingWidget(),
        ),
      );
    });
  }

//**************************** UI functions *************************************

  Widget buildCharactersList(double screenWidth, double screenHight) {
    // character's name doesn't exist
    if (searchCtrl.text.isNotEmpty && wantedCharacters.isEmpty) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: MyColors.myGrey,
        child: const Center(
          child: Text(
            'There is no actor with such name',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ),
      );
    }

    // character's name exist
    return Container(
      color: MyColors.myGrey,
      padding: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (screenWidth / 250).round(),
            childAspectRatio: 2 / 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemBuilder: (context, index) =>
              searchCtrl.text.isEmpty && wantedCharacters.isEmpty
                  ? CharacterItem(
                      characters: allCharacters, characretIndex: index,) // presentation/widgets/CharacterItem
                  : CharacterItem(
                      characters: wantedCharacters, characretIndex: index,), // presentation/widgets/CharacterItem
          itemCount: wantedCharacters.isEmpty
              ? allCharacters.length
              : wantedCharacters.length,
        ),
      ),
    );
  }

  Widget buildLoadingWidget() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: MyColors.myGrey,
      child: const Center(
        child: CircularProgressIndicator(
          color: MyColors.myYellow,
        ),
      ),
    );
  }

  AppBar noramlAppBar() {
    return AppBar(
      backgroundColor: MyColors.myYellow,
      title: const Text(
        'Characters',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
              onPressed: () {
                setState(() {
                  isSearching = true;
                });
              },
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              )),
        )
      ],
    );
  }

  AppBar searchAppBar() {
    return AppBar(
      backgroundColor: MyColors.myYellow,
      title: TextFormField(
        controller: searchCtrl,
        onChanged: (searchText) {
          searchForCharacter(searchText);
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          // border: InputBorder.none,
          hintText: 'Search for an actor',
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
        cursorColor: MyColors.myGrey,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
              onPressed: () {
                setState(() {
                  isSearching = false;
                  wantedCharacters = [];
                  searchCtrl.text = '';
                });
              },
              icon: const Icon(
                Icons.clear,
                color: Colors.black,
              )),
        )
      ],
    );
  }
}
