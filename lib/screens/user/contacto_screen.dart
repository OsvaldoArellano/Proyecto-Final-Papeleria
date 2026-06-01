import 'package:flutter/material.dart';

class ContactoScreen extends StatelessWidget {
  const ContactoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Text('¿Cómo podemos\nayudarte?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          _contactCard(Icons.email, "Correo Electronico", "lacasitadepapel@gmail.com"),
          const SizedBox(height: 15),
          _contactCard(Icons.phone, "Teléfono / Whatsapp", "+52 656 166 55 88"),
          const Spacer(),
          Image.network('https://raw.githubusercontent.com/OsvaldoArellano/Imagenes-para-flutter-6-J-11-febrero-2026/refs/heads/main/logo-removebg-preview.png', height: 120),
        ],
      ),
    );
  }

  Widget _contactCard(IconData icon, String title, String content) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE50914), size: 30),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(content, style: const TextStyle(color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }
}