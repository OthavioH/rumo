import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumo/core/asset_images.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 26, top: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        AssetImages.logo,
                        width: 134,
                        height: 52,
                      ),
                      Text(
                        'Memórias na',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.68,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'palma da mão.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.68,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(AssetImages.createAccountCharacter),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 12),
                  child: IconButton.filled(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    color: Color(0xFF383838),
                    icon: Icon(Icons.chevron_left),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cadastra-se',
                        style: TextStyle(
                          color: const Color(0xFF1E1E1E),
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.20,
                          letterSpacing: -0.48,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Preenchar os dados abaixo para criar sua conta.',
                        style: TextStyle(
                          color: const Color(0xFF1E1E1E),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.40,
                        ),
                      ),
                      SizedBox(height: 24),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          spacing: 16,
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(hintText: 'Nome'),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Por favor, insira seu nome";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(hintText: 'E-mail'),
                              validator: (value) {
                                final invalidEmailText =
                                    'Insira um e-mail válido';

                                if (value == null || value.trim().isEmpty) {
                                  return invalidEmailText;
                                }

                                final email = value.trim();

                                if (!email.contains('@') ||
                                    !email.contains('.')) {
                                  return invalidEmailText;
                                }

                                final parts = email.split('@');
                                final firstPart = parts[0];

                                if (firstPart.trim().isEmpty) {
                                  return invalidEmailText;
                                }

                                final lastPart = parts[1];

                                if (lastPart.trim().isEmpty ||
                                    !lastPart.contains('.')) {
                                  return invalidEmailText;
                                }

                                if (lastPart.startsWith('.') ||
                                    lastPart.endsWith('.')) {
                                  return invalidEmailText;
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                hintText: 'Senha',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hidePassword = !hidePassword;
                                    });
                                  },
                                  icon: Icon(
                                    hidePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                              ),
                              obscureText: hidePassword,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor, insira uma senha';
                                }

                                if (value.length < 6) {
                                  return 'A senha deve ter pelo menos 6 caracteres';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Confirmar senha',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hideConfirmPassword =
                                          !hideConfirmPassword;
                                    });
                                  },
                                  icon: Icon(
                                    hideConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                              ),
                              obscureText: hideConfirmPassword,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor, insira uma senha';
                                }
                                if (value != _passwordController.text) {
                                  return 'As senhas não coincidem';
                                }

                                if (value.length < 6) {
                                  return 'A senha deve ter pelo menos 6 caracteres';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 62),
                      SizedBox(
                        width: double.maxFinite,
                        child: FilledButton(
                          onPressed: () async {
                            final isValid =
                                _formKey.currentState?.validate() ?? false;
                            if (isValid) {
                              try {
                                setState(() {
                                  isLoading = true;
                                });

                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );

                                await FirebaseAuth.instance.currentUser
                                    ?.updateDisplayName(_nameController.text);

                                setState(() {
                                  isLoading = false;
                                });
                              } on FirebaseAuthException catch (error) {
                                log(error.message ?? 'Error desconhecido');
                                if(!context.mounted) return;
                                showDialog(context: context, builder: (context) {
                                  return AlertDialog(
                                    title: Text('Erro'),
                                    content: Text(error.message ?? 'Erro desconhecido'),
                                  );
                                });
                              }
                            }
                          },
                          child: Builder(
                            builder: (context) {
                              if (isLoading) {
                                return SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                );
                              }
                              return Text('Criar conta');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
