<<<<<<< HEAD
import 'dart:ui';

=======
>>>>>>> main
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/auth_providers.dart';
<<<<<<< HEAD
import 'signup_page.dart';
=======
>>>>>>> main

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
<<<<<<< HEAD
  final _formKey = GlobalKey<FormState>();
=======
>>>>>>> main
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
<<<<<<< HEAD
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(firebaseAuthProvider).signInWithEmailAndPassword(email: _email.text.trim(), password: _password.text.trim());
    } on Exception catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ログイン失敗: $e')));
    } finally { if (mounted) setState(() => _loading = false); }
  }

  Future<void> _resetPassword() async {
    if (_email.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('先にメールアドレスを入力してください')));
      return;
    }
    try {
      await ref.read(firebaseAuthProvider).sendPasswordResetEmail(email: _email.text.trim());
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('パスワード再設定メールを送信しました')));
    } on Exception catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('送信失敗: $e')));
=======
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      await ref.read(firebaseAuthProvider).signInWithEmailAndPassword(
            email: _email.text.trim(),
            password: _password.text.trim(),
          );
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ログイン失敗: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
>>>>>>> main
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              constraints: const BoxConstraints(maxWidth: 420),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                          const Icon(Icons.health_and_safety_outlined, size: 54),
                          const SizedBox(height: 8),
                          const Text('登録販売者試験対策', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 24),
                          TextFormField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'メールアドレス'), validator: (v)=>(v==null||!v.contains('@'))?'正しいメールアドレスを入力してください':null),
                          const SizedBox(height: 14),
                          TextFormField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'パスワード'), validator: (v)=>(v==null||v.length<6)?'6文字以上で入力してください':null),
                          Align(alignment: Alignment.centerRight, child: TextButton(onPressed: _resetPassword, child: const Text('パスワードをお忘れですか？'))),
                          const SizedBox(height: 8),
                          SizedBox(height: 52, child: FilledButton(onPressed: _loading?null:_login, child: _loading?const SizedBox(height: 20, width:20, child: CircularProgressIndicator(strokeWidth: 2)):const Text('ログイン'))),
                          const SizedBox(height: 8),
                          TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const SignUpPage())), child: const Text('新規登録はこちら')),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
=======
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(controller: _email, decoration: const InputDecoration(labelText: 'メールアドレス')),
                const SizedBox(height: 16),
                TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'パスワード')),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(onPressed: _loading ? null : _login, child: Text(_loading ? 'ログイン中...' : 'ログイン')),
                ),
              ],
>>>>>>> main
            ),
          ),
        ),
      ),
    );
  }
}
