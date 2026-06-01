import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import '../../widgets/custom_app_bar.dart';
import 'detalles_producto_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final wishlist = store.wishlist;
    return Scaffold(
      appBar: const CustomAppBar(showBack: true, titleText: 'Wishlist'),
      body: wishlist.isEmpty
          ? const Center(child: Text('No tienes elementos guardados en tu lista.'))
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: wishlist.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final prod = wishlist[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetallesProductoScreen(product: prod))),
                    child: Container(
                      decoration: BoxDecoration(color: const Color(0xFFE50914), borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Expanded(child: Image.network(prod.imageUrl, fit: BoxFit.cover)),
                          const SizedBox(height: 5),
                          Text(prod.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('\$${prod.price}', style: const TextStyle(color: Colors.white)),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(Icons.bookmark_remove, color: Colors.white),
                              onPressed: () => store.toggleWishlist(prod),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}