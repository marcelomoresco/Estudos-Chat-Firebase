import 'dart:io';

import 'package:chat_completo/components/user_image_picker.dart';
import 'package:flutter/material.dart';

import '../core/models/auth_form_data.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;

  AuthForm({required this.onSubmit});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = AuthFormData();

  _handleImagePick(File image) {
    _formData.image = image;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_formData.image == null && _formData.isSignUp) {
      return _showError("Imagem Não Foi Selecionada");
    }

    widget.onSubmit(_formData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(30),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_formData.isSignUp)
                UserImagePicker(onImagePick: _handleImagePick),
              if (_formData.isSignUp)
                TextFormField(
                  key: const ValueKey('name'),
                  initialValue: _formData.name,
                  onChanged: (name) => _formData.name = name,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                  ),
                  validator: (_name) {
                    final name = _name ?? '';
                    if (name.trim().length < 5) {
                      return "Seu nome deve conter mais de 5 digitos";
                    }
                    return null;
                  },
                ),
              TextFormField(
                key: const ValueKey('e-mail'),
                initialValue: _formData.email,
                onChanged: (email) => _formData.email = email,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                ),
                validator: (_email) {
                  final email = _email ?? '';
                  bool emailValid =
                      RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                          .hasMatch(email);

                  if (emailValid == false) {
                    return "Email Incorreto, digite um email correto!";
                  }
                  return null;
                },
              ),
              TextFormField(
                key: const ValueKey('password'),
                initialValue: _formData.password,
                onChanged: (password) => _formData.password = password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
                validator: (_password) {
                  RegExp regex = RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                  var password = _password ?? "";
                  if (password.isEmpty) {
                    return ("Senha é obrigatória");
                  } else if (password.length < 6) {
                    return ("Senha tem que ter mais que 5 caracteres");
                  } else if (!regex.hasMatch(password)) {
                    return ("Senha deve conter Letras Maiusculas, Minusculas, Digitos e um Caracter Especial");
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                    _formData.isLogin ? "Entrar" : "Registrar Conta",
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.deepPurple)),
              TextButton(
                onPressed: () {
                  setState(() {
                    _formData.toggleAuthMode();
                  });
                },
                child: Text(
                  _formData.isLogin
                      ? "Criar uma Nova Conta?"
                      : "Já Possui Conta?",
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
