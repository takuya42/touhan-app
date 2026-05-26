import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const int freePlanAnswerLimit = 30;

final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final planAccessServiceProvider = Provider<PlanAccessService>(
  (ref) => PlanAccessService(
    auth: FirebaseAuth.instance,
    firestore: ref.watch(firestoreProvider),
  ),
);

class PlanUsageStatus {
  const PlanUsageStatus({required this.plan, required this.freeAnswerCount});

  final String plan;
  final int freeAnswerCount;

  bool get isPro => plan.toLowerCase() == 'pro';
  bool get canAnswer => isPro || freeAnswerCount < freePlanAnswerLimit;
  int get remainingFreeAnswers => (freePlanAnswerLimit - freeAnswerCount).clamp(0, freePlanAnswerLimit);
}

class PlanAccessService {
  PlanAccessService({required FirebaseAuth auth, required FirebaseFirestore firestore})
      : _auth = auth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Future<PlanUsageStatus> getUsageStatus() async {
    final user = _auth.currentUser;
    if (user == null) {
      return const PlanUsageStatus(plan: 'free', freeAnswerCount: 0);
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final data = doc.data() ?? <String, dynamic>{};
    final plan = (data['plan'] as String?)?.toLowerCase() ?? 'free';
    final count = (data['freeAnswerCount'] as num?)?.toInt() ?? 0;
    return PlanUsageStatus(plan: plan, freeAnswerCount: count);
  }

  Future<PlanUsageStatus> incrementCountIfNeeded() async {
    final user = _auth.currentUser;
    if (user == null) {
      return const PlanUsageStatus(plan: 'free', freeAnswerCount: 0);
    }

    final userRef = _firestore.collection('users').doc(user.uid);

    return _firestore.runTransaction((tx) async {
      final snap = await tx.get(userRef);
      final data = snap.data() ?? <String, dynamic>{};
      final plan = (data['plan'] as String?)?.toLowerCase() ?? 'free';
      var count = (data['freeAnswerCount'] as num?)?.toInt() ?? 0;

      if (plan != 'pro') {
        count += 1;
      }

      tx.set(userRef, {
        'plan': plan,
        'freeAnswerCount': count,
        'lastAnsweredAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return PlanUsageStatus(plan: plan, freeAnswerCount: count);
    });
  }
}
