import 'package:breaking_bad_bloc/business_logic/cubit/characters_cubit.dart';
import 'package:breaking_bad_bloc/constants/Strings.dart';
import 'package:breaking_bad_bloc/data/api/characters_web_server.dart';
import 'package:breaking_bad_bloc/data/model/Character.dart';
import 'package:breaking_bad_bloc/data/repositry/characters_repo.dart';
import 'package:breaking_bad_bloc/presentation/screens/characters_screen.dart';
import 'package:breaking_bad_bloc/presentation/screens/characters_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  late CharactersRepository charactersRepository;
  late CharactersCubit charactersCubit;

  AppRouter() {
    charactersRepository = CharactersRepository(CharacterWebServices());
    charactersCubit = CharactersCubit(charactersRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charactersScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => charactersCubit,
            child: CharactersScreen(),
          ),
        );
      case characterDetailsScreen:
        final character = settings.arguments as Character;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) =>
            CharactersCubit(charactersRepository),
            child: CharacterDetailsScreen(
              character: character,
            ),
          ),
        );
    }
  }
}