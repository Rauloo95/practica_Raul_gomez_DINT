import 'package:speech_to_text/speech_to_text.dart';

/// Servicio encargado de manejar el reconocimiento de voz.
///
/// Proporciona una API clara para inicializar, comenzar y detener la escucha.
/// Incluye control de estados, manejo de errores y soporte para resultados
/// parciales y finales.
///
/// ### Uso básico:
/// ```dart
/// final voiceService = VoiceService();
/// await voiceService.init();
/// await voiceService.startListening((text) {
///   print('Reconocido: $text');
/// });
/// ```
///
/// ### Flujo de vida:
/// 1. Crear instancia de [VoiceService]
/// 2. Llamar [init] para inicializar el motor de reconocimiento
/// 3. Llamar [startListening] con un callback para procesar resultados
/// 4. Llamar [stopListening] o [cancel] cuando sea necesario
class VoiceService {
  /// Instancia del motor de reconocimiento de voz.
  final SpeechToText _speech = SpeechToText();

  /// Indica si el servicio ha sido inicializado correctamente.
  bool _isInitialized = false;

  /// Indica si actualmente se está escuchando la voz del usuario.
  bool _isListening = false;

  /// Getter para saber si el servicio está inicializado.
  bool get isInitialized => _isInitialized;

  /// Getter para saber si se está escuchando actualmente.
  bool get isListening => _isListening;

  /// Inicializa el motor de reconocimiento de voz.
  ///
  /// Configura los callbacks para errores y cambios de estado.
  /// Debe llamarse una sola vez antes de usar [startListening].
  ///
  /// Devuelve:
  /// - `true` si la inicialización fue exitosa
  /// - `false` si falló (por ejemplo, micrófono no disponible o permisos denegados)
  ///
  /// ### Ejemplo:
  /// ```dart
  /// bool initialized = await voiceService.init();
  /// if (initialized) {
  ///   print('Listo para usar reconocimiento de voz');
  /// }
  /// ```
  Future<bool> init() async {
    /// Inicializa el motor de reconocimiento configurando callbacks
    _isInitialized = await _speech.initialize(
      onError: (error) {
        print('Speech error: $error');
      },
      onStatus: (status) {
        print('Speech status: $status');
      },
    );

    return _isInitialized;
  }

  /// Comienza a escuchar la voz del usuario.
  ///
  /// Activa el micrófono y comienza a procesar audio. Requiere que [init]
  /// haya sido llamado previamente.
  ///
  /// Parámetros:
  /// - [onResult]: Callback que recibe el texto reconocido (parcial o final)
  ///   Se dispara múltiples veces: primero con resultados parciales,
  ///   luego con el resultado final.
  ///
  /// Lanza [print] si:
  /// - El servicio no está inicializado
  /// - Ya se está escuchando
  ///
  /// ### Ejemplo:
  /// ```dart
  /// await voiceService.startListening((text) {
  ///   print('Usuario dijo: $text');
  /// });
  /// ```
  Future<void> startListening(Function(String) onResult) async {
    /// Valida si el servicio está inicializado
    if (!_isInitialized) {
      print('Error: SpeechToText no está inicializado.');
      return;
    }

    /// Valida si ya se está escuchando
    if (_isListening) {
      print('Ya se está escuchando.');
      return;
    }

    /// Marca como escuchando y comienza la captura
    _isListening = true;

    /// Inicia la escucha con configuración en español
    /// partialResults: true permite recibir resultados parciales mientras habla
    /// listenMode: confirmation requiere confirmación de voz
    await _speech.listen(
      localeId: 'es_ES',
      ///listenMode: ListenMode.confirmation,
      ///partialResults: true,
      onResult: (result) {
        /// Procesa los palabras reconocidas y las pasa al callback
        onResult(result.recognizedWords);
      },
    );
  }

  /// Detiene la escucha de forma ordenada.
  ///
  /// Procesa los resultados finales del reconocimiento antes de detener.
  /// Es el método recomendado para terminar la captura de voz.
  ///
  /// ### Ejemplo:
  /// ```dart
  /// await voiceService.stopListening();
  /// print('Escucha detenida');
  /// ```
  Future<void> stopListening() async {
    /// Valida si se está escuchando antes de detener
    if (!_isListening) return;

    /// Detiene la captura de audio de forma ordenada
    await _speech.stop();
    /// Actualiza el estado
    _isListening = false;
  }

  /// Cancela la escucha sin procesar resultados.
  ///
  /// A diferencia de [stopListening], esta función detiene la escucha
  /// inmediatamente sin procesar los resultados finales. Útil para
  /// cancelaciones rápidas.
  ///
  /// ### Ejemplo:
  /// ```dart
  /// await voiceService.cancel();
  /// print('Escucha cancelada');
  /// ```
  Future<void> cancel() async {
    /// Valida si se está escuchando antes de cancelar
    if (!_isListening) return;

    /// Cancela la captura de audio sin procesar resultados
    await _speech.cancel();
    /// Actualiza el estado
    _isListening = false;
  }
}