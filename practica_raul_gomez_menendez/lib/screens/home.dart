
library;

import 'package:flutter/material.dart';
import '../services/voice_service.dart';


class Home extends StatefulWidget {
  /// Crea una instancia de [Home].
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  /// Instancia del servicio de reconocimiento de voz.
  final VoiceService voiceService = VoiceService();
  Color backgroundColor = Colors.black;  
 Color textColor = Colors.yellow;
  String message = "Di uno de los siguientes procesos: Iniciar, Parar, Siguiente";

  @override
  void initState() {
    super.initState();
    voiceService.init().then((_) {
      setState(() {});
    });
  }

  void handleCommand(String text) {
    final cmd = text.toLowerCase();

    if (cmd.contains("iniciar")) {
      setState(() {
        backgroundColor = Colors.black;
        textColor = Colors.white;
        message = "Proceso iniciado, diga ahora a decir Parar o Siguiente";
      });
    } else if (cmd.contains("parar")) {
      setState(() {
        backgroundColor = Colors.green;
        textColor = Colors.black;
        message = "Proceso detenido, prueba ahora a decir Iniciar o Siguiente";
      });
    } else if (cmd.contains("siguiente")) {
      setState(() {
        backgroundColor = Colors.blue;
        textColor = Colors.white;
        message = "Has dicho siguiente, prueba ahora a decir Parar o Iniciar.";
      });
    } else {
      setState(() {
        message = "Comando no reconocido. Intente de nuevo.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
  ),
),

            const SizedBox(height: 40),

            FloatingActionButton(
              backgroundColor:
                  voiceService.isListening ? Colors.red : Colors.lightGreen,
              onPressed: !voiceService.isInitialized
                  ? null
                  : () async {
                      if (voiceService.isListening) {
                        await voiceService.stopListening();
                      } else {
                        await voiceService.startListening((text) {
                          handleCommand(text);
                        });
                      }
                      setState(() {});
                    },
              child: Icon(
                voiceService.isListening ? Icons.mic : Icons.mic_none,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}