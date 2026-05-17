enum QuestionCategory { medicine, humanBody, law }

extension QuestionCategoryX on QuestionCategory {
  String get label {
    switch (this) {
      case QuestionCategory.medicine:
        return '医薬品';
      case QuestionCategory.humanBody:
        return '人体';
      case QuestionCategory.law:
        return '法規';
    }
  }
}

class Question {
  const Question({
    required this.id,
    required this.category,
    required this.questionText,
    required this.choices,
    required this.correctIndex,
    required this.explanation,
  }) : assert(choices.length == 4, '4択問題は選択肢が4つ必要です。');

  final String id;
  final QuestionCategory category;
  final String questionText;
  final List<String> choices;
  final int correctIndex;
  final String explanation;

  bool isCorrect(int selectedIndex) => selectedIndex == correctIndex;
}
