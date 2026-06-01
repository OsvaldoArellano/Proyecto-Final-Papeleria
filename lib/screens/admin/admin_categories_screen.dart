import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import '../../models/category_model.dart';
import '../../providers/theme_provider.dart';

class AdminCategoriesScreen extends StatelessWidget {
  const AdminCategoriesScreen({Key? key}) : super(key: key);

  void _showForm(BuildContext context, [CategoryModel? cat]) {
    final store = Provider.of<StoreProvider>(context, listen: false);
    final nameCtrl = TextEditingController(text: cat?.name ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(cat == null ? 'Nueva Categoría' : 'Editar Categoría'),
        content: TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;

              try {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Guardando categoría...'), duration: Duration(seconds: 1)),
                );

                if (cat == null) {
                  await store.addCategory(name, 'star');
                } else {
                  await store.updateCategory(cat.id, name, cat.iconKey);
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(backgroundColor: Colors.green, content: Text('¡Categoría guardada con éxito!')),
                );
                Navigator.pop(context);
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Error de Firebase'),
                    content: Text(e.toString()),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                  ),
                );
              }
            },
            child: const Text('Guardar'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final store = Provider.of<StoreProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        iconTheme: const IconThemeData(color: Colors.red),
        title: Image.network(
          'https://raw.githubusercontent.com/OsvaldoArellano/Imagenes-para-flutter-6-J-11-febrero-2026/refs/heads/main/logo-removebg-preview-down.png',
          height: 45, // Altura ideal para que luzca estilizado en el AppBar
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            // Mientras carga la imagen de GitHub, muestra un indicador sutil o el espacio reservado
            return const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.red,
                strokeWidth: 2,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            // Fallback en caso de que falle la red o la URL cambie, para que la app no rompa
            return const Text(
              'LA CASITA DE PAPEL',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                fontSize: 14,
              ),
            );
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode, 
              color: Colors.white
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: store.categories.length,
        itemBuilder: (context, idx) {
          final c = store.categories[idx];
          return ListTile(
            title: Text(c.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showForm(context, c)),
                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => store.deleteCategory(c.id)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE50914),
        child: const Icon(Icons.add),
        onPressed: () => _showForm(context),
      ),
    );
  }
}