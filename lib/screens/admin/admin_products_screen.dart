import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import '../../models/product_model.dart';
import '../../providers/theme_provider.dart';

class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({Key? key}) : super(key: key);

  void _showForm(BuildContext context, [ProductModel? product]) {
    final store = Provider.of<StoreProvider>(context, listen: false);
    final nameCtrl = TextEditingController(text: product?.name ?? '');
    final descCtrl = TextEditingController(text: product?.description ?? '');
    final priceCtrl = TextEditingController(text: product != null ? product.price.toString() : '');
    final imageCtrl = TextEditingController(text: product?.imageUrl ?? '');
    String selectedCatId = product?.categoryId ?? (store.categories.isNotEmpty ? store.categories.first.id : '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
                TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descripción')),
                TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Precio'), keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                TextField(controller: imageCtrl, decoration: const InputDecoration(labelText: 'URL de la imagen')),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedCatId.isEmpty ? null : selectedCatId,
                  items: store.categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                  onChanged: (val) => setState(() => selectedCatId = val ?? ''),
                  decoration: const InputDecoration(labelText: 'Categoría (Desde DB)'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                  try {
                    final store = Provider.of<StoreProvider>(context, listen: false);
                    final String name = nameCtrl.text.trim();
                    final String desc = descCtrl.text.trim();
                    final String image = imageCtrl.text.trim();
                    final double precio = double.tryParse(priceCtrl.text) ?? 0.0;
                    if (name.isEmpty) return;

                    if (product == null) {
                      await store.addProduct(name, precio, desc, image, selectedCatId);
                    } else {
                      await store.updateProduct(product.id, name, precio, desc, image, selectedCatId);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(backgroundColor: Colors.green, content: Text('¡Producto guardado con éxito!')),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Error al guardar producto'),
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
        ),
      ),
    )
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
        itemCount: store.products.length,
        itemBuilder: (context, idx) {
          final p = store.products[idx];
          return ListTile(
            title: Text(p.name),
            subtitle: Text('\$${p.price}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showForm(context, p)),
                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => store.deleteProduct(p.id)),
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