import '../domain/question.dart';

final questionSeedData = <Question>[
  Question(
    id: 'q_001',
    category: QuestionCategory.medicine,
    questionText:
        '一般用医薬品（OTC）の購入時に、登録販売者が最優先で確認すべきことはどれですか。',
    choices: [
      '商品のパッケージデザイン',
      '購入者の年齢・症状・併用薬',
      'メーカーの知名度',
      'ポイント還元率',
    ],
    correctIndex: 1,
    explanation:
        '安全使用のため、年齢・症状・併用薬など背景情報の確認が最優先です。',
  ),

  Question(
    id: 'q_002',
    category: QuestionCategory.humanBody,
    questionText: '胃の主な働きとして正しいものはどれですか。',
    choices: [
      '酸素と二酸化炭素の交換',
      '血液中の老廃物ろ過',
      '食物の一時貯留と消化',
      'ホルモン分泌のみを行う',
    ],
    correctIndex: 2,
    explanation:
        '胃は食物を一時的に貯留し、胃酸や消化酵素で消化を進めます。',
  ),

  Question(
    id: 'q_003',
    category: QuestionCategory.law,
    questionText:
        '登録販売者が販売できる医薬品区分として正しいものはどれですか。',
    choices: [
      '要指導医薬品',
      '第一類医薬品',
      '第二類・第三類医薬品',
      '医療用医薬品のみ',
    ],
    correctIndex: 2,
    explanation:
        '登録販売者は、原則として第二類医薬品および第三類医薬品を販売できます。',
  ),
];