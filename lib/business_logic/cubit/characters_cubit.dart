import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../data/models/character_model.dart';
import '../../data/models/quote_model.dart';
import '../../data/repository/characters_repo.dart';
import 'package:meta/meta.dart';

part 'characters_states.dart';

class CharactersCubit extends Cubit<CharactersStates> {
  CharactersCubit(this.charactersRepository) : super(CharactersInitialState());
  final CharactersRepository charactersRepository;

  void getAllCharacters() {
    charactersRepository.getAllCharacters().then((characters) {
      emit(CharactersLoadedState(characters));
    });
  }

  void getQuotesByCharacterName(String charName) {
    charactersRepository.getQuotesByCharacterName(charName).then((quotes) {
      if (quotes.isNotEmpty) {
        emit(QuotesLoadedState(quotes));
      }
    });
  }
}
