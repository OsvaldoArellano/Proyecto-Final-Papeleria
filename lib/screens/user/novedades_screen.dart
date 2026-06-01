import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';

class NovedadesScreen extends StatelessWidget {
  const NovedadesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBack: true, titleText: 'NOVEDADES'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Destacado', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE50914), width: 2), borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(10),
              child: Image.network('https://github.com/OsvaldoArellano/Imagenes-para-flutter-6-J-11-febrero-2026/blob/main/calculadora.png?raw=true', fit: BoxFit.contain, height: 180, width: double.infinity),
            ),
            const SizedBox(height: 25),
            const Text('Llega Pronto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE50914), width: 2), borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(10),
              child: Image.network('https://github.com/OsvaldoArellano/Imagenes-para-flutter-6-J-11-febrero-2026/blob/main/fichas.png?raw=true', fit: BoxFit.contain, height: 180, width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}