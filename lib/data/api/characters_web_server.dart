import 'package:breaking_bad_bloc/constants/Strings.dart';
import 'package:dio/dio.dart';

class CharacterWebServices {
  late Dio dio;

  CharacterWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: 20 * 1000, // 60 seconds,
      receiveTimeout: 20 * 1000,
    );

    dio = Dio(options);
  }

  Future<List<dynamic>> fetchCharacters() async {
    try {
      Response response = await dio.get('characters');
      return response.data;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> fetchCharactersQuotes(String charName) async {
    try {
      Response response = await dio.get(
          'quote',
          queryParameters: {'author' : charName}
      );
      return response.data;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}