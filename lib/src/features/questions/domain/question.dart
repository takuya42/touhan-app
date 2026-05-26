enum QuestionCategory {
  commonBasics,
  humanBodyAndMedicine,
  mainMedicines,
  pharmaRegulations,
  properUseSafety,
}

extension QuestionCategoryX on QuestionCategory {
  String get label {
    switch (this) {
      case QuestionCategory.commonBasics:
        return '医薬品に共通する特性と基本的な知識';
      case QuestionCategory.humanBodyAndMedicine:
        return '人体の働きと医薬品';
      case QuestionCategory.mainMedicines:
        return '主な医薬品とその作用';
      case QuestionCategory.pharmaRegulations:
        return '薬事関連法規・制度';
      case QuestionCategory.properUseSafety:
        return '医薬品の適正使用・安全対策';
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
