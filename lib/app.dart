import 'package:flutter/material.dart';

import 'src/core/theme/app_theme.dart';
import 'src/features/questions/presentation/pages/question_list_page.dart';

class TouhanApp extends StatelessWidget {
  const TouhanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '登録販売者 試験対策アプリ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const QuestionListPage(),
    );
  }
}
