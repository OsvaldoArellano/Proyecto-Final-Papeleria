import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/custom_app_bar.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBack: true, titleText: 'ADM. USUARIOS'),
      body: StreamBuilder<QuerySnapshot>(
        // Forzamos la escucha directa aquí para auditar el canal de datos
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.gpp_bad, color: Colors.red, size: 60),
                    const SizedBox(height: 10),
                    Text(
                      'Firestore rechazó la conexión:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFE50914)));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('La colección "users" existe pero está vacía.'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, idx) {
              final doc = docs[idx];
              final data = doc.data() as Map<String, dynamic>;
              bool isAdmin = data['isAdmin'] ?? false;
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(data['name'] ?? 'Sin nombre'),
                subtitle: Text(data['email'] ?? 'Sin correo'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Admin', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 8),
                    Switch.adaptive(
                      value: isAdmin,
                      onChanged: (val) async {
                        try {
                          await FirebaseFirestore.instance.collection('users').doc(doc.id).update({'isAdmin': val});
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rol actualizado')));
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Error'),
                              content: Text(e.toString()),
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}