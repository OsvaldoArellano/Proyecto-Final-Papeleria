import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import '../../widgets/custom_app_bar.dart';
import 'detalles_producto_screen.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  const CategoryProductsScreen({Key? key, required this.categoryId, required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final categoryProducts = store.products.where((p) => p.categoryId == categoryId).toList(); 

    return Scaffold(
      appBar: CustomAppBar(showBack: true, titleText: categoryName.toUpperCase()),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: categoryProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.85),
          itemBuilder: (context, idx) {
            final product = categoryProducts[idx];
            return GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetallesProductoScreen(product: product))),
              child: Container(
                decoration: BoxDecoration(color: const Color(0xFFE50914), borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Expanded(child: Image.network(product.imageUrl, fit: BoxFit.cover)),
                    const SizedBox(height: 5),
                    Text(product.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('\$${product.price}', style: const TextStyle(color: Colors.white)),
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