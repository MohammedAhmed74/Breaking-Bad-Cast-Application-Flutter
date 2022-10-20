part of 'characters_cubit.dart';

@immutable
abstract class CharactersStates {}

class CharactersInitialState extends CharactersStates {}

class CharactersLoadedState extends CharactersStates {
  final List<Character> characters;
  CharactersLoadedState(this.characters);
}

class QuotesLoadedState extends CharactersStates {
  final List<Quote> quotes;
  QuotesLoadedState(this.quotes);
}
