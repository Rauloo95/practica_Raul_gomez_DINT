/// Biblioteca principal de la aplicación Flutter.
///
/// Esta es la entrada principal de la aplicación de reconocimiento de voz.
/// Configura el tema de la aplicación y la pantalla inicial.
library;

import 'package:flutter/material.dart';
import 'screens/home.dart';

/// Función principal que inicia la aplicación.
///
/// Crea la instancia de [MyApp] y la pasa a [runApp] para ejecutarla.
void main() {
  runApp(const MyApp());
}

/// Widget raíz de la aplicación.
///
/// [MyApp] es un [StatelessWidget] que configura:
/// - La pantalla principal [Home]
/// - La configuración de Material Design
/// /// - El tema de la aplicación con un color base personalizado
/// Esta clase es la raíz del árbol de widgets y no cambia su estado.
class MyApp extends StatelessWidget {
  /// Crea una instancia de [MyApp].
  ///
  /// El parámetro [key] es opcional y se usa para identificar el widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voz a Texto de Raúl Gómez',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 242, 5, 5)),
      ),
      /// Pantalla principal de la aplicación
      home: const Home(),
    );
  }
}