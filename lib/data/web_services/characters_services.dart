
import 'package:dio/dio.dart';
import '../../constants/const_strings.dart';

class CharactersServices {
  late Dio dio;

  CharactersServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: 20 * 1000, //20s
      receiveTimeout: 20 * 1000, //20s
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> getCharacters() async {
    try {
      Response response = await dio.get(charactersEndPoint);
      return response.data;
    } catch (error) {
      return [];
    }
  }

    Future<List<dynamic>> getQuotesByCharacterName(String charName) async {
    try {
      Response response = await dio.get(quotesEndPoint, queryParameters: {'author' : charName});
      return response.data;
    } catch (error) {
      return [];
    }
  }
}
