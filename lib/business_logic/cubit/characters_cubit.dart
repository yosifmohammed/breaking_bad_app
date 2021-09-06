import 'package:bloc/bloc.dart';
import 'package:breaking_bad_bloc/data/model/Character.dart';
import 'package:breaking_bad_bloc/data/model/quotes.dart';
import 'package:breaking_bad_bloc/data/repositry/characters_repo.dart';
import 'package:meta/meta.dart';
part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepository charactersRepository;
  List<Character> characters = [];

  CharactersCubit(this.charactersRepository) : super(CharactersInitial());

  List<Character> fetchCharacters() {
    charactersRepository.fetchCharacters().then((characters) {
      emit(CharactersLoaded(characters));
      this.characters = characters;
    });
    return characters;
  }

  void fetchQuotes(String charName) {
    charactersRepository.fetchCharactersQuotes(charName).then((quotes) {
      emit(QuotesLoaded(quotes));
    });
  }
}
