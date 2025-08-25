import 'package:flutter/foundation.dart';

/// Configuration class for NFC SDK parameters
class NfcConfig {
  // Optional SDK presentation options (currently hardcoded in iOS, reserved for future)
  final String? languageSdk; // "icekyc_vi" | "icekyc_en"
  final bool? isShowTutorial;
  final bool? isEnableGotIt;

  // NFC reader (manual input) requirements
  final String? idNumber; // 12 digits
  final String? birthday; // yymmdd
  final String? expiredDate; // yymmdd

  const NfcConfig({
    this.languageSdk,
    this.isShowTutorial,
    this.isEnableGotIt,
    this.idNumber,
    this.birthday,
    this.expiredDate,
  });

  /// Convert to Map for method channel. Only non-null fields included.
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    // Only the following keys are read by current iOS implementations for manual NFC:
    if (idNumber != null) {
      map['idNumber'] = idNumber;
    }
    if (birthday != null) {
      map['birthday'] = birthday;
    }
    if (expiredDate != null) {
      map['expiredDate'] = expiredDate;
    }

    // Reserved for future enhancements on iOS side
    if (languageSdk != null) {
      map['languageSdk'] = languageSdk;
    }
    if (isShowTutorial != null) {
      map['isShowTutorial'] = isShowTutorial;
    }
    if (isEnableGotIt != null) {
      map['isEnableGotIt'] = isEnableGotIt;
    }

    return map;
  }

  /// Quick validator used by UI before invoking native methods
  bool get hasValidManualInput {
    if (idNumber == null || birthday == null || expiredDate == null) {
      return false;
    }
    return idNumber!.trim().length == 12 &&
        birthday!.trim().length == 6 &&
        expiredDate!.trim().length == 6;
  }

  NfcConfig copyWith({
    String? languageSdk,
    bool? isShowTutorial,
    bool? isEnableGotIt,
    String? idNumber,
    String? birthday,
    String? expiredDate,
  }) {
    return NfcConfig(
      languageSdk: languageSdk ?? this.languageSdk,
      isShowTutorial: isShowTutorial ?? this.isShowTutorial,
      isEnableGotIt: isEnableGotIt ?? this.isEnableGotIt,
      idNumber: idNumber ?? this.idNumber,
      birthday: birthday ?? this.birthday,
      expiredDate: expiredDate ?? this.expiredDate,
    );
  }

  @override
  String toString() => describeIdentity(this);
}
