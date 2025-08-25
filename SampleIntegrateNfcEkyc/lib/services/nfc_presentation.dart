import 'nfc_config.dart';

/// Predefined configurations for common NFC use cases
class NfcPresets {
  /// QR -> NFC flow (no manual inputs needed)
  static NfcConfig qrToNfc({
    String languageSdk = 'icekyc_vi',
    bool isShowTutorial = true,
    bool isEnableGotIt = true,
  }) {
    return NfcConfig(
      languageSdk: languageSdk,
      isShowTutorial: isShowTutorial,
      isEnableGotIt: isEnableGotIt,
    );
  }

  /// MRZ -> NFC flow (no manual inputs needed)
  static NfcConfig mrzToNfc({
    String languageSdk = 'icekyc_vi',
    bool isShowTutorial = true,
    bool isEnableGotIt = true,
  }) {
    return NfcConfig(
      languageSdk: languageSdk,
      isShowTutorial: isShowTutorial,
      isEnableGotIt: isEnableGotIt,
    );
  }

  /// Manual NFC with SDK UI
  static NfcConfig manualWithUi({
    required String idNumber,
    required String birthday,
    required String expiredDate,
    String languageSdk = 'icekyc_vi',
    bool isShowTutorial = true,
    bool isEnableGotIt = true,
  }) {
    return NfcConfig(
      idNumber: idNumber,
      birthday: birthday,
      expiredDate: expiredDate,
      languageSdk: languageSdk,
      isShowTutorial: isShowTutorial,
      isEnableGotIt: isEnableGotIt,
    );
  }

  /// Manual NFC without SDK UI
  static NfcConfig manualWithoutUi({
    required String idNumber,
    required String birthday,
    required String expiredDate,
  }) {
    return NfcConfig(
      idNumber: idNumber,
      birthday: birthday,
      expiredDate: expiredDate,
    );
  }
}
