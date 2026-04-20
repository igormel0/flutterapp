import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove a faixa de debug
      title: 'TELA DE LOGIN',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Tela de Login"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.lock_outline, size: 80, color: Colors.blueGrey),
              const SizedBox(height: 30),

              TextField(
                controller: _usuarioController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Usuário',
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.password),
                ),
              ),

              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loginNoServidor,
                  child: const Text('LOGIN', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginNoServidor() async {
    // API rodando na porta 8081
    final url = Uri.parse('http://localhost:8081/login');

    try {
      // .trim() remove espaços acidentais no início ou fim do texto
      final String usuario = _usuarioController.text.trim();
      final String senha = _senhaController.text.trim();

      if (usuario.isEmpty || senha.isEmpty) {
        _mostrarAlerta("Atenção", "Preencha todos os campos.");
        return;
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'usuario': usuario,
          'senha': senha,
        }),
      );

      if (response.statusCode == 200) {
        // Login bem-sucedido - navega para a página inicial
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(usuario: usuario),
          ),
        );
      } else if (response.statusCode == 403) {
        _mostrarAlerta("Erro", "Usuário ou senha incorretos.");
      } else {
        _mostrarAlerta("Erro", "Servidor com problemas: ${response.statusCode}");
      }
    } catch (e) {
      _mostrarAlerta("Erro de Conexão", "Certifique-se que a API está rodando.");
    }
  }

  void _mostrarAlerta(String titulo, String mensagem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text("OK"))
        ],
      ),
    );
  }
}