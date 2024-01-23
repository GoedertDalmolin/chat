import 'dart:io';

import 'package:chat/core/models/auth_form_data.dart';
import 'package:chat/pages/components/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function(AuthFormData) onSubmited;

  const AuthForm({super.key, required this.onSubmited});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _authFormData = AuthFormData();

  handleImagePick(File image) {
    _authFormData.image = image;
  }

  _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    if (_authFormData.image == null && _authFormData.isSignup) {
      return _showError('Imagem não Selecionada!!!');
    }

    widget.onSubmited(_authFormData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_authFormData.isSignup)
                UserImagePicker(
                  onImagePick: handleImagePick,
                ),
              if (_authFormData.isSignup)
                TextFormField(
                  initialValue: _authFormData.name,
                  onChanged: (name) {
                    _authFormData.name = name;
                  },
                  key: const ValueKey('name'),
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                  ),
                  validator: (nameInput) {
                    final name = nameInput ?? '';

                    if (name.trim().length < 5) {
                      return 'Nome deve ter no mínimo 5 caracteres';
                    }

                    return null;
                  },
                ),
              TextFormField(
                initialValue: _authFormData.email,
                onChanged: (email) {
                  _authFormData.email = email;
                },
                key: const ValueKey('email'),
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                ),
                validator: (emailInput) {
                  final email = emailInput ?? '';

                  if (!email.contains('@')) {
                    return 'O e-mail informado não é valido!';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: _authFormData.password,
                onChanged: (password) {
                  _authFormData.password = password;
                },
                obscureText: true,
                key: const ValueKey('password'),
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
                validator: (passwordInput) {
                  final password = passwordInput ?? '';

                  if (password.length < 5) {
                    return 'A senha deve conter no minimo 5 caracteres!';
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 4),
                onPressed: _submit,
                child: Text(
                  _authFormData.isLogin ? 'Entrar' : 'Cadastrar?',
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _authFormData.toggleAuthMode();
                  });
                },
                child: Text(
                  _authFormData.isLogin ? 'Criar uma nova conta?' : 'Já possui uma conta?',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
