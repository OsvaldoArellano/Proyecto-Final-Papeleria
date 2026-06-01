import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final String? titleText; // Se mantiene por compatibilidad si se llega a necesitar en alguna pantalla específica

  const CustomAppBar({
    Key? key, 
    this.showBack = true,
    this.titleText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return AppBar(
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Rojo característico
      iconTheme: const IconThemeData(color: Colors.white),
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.maybePop(context),
            )
          : null,
      
      // Reemplazamos el contenedor de texto por la imagen del logotipo oficial
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
              color: Colors.white,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}