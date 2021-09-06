import 'package:breaking_bad_bloc/data/api/characters_web_server.dart';
import 'package:breaking_bad_bloc/data/model/Character.dart';
import 'package:breaking_bad_bloc/data/model/quotes.dart';

class CharactersRepository {
  final CharacterWebServices charactersWebServices;

  CharactersRepository(this.charactersWebServices);

  Future<List<Character>> fetchCharacters() async {
    final characters = await charactersWebServices.fetchCharacters();
    return characters.map((character) => Character.fromJson(character)).toList();
  }

  Future<List<Quote>> fetchCharactersQuotes(String charName) async {
    final quotes = await charactersWebServices.fetchCharactersQuotes(charName);
    return quotes.map((charQuotes) => Quote.fromJson(charQuotes)).toList();
  }

}