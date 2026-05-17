import '../domain/question.dart';

abstract class AiExplanationService {
  Future<String> generateExplanation(Question question);
}

class MockAiExplanationService implements AiExplanationService {
  @override
  Future<String> generateExplanation(Question question) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return 'AI解説（モック）: 「${question.questionText}」は${question.category.label}分野です。解説: ${question.explanation}';
  }
}
