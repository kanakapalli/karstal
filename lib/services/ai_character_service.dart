import 'dart:convert';
import 'package:flutter/services.dart';
import '../features/chat/model/ai_character.dart';

class AICharacterService {
  static Future<List<AICharacter>> loadCharacters() async {
    final data = await rootBundle.loadString('assets/data/professional_ai_characters.json');
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((e) => AICharacter.fromJson(e)).toList();
  }
}
