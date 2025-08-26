import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'log_screen.dart';
import 'services/nfc_method_channel.dart';
import 'services/nfc_presentation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EkycNfcScreen extends StatefulWidget {
  const EkycNfcScreen({super.key});

  @override
  State<EkycNfcScreen> createState() => _EkycNfcScreenState();
}

class _EkycNfcScreenState extends State<EkycNfcScreen> {
  final NfcMethodChannel _nfcService = const NfcMethodChannel();
  late TextEditingController _textIdController;
  late TextEditingController _textDobController;
  late TextEditingController _textExpireController;

  @override
  void initState() {
    _textIdController =
        TextEditingController(text: dotenv.env['ID_NUMBER'] ?? '030201008790');
    _textDobController =
        TextEditingController(text: dotenv.env['DOB'] ?? '010211');
    _textExpireController =
        TextEditingController(text: dotenv.env['EXPIRE'] ?? '260211');
    super.initState();
  }

  _navigateToLog(Map<String, dynamic> json) {
    if (json.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LogScreen(json: json),
        ),
      );
    }
  }

  Map<String, dynamic> _parseResult(final Map<String, dynamic> json) {
    // Align with iOS AppDelegate keys
    return {
      'Qrcode': json['QR_CODE_RESULT_NFC'],
      'Avatar NFC': json['IMAGE_AVATAR_CARD_NFC'],
      'Hash avatar': json['HASH_AVATAR'],
      'Client session': json['CLIENT_SESSION_RESULT'],
      'Data NFC': json['LOG_NFC'],
      'Postcode original location': json['POST_CODE_ORIGINAL_LOCATION_RESULT'],
      'Postcode recent location': json['POST_CODE_RECENT_LOCATION_RESULT'],
    }..removeWhere(
        (key, value) => value == null || (value is String && value.isEmpty));
  }

  Future<Map<String, dynamic>> _qrToNfc() async {
    try {
      final config = NfcPresets.qrToNfc();
      final json = await _nfcService.startQrToNfc(config);
      return json.isEmpty ? {} : _parseResult(json);
    } on PlatformException catch (e) {
      _showError(e.message);
      return {};
    }
  }

  Future<Map<String, dynamic>> _mrzToNfc() async {
    try {
      final config = NfcPresets.mrzToNfc();
      final json = await _nfcService.startMrzToNfc(config);
      return json.isEmpty ? {} : _parseResult(json);
    } on PlatformException catch (e) {
      _showError(e.message);
      return {};
    }
  }

  Future<Map<String, dynamic>> _onlyNfcWithUi() async {
    final id = _textIdController.text.trim();
    final dob = _textDobController.text.trim();
    final exp = _textExpireController.text.trim();

    if (id.isEmpty || dob.isEmpty || exp.isEmpty) {
      _showError(
          'Thiếu thông tin, Vui lòng nhập Số thẻ, Ngày sinh, Ngày hết hạn');
      return {};
    }
    if (id.length != 12 || dob.length != 6 || exp.length != 6) {
      _showError(
          'Định dạng không hợp lệ, Số thẻ 12 số, ngày sinh và hết hạn YYMMDD');
      return {};
    }

    try {
      final config = NfcPresets.manualWithUi(
        idNumber: id,
        birthday: dob,
        expiredDate: exp,
      );
      final json = await _nfcService.startOnlyNfc(config);
      return json.isEmpty ? {} : _parseResult(json);
    } on PlatformException catch (e) {
      _showError(e.message);
      return {};
    }
  }

  Future<Map<String, dynamic>> _onlyNfcWithoutUi() async {
    final id = _textIdController.text.trim();
    final dob = _textDobController.text.trim();
    final exp = _textExpireController.text.trim();

    if (id.isEmpty || dob.isEmpty || exp.isEmpty) {
      _showError(
          'Thiếu thông tin, Vui lòng nhập Số thẻ, Ngày sinh, Ngày hết hạn');
      return {};
    }
    if (id.length != 12 || dob.length != 6 || exp.length != 6) {
      _showError(
          'Định dạng không hợp lệ, Số thẻ 12 số, ngày sinh và hết hạn YYMMDD');
      return {};
    }

    try {
      final config = NfcPresets.manualWithoutUi(
        idNumber: id,
        birthday: dob,
        expiredDate: exp,
      );
      final json = await _nfcService.startOnlyNfcWithoutUi(config);
      return json.isEmpty ? {} : _parseResult(json);
    } on PlatformException catch (e) {
      _showError(e.message);
      return {};
    }
  }

  void _showError(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Có lỗi xảy ra'),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showToast(String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tích hợp SDK VNPT eKYC NFC',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 16),
            const Text('Số căn cước'),
            const SizedBox(height: 8),
            ShadInput(
              controller: _textIdController,
              keyboardType: TextInputType.number,
              maxLength: 12,
              placeholder: const Text('Nhập số ID'),
            ),
            const SizedBox(height: 16),
            const Text('Ngày sinh YYMMDD'),
            const SizedBox(height: 8),
            ShadInput(
              controller: _textDobController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              placeholder: const Text('yyMMdd, ví dụ: 950614'),
            ),
            const SizedBox(height: 16),
            const Text('Ngày hết hạn YYMMDD'),
            const SizedBox(height: 8),
            ShadInput(
              controller: _textExpireController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              placeholder: const Text('yyMMdd, ví dụ: 950614'),
            ),
            const Spacer(),
            ShadButton(
              onPressed: () async => _navigateToLog(await _qrToNfc()),
              child: const Text('Quét QR -> Đọc chip NFC'),
            ),
            const SizedBox(height: 8),
            ShadButton(
              onPressed: () async => _navigateToLog(await _mrzToNfc()),
              child: const Text('Quét MRZ -> Đọc chip NFC'),
            ),
            const SizedBox(height: 8),
            ShadButton(
              onPressed: () async => _navigateToLog(await _onlyNfcWithUi()),
              child: const Text('Nhập thông tin -> Đọc NFC (có UI SDK)'),
            ),
            const SizedBox(height: 8),
            ShadButton(
              onPressed: () async => _navigateToLog(await _onlyNfcWithoutUi()),
              child: const Text('Nhập thông tin -> Đọc NFC (không UI)'),
            ),
          ],
        ),
      ),
    );
  }
}
