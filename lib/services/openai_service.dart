import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  final Dio _dio;
  final String apiKey;
  final String systemPrompt;

  OpenAIService({
    String? apiKey,
    this.systemPrompt = "You are a helpful AI assistant.",
  })  : apiKey = apiKey ?? dotenv.env['OPENAI_API_KEY'] ?? '',
        _dio = Dio(
          BaseOptions(
            baseUrl: 'https://api.openai.com/v1',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ' + (apiKey ?? dotenv.env['OPENAI_API_KEY'] ?? ''),
            },
          ),
        );

  Future<String> getChatCompletion(List<Map<String, String>> messages) async {
    final data = {
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        ...messages,
      ],
      'max_tokens': 256,
      'temperature': 0.7,
    };
    final response = await _dio.post('/chat/completions', data: data);
    if (response.statusCode == 200) {
      return response.data['choices'][0]['message']['content'] as String;
    } else {
      throw Exception('Failed to get response: \\${response.data}');
    }
  }

  Future<String> getChatCompletionWithPrompt(List<Map<String, String>> messages, String systemPrompt) async {
    final data = {
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        ...messages,
      ],
      'max_tokens': 256,
      'temperature': 0.7,
    };
    final response = await _dio.post('/chat/completions', data: data);
    if (response.statusCode == 200) {
      return response.data['choices'][0]['message']['content'] as String;
    } else {
      throw Exception('Failed to get response: \\${response.data}');
    }
  }
}
