import 'package:cloud_firestore/cloud_firestore.dart';

class AiUsageService {
  AiUsageService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<bool> canUseAi({required String userId, int maxPerDay = 3}) async {
    final doc = _firestore.collection('ai_usage').doc(userId);
    final key = _dayKey(DateTime.now());
    final snap = await doc.get();
    final data = snap.data() ?? <String, dynamic>{};
    final date = data['date'] as String?;
    final count = (data['count'] as num?)?.toInt() ?? 0;
    return !(date == key && count >= maxPerDay);
  }

  Future<void> consumeAiUse({required String userId}) async {
    final doc = _firestore.collection('ai_usage').doc(userId);
    final key = _dayKey(DateTime.now());
    final snap = await doc.get();
    final data = snap.data() ?? <String, dynamic>{};
    final date = data['date'] as String?;
    final count = (data['count'] as num?)?.toInt() ?? 0;
    final todayCount = date == key ? count : 0;
    await doc.set({'date': key, 'count': todayCount + 1});
  }

  String _dayKey(DateTime dt) => '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}
