import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/auth_providers.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(firebaseAuthProvider).createUserWithEmailAndPassword(email: _email.text.trim(), password: _password.text.trim());
      if (mounted) Navigator.pop(context);
    } on Exception catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('新規登録失敗: $e')));
    } finally { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(children:[const Text('新規登録', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)), const SizedBox(height: 20), TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'メールアドレス'), validator: (v)=> (v==null||!v.contains('@'))?'正しいメールアドレスを入力してください':null), const SizedBox(height: 12), TextFormField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'パスワード'), validator: (v)=> (v==null||v.length<6)?'6文字以上で入力してください':null), const SizedBox(height: 20), SizedBox(width: double.infinity, child: FilledButton(onPressed: _loading?null:_signUp, child: _loading?const CircularProgressIndicator():const Text('登録する')))])
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
