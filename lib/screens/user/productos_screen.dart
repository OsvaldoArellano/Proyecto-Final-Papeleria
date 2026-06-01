import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import 'category_products_screen.dart';

class ProductosScreen extends StatelessWidget {
  const ProductosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Escuchamos el StoreProvider donde residen las categorías de la BD
    final store = Provider.of<StoreProvider>(context);
    final categoriasDesdeDB = store.categories;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Categorías de la Tienda',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ),
            const SizedBox(height: 15),
            
            categoriasDesdeDB.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40.0),
                      child: Column(
                        children: [
                          CircularProgressIndicator(color: Color(0xFFE50914)),
                          SizedBox(height: 15),
                          Text('Cargando categorías desde la base de datos...', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categoriasDesdeDB.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 1.0, // Formato cuadrado exacto
                    ),
                    itemBuilder: (context, index) {
                      final categoria = categoriasDesdeDB[index];
                      
                      // Mapeo dinámico o fallback de colores estéticos según el índice
                      final List<Color> paletaColores = [
                        const Color(0xFFE50914), // Rojo Casita de Papel
                        const Color(0xFFC4A45A), // Dorado Base
                        const Color(0xFF1A1A40), // Azul Oscuro complementario
                        Colors.blueGrey,
                        Colors.black87,
                      ];
                      Color tarjetaColor = paletaColores[index % paletaColores.length];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoryProductsScreen(categoryId: categoria.id, categoryName: categoria.name),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: tarjetaColor,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icono dinámico basado en un switch simple o un valor genérico de fallback
                              Icon(
                                _getIconData(categoria.iconKey),
                                size: 45,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  categoria.name.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  // Helper para asignar un icono nativo según el string que guardes en Firebase
  IconData _getIconData(String key) {
    switch (key.toLowerCase()) {
      case 'school':
      case 'utiles':
        return Icons.school;
      case 'architecture':
      case 'geometria':
        return Icons.architecture;
      case 'palette':
      case 'arte':
        return Icons.palette;
      case 'book':
        return Icons.menu_book;
      default:
        return Icons.star_border_purple500_rounded; // Icono por defecto elegante
    }
  }
}