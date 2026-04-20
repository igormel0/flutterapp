import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String usuario;

  const HomePage({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Página Inicial"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.home,
              size: 100,
              color: Colors.blueGrey,
            ),
            const SizedBox(height: 30),
            Text(
              'Bem-vindo, $usuario!',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Login realizado com sucesso.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}