import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../shared/models/food_item.dart';

class ClaudeAiService {
  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';
  static const String _model = 'claude-sonnet-4-20250514';
  static const String _apiVersion = '2023-06-01';

  final Dio _dio;
  final String apiKey;

  ClaudeAiService({required this.apiKey})
      : _dio = Dio(BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
        ));

  static const String _systemPrompt = '''
Analyzuj jedlo na obrázku z pohľadu refluxnej choroby. 
Vráť VÝHRADNE JSON v tomto formáte (bez markdown, bez vysvetlení):
{
  "dish_name": "Názov jedla v slovenčine",
  "ingredients": [
    {
      "name": "Názov ingrediencie",
      "ph_value": 6.0,
      "fat_level": "low|medium|high",
      "sugar_content": 0,
      "fiber_content": 0
    }
  ],
  "overall_acidity": "low|medium|high",
  "overall_fat": "low|medium|high",
  "reflux_risk": "low|medium|high",
  "reflux_risk_explanation": "Krátke vysvetlenie v slovenčine"
}
''';

  Future<FoodItem?> analyzeFoodPhoto(Uint8List imageBytes) async {
    try {
      final base64Image = base64Encode(imageBytes);

      final response = await _dio.post(
        '',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': apiKey,
            'anthropic-version': _apiVersion,
          },
        ),
        data: {
          'model': _model,
          'max_tokens': 1024,
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'image',
                  'source': {
                    'type': 'base64',
                    'media_type': 'image/jpeg',
                    'data': base64Image,
                  },
                },
                {
                  'type': 'text',
                  'text': _systemPrompt,
                },
              ],
            },
          ],
        },
      );

      if (response.statusCode == 200) {
        final content = response.data['content'] as List;
        final textContent = content.firstWhere(
          (c) => c['type'] == 'text',
          orElse: () => null,
        );

        if (textContent != null) {
          final jsonStr = textContent['text'] as String;
          final json = jsonDecode(jsonStr) as Map<String, dynamic>;

          // Add default fields for FoodItem
          json['id'] = 'scan_${DateTime.now().millisecondsSinceEpoch}';
          json['imageUrl'] = '';
          json['category'] = 'lunch';
          json['prepTimeMinutes'] = 0;
          json['difficulty'] = 'medium';
          json['recipeSteps'] = <String>[];
          json['name'] = json['dish_name'];
          json['fatLevel'] = json['overall_fat'];

          // Calculate average pH
          final ingredients = json['ingredients'] as List?;
          if (ingredients != null && ingredients.isNotEmpty) {
            final avgPh = ingredients
                    .map((i) => (i['ph_value'] as num).toDouble())
                    .reduce((a, b) => a + b) /
                ingredients.length;
            json['ph_value'] = avgPh;
          } else {
            json['ph_value'] = 7.0;
          }

          return FoodItem.fromJson(json);
        }
      }
      return null;
    } on DioException catch (e) {
      throw AiServiceException(
        'Chyba pri komunikácii s AI: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw AiServiceException('Nepodarilo sa analyzovať obrázok: $e');
    }
  }
}

class AiServiceException implements Exception {
  final String message;
  final int? statusCode;

  AiServiceException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

