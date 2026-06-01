import 'package:flutter/material.dart';
import 'novedades_screen.dart';
import 'index2_screen.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE50914), width: 3)),
              child: Image.network('https://raw.githubusercontent.com/OsvaldoArellano/Imagenes-para-flutter-6-J-11-febrero-2026/refs/heads/main/logo-removebg-preview.png', height: 160),
            ),
          ),
          const SizedBox(height: 25),
          const Text('Novedades', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NovedadesScreen())),
            child: Container(
              height: 50, width: 50,
              decoration: const BoxDecoration(color: Color(0xFFE50914), shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
          const SizedBox(height: 30),
          const Text('¡Tu Papeleria de\nConfianza!', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.2)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Index2Screen())),
            child: const Text('Ver Estadísticas rápidas'),
          )
        ],
      ),
    );
  }
}