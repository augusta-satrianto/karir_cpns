import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/question_model.dart';
import '../shared/shared_values.dart';

class QuestionService {
  Future<List<QuestionModel>> getQuestions() async {
    try {
      // final token = await AuthService().getToken();
      final res = await http.get(
        Uri.parse('$baseUrl/question'),
        // headers: {
        //   'Authorization': token,
        // },
      );
      print(res.statusCode);
      if (res.statusCode == 200) {
        return List<QuestionModel>.from(
          jsonDecode(res.body)['data'].map(
            (question) => QuestionModel.fromJson(question),
          ),
        ).toList();
      }

      throw jsonDecode(res.body)['message'];
    } catch (e) {
      rethrow;
    }
  }
}
