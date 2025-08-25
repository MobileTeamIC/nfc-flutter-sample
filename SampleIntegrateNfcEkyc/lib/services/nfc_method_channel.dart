import 'dart:convert';
import 'package:flutter/services.dart';

import 'nfc_config.dart';

/// Main NFC method channel service
class NfcMethodChannel {
  static const MethodChannel _channel =
      MethodChannel('flutter.sdk.ekyc/integrate');

  const NfcMethodChannel();

  /// QR -> NFC (navigateToNfcQrCode)
  Future<Map<String, dynamic>> startQrToNfc(NfcConfig config) async {
    return _invokeMethod('navigateToNfcQrCode', config);
  }

  /// MRZ -> NFC (actionStart_MRZ_NFC)
  Future<Map<String, dynamic>> startMrzToNfc(NfcConfig config) async {
    return _invokeMethod('actionStart_MRZ_NFC', config);
  }

  /// Manual NFC with UI (actionStart_Only_NFC)
  Future<Map<String, dynamic>> startOnlyNfc(NfcConfig config) async {
    return _invokeMethod('actionStart_Only_NFC', config);
  }

  /// Manual NFC without UI (actionStart_Only_NFC_WithoutUI)
  Future<Map<String, dynamic>> startOnlyNfcWithoutUi(NfcConfig config) async {
    return _invokeMethod('actionStart_Only_NFC_WithoutUI', config);
  }

  Future<Map<String, dynamic>> _invokeMethod(
      String methodName, NfcConfig config) async {
    try {
      final dynamic result =
          await _channel.invokeMethod(methodName, config.toMap());

      if (result == null) return {};

      final decoded = jsonDecode(result as String);
      if (decoded is Map<String, dynamic>) return decoded;
      return {};
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        message: 'Failed to invoke $methodName: ${e.message}',
        details: e.details,
      );
    } catch (e) {
      throw PlatformException(
        code: 'UNKNOWN_ERROR',
        message: 'Unknown error occurred: $e',
      );
    }
  }
}
