import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final authStateProvider = StreamProvider<User?>((ref) async* {
  await for (final user in ref.watch(firebaseAuthProvider).authStateChanges()) {
    if (user != null) {
      try {
        await ref.watch(firestoreProvider).collection('users').doc(user.uid).set({
          'email': user.email ?? '',
          'uid': user.uid,
          'plan': 'free',
        }, SetOptions(merge: true));
      } on FirebaseException {
        // Firestore同期エラーでもログイン状態の反映は継続する。
      }
    }
    yield user;
  }
});

final darkModeProvider = StateProvider<bool>((ref) => false);
