import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import '../../providers/auth_provider.dart';
import 'formulario_pago_screen.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/product_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Set<String> _processing = {};

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final auth = Provider.of<AppAuthProvider>(context);
    final productIds = store.cart.keys.toList();

    return Scaffold(
      appBar: const CustomAppBar(showBack: true, titleText: 'Mi Carrito'),
      body: Column(
        children: [
          Expanded(
            child: productIds.isEmpty
                ? const Center(child: Text('Tu carrito está vacío.'))
                : ListView.builder(
                    itemCount: productIds.length,
                    itemBuilder: (context, index) {
                      final productId = productIds[index];
                      final qty = store.cart[productId] ?? 0;
                      final prod = store.products.firstWhere(
                        (p) => p.id == productId,
                        orElse: () => ProductModel(id: '', name: 'Producto no disponible', price: 0.0, description: '', imageUrl: 'https://via.placeholder.com/50', categoryId: ''),
                      );

                      final isProcessing = _processing.contains(productId);

                      return ListTile(
                        key: ValueKey(productId),
                        leading: prod.id.isNotEmpty
                            ? Image.network(prod.imageUrl, width: 50, errorBuilder: (c, e, s) => Image.network('https://via.placeholder.com/50', width: 50))
                            : Image.network('https://via.placeholder.com/50', width: 50),
                        title: Text(prod.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('\$${prod.price} x $qty'),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('\$${store.cartTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, color: Color(0xFFE50914), fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE50914), minimumSize: const Size(double.infinity, 50)),
                  onPressed: productIds.isEmpty
                      ? null
                      : () {
                          if (auth.currentUser == null) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inicia sesión para poder comprar')));
                            return;
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const FormularioPagoScreen()));
                        },
                  child: const Text('REALIZAR COMPRA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}