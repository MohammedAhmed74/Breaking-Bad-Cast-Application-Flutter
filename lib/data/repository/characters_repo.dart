import '../models/character_model.dart';
import '../models/quote_model.dart';
import '../web_services/characters_services.dart';

class CharactersRepository {
  final CharactersServices charactersServices;
  CharactersRepository(this.charactersServices);

  Future<List<Character>> getAllCharacters() async {
    final characters = await charactersServices.getCharacters();
    return characters
        .map((character) => Character.fromJson(character))
        .toList();
  }

  Future<List<Quote>> getQuotesByCharacterName(String charName) async {
    final quotes = await charactersServices.getQuotesByCharacterName(charName);
    return quotes.map((quote) => Quote.fromJson(quote)).toList();
  }
}
