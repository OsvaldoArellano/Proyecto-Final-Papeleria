import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import '../../providers/theme_provider.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

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
          )
        ],
      ),
      body: ListView.builder(
        itemCount: store.orders.length,
        itemBuilder: (context, idx) {
          final order = store.orders[idx];
          final idDisplay = (order.id.length >= 5) ? order.id.substring(0, 5) : order.id;
          // Asegurar que el valor actual de status esté presente en las opciones
          final statuses = <String>{order.status, 'Pendiente', 'en proceso', 'enviado', 'entregado'}.toList();
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text('Pedido: #$idDisplay - Total: \$${order.total}'),
              subtitle: Text('Estado: ${order.status.toUpperCase()}'),
              trailing: DropdownButton<String>(
                value: order.status,
                items: statuses.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (newStatus) async {
                  if (newStatus != null) {
                    await store.updateOrderStatus(order.id, newStatus);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}