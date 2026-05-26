import '../domain/question.dart';

final questionSeedData = <Question>[
  Question(
    id: 'q1',
    category: QuestionCategory.commonBasics,
    questionText: '第1問: 医薬品の本質として正しいものはどれか。',
    choices: [
      '健康被害を起こす可能性が全くない',
      '適正使用が必要である',
      '食品と同じ扱いである',
      '誰でも製造できる',
    ],
    correctIndex: 1,
    explanation:
    '医薬品は有効性とリスクを持つため、適正使用が必要。',
  ),

  Question(
    id: 'q2',
    category: QuestionCategory.humanBodyAndMedicine,
    questionText: '第2問: 心臓の役割として正しいものはどれか。',
    choices: [
      '血液を循環させる',
      '尿を作る',
      '酸素を作る',
      '消化を行う',
    ],
    correctIndex: 0,
    explanation:
    '心臓は全身へ血液を送るポンプの役割を持つ。',
  ),

  Question(
    id: 'q3',
    category: QuestionCategory.mainMedicines,
    questionText: '第3問: 解熱鎮痛薬の目的として正しいものはどれか。',
    choices: [
      '熱や痛みを抑える',
      '視力を回復する',
      '骨を強くする',
      '血糖値を上げる',
    ],
    correctIndex: 0,
    explanation:
    '解熱鎮痛薬は発熱や痛みの緩和に用いる。',
  ),

  Question(
    id: 'q4',
    category: QuestionCategory.pharmaRegulations,
    questionText: '第4問: 第1類医薬品の販売時に必要なものはどれか。',
    choices: [
      '薬剤師による情報提供',
      '説明不要',
      'ネット販売のみ',
      '医師の処方箋',
    ],
    correctIndex: 0,
    explanation:
    '第1類医薬品は薬剤師による説明が必要。',
  ),

  Question(
    id: 'q5',
    category: QuestionCategory.properUseSafety,
    questionText: '第5問: 副作用被害救済制度の対象となるのはどれか。',
    choices: [
      '適正使用による副作用',
      '違法薬物',
      '食品',
      'サプリメント',
    ],
    correctIndex: 0,
    explanation:
    '適正使用にも関わらず発生した副作用が対象。',
  ),
];